#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Claude Code Skills Collection — 一键安装脚本 (macOS / Linux)
# ============================================================

CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/skills-collection-$(date +%Y%m%d_%H%M%S)"
SKILLS_DIR="$CLAUDE_DIR/skills"
PLUGINS_DIR="$CLAUDE_DIR/plugins"
MARKETPLACES_FILE="$PLUGINS_DIR/known_marketplaces.json"
INSTALLED_FILE="$PLUGINS_DIR/installed_plugins.json"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Code Skills Collection Installer     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

# --- Check prerequisites ---
echo -e "${YELLOW}[1/5] 检查环境...${NC}"
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}✗ 未找到 ~/.claude 目录。请先安装 Claude Code。${NC}"
    exit 1
fi

# Ensure required directories exist
mkdir -p "$PLUGINS_DIR"
mkdir -p "$SKILLS_DIR"
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}✓ 环境检查通过${NC}"

# --- Backup existing config ---
echo -e "${YELLOW}[2/5] 备份现有配置...${NC}"
if [ -f "$MARKETPLACES_FILE" ]; then
    cp "$MARKETPLACES_FILE" "$BACKUP_DIR/known_marketplaces.json"
    echo -e "${GREEN}✓ 已备份 known_marketplaces.json${NC}"
fi
if [ -f "$INSTALLED_FILE" ]; then
    cp "$INSTALLED_FILE" "$BACKUP_DIR/installed_plugins.json"
    echo -e "${GREEN}✓ 已备份 installed_plugins.json${NC}"
fi
echo -e "${GREEN}✓ 备份完成 (${BACKUP_DIR})${NC}"

# --- Add marketplace sources ---
echo -e "${YELLOW}[3/5] 添加 marketplace 源...${NC}"

declare -A MARKETPLACES
MARKETPLACES["understand-anything"]="Lum1104/Understand-Anything"
MARKETPLACES["anthropic-agent-skills"]="anthropics/skills"
MARKETPLACES["baoyu-skills"]="JimLiu/baoyu-skills"
MARKETPLACES["superpowers-marketplace"]="obra/superpowers-marketplace"
MARKETPLACES["obsidian-skills"]="kepano/obsidian-skills"
MARKETPLACES["stata-skill"]="dylantmoore/stata-skill"

# Read existing marketplaces or create new
if [ -f "$MARKETPLACES_FILE" ]; then
    MARKETPLACES_JSON=$(cat "$MARKETPLACES_FILE")
else
    MARKETPLACES_JSON="{}"
fi

