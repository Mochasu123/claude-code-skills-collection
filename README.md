# Claude Code Skills Collection 🚀

> 一站式 Claude Code Skill 合集 — 50+ 高质量 skill，覆盖前端设计、文档处理、代码分析、Obsidian、AI 翻译、图表绘制等场景
>
> **安装方式：克隆本仓库 → 运行安装脚本 → 重启 Claude Code → 开始使用**

---

## 📦 快速安装

### 方式一：一键安装脚本（推荐）

```bash
# macOS / Linux
git clone https://github.com/Mochasu123/claude-code-skills-collection.git
cd claude-code-skills-collection
chmod +x install.sh
./install.sh

# Windows (PowerShell)
git clone https://github.com/Mochasu123/claude-code-skills-collection.git
cd claude-code-skills-collection
.\install.ps1
```

### 方式二：逐一手动添加 marketplace 源

在 Claude Code 中执行以下命令添加每个 marketplace：

```
/claude plugins add https://github.com/obra/superpowers-marketplace
/claude plugins add https://github.com/anthropics/skills
/claude plugins add https://github.com/JimLiu/baoyu-skills
/claude plugins add https://github.com/kepano/obsidian-skills
/claude plugins add https://github.com/Lum1104/Understand-Anything
/claude plugins add https://github.com/dylantmoore/stata-skill
```

### 方式三：直接使用本仓库作为 marketplace 源

```
/claude plugins add https://github.com/Mochasu123/claude-code-skills-collection
```

---

## 📋 Skill 目录

### ⚡ Superpowers — 工作流增强（来自 [obra/superpowers-marketplace](https://github.com/obra/superpowers-marketplace)）

| Skill | 说明 |
|-------|------|
| `brainstorming` | 创意工作前的需求/设计探索 |
| `using-superpowers` | Superpowers 使用指南 |
| `writing-plans` | 编写实施计划 |
| `executing-plans` | 在独立会话中执行计划 |
| `dispatching-parallel-agents` | 并行处理独立任务 |
| `subagent-driven-development` | 在当前会话中执行计划 |
| `verification-before-completion` | 完成前的自动化验证 |
| `systematic-debugging` | 结构化调试流程 |
| `test-driven-development` | 测试驱动开发（TDD）流程 |
| `requesting-code-review` | 请求代码审查 |
| `receiving-code-review` | 接收代码审查反馈 |
| `finishing-a-development-branch` | 完成开发分支后的操作 |
| `simplify` | 代码质量与效率审查 |
| `using-git-worktrees` | Git Worktree 隔离工作空间 |
| `fewer-permission-prompts` | 减少权限提示 |
| `writing-skills` | 创建/编辑新的 skill |
| `update-config` | 配置 Claude Code 设置 |
| `keybindings-help` | 自定义键盘快捷键 |
| `loop` | 定时循环执行任务 |

### 🎨 Anthropic 官方 — 设计与文档（来自 [anthropics/skills](https://github.com/anthropics/skills)）

| Skill | 说明 |
|-------|------|
| `frontend-design` | 高质量前端界面设计 |
| `canvas-design` | 艺术海报/图片设计 |
| `web-artifacts-builder` | 复杂 HTML artifact 构建 |
| `algorithmic-art` | p5.js 算法艺术创作 |
| `brand-guidelines` | Anthropic 品牌风格应用 |
| `theme-factory` | 主题定制工具包 |
| `docx` | Word 文档创建与编辑 |
| `pptx` | PowerPoint 演示文稿 |
| `pdf` | PDF 文件处理 |
| `xlsx` | 电子表格处理 |
| `doc-coauthoring` | 文档协作编写工作流 |
| `internal-comms` | 内部沟通文书撰写 |
| `slack-gif-creator` | Slack 动图制作 |
| `mcp-builder` | MCP 服务器构建指南 |
| `skill-creator` | 创建/优化 skill |
| `webapp-testing` | 本地 Web 应用测试 |
| `claude-api` | Claude API / Anthropic SDK 开发 |

### 🌏 Baoyu 生态 — 内容创作与发布（来自 [JimLiu/baoyu-skills](https://github.com/JimLiu/baoyu-skills)）

| Skill | 说明 |
|-------|------|
| `baoyu-translate` | 多语言翻译（快速/正常/精翻三种模式） |
| `baoyu-url-to-markdown` | 网页转 Markdown |
| `baoyu-youtube-transcript` | YouTube 字幕下载 |
| `baoyu-wechat-summary` | 微信群聊精华总结 |
| `baoyu-post-to-wechat` | 发布到微信公众号 |
| `baoyu-post-to-x` | 发布到 X/Twitter |
| `baoyu-post-to-weibo` | 发布到微博 |
| `baoyu-danger-x-to-markdown` | X 推文转 Markdown |
| `baoyu-markdown-to-html` | Markdown 转 HTML |
| `baoyu-image-gen` | AI 图片生成（多 API） |
| `baoyu-cover-image` | 文章封面图生成 |
| `baoyu-article-illustrator` | 文章插图生成 |
| `baoyu-xhs-images` | 小红书图片卡片 |
| `baoyu-infographic` | 信息图生成 |
| `baoyu-diagram` | SVG 图表/架构图 |
| `baoyu-slide-deck` | 幻灯片图片生成 |
| `baoyu-comic` | 知识漫画创作 |
| `baoyu-format-markdown` | Markdown 格式化 |
| `baoyu-compress-image` | 图片压缩 |
| `baoyu-electron-extract` | Electron 应用源码提取 |
| `baoyu-danger-gemini-web` | Gemini Web API 逆向接口 |

