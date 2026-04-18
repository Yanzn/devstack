---
description: "Execute an implementation plan — preferred path is subagent-driven with fresh subagent per task and two-stage review (spec compliance, then code quality)."
---

Invoke the `devstack:flow/subagent-driven-development` skill.

Requirements:
- A plan exists at `docs/devstack/plans/<plan-file>.md`
- A worktree is set up (otherwise use `devstack:flow/using-git-worktrees` first)
- User consent if work will land on `main` / `master` (default: no)

If subagents are not available in the current environment, fall back to `devstack:flow/executing-plans` with batch checkpoints.

After all tasks complete, dispatch a final full-diff code review, then invoke `devstack:flow/finishing-a-development-branch` to complete.
