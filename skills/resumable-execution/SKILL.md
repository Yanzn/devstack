---
name: resumable-execution
description: "Use when executing a multi-task plan and progress must survive interruption — session end, context reset, or crash. Persists per-task completion into the plan file itself (on-disk checkboxes + an Execution Log) and defines the resume procedure that rebuilds state from the plan plus git. Invoked by executing-plans and subagent-driven-development; entered directly via /resume."
---

<!--
origin: [NEW]
inspired_by:
  - 12-factor-agents @ humanlayer — factor 5 (unify execution state and business state),
    factor 6 (launch/pause/resume with simple APIs), factor 12 (make your agent a stateless reducer)
  - gstack:checkpoint — save/resume working state across handoffs (conceptual sibling, not a port)
notes: |
  Original to devstack. Closes the durability gap surfaced by auditing devstack's own
  execution loop against 12-factor-agents: progress lived only in ephemeral TodoWrite +
  conversation context, so a dead session lost the thread. This skill makes the plan file
  the single durable source of execution state (factor 5), defines pause/resume over it
  (factor 6), and frames resume as a pure reduction of (plan + git) → next task (factor 12).
  Absorbs the delivery manifest that executing-plans v0.8 emitted only conversationally,
  persisting it into the log instead.
-->

# Resumable Execution

## Overview

Execution progress must outlive the session. The plan file is the single durable source of truth: task checkboxes checked **on disk**, plus an **Execution Log** appended to the plan, record what's done, with which commits, and what the environment now needs. Resume rebuilds state by reducing `(plan + git history) → next task`. No separate state store.

**Announce at start:** "I'm using `devstack:resumable-execution` to persist progress to the plan so this work can be resumed."

## Why Durable State

- **Ephemeral state is a single point of failure.** TodoWrite and conversation context vanish when the session ends, the context window resets, or the process crashes. Anything required to resume must be on disk.
- **The plan already has the structure.** `devstack:writing-plans` emits every task and step as `- [ ]` checkboxes. Checking a box on disk is the cheapest possible durable progress marker — use it instead of inventing a parallel tracker.
- **Unify execution state with the plan** (the spec/business state). One file, one source of truth — not a plan in one place and a hidden progress tracker in another that drift apart.
- **Resume must be a pure function of durable inputs.** If recovering where you stopped needs conversation memory, the work was never resumable.

