---
description: "Execute an approved plan or spec. With a plan: subagent-driven, fresh subagent per task, two-stage review. With only a spec: lightweight in-session TDD. A plan is optional — work is decoupled from plan."
---

Pick the execution path by what exists. A plan is **not** required — `/work` runs against a plan when one exists, or directly against an approved spec when it doesn't.

**A plan exists** (`docs/devstack/plans/<plan-file>.md`) → invoke `devstack:subagent-driven-development` — fresh subagent per task with two-stage review (spec compliance, then code quality). If subagents aren't available, fall back to `devstack:executing-plans` with batch checkpoints.

**Only an approved spec exists** (`docs/devstack/specs/<spec-file>.md`, no plan) → lightweight path: implement the spec directly in this session with `devstack:incremental-implementation` (thin vertical slices — implement, test, verify, commit per slice) and `devstack:test-driven-development` (failing test first). The spec is the contract; there's no task graph. Use this for small, self-contained work. If the spec turns out to be large or spans multiple subsystems, stop and run `/plan` instead.

Requirements:
- **Plan path** — a worktree is set up (otherwise use `devstack:using-git-worktrees` first). Subagent-driven execution wants an isolated workspace.
- **Spec-only lightweight path** — a worktree is **optional**. For a small self-contained change, a feature branch in the current checkout is enough; set up a worktree only if you want the isolation. Don't add the ceremony the lightweight path exists to avoid.
- **Both paths** — never land on `main` / `master` without explicit user consent (default: no). This is the real safety rule; the worktree is just convenience.

After all work completes, dispatch a final full-diff code review (`devstack:requesting-code-review`), then invoke `devstack:finishing-a-development-branch` to complete.