ADDED_COUNT=0
for KEY in "${!MARKETPLACES[@]}"; do
    REPO="${MARKETPLACES[$KEY]}"
    if echo "$MARKETPLACES_JSON" | python3 -c "import json,sys; d=json.load(sys.stdin); print('$KEY' in d)" 2>/dev/null | grep -q "True"; then
        echo -e "  ${YELLOW}→ $KEY 已存在，跳过${NC}"
    else
        # Determine install location
        INSTALL_PATH="$PLUGINS_DIR/marketplaces/$KEY"
        mkdir -p "$INSTALL_PATH"

        NEW_ENTRY=$(cat <<EOF
{
  "source": {"source": "github", "repo": "$REPO"},
  "installLocation": "$INSTALL_PATH",
  "lastUpdated": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
}
EOF
)
        MARKETPLACES_JSON=$(echo "$MARKETPLACES_JSON" | python3 -c "
import json, sys
d = json.load(sys.stdin)
d['$KEY'] = ${NEW_ENTRY}
print(json.dumps(d, indent=2))
")
        echo -e "  ${GREEN}✓ 添加 $KEY ($REPO)${NC}"
        ADDED_COUNT=$((ADDED_COUNT + 1))
    fi
done

echo "$MARKETPLACES_JSON" > "$MARKETPLACES_FILE"
echo -e "${GREEN}✓ Marketplace 源配置完成 (新增 $ADDED_COUNT 个)${NC}"

# --- Install plugins ---
echo -e "${YELLOW}[4/5] 安装插件...${NC}"

# Read existing installed plugins
if [ -f "$INSTALLED_FILE" ]; then
    INSTALLED_JSON=$(cat "$INSTALLED_FILE")
else
    INSTALLED_JSON='{"version": 2, "plugins": {}}'
fi

declare -A PLUGINS
PLUGINS["understand-anything@understand-anything"]="understand-anything/understand-anything/2.7.5"
PLUGINS["document-skills@anthropic-agent-skills"]="anthropic-agent-skills/document-skills/690f15cac7f7"
PLUGINS["baoyu-skills@baoyu-skills"]="baoyu-skills/baoyu-skills/77dd193b5889"
PLUGINS["superpowers@superpowers-marketplace"]="superpowers-marketplace/superpowers/5.1.0"
PLUGINS["obsidian@obsidian-skills"]="obsidian-skills/obsidian/1.0.1"
PLUGINS["stata-bundle@stata-skill"]="stata-skill/stata-bundle/1.1.0"

INSTALLED_COUNT=0
for PLUGIN_KEY in "${!PLUGINS[@]}"; do
    CACHE_PATH="${PLUGINS_DIR}/cache/${PLUGINS[$PLUGIN_KEY]}"

    if echo "$INSTALLED_JSON" | python3 -c "import json,sys; d=json.load(sys.stdin); p=d.get('plugins',{}); print('$PLUGIN_KEY' in p)" 2>/dev/null | grep -q "True"; then
        echo -e "  ${YELLOW}→ $PLUGIN_KEY 已安装，跳过${NC}"
    else
        # For a fresh install, we note the plugin but can't actually download it here
        # Users need to run Claude Code to complete the download
        INSTALLED_JSON=$(echo "$INSTALLED_JSON" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'plugins' not in d:
    d['plugins'] = {}
d['plugins']['$PLUGIN_KEY'] = [{
    'scope': 'user',
    'installPath': '${PLUGINS_DIR}/cache/${PLUGINS[$PLUGIN_KEY]}',
    'version': '${PLUGINS[$PLUGIN_KEY]##*/}',
    'installedAt': '$(date -u +%Y-%m-%dT%H:%M:%S.000Z)',
    'lastUpdated': '$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'
}]
print(json.dumps(d, indent=2))
")
        echo -e "  ${GREEN}✓ 注册 $PLUGIN_KEY${NC}"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    fi
done

echo "$INSTALLED_JSON" > "$INSTALLED_FILE"
echo -e "${GREEN}✓ 插件注册完成 (新增 $INSTALLED_COUNT 个)${NC}"

# --- Install local skills ---
echo -e "${YELLOW}[5/5] 安装本地 skill...${NC}"
LOCAL_COUNT=0

if [ -d "$REPO_DIR/skills" ]; then
    for SKILL_DIR in "$REPO_DIR/skills"/*/; do
        SKILL_NAME=$(basename "$SKILL_DIR")
        TARGET_DIR="$SKILLS_DIR/$SKILL_NAME"
        mkdir -p "$TARGET_DIR"

        if [ -f "$SKILL_DIR/SKILL.md" ]; then
            cp "$SKILL_DIR/SKILL.md" "$TARGET_DIR/SKILL.md"
            echo -e "  ${GREEN}✓ 安装 local skill: $SKILL_NAME${NC}"
            LOCAL_COUNT=$((LOCAL_COUNT + 1))
        fi

        # Copy any additional files (scripts, references, etc.)
        for SUB in scripts references agents; do
            if [ -d "$SKILL_DIR/$SUB" ]; then
                cp -r "$SKILL_DIR/$SUB" "$TARGET_DIR/"
            fi
        done
    done
fi

echo -e "${GREEN}✓ 本地 skill 安装完成 (共 $LOCAL_COUNT 个)${NC}"

# --- Done ---
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  安装完成！请重启 Claude Code 以生效          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "备份位置: ${BLUE}${BACKUP_DIR}${NC}"
echo ""
echo -e "${YELLOW}注意：${NC}"
echo -e "- 部分插件需要在 Claude Code 启动后自动下载完成"
echo -e "- 如果遇到权限问题，请手动在 Claude Code 中运行："
echo -e "  ${BLUE}/claude plugins add https://github.com/obra/superpowers-marketplace${NC}"
echo -e "  ${BLUE}/claude plugins add https://github.com/anthropics/skills${NC}"
echo -e "  ${BLUE}/claude plugins add https://github.com/JimLiu/baoyu-skills${NC}"
echo -e "  ${BLUE}/claude plugins add https://github.com/kepano/obsidian-skills${NC}"
echo -e "  ${BLUE}/claude plugins add https://github.com/Lum1104/Understand-Anything${NC}"
echo -e "  ${BLUE}/claude plugins add https://github.com/dylantmoore/stata-skill${NC}"
