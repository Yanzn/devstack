---
description: "Resume an interrupted plan execution — rebuild progress from the plan's Execution Log and git, then continue from the next unfinished task."
---

Invoke the `devstack:resumable-execution` skill and run its resume procedure.

Requirements:
- A plan exists at `docs/devstack/plans/<plan-file>.md` with an `## Execution Log` (written by a prior execution run)
- The branch / worktree the log names is available (otherwise recreate it via `devstack:using-git-worktrees`)

The skill reads the plan checkboxes + Execution Log, reconciles them against `git log` / `git status`, rebuilds the task list, and resumes at the first unfinished task. It stops and surfaces any discrepancy between the log and git rather than guessing, and never re-runs a task already marked done.

After reconstructing state, it hands back to `devstack:subagent-driven-development` (or `devstack:executing-plans`) for the remaining tasks.
