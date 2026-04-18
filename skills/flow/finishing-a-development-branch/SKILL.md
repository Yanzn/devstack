---
name: finishing-a-development-branch
description: "Use when implementation is complete and tests pass — decides how to integrate the work. Verifies tests, presents merge/PR/keep/discard options, enforces trunk-based and atomic-commit hygiene, executes the chosen workflow, cleans up the worktree."
---

<!--
origin: [SP+AS]
sources:
  - superpowers:finishing-a-development-branch @ 5.0.7
  - agent-skills:git-workflow-and-versioning @ 1.0.0
notes: |
  Kept SP's tests-first gate, exactly-4 options, typed-confirmation for discard,
  worktree cleanup rules, and quick-reference matrix.
  Grafted AS's trunk-based guidance, atomic-commit check, ~100-line change sizing,
  pre-commit hygiene (no secrets, lint, types), and change-summary pattern.
  The detailed git-workflow reference content still lives in standards/git-workflow-and-versioning —
  this skill enforces the commit-discipline at finishing time.
-->

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling the chosen workflow.

**Core principle:** Verify tests → Enforce commit hygiene → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using `devstack:flow/finishing-a-development-branch` to complete this work."

## The Process

### Step 1: Verify Tests

Before anything else, tests must pass:

```bash
npm test / cargo test / pytest / go test ./... / ./gradlew test / swift test
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

<show failures>

Cannot proceed with merge / PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** continue.

### Step 2: Commit Hygiene Audit

Before presenting options, scan the branch's commits. This is where AS's trunk-based and atomic-commit discipline enters:

```bash
git log --oneline <base>..HEAD
git diff --stat <base>..HEAD
```

**Check:**

- **Size** — total changes over ~1000 lines? Flag it. Recommend splitting into separate PRs or staged PRs.
- **Atomic commits** — does each commit do one logical thing? Or is there a "fix + refactor + new feature" mess?
- **Commit messages** — do they follow `<type>: <description>` format (feat / fix / refactor / test / docs / chore / perf / ci)? Do they explain *why*, not just *what*?
- **Concerns mixed** — formatting changes mixed with behavior changes? Refactors mixed with features? Flag it.
- **Secrets** — `git log -p <base>..HEAD | grep -iE "password|secret|api_key|token"` — anything committed?

**If concerns found:** present them to the user, recommend `git rebase -i` to clean up history (atomic commits, reword messages, split mixed-concern commits) before merging. Do not proceed with a messy history unless the user explicitly accepts it.

### Step 3: Change Summary

Produce a structured summary so the user (or reviewer) can see scope discipline:

```
CHANGES MADE:
- src/routes/tasks.ts: Added validation middleware to POST endpoint
- src/lib/validation.ts: Added TaskCreateSchema using Zod
- tests/routes/tasks.test.ts: Integration tests for validation

THINGS I DIDN'T TOUCH (intentionally):
- src/routes/auth.ts: Has similar validation gap but out of scope
- src/middleware/error.ts: Error format could be improved (separate task)

POTENTIAL CONCERNS:
- Zod schema is strict — rejects extra fields. Confirm this is desired.
- Added zod as a dependency (72KB gzipped) — already in package.json
```

The "DIDN'T TOUCH" section is important — it shows scope discipline and catches unsolicited renovation early.

### Step 4: Determine Base Branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from `main` — is that correct?"

### Step 5: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

Don't add explanation — keep it concise.

### Step 6: Execute Choice

#### Option 1: Merge Locally

```bash
git checkout <base-branch>
git pull

# Prefer --no-ff to preserve the branch's commit context
git merge --no-ff <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: cleanup worktree (Step 7).

#### Option 2: Push and Create PR

```bash
git push -u origin <feature-branch>

gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed, referencing the spec file>

## Changes
<short list from change summary>

## Test Plan
- [ ] <verification steps>

## Links
- Spec: docs/devstack/specs/<spec-file>.md
- Plan: docs/devstack/plans/<plan-file>.md
EOF
)"
```

Then: cleanup worktree (Step 7).

#### Option 3: Keep As-Is

Report: "Keeping branch `<name>`. Worktree preserved at `<path>`."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first — require typed confirmation:**

```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact match. If confirmed:

```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: cleanup worktree (Step 7).

### Step 7: Cleanup Worktree

**For Options 1, 2, 4:**

```bash
git worktree list | grep $(git branch --show-current)
# If match:
git worktree remove <worktree-path>
```

**For Option 3:** keep the worktree.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | ✓ | — | — | ✓ |
| 2. Create PR | — | ✓ | ✓ (until PR merged) | — |
| 3. Keep as-is | — | — | ✓ | — |
| 4. Discard | — | — | — | ✓ (force) |

## Trunk-Based Principle

Short-lived branches merge within 1–3 days. If this branch is older and hasn't merged, that's a signal — long-lived branches accumulate merge risk. Recommend either:

- Finishing and merging (this flow), OR
- Splitting into smaller PRs that can merge incrementally, OR
- Deploying behind a feature flag instead of keeping code on a branch.

## Common Mistakes

**Skipping test verification** → merge broken code, failing PR. **Fix:** always verify tests before offering options.

**Skipping commit hygiene audit** → messy history lands on main. **Fix:** audit before options, offer to rebase.

**Open-ended questions** → "What should I do next?" is ambiguous. **Fix:** exactly 4 structured options.

**Automatic worktree cleanup** → removing worktree when user might still need it (Option 2 or 3). **Fix:** only cleanup for Options 1 and 4.

**No confirmation for discard** → accidentally delete work. **Fix:** require typed `discard`.

## Red Flags

**Never:**
- Proceed with failing tests
- Merge without verifying tests on the merged result
- Delete work without typed confirmation
- Force-push without explicit request

**Always:**
- Verify tests before offering options
- Audit commit hygiene and flag issues
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 and 4 only

## Integration

**Called by:**
- `devstack:flow/subagent-driven-development` — after all tasks complete
- `devstack:flow/executing-plans` — after all batches complete

**References:**
- `devstack:standards/git-workflow-and-versioning` — full reference for commit format, branching, and trunk-based development
- `devstack:standards/shipping-and-launch` — if Option 2 (PR) leads to production deploy, that skill's pre-launch checklist runs next

**Pairs with:**
- `devstack:flow/using-git-worktrees` — cleans up the worktree created by that skill
