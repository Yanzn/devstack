# 上游追溯

> [English version](origins.md)

逐 skill 的上游版本固定和更新决策记录。决定是否从 Superpowers、agent-skills、andrej-karpathy-skills 或 mattpocock/skills 拉取更新时，用这份文档。

## 上游版本固定

| 上游 | 固定版本 | 固定日期 | 仓库 |
|---|---|---|---|
| Superpowers | 5.0.7 | 2026-04-18 | https://github.com/obra/superpowers |
| agent-skills | 1.0.0 | 2026-04-18 | https://github.com/addyosmani/agent-skills |
| andrej-karpathy-skills | CLAUDE.md @ 2025-10 | 2026-04-20 | https://github.com/forrestchang/andrej-karpathy-skills |
| mattpocock/skills | main @ 2026-04-26 | 2026-04-26 | https://github.com/mattpocock/skills |

每次评估完上游变更后，更新这里的版本号，在下方决策日志里记下结论。

## Skill 出处与合并说明

行列出 devstack skill 名称、出处标记、合并说明。短格式表见 [CREDITS.md](../CREDITS.md)。

### flow/

| devstack skill | 上游来源 | 合并说明 |
|---|---|---|
| `brainstorming` | `superpowers:brainstorming`, `agent-skills:idea-refine`, `agent-skills:spec-driven-development` | 保留 SP 的 HARD-GATE、socratic 提问、visual companion、分段审批；植入 AS 的 "Surface Assumptions" 模式；采用 AS 的六区 spec 模板（objective / commands / structure / style / testing / boundaries）作为输出格式，替换 SP 较松散的"architecture / components / data flow"指引；保留 SP 的 "Not Doing" 列表作为必填区。终点仍然是调用 `writing-plans`。 |
| `writing-plans` | `superpowers:writing-plans`, `agent-skills:planning-and-task-breakdown`, `karpathy-skills:CLAUDE.md Principle 4` | 保留 SP 的 2-5 分钟小任务、精确路径、每步完整代码、零占位规则；增加 AS 的每任务验收标准、明确的依赖排序、任务规模 XS/S/M/L 分级、阶段间 checkpoint；植入 KS 的"指令→可验证目标"转换模式，新增 "Framing Tasks as Verifiable Goals" 段落。 |
| `executing-plans` | `superpowers:executing-plans` | 直接移植。 |
| `subagent-driven-development` | `superpowers:subagent-driven-development` | 直接移植。保留两阶段 review。 |
| `dispatching-parallel-agents` | `superpowers:dispatching-parallel-agents`, `mattpocock-skills:improve-codebase-architecture/INTERFACE-DESIGN.md` | SP 基底移植（一个 agent 处理一个独立问题域）；植入 MP "Design It Twice" 模式作为该原语的具名应用 —— 三个或以上 agent 为同一个加深候选并行产出"截然不同"的接口设计，由调度方对比并给出推荐。 |
| `using-git-worktrees` | `superpowers:using-git-worktrees` | 直接移植。 |
| `requesting-code-review` | `superpowers:requesting-code-review` | 直接移植。交叉引用 standards/code-review-and-quality 作为 review 标准。 |
| `receiving-code-review` | `superpowers:receiving-code-review` | 直接移植。 |
| `finishing-a-development-branch` | `superpowers:finishing-a-development-branch`, `agent-skills:git-workflow-and-versioning` | 保留 SP 的决策树（merge/PR/keep/discard）和 worktree 清理；植入 AS 的 trunk-based 原则、原子提交规则、~100 行变更大小约束。 |
| `improving-architecture` | `mattpocock-skills:improve-codebase-architecture` | 直接整体嫁接 MP skill（SKILL + LANGUAGE + DEEPENING + INTERFACE-DESIGN）。按 devstack 动名词命名约定改名。交叉引用从 `../domain-model/*` 重写为 `../domain-modeling/*`（devstack 命名）；并把 MP 单一 ADR 模板拆为：轻量版留在本 skill 的伴随文件，重量版指向 `standards/documentation-and-adrs`。 |
| `domain-modeling` | `mattpocock-skills:domain-model` | 直接整体嫁接 MP skill（SKILL + CONTEXT-FORMAT + ADR-FORMAT）。按 devstack 动名词命名约定改名。保留 `disable-model-invocation: true` —— 仅手动触发。ADR-FORMAT 明确为轻量变体，并交叉引用 `standards/documentation-and-adrs` 作为重量版模板。 |

### core/

