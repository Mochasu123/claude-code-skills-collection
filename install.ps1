#Requires -Version 5.1

<#
.SYNOPSIS
    Claude Code Skills Collection — 一键安装脚本 (Windows PowerShell)
.DESCRIPTION
    自动添加所有 marketplace 源、注册插件、安装本地 skill
#>

$ErrorActionPreference = "Stop"

$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$BACKUP_DIR = "$CLAUDE_DIR\backups\skills-collection-$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$SKILLS_DIR = "$CLAUDE_DIR\skills"
$PLUGINS_DIR = "$CLAUDE_DIR\plugins"
$MARKETPLACES_FILE = "$PLUGINS_DIR\known_marketplaces.json"
$INSTALLED_FILE = "$PLUGINS_DIR\installed_plugins.json"
$REPO_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Step {
    param([string]$Message)
    Write-Host ">>> $Message" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✓ $Message" -ForegroundColor Green
}

function Write-Skip {
    param([string]$Message)
    Write-Host "  → $Message (已存在，跳过)" -ForegroundColor Yellow
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Claude Code Skills Collection Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# --- Step 1: Check environment ---
Write-Step "[1/5] 检查环境..."
if (-not (Test-Path $CLAUDE_DIR)) {
    Write-Host "✗ 未找到 $CLAUDE_DIR 目录。请先安装 Claude Code。" -ForegroundColor Red
    exit 1
}
New-Item -ItemType Directory -Force -Path $PLUGINS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $SKILLS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null
Write-Success "环境检查通过"

# --- Step 2: Backup ---
Write-Step "[2/5] 备份现有配置..."
if (Test-Path $MARKETPLACES_FILE) {
    Copy-Item $MARKETPLACES_FILE "$BACKUP_DIR\known_marketplaces.json"
    Write-Success "已备份 known_marketplaces.json"
}
if (Test-Path $INSTALLED_FILE) {
    Copy-Item $INSTALLED_FILE "$BACKUP_DIR\installed_plugins.json"
    Write-Success "已备份 installed_plugins.json"
}
Write-Success "备份完成 ($BACKUP_DIR)"

# --- Step 3: Add marketplace sources ---
Write-Step "[3/5] 添加 marketplace 源..."

$marketplaces = @{
    "understand-anything"      = "Lum1104/Understand-Anything"
    "anthropic-agent-skills"   = "anthropics/skills"
    "baoyu-skills"             = "JimLiu/baoyu-skills"
    "superpowers-marketplace"  = "obra/superpowers-marketplace"
    "obsidian-skills"          = "kepano/obsidian-skills"
    "stata-skill"              = "dylantmoore/stata-skill"
}

# Read existing marketplaces
if (Test-Path $MARKETPLACES_FILE) {
    $marketplacesJson = Get-Content $MARKETPLACES_FILE -Raw | ConvertFrom-Json
} else {
    $marketplacesJson = @{}
}

$addedCount = 0
foreach ($key in $marketplaces.Keys) {
    $repo = $marketplaces[$key]
    if ($marketplacesJson.PSObject.Properties.Name -contains $key) {
        Write-Skip "marketplace: $key ($repo)"
    } else {
        $installPath = "$PLUGINS_DIR\marketplaces\$key"
        New-Item -ItemType Directory -Force -Path $installPath | Out-Null
        $entry = @{
            source = @{
                source = "github"
                repo   = $repo
            }
            installLocation = $installPath
            lastUpdated = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
        }
        $marketplacesJson | Add-Member -MemberType NoteProperty -Name $key -Value $entry
        Write-Success "添加 marketplace: $key ($repo)"
        $addedCount++
    }
}
$marketplacesJson | ConvertTo-Json -Depth 10 | Set-Content $MARKETPLACES_FILE
Write-Success "Marketplace 源配置完成 (新增 $addedCount 个)"

# --- Step 4: Install plugins ---
Write-Step "[4/5] 安装插件..."

# Read existing installed plugins
if (Test-Path $INSTALLED_FILE) {
    $installedJson = Get-Content $INSTALLED_FILE -Raw | ConvertFrom-Json
} else {
    $installedJson = @{ version = 2; plugins = @{} }
}

$plugins = @{
    "understand-anything@understand-anything" = "understand-anything/understand-anything/2.7.5"
    "document-skills@anthropic-agent-skills"  = "anthropic-agent-skills/document-skills/690f15cac7f7"
    "baoyu-skills@baoyu-skills"               = "baoyu-skills/baoyu-skills/77dd193b5889"
    "superpowers@superpowers-marketplace"     = "superpowers-marketplace/superpowers/5.1.0"
    "obsidian@obsidian-skills"                = "obsidian-skills/obsidian/1.0.1"
    "stata-bundle@stata-skill"                = "stata-skill/stata-bundle/1.1.0"
}

$installedCount = 0
foreach ($pluginKey in $plugins.Keys) {
    $cachePath = $plugins[$pluginKey]
    $version = $cachePath.Split('/')[-1]

    if ($installedJson.plugins.PSObject.Properties.Name -contains $pluginKey) {
        Write-Skip "plugin: $pluginKey"
    } else {
        $fullInstallPath = "$PLUGINS_DIR\cache\$cachePath"
        $pluginEntry = @(
            @{
                scope         = "user"
                installPath   = $fullInstallPath
                version       = $version
                installedAt   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                lastUpdated   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            }
        )
        $installedJson.plugins | Add-Member -MemberType NoteProperty -Name $pluginKey -Value $pluginEntry
        Write-Success "注册 plugin: $pluginKey"
        $installedCount++
    }
}
$installedJson | ConvertTo-Json -Depth 10 | Set-Content $INSTALLED_FILE
Write-Success "插件注册完成 (新增 $installedCount 个)"

# --- Step 5: Install local skills ---
Write-Step "[5/5] 安装本地 skill..."
$localCount = 0
$localSkillsPath = Join-Path $REPO_DIR "skills"
if (Test-Path $localSkillsPath) {
    Get-ChildItem $localSkillsPath -Directory | ForEach-Object {
        $skillName = $_.Name
        $targetDir = "$SKILLS_DIR\$skillName"
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillFile) {
            Copy-Item $skillFile "$targetDir\SKILL.md"
        }

        # Copy additional resources
        Get-ChildItem $_.FullName -Directory | ForEach-Object {
            $subDir = $_.Name
            if ($subDir -in @("scripts", "references", "agents")) {
                Copy-Item "$($_.FullName)\*" "$targetDir\$subDir\" -Recurse -Force
            }
        }

        Write-Success "安装 local skill: $skillName"
        $localCount++
    }
}
Write-Success "本地 skill 安装完成 (共 $localCount 个)"

# --- Done ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " 安装完成！请重启 Claude Code 以生效" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "备份位置: $BACKUP_DIR" -ForegroundColor Cyan
Write-Host ""
Write-Host "注意：" -ForegroundColor Yellow
Write-Host "- 部分插件需要在 Claude Code 启动后自动下载完成"
Write-Host "- 如果遇到权限问题，请手动在 Claude Code 中运行：" -ForegroundColor Yellow
Write-Host "  /claude plugins add https://github.com/obra/superpowers-marketplace"
Write-Host "  /claude plugins add https://github.com/anthropics/skills"
Write-Host "  /claude plugins add https://github.com/JimLiu/baoyu-skills"
Write-Host "  /claude plugins add https://github.com/kepano/obsidian-skills"
Write-Host "  /claude plugins add https://github.com/Lum1104/Understand-Anything"
Write-Host "  /claude plugins add https://github.com/dylantmoore/stata-skill"
