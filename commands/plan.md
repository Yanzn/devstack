---
description: "Turn an approved spec into a bite-sized implementation plan — exact files, complete code, acceptance criteria, verification steps. Optional: simple work can skip the plan and run /work directly."
---

Invoke the `devstack:writing-plans` skill.

A plan is **optional**. It earns its keep for complex, multi-file, or subagent-executed work — anything where a dependency-ordered task graph with exact code per task prevents mistakes. For small, self-contained changes, skip the plan and run `/work` directly against the approved spec (see `devstack:brainstorming` § Implementation Handoff). Writing a full plan for a one-file change is doing the work twice.

Requirements:
- An approved spec exists (at `docs/devstack/specs/<spec-file>.md` or path provided by the user)
- A worktree is available (create one via `devstack:using-git-worktrees` if not)

Save the plan to `docs/devstack/plans/YYYY-MM-DD-<feature-name>.md`. At the end, present the execution-handoff choice (subagent-driven vs inline).