These four points are factors 5, 6, and 12 of [12-factor-agents](https://github.com/humanlayer/12-factor-agents) applied to devstack's own execution loop.

## The Durable State Contract

Two artifacts, both **inside the plan file**.

### 1. Checkboxes, checked on disk

As each step and task completes, edit the plan to flip its box: `- [ ]` → `- [x]`. The orchestrator does this — never a subagent. The checkboxes are the at-a-glance progress map.

### 2. The Execution Log

Maintain an `## Execution Log` section at the end of the plan:

````markdown
## Execution Log

**Branch:** `feat/<name>`  •  **Worktree:** `<path>`  •  **Last updated:** `<ISO 8601>`

### Task 3: User login — ✅ done
- Commits: `a1b2c3d`, `e4f5a6b`
- Result: login route + session middleware; 6 tests pass
- Manifest:
  - Files: `+src/auth/session.ts`
  - Deps: `pnpm add jose`
  - Env: `JWT_SECRET` — `dev-only-change-me` — read in `src/auth/session.ts`

### Task 4: Task list view — ⏳ in progress
- Failing test written (steps 1–2 done); implementation pending

### Task 5: Bulk delete — ⛔ blocked
- Blocker: spec doesn't define soft vs hard delete — escalated to human
````

Status markers: `✅ done`, `⏳ in progress`, `⛔ blocked`. The **Manifest** sub-block uses the same categories as the `executing-plans` checkpoint — new files / dependencies / env vars / schema migrations / scripts — recording only what *that task* changed. This is where the delivery manifest now lives durably, instead of scrolling away in chat.

### What does NOT go in the log

- Full diffs — git has them; reference commit SHAs.
- Subagent transcripts.
- Anything recomputable from git.

Keep the log a thin index into git, not a copy of it.

## When to Persist

- **`devstack:subagent-driven-development`** — after a task passes both reviews and is marked complete in TodoWrite, the orchestrator checks the task's boxes on disk and writes its Execution Log entry, *before* dispatching the next implementer.
- **`devstack:executing-plans`** — at each batch checkpoint, check the completed tasks' boxes and write their log entries *as part of* producing the checkpoint summary, not after.
- **Commit the plan-file update.** The plan lives in git; each progress write is a small commit (`chore(plan): mark Task N complete`) or folds into the task's own commit. The plan's git history becomes the execution audit trail.

Persist eagerly. A checkpoint you didn't write to disk is a checkpoint you can't resume from.

## The Resume Procedure (the reducer)

Triggered by `/resume`, "pick up where I left off", a resumed session, or a context reset mid-execution.

1. **Locate the plan.** `docs/devstack/plans/<...>.md`. If several exist, pick the one whose Execution Log is not marked complete (ask if ambiguous).
2. **Read durable state.** Parse checkboxes + Execution Log into the set of `{done, in-progress, blocked, not-started}` tasks.
3. **Reconcile against git.** Run `git log --oneline` and `git status`:
   - Every commit the log references must exist.
   - A box checked with no matching commit, or commits present for a task the log calls not-done → **discrepancy**. Surface it; do not guess.
   - Uncommitted working-tree changes → inspect before continuing (a half-done task may be mid-flight).
4. **Restore the worktree.** Confirm you're on the branch/worktree the log names (`devstack:using-git-worktrees`). If it's gone, recreate it from the branch.
5. **Rebuild TodoWrite** from the not-done tasks.
6. **Resume at the first not-done task.** If a task was ⏳ in progress, re-read its on-disk state and continue from the first unchecked step — re-run that step's verification rather than assuming earlier steps still hold.
7. **Hand back** to the execution skill (`subagent-driven-development` or `executing-plans`) for the remaining tasks.

**Never** blindly re-run a task the log marks ✅ done — you'll duplicate commits or clobber work. **Never** continue past an unresolved git↔log discrepancy.

## Red Flags

- Progress tracked only in TodoWrite or conversation — nothing on disk. The session ends, it's gone.
- Resuming from memory ("I think I finished Task 3") instead of reading the plan + git.
- A subagent editing the plan file. Only the orchestrator persists. (Consistent with `subagent-driven-development`: subagents get task text, never the plan.)
- Re-running completed tasks because you didn't read the log first.
- An Execution Log that inlines diffs instead of referencing SHAs — bloats the plan and drifts from git.
- Checking boxes but never committing the plan file — the worktree can still be lost.

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|---|---|---|
| Ephemeral-only progress | Session death = total loss | Check boxes + write log on disk after each task |
| A separate `state.json` | A second source of truth drifts from the plan | Use the plan file — the checkboxes already exist |
| Log as diff dump | Plan bloats, duplicates git | Reference commit SHAs; git holds the diffs |
| Resume without reconciling git | Re-runs or skips tasks | Do step 3 (reconcile) before continuing |
| Check the box before verifying | Marks done what isn't | Flip the box only after the task's verification passes |

## Verification

- [ ] Plan file has an `## Execution Log` with one entry per completed task (commits, result, manifest deltas)
- [ ] Completed tasks' checkboxes are `- [x]` on disk
- [ ] Plan-file progress updates are committed to git
- [ ] A cold resume — reading only the plan + git, no conversation — can identify the exact next task
- [ ] The log references SHAs, not inlined diffs

## Integration

**Invoked by:**
- `devstack:executing-plans` — persists at each batch checkpoint
- `devstack:subagent-driven-development` — persists after each task's two-stage review

**Required context:**
- `devstack:writing-plans` — produces the plan (with the empty `## Execution Log` stub) this skill persists into
- `devstack:using-git-worktrees` — the worktree that resume restores

**Entry point:** `/resume`