### 📝 Obsidian — 笔记与知识管理（来自 [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)）

| Skill | 说明 |
|-------|------|
| `obsidian-markdown` | Obsidian 格式 Markdown |
| `obsidian-cli` | Obsidian CLI 交互 |
| `obsidian-bases` | Obsidian Bases 数据库视图 |
| `json-canvas` | JSON Canvas 可视画布 |
| `obsidian:defuddle` | 网页内容转 Markdown |

### 🔍 Understand Anything — 代码分析（来自 [Lum1104/Understand-Anything](https://github.com/Lum1104/Understand-Anything)）

| Skill | 说明 |
|-------|------|
| `understand` | 代码库知识图谱分析 |
| `understand-explain` | 代码深度解释 |
| `understand-diff` | Git diff/PR 变更分析 |
| `understand-onboard` | 新成员上手指南 |
| `understand-chat` | 基于知识图谱的代码问答 |
| `understand-dashboard` | 知识图谱可视化仪表盘 |
| `understand-knowledge` | LLM wiki 知识库分析 |
| `understand-domain` | 业务领域知识提取 |

### 🤖 AI 生成 — 图像与文本（本仓库打包）

| Skill | 说明 |
|-------|------|
| `agnes-ai-generation` | Agnes AI / Sapiens AI API — 文本、图像、视频生成 |

### 📊 统计工具（来自 [dylantmoore/stata-skill](https://github.com/dylantmoore/stata-skill)）

| Skill | 说明 |
|-------|------|
| `stata` | Stata 统计分析 |
| `stata-c-plugins` | Stata C 插件开发 |
| `stata-skill-contributor` | Stata skill 贡献指南 |

---

## 🎯 使用场景推荐

| 你想做什么 | 推荐 Skill |
|-----------|-----------|
| 写前端页面/组件 | `frontend-design` |
| 写 Word/PPT/PDF 文档 | `docx` / `pptx` / `pdf` |
| 处理 Excel 表格 | `xlsx` |
| 翻译外文文章 | `baoyu-translate` |
| 保存网页为 Markdown | `baoyu-url-to-markdown` / `obsidian:defuddle` |
| 发布公众号文章 | `baoyu-post-to-wechat` |
| 画架构图/流程图 | `baoyu-diagram` |
| 分析陌生代码库 | `understand` |
| 调试 bug | `systematic-debugging` |
| TDD 开发 | `test-driven-development` |
| 代码审查 | `requesting-code-review` |
| 构建 MCP Server | `mcp-builder` |
| Obsidian 插件开发 | `obsidian-cli` |
| 下载 YouTube 字幕 | `baoyu-youtube-transcript` |
| 创建信息图/海报 | `baoyu-infographic` / `canvas-design` |

---

## 🛠 安装脚本说明

### install.sh（macOS / Linux）

自动执行以下操作：
1. 备份现有配置文件
2. 向 `known_marketplaces.json` 添加所有 marketplace 源
3. 向 `installed_plugins.json` 注册所有插件
4. 将本地 skill（agnes-ai-generation）复制到 `.claude/skills/` 目录
5. 验证安装结果

### install.ps1（Windows）

功能同上，适用于 Windows PowerShell 环境。

---

## 📁 仓库结构

```
claude-code-skills-collection/
├── README.md                    # 本文件
├── install.sh                   # macOS/Linux 安装脚本
├── install.ps1                  # Windows 安装脚本
├── .claude-plugin/
│   └── marketplace.json         # 本仓库作为 marketplace 源的配置文件
└── skills/
    └── agnes-ai-generation/     # 本地打包的 skill（不在 marketplace 上）
        └── SKILL.md
```

---

## 📄 许可

- 各 marketplace skill 遵循其原始仓库的许可条款
- 本仓库的安装脚本和文档采用 MIT 许可
- 详见各原始仓库的 LICENSE 文件：
  - [Superpowers](https://github.com/obra/superpowers-marketplace)
  - [Anthropic Skills](https://github.com/anthropics/skills)
  - [Baoyu Skills](https://github.com/JimLiu/baoyu-skills)
  - [Obsidian Skills](https://github.com/kepano/obsidian-skills)
  - [Understand Anything](https://github.com/Lum1104/Understand-Anything)
  - [Stata Skill](https://github.com/dylantmoore/stata-skill)

---

*Generated with ❤️ by Claude Code*
