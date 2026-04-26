# Origins Tracking

> [中文版](origins_zh-CN.md)

Per-skill upstream pinning and update notes. Use this doc when deciding whether to pull a change from Superpowers, agent-skills, or andrej-karpathy-skills into devstack.

## Upstream Pins

| Upstream | Pinned Version | Pinned At | Repo |
|---|---|---|---|
| Superpowers | 5.0.7 | 2026-04-18 | https://github.com/obra/superpowers |
| agent-skills | 1.0.0 | 2026-04-18 | https://github.com/addyosmani/agent-skills |
| andrej-karpathy-skills | CLAUDE.md @ 2025-10 | 2026-04-20 | https://github.com/forrestchang/andrej-karpathy-skills |
| mattpocock/skills | main @ 2026-04-26 | 2026-04-26 | https://github.com/mattpocock/skills |

When you review upstream changes, update these pins and note the decisions in the table below.

## Skill Provenance & Merge Notes

Rows show the devstack skill name, origin tag, and merge notes. See [CREDITS.md](../CREDITS.md) for the short-form table.

### flow/

| devstack skill | Upstream sources | Merge notes |
|---|---|---|
| `brainstorming` | `superpowers:brainstorming`, `agent-skills:idea-refine`, `agent-skills:spec-driven-development` | Keep SP HARD-GATE, socratic questioning, visual companion. Graft AS "Surface Assumptions" pattern. Adopt AS six-area spec template (objective/commands/structure/style/testing/boundaries) as the output of the design-doc step. Terminal state remains `writing-plans`. |
| `writing-plans` | `superpowers:writing-plans`, `agent-skills:planning-and-task-breakdown`, `karpathy-skills:CLAUDE.md Principle 4` | Keep SP 2-5min bite-sized tasks, exact paths, complete code per step, no-placeholder rule. Add AS acceptance criteria per task and explicit dependency ordering. Graft KS instruction→verifiable-goal transformation as "Framing Tasks as Verifiable Goals". |
| `executing-plans` | `superpowers:executing-plans` | Direct port. |
| `subagent-driven-development` | `superpowers:subagent-driven-development` | Direct port. Keep two-stage review. |
| `dispatching-parallel-agents` | `superpowers:dispatching-parallel-agents`, `mattpocock-skills:improve-codebase-architecture/INTERFACE-DESIGN.md` | SP base port (one agent per independent problem domain). Grafted MP "Design It Twice" pattern as a named application — three or more agents propose radically different interface designs in parallel for the same deepening candidate. |
| `using-git-worktrees` | `superpowers:using-git-worktrees` | Direct port. |
| `requesting-code-review` | `superpowers:requesting-code-review` | Direct port. Cross-reference standards/code-review-and-quality for the review criteria. |
| `receiving-code-review` | `superpowers:receiving-code-review` | Direct port. |
| `finishing-a-development-branch` | `superpowers:finishing-a-development-branch`, `agent-skills:git-workflow-and-versioning` | Keep SP decision tree (merge/PR/keep/discard) and worktree cleanup. Graft AS trunk-based guidance, atomic-commit rule, and change-sizing (~100 lines). |
| `improving-architecture` | `mattpocock-skills:improve-codebase-architecture` | Direct graft of MP skill (SKILL + LANGUAGE + DEEPENING + INTERFACE-DESIGN). Renamed for gerund convention. Cross-references rewritten from `../domain-model/*` to `../domain-modeling/*` (devstack name) and from MP's single ADR template to a split — lightweight format here, heavyweight in `standards/documentation-and-adrs`. |
| `domain-modeling` | `mattpocock-skills:domain-model` | Direct graft of MP skill (SKILL + CONTEXT-FORMAT + ADR-FORMAT). Renamed for gerund convention. `disable-model-invocation: true` preserved — only fires manually. ADR-FORMAT clarified as the lightweight variant; cross-reference added to `standards/documentation-and-adrs` for the heavyweight template. |

### core/

| devstack skill | Upstream sources | Merge notes |
|---|---|---|
| `test-driven-development` | `superpowers:test-driven-development`, `agent-skills:test-driven-development` | Keep SP Iron Law ("no production code without a failing test first"), delete-and-restart rule, RED-GREEN-REFACTOR cycle. Graft AS test pyramid (80/15/5), DAMP-over-DRY, Beyoncé Rule, test-size categorization. |
| `systematic-debugging` | `superpowers:systematic-debugging`, `agent-skills:debugging-and-error-recovery` | Keep SP 4-phase structure (investigate → analyze → hypothesize → implement) and "no fix without root cause" iron law. Graft AS 5-step triage (reproduce, localize, reduce, fix, guard) as concrete tactics inside the Investigate and Implement phases. Include AS "stop-the-line" rule. |
| `verification-before-completion` | `superpowers:verification-before-completion` | Direct port. |
| `incremental-implementation` | `agent-skills:incremental-implementation`, `karpathy-skills:CLAUDE.md Principle 3` | AS base port. Graft KS orphan-cleanup rule into Rule 0.5 Scope Discipline: orphans YOUR changes create are in scope; pre-existing dead code is not. |
| `context-engineering` | `agent-skills:context-engineering`, `karpathy-skills:CLAUDE.md Principle 1` | AS base port. Graft KS "push back when warranted" dissent pattern into Confusion Management as "When You Disagree — Push Back". |

### standards/

All direct ports from agent-skills unless noted:

| devstack skill | Upstream | Notes |
|---|---|---|
| `api-and-interface-design` | `agent-skills:api-and-interface-design`, `mattpocock-skills:improve-codebase-architecture/LANGUAGE.md` | AS base port (Hyrum's Law, REST patterns, validation discipline). Grafted MP architecture vocabulary as "Architecture Vocabulary" section — single source of truth for module/interface/depth/seam/adapter/leverage/locality terms used across review, planning, and architecture-improvement skills. |
| `frontend-ui-engineering` | `agent-skills:frontend-ui-engineering` | — |
| `security-and-hardening` | `agent-skills:security-and-hardening` | — |
| `performance-optimization` | `agent-skills:performance-optimization` | — |
| `code-review-and-quality` | `agent-skills:code-review-and-quality` | Cross-reference flow/requesting-code-review for the request mechanics. |
| `code-simplification` | `agent-skills:code-simplification` | — |
| `documentation-and-adrs` | `agent-skills:documentation-and-adrs` | AS port. Cross-reference added to `flow/domain-modeling/ADR-FORMAT.md` for the lightweight 1–3 sentence ADR variant; this skill remains the source of truth for the heavyweight Status / Date / Context / Decision / Consequences template. |
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
| 2026-04-20 | andrej-karpathy-skills | — → CLAUDE.md @ 2025-10 | Grafted 3 of 4 principles (skipped Principle 2 as duplicate of code-simplification + incremental-implementation Rule 0) | `core/context-engineering`, `core/incremental-implementation`, `flow/writing-plans` |
| 2026-04-26 | mattpocock/skills | — → main @ 2026-04-26 | Grafted `improve-codebase-architecture` and `domain-model` skills whole; injected architecture vocabulary into `api-and-interface-design` and "Design It Twice" pattern into `dispatching-parallel-agents`; cross-referenced lightweight ADR variant from `documentation-and-adrs`. | `flow/improving-architecture` (new), `flow/domain-modeling` (new), `flow/dispatching-parallel-agents`, `standards/api-and-interface-design`, `standards/documentation-and-adrs` |
