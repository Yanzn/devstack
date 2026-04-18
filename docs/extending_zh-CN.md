# 扩展 devstack

> [English version](extending.md)

devstack 的设计原则：增加新平台和技术栈**不需要**修改 `flow/` 或 `core/`，只在 `standards/` 下添加。

## 加一个新技术栈 skill

### 第 1 步：识别差距

问自己：这个技术栈的资深工程师知道什么，通用智能体不知道？举例：

- **iOS**：Swift 并发、SwiftUI 状态管理、App Store 审核规范、Core Data 迁移、XCTest 模式
- **Android**：Kotlin 协程、Jetpack Compose、ProGuard/R8、Espresso、Play Store 政策
- **Rust**：所有权模式、`Result`/`Option` 惯用法、cargo workspace、unsafe 边界
- **Go**：错误包装、context 传播、goroutine 生命周期、table-driven 测试
- **嵌入式**：内存预算、确定性时序、中断安全

每一项变成 `skills/standards/<domain>/` 下的一个或多个 skill。

### 第 2 步：起草 SKILL.md

用 `meta/writing-skills` 作结构指引：

```
skills/standards/ios-swift-concurrency/
└── SKILL.md
```

Frontmatter 遵循 devstack 约定：

```yaml
---
name: ios-swift-concurrency
description: 指导安全且符合 Swift 习惯的 async/await、actor、结构化并发。适用于构建并发 iOS 代码——异步操作、actor 隔离、任务取消、数据竞争场景。
---
```

顶部加上归属注释：

```html
<!--
origin: [NEW]
notes: devstack 原创 skill，基于 Apple 官方文档和 Swift 并发 WWDC session 整理。
-->
```

### 第 3 步：正文结构

遵守 [docs/philosophy.md](philosophy_zh-CN.md) 里的两种声音规则：

- 如果 skill **强制行为**（例如"必须在子任务失败时取消父任务"），用 SP 的命令式声音：HARD-GATE、rationalization 反驳表、red flags。
- 如果 skill **传授原则**（例如"什么时候选 `actor` 而不是 `@MainActor class`"），用 AS 的声音：Overview / When to Use / Process / Rationalizations / Red Flags / Verification，配大量代码示例。

大部分 standards skill 属于第二种。

### 第 4 步：接入系统

- 在 [CREDITS.md](../CREDITS.md) 的 `standards/` 表格加一行
- 在 [docs/origins.md](origins.md) 加一行
- 在 `skills/using-devstack/SKILL.md` 的"各 standards 何时触发"章节提一下这个领域，让智能体知道什么时候调用它
- 如果 skill 需要根据特定上下文自动触发（例如编辑 `.swift` 文件），在 `description` 字段里写清楚这些触发条件——Claude Code 和大多数 harness 用 `description` 做发现匹配

### 第 5 步：验证

```bash
./scripts/validate-skills.sh
```

检查 frontmatter、交叉引用、失效链接。

## 加一个新 slash 命令

devstack 命令是"薄壳"——只调用一个或几个 skill（沿用 Superpowers 模式）。例如一个 iOS 专用命令：

```markdown
---
description: "iOS 提交审核前清单 —— App Store review、隐私清单、截图、entitlements"
---

调用 devstack:standards/ios-app-store-submission skill。
走完提交清单。报告任何不合格项。
```

命令应该只用于**工作流入口**，不是每个 skill 都要配命令。大部分 skill 通过 `description` 自动发现触发。

## 换掉一整层

如果你想把 devstack 的 `flow/` 换成自己的（例如更严格的 brainstorm 对话）：

1. 在 `skills/flow/` 下写你的替换 skill
2. 保持 `core/` 和 `standards/` 不动
3. 更新 `skills/using-devstack/SKILL.md` 的 flow 层介绍，指向新的 skill 名字

能这样做的原因：三层之间只按名字相互引用，不耦合实现。

## 贡献回上游

如果你写的 skill 对**所有** devstack 用户有益（不只你的团队/项目），可以考虑提交上游。但先读 Superpowers 和 agent-skills 的贡献指南——两个项目对"什么属于 core"都有自己的判断。

大多数领域专用 skill 应该放在一个扩展 devstack 的独立插件里，而不是 devstack core 本身。
