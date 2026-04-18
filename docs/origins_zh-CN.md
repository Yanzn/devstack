# 上游追溯

> [English version](origins.md)

逐 skill 的上游版本固定和更新决策记录。决定是否从 Superpowers 或 agent-skills 拉取更新时，用这份文档。

## 上游版本固定

| 上游 | 固定版本 | 固定日期 | 仓库 |
|---|---|---|---|
| Superpowers | 5.0.7 | 2026-04-18 | https://github.com/obra/superpowers |
| agent-skills | 1.0.0 | 2026-04-18 | https://github.com/addyosmani/agent-skills |

每次评估完上游变更后，更新这里的版本号，在下方决策日志里记下结论。

## Skill 出处与合并说明

行列出 devstack skill 名称、出处标记、合并说明。短格式表见 [CREDITS.md](../CREDITS.md)。

### flow/

| devstack skill | 上游来源 | 合并说明 |
|---|---|---|
| `brainstorming` | `superpowers:brainstorming`, `agent-skills:idea-refine`, `agent-skills:spec-driven-development` | 保留 SP 的 HARD-GATE、socratic 提问、visual companion、分段审批；植入 AS 的 "Surface Assumptions" 模式；采用 AS 的六区 spec 模板（objective / commands / structure / style / testing / boundaries）作为输出格式，替换 SP 较松散的"architecture / components / data flow"指引；保留 SP 的 "Not Doing" 列表作为必填区。终点仍然是调用 `writing-plans`。 |
| `writing-plans` | `superpowers:writing-plans`, `agent-skills:planning-and-task-breakdown` | 保留 SP 的 2-5 分钟小任务、精确路径、每步完整代码、零占位规则；增加 AS 的每任务验收标准、明确的依赖排序、任务规模 XS/S/M/L 分级、阶段间 checkpoint。 |
| `executing-plans` | `superpowers:executing-plans` | 直接移植。 |
| `subagent-driven-development` | `superpowers:subagent-driven-development` | 直接移植。保留两阶段 review。 |
| `dispatching-parallel-agents` | `superpowers:dispatching-parallel-agents` | 直接移植。 |
| `using-git-worktrees` | `superpowers:using-git-worktrees` | 直接移植。 |
| `requesting-code-review` | `superpowers:requesting-code-review` | 直接移植。交叉引用 standards/code-review-and-quality 作为 review 标准。 |
| `receiving-code-review` | `superpowers:receiving-code-review` | 直接移植。 |
| `finishing-a-development-branch` | `superpowers:finishing-a-development-branch`, `agent-skills:git-workflow-and-versioning` | 保留 SP 的决策树（merge/PR/keep/discard）和 worktree 清理；植入 AS 的 trunk-based 原则、原子提交规则、~100 行变更大小约束。 |

### core/

| devstack skill | 上游来源 | 合并说明 |
|---|---|---|
| `test-driven-development` | `superpowers:test-driven-development`, `agent-skills:test-driven-development` | 保留 SP 的 Iron Law（"没有失败测试就不允许写生产代码"）、删-重写规则、RED-GREEN-REFACTOR 循环；植入 AS 的测试金字塔（80/15/5）、DAMP-over-DRY、Beyoncé Rule、测试大小分级。 |
| `systematic-debugging` | `superpowers:systematic-debugging`, `agent-skills:debugging-and-error-recovery` | 保留 SP 的 4 阶段结构（investigate → analyze → hypothesize → implement）和"没根因不允许修复"的铁律；植入 AS 的 5 步 triage（reproduce / localize / reduce / fix / guard）作为 Investigate 和 Implement 阶段的具体战术；加入 AS 的"stop-the-line"规则。 |
| `verification-before-completion` | `superpowers:verification-before-completion` | 直接移植。 |
| `incremental-implementation` | `agent-skills:incremental-implementation` | 直接移植。 |
| `context-engineering` | `agent-skills:context-engineering` | 直接移植。 |

### standards/

除特别说明外都是 agent-skills 的直接移植：

| devstack skill | 上游 | 备注 |
|---|---|---|
| `api-and-interface-design` | `agent-skills:api-and-interface-design` | — |
| `frontend-ui-engineering` | `agent-skills:frontend-ui-engineering` | — |
| `security-and-hardening` | `agent-skills:security-and-hardening` | — |
| `performance-optimization` | `agent-skills:performance-optimization` | — |
| `code-review-and-quality` | `agent-skills:code-review-and-quality` | 交叉引用 flow/requesting-code-review 作为请求机制。 |
| `code-simplification` | `agent-skills:code-simplification` | — |
| `documentation-and-adrs` | `agent-skills:documentation-and-adrs` | — |
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
