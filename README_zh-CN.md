# devstack

**面向 AI 编码智能体的全套开发规范。** 一套从头脑风暴到上线的流程纪律，融合生产级工程标准。覆盖 Web 前端、Python/Django、Java/Spring，可扩展到 iOS、Android，以及未来任何你要做的技术栈。

> [English version](README.md)

---

## 这是什么

devstack 把"资深工程师的做事方式"打包成一整套可执行的工作流，让 AI 编码智能体按照专业标准产出代码：

1. **先想清楚再动手** — 把模糊的想法提炼成书面规格，拿到用户批准
2. **拆成小任务再执行** — 每一步都有明确文件、完整代码、验收标准
3. **严格纪律执行** — 每个任务派独立 subagent，两阶段 review，TDD 全程
4. **按规范 review** — 五轴评审、安全、性能、无障碍全面覆盖
5. **稳妥发布** — 上线前清单、功能开关、回滚方案

整体分为三层：

| 层 | 作用 | 何时触发 |
|---|---|---|
| **flow/** | 工作流骨架：brainstorm → plan → work → review → ship | 由 `/devstack`、`/brainstorm`、`/plan`、`/work`、`/review`、`/ship` 触发 |
| **core/** | 跨切纪律：TDD、系统化调试、验证、增量实施 | 任何写代码的动作自动触发 |
| **standards/** | 领域知识：API 设计、安全、前端、性能、文档、Git、CI/CD、发布 | 按领域自动触发，或在 `/review` / `/ship` 时整体触发 |

完整设计哲学见 **[docs/philosophy.md](docs/philosophy.md)**。

---

## 项目渊源

devstack 是一次融合重构。三个开源项目提供了原始素材：

- **[Superpowers](https://github.com/obra/superpowers)**（作者 Jesse Vincent）— 贡献了工作流骨架、subagent 编排、git worktree 模式，以及"流程即强制"的高压声音
- **[agent-skills](https://github.com/addyosmani/agent-skills)**（作者 Addy Osmani）— 贡献了工程规范内容：Hyrum's Law API 设计、OWASP 安全、Core Web Vitals 性能、ADR、trunk-based git、CI/CD、发布清单，以及开发阶段分类体系
- **[andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)**（作者 Forrest Chang，提炼自 [Andrej Karpathy](https://x.com/karpathy/status/2015883857489522876) 对 LLM 编码陷阱的观察）— 贡献了四条行为原则，其中三条被嫁接到现有 skill 中：推回异议模式（`core/context-engineering`）、精准修改的孤儿清理规则（`core/incremental-implementation`）、以及"指令→可验证目标"的任务框定法（`flow/writing-plans`）

devstack 不是一个加载器或绑定器。它是一个**全新、独立的项目**，在三者思想基础上构建。每个 skill 都经过评审、合并（对于重叠的部分）、并重新调整到统一的声音和命名空间下。

逐 skill 归属表见 **[CREDITS.md](CREDITS.md)**，升级追踪见 **[docs/origins.md](docs/origins.md)**。

三个上游项目都是 MIT 协议。devstack 也是 MIT 协议。

---

## 快速开始

作为 Claude Code 插件安装：

```bash
/plugin marketplace add Yanzn/devstack
/plugin install devstack@devstack
```

在任何会话里：

```bash
/devstack         # 了解三层模型
/brainstorm       # 开启新功能 —— 把想法打磨成规格
/plan             # 把规格拆成小任务列表
/work             # 用 subagent 驱动模式执行
/review           # 合并前五轴代码 review
/ship             # 上线前清单 + 部署
```

日常小修小补不需要任何 slash 命令 —— `core/` 层（TDD、调试、验证）会自动生效。

---

## 典型场景

### 小改动（一个文件，<10 分钟）

直接描述要改什么。`core/` 自动触发，不走任何流程，零额外开销。

### 中等改动（几个文件，需求清晰）

从 `/plan` 开始，跳过 `/brainstorm`。规划→执行。

### 大改动（新功能、架构变更）

完整流程：

```bash
/brainstorm   # 打磨规格，拿到批准，存到 docs/devstack/specs/
/plan         # 规格拆成精确任务，存到 docs/devstack/plans/
/work         # subagent 驱动执行，每任务两阶段 review
/review       # 全量 diff 五轴 review
/ship         # 上线前清单 + 合并或 PR
```

每个阶段都有硬闸（HARD-GATE），不能跳过上一阶段的验收就往下走。

---

## 扩展性

加新技术栈（iOS、Android、Rust、Go…）只需在 `standards/` 下加对应 skill，**不碰 flow/ 和 core/**。详见 **[docs/extending.md](docs/extending.md)**。

举例：要给 iOS 加 Swift 并发规范：

```bash
skills/standards/ios-swift-concurrency/
└── SKILL.md
```

用 `meta/writing-skills` 指导写法，在 CREDITS.md 和 origins.md 登记，完工。现有任何 skill 都不用动。

---

## 为什么是这三层

两个上游项目各解决了一半问题：

- **Superpowers** 回答"怎么干活"（流程），但不说"什么是好代码"
- **agent-skills** 回答"什么是好代码"（规范），但流程骨架较弱

devstack 的核心判断：**两者正交，应该叠加使用**。

```
┌─────────────────────────────────────────────────┐
│  flow/      工作流骨架（Superpowers 启发）       │
├─────────────────────────────────────────────────┤
│  core/      跨切纪律（始终生效）                 │
├─────────────────────────────────────────────────┤
│  standards/ 领域知识（agent-skills 启发）        │
└─────────────────────────────────────────────────┘
```

三层互不耦合。换掉一层，其他两层照常工作。加 iOS skill 不动 flow/，重写 flow/ 不动 standards/。

---

## 当前状态

**v0.1.0 — 29 个 SKILL.md，6 个 slash 命令，3 个 agent，4 个参考清单。** 完整 skill 集合分 4 批交付完毕。详见 [CHANGELOG.md](CHANGELOG.md)。

验证完整性：

```bash
./scripts/validate-skills.sh
```

---

## 许可

MIT。见 [LICENSE](LICENSE)。
