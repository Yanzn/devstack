# Origins Tracking

> [中文版](origins_zh-CN.md)

Per-skill upstream pinning and update notes. Use this doc when deciding whether to pull a change from Superpowers or agent-skills into devstack.

## Upstream Pins

| Upstream | Pinned Version | Pinned At | Repo |
|---|---|---|---|
| Superpowers | 5.0.7 | 2026-04-18 | https://github.com/obra/superpowers |
| agent-skills | 1.0.0 | 2026-04-18 | https://github.com/addyosmani/agent-skills |

When you review upstream changes, update these pins and note the decisions in the table below.

## Skill Provenance & Merge Notes

Rows show the devstack skill name, origin tag, and merge notes. See [CREDITS.md](../CREDITS.md) for the short-form table.

### flow/

| devstack skill | Upstream sources | Merge notes |
|---|---|---|
| `brainstorming` | `superpowers:brainstorming`, `agent-skills:idea-refine`, `agent-skills:spec-driven-development` | Keep SP HARD-GATE, socratic questioning, visual companion. Graft AS "Surface Assumptions" pattern. Adopt AS six-area spec template (objective/commands/structure/style/testing/boundaries) as the output of the design-doc step. Terminal state remains `writing-plans`. |
| `writing-plans` | `superpowers:writing-plans`, `agent-skills:planning-and-task-breakdown` | Keep SP 2-5min bite-sized tasks, exact paths, complete code per step, no-placeholder rule. Add AS acceptance criteria per task and explicit dependency ordering. |
| `executing-plans` | `superpowers:executing-plans` | Direct port. |
| `subagent-driven-development` | `superpowers:subagent-driven-development` | Direct port. Keep two-stage review. |
| `dispatching-parallel-agents` | `superpowers:dispatching-parallel-agents` | Direct port. |
| `using-git-worktrees` | `superpowers:using-git-worktrees` | Direct port. |
| `requesting-code-review` | `superpowers:requesting-code-review` | Direct port. Cross-reference standards/code-review-and-quality for the review criteria. |
| `receiving-code-review` | `superpowers:receiving-code-review` | Direct port. |
| `finishing-a-development-branch` | `superpowers:finishing-a-development-branch`, `agent-skills:git-workflow-and-versioning` | Keep SP decision tree (merge/PR/keep/discard) and worktree cleanup. Graft AS trunk-based guidance, atomic-commit rule, and change-sizing (~100 lines). |

### core/

| devstack skill | Upstream sources | Merge notes |
|---|---|---|
| `test-driven-development` | `superpowers:test-driven-development`, `agent-skills:test-driven-development` | Keep SP Iron Law ("no production code without a failing test first"), delete-and-restart rule, RED-GREEN-REFACTOR cycle. Graft AS test pyramid (80/15/5), DAMP-over-DRY, Beyoncé Rule, test-size categorization. |
| `systematic-debugging` | `superpowers:systematic-debugging`, `agent-skills:debugging-and-error-recovery` | Keep SP 4-phase structure (investigate → analyze → hypothesize → implement) and "no fix without root cause" iron law. Graft AS 5-step triage (reproduce, localize, reduce, fix, guard) as concrete tactics inside the Investigate and Implement phases. Include AS "stop-the-line" rule. |
| `verification-before-completion` | `superpowers:verification-before-completion` | Direct port. |
| `incremental-implementation` | `agent-skills:incremental-implementation` | Direct port. |
| `context-engineering` | `agent-skills:context-engineering` | Direct port. |

### standards/

All direct ports from agent-skills unless noted:

| devstack skill | Upstream | Notes |
|---|---|---|
| `api-and-interface-design` | `agent-skills:api-and-interface-design` | — |
| `frontend-ui-engineering` | `agent-skills:frontend-ui-engineering` | — |
| `security-and-hardening` | `agent-skills:security-and-hardening` | — |
| `performance-optimization` | `agent-skills:performance-optimization` | — |
| `code-review-and-quality` | `agent-skills:code-review-and-quality` | Cross-reference flow/requesting-code-review for the request mechanics. |
| `code-simplification` | `agent-skills:code-simplification` | — |
| `documentation-and-adrs` | `agent-skills:documentation-and-adrs` | — |
| `git-workflow-and-versioning` | `agent-skills:git-workflow-and-versioning` | Some content also lives in flow/finishing-a-development-branch; keep the detailed reference here. |
| `ci-cd-and-automation` | `agent-skills:ci-cd-and-automation` | — |
| `shipping-and-launch` | `agent-skills:shipping-and-launch` | — |
| `deprecation-and-migration` | `agent-skills:deprecation-and-migration` | — |
| `source-driven-development` | `agent-skills:source-driven-development` | — |
| `browser-testing-with-devtools` | `agent-skills:browser-testing-with-devtools` | — |

### meta/

| devstack skill | Upstream | Notes |
|---|---|---|
| `writing-skills` | `superpowers:writing-skills` | Direct port. Used when adding new devstack skills (iOS, Android, etc). |

## Upstream Change Review Log

Record each time you evaluate an upstream update:

| Date | Upstream | From → To | Decision | Skills touched |
|---|---|---|---|---|
| 2026-04-18 | both | — → initial | Imported for v0.1.0 scaffold | — (content lands in batches 2-4) |
