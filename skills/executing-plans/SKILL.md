---
name: executing-plans
description: "Use when you have a written implementation plan and want batch execution with human checkpoints between phases. For subagent-driven execution with per-task two-stage review, use devstack:subagent-driven-development instead."
---

<!--
origin: [SP]
sources:
  - superpowers:executing-plans @ 5.0.7
notes: |
  Direct port. Namespace rewritten from superpowers:* to devstack:*.
  Path reference changed from docs/superpowers/ to docs/devstack/.
  v0.8.0: added conditional "delivery manifest" lines to Step 3 checkpoint
  (new files / deps / env vars / migrations / scripts). Inspired by
  awesome-llm-apps fullstack-developer SKILL.md "Output Format" section,
  reshaped as a checkpoint-time conditional manifest instead of a persona-style
  response template.
-->

# Executing Plans

## Overview

Load plan, review critically, execute tasks batch by batch with human checkpoints.

**Announce at start:** "I'm using `devstack:executing-plans` to implement this plan."

**Note on platform capability:** devstack works much better with access to subagents. If subagents are available (Claude Code, Codex), prefer `devstack:subagent-driven-development` over this skill — it's higher quality with less context pollution. Use this skill when subagents aren't available, or when the user explicitly wants to stay inline with checkpoints.

## The Process

### Step 1: Load and Review Plan

1. Read the plan file (path provided by user or writing-plans handoff)
2. Review critically — identify any questions or concerns
3. **If concerns:** raise them with your human partner before starting
4. **If no concerns:** create TodoWrite with every task and proceed

### Step 2: Execute Tasks in Batches

Default batch size: **3 tasks**, or one phase, whichever is smaller.

For each task in the batch:

1. Mark task as `in_progress` in TodoWrite
2. Follow each step in the plan exactly (the plan has bite-sized steps — don't skip)
3. Run verifications as specified
4. Mark task as `completed`

### Step 3: Checkpoint After Each Batch

After the batch completes:

```
Batch <N> complete. Summary:
- Task X: <what was built, tests passing>
- Task Y: <what was built, tests passing>
- Task Z: <what was built, tests passing>

Delivery manifest (only include sections that changed in this batch):
- New / renamed files: <paths>
- New dependencies: <exact install command, e.g. `pnpm add zod`>
- New environment variables: <NAME — example value — where read>
- Schema / migration changes: <apply command + rollback command>
- New scripts or entry points: <how to run>

Checkpoint verification:
- [ ] All tests pass
- [ ] Build succeeds
- [ ] <any plan-defined checkpoint criteria>

Ready for next batch?
```

Wait for explicit "go" before starting the next batch. The checkpoint exists to let the user redirect, re-scope, or spot issues before they compound.

**Delivery manifest rule:** include a manifest section only if that category *changed* in this batch. Don't write `Environment variables: none` or `Dependencies: no changes` — those lines are noise. If nothing outside the source tree changed, omit the manifest block entirely.

**Why the manifest matters:** the user needs to know what to install, set, or migrate before pulling your branch. A summary that says "added auth route" without naming the new `JWT_SECRET` env var or `pnpm add jose` dependency forces the user to read the diff to reproduce your environment. The manifest is the difference between a checkpoint the user can act on and one they have to investigate.

### Step 4: Request Code Review

After every 2–3 batches, or at a major phase boundary:

- Invoke `devstack:requesting-code-review` to dispatch a reviewer subagent
- Address critical and important findings before proceeding
- Note minor findings for later

### Step 5: Complete Development

After all tasks complete and verified:

```
Announce: "I'm using devstack:finishing-a-development-branch to complete this work."
```

REQUIRED SUB-SKILL: `devstack:finishing-a-development-branch`. Follow it to verify tests, present merge/PR/keep/discard options, execute the chosen workflow.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- You hit a blocker (missing dependency, test fails unexpectedly, instruction unclear)
- The plan has a critical gap that prevents starting a task
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.** Bad work is worse than no work.

## When to Revisit Earlier Steps

Return to Step 1 (Review Plan) when:
- Your human partner updates the plan based on your feedback
- The fundamental approach needs rethinking

**Don't force through blockers.** Stop and ask.

## Remember

- Review the plan critically before starting
- Follow plan steps exactly — the plan is the spec
- Don't skip verifications
- Reference the sub-skills the plan points to (TDD, debugging, etc.)
- Stop when blocked — don't guess
- Never start implementation on `main` / `master` without explicit user consent

## Integration

**Required workflow skills:**
- `devstack:using-git-worktrees` — REQUIRED: isolated workspace before any task
- `devstack:writing-plans` — creates the plan this skill executes
- `devstack:requesting-code-review` — dispatch review between batches
- `devstack:finishing-a-development-branch` — complete development after all tasks

**Alternative:**
- `devstack:subagent-driven-development` — preferred when subagents are available; per-task two-stage review instead of batch checkpoints
