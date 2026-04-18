# 快速上手

> [English version](getting-started.md)

## 安装

### Claude Code（本地开发时）

让 Claude Code 直接指向本地克隆：

```bash
claude --plugin-dir /Users/max/Projects/prompt/devstack
```

或者推到 git 托管并配好 marketplace 后：

```bash
/plugin marketplace add <your-org>/devstack
/plugin install devstack@devstack
```

### 其他智能体

因为每个 skill 都是带 YAML frontmatter 的纯 Markdown 文件，devstack 在任何能加载 skill 的地方都能用：

- **Cursor** — 把 `skills/**/SKILL.md` 复制到 `.cursor/rules/`
- **Gemini CLI** — `gemini skills install /path/to/devstack/skills`
- **OpenCode / Codex / Copilot** — 参考 [Superpowers 文档](https://github.com/obra/superpowers/tree/main/docs) 和 [agent-skills 文档](https://github.com/addyosmani/agent-skills/tree/main/docs) 的配置方式，同样适用于 devstack

## 第一次使用

装好之后，在任何项目里：

```bash
/devstack
```

这会加载 `using-devstack`，介绍三层模型、slash 命令以及各自的触发时机。

## 日常工作流

### 小修复（一个文件，<10 分钟）

直接描述要改什么。`core/` 层（TDD、调试、验证）自动生效，不触发任何流程。

### 中等改动（几个文件，需求清晰）

从 `/plan` 开始。如果规格已经明确就跳过 `/brainstorm`。规划变成小任务列表，然后 `/work` 执行。

### 大改动（新功能、新子系统、架构级）

完整流程：

```bash
/brainstorm   # 把想法打磨成规格，拿到批准，存到 docs/devstack/specs/
/plan         # 把规格拆成精确任务，存到 docs/devstack/plans/
/work         # subagent 驱动执行，每任务两阶段 review
/review       # 全量 diff 五轴 review（合并前）
/ship         # 上线前清单 + 合并或 PR
```

每阶段都有硬闸（HARD-GATE），不能跳过上一阶段的验收就往下走。

## 出问题怎么办

- **智能体跳步了。** 明确告诉它调用哪个 skill，它会回到对应阶段。
- **某个 skill 不适合当前任务。** 告诉智能体；skill 系统允许在说明理由后退出。
- **上游有更新想拉进来。** 看 [docs/origins.md](origins.md) 里的逐 skill 归属记录，对比上游变更，决定是否采纳。

## 接下来

- [docs/philosophy.md](philosophy_zh-CN.md) — devstack 建立在哪五条信念上
- [docs/extending.md](extending_zh-CN.md) — 怎么加 iOS / Android / Rust / Go skill
- [CREDITS.md](../CREDITS.md) — 哪些内容来自哪里
