---
description: "Finish a development branch and prepare for deploy — tests-first gate, commit-hygiene audit, 4-option workflow (merge / PR / keep / discard), pre-launch checklist."
---

Run two skills in sequence:

1. **`devstack:flow/finishing-a-development-branch`** — verify tests, audit commit hygiene (atomic commits, message format, no secrets, no mixed concerns), produce change summary, present exactly 4 options (merge / PR / keep / discard), execute the choice, clean up the worktree.

2. **`devstack:standards/shipping-and-launch`** — if the chosen path leads to production (Option 1 merge to main, or Option 2 PR that will be merged), run the pre-launch checklist: code quality, security, performance, accessibility, infrastructure, documentation, monitoring, rollback plan.

If the user chose Option 3 (keep as-is) or Option 4 (discard), stop after step 1.