| devstack skill | 上游来源 | 合并说明 |
|---|---|---|
| `test-driven-development` | `superpowers:test-driven-development`, `agent-skills:test-driven-development` | 保留 SP 的 Iron Law（"没有失败测试就不允许写生产代码"）、删-重写规则、RED-GREEN-REFACTOR 循环；植入 AS 的测试金字塔（80/15/5）、DAMP-over-DRY、Beyoncé Rule、测试大小分级。 |
| `systematic-debugging` | `superpowers:systematic-debugging`, `agent-skills:debugging-and-error-recovery` | 保留 SP 的 4 阶段结构（investigate → analyze → hypothesize → implement）和"没根因不允许修复"的铁律；植入 AS 的 5 步 triage（reproduce / localize / reduce / fix / guard）作为 Investigate 和 Implement 阶段的具体战术；加入 AS 的"stop-the-line"规则。 |
| `verification-before-completion` | `superpowers:verification-before-completion` | 直接移植。 |
| `incremental-implementation` | `agent-skills:incremental-implementation`, `karpathy-skills:CLAUDE.md Principle 3` | 以 AS 为基底移植；植入 KS 的孤儿清理规则到 Rule 0.5 Scope Discipline：你自己改动产生的孤儿代码要清理，已经存在的死代码不要碰。 |
| `context-engineering` | `agent-skills:context-engineering`, `karpathy-skills:CLAUDE.md Principle 1` | 以 AS 为基底移植；植入 KS 的"适时推回异议"模式到 Confusion Management，新增 "When You Disagree — Push Back" 段落。 |

### standards/

除特别说明外都是 agent-skills 的直接移植：

| devstack skill | 上游 | 备注 |
|---|---|---|
| `api-and-interface-design` | `agent-skills:api-and-interface-design`, `mattpocock-skills:improve-codebase-architecture/LANGUAGE.md` | AS 基底移植（Hyrum's Law、REST 模式、边界校验纪律）；植入 MP 架构词汇表作为新的 "Architecture Vocabulary" 段落 —— 跨 review、planning 和架构改进 skill 的 module/interface/depth/seam/adapter/leverage/locality 术语的单一真相源。 |
| `frontend-ui-engineering` | `agent-skills:frontend-ui-engineering` | — |
| `security-and-hardening` | `agent-skills:security-and-hardening` | — |
| `performance-optimization` | `agent-skills:performance-optimization` | — |
| `code-review-and-quality` | `agent-skills:code-review-and-quality` | 交叉引用 flow/requesting-code-review 作为请求机制。 |
| `code-simplification` | `agent-skills:code-simplification` | — |
| `documentation-and-adrs` | `agent-skills:documentation-and-adrs` | AS 移植。新增交叉引用指向 `flow/domain-modeling/ADR-FORMAT.md` 的轻量 1–3 句 ADR 变体；本 skill 仍是重量版 Status / Date / Context / Decision / Consequences 模板的真相源。 |
| `git-workflow-and-versioning` | `agent-skills:git-workflow-and-versioning` | 部分内容也存在于 flow/finishing-a-development-branch，这里保留完整参考。 |
| `ci-cd-and-automation` | `agent-skills:ci-cd-and-automation` | — |
| `shipping-and-launch` | `agent-skills:shipping-and-launch` | — |
| `deprecation-and-migration` | `agent-skills:deprecation-and-migration` | — |
| `source-driven-development` | `agent-skills:source-driven-development` | — |
| `browser-testing-with-devtools` | `agent-skills:browser-testing-with-devtools` | — |

### meta/

| devstack skill | 上游 | 备注 |
|---|---|---|
| `writing-skills` | `superpowers:writing-skills` | 直接移植。用于给 devstack 添加新 skill（iOS、Android 等）。 |

## 上游变更评审日志

每次评估上游更新时在这里记录：

| 日期 | 上游 | 版本变化 | 决策 | 涉及 skill |
|---|---|---|---|---|
| 2026-04-18 | 两者 | — → initial | 导入作为 v0.1.0 脚手架 | — （内容在批次 2-4 陆续落地） |
| 2026-04-20 | andrej-karpathy-skills | — → CLAUDE.md @ 2025-10 | 嫁接 4 原则中的 3 条（原则 2 简洁优先与 code-simplification + incremental-implementation Rule 0 重复，跳过） | `core/context-engineering`、`core/incremental-implementation`、`flow/writing-plans` |
| 2026-04-26 | mattpocock/skills | — → main @ 2026-04-26 | 整体嫁接 `improve-codebase-architecture` 与 `domain-model` 两个 skill；架构词汇表注入 `api-and-interface-design`，"Design It Twice" 注入 `dispatching-parallel-agents`；从 `documentation-and-adrs` 交叉引用轻量 ADR 变体 | `flow/improving-architecture`（新）、`flow/domain-modeling`（新）、`flow/dispatching-parallel-agents`、`standards/api-and-interface-design`、`standards/documentation-and-adrs` |
