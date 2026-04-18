---
description: "Turn an approved spec into a bite-sized implementation plan — exact files, complete code, acceptance criteria, verification steps."
---

Invoke the `devstack:flow/writing-plans` skill.

Requirements:
- An approved spec exists (at `docs/devstack/specs/<spec-file>.md` or path provided by the user)
- A worktree is available (create one via `devstack:flow/using-git-worktrees` if not)

Save the plan to `docs/devstack/plans/YYYY-MM-DD-<feature-name>.md`. At the end, present the execution-handoff choice (subagent-driven vs inline).
