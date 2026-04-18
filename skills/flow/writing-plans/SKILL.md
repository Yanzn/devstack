---
name: writing-plans
description: "Use when you have an approved spec and need to turn it into a task-by-task implementation plan, before touching code. Produces bite-sized tasks (2-5 min each) with exact file paths, complete code, acceptance criteria, and verification steps."
---

<!--
origin: [SP+AS]
sources:
  - superpowers:writing-plans @ 5.0.7
  - agent-skills:planning-and-task-breakdown @ 1.0.0
notes: |
  Kept SP's bite-sized 2-5-minute tasks, exact file paths, complete code per step,
  no-placeholder rule, subagent-driven-development handoff, and plan self-review.
  Grafted AS's per-task acceptance criteria, explicit dependency ordering, task sizing
  guidelines (XS/S/M/L), vertical-slicing pattern, and checkpoint structure between phases.
-->

# Writing Plans

## Overview

Write a comprehensive implementation plan assuming the engineer has zero context for our codebase and questionable taste. Document everything they need: exact files to touch per task, complete code, verification commands. Every task is bite-sized (2–5 minutes), has acceptance criteria, and fits into a dependency-ordered graph.

Assume the engineer is skilled but knows almost nothing about our toolset, problem domain, or test design.

**Announce at start:** "I'm using `devstack:flow/writing-plans` to create the implementation plan."

**Context:** This runs in a worktree already created by `devstack:flow/brainstorming` (via `devstack:flow/using-git-worktrees`). If not in a worktree, set one up first.

**Save plans to:** `docs/devstack/plans/YYYY-MM-DD-<feature-name>.md` (user preferences override this default).

## Scope Check

If the spec covers multiple independent subsystems, it should have been decomposed during brainstorming. If it wasn't, stop and suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## The Planning Process

### Step 1: Enter Plan Mode

Read-only. Do not write code during planning. The output is a plan document, not implementation.

- Read the spec and relevant codebase sections
- Identify existing patterns and conventions
- Map dependencies between components
- Note risks and unknowns

### Step 2: File Structure First

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Each file has one clear responsibility with a well-defined interface
- Files that change together live together — split by responsibility, not by technical layer
- Prefer smaller focused files over large ones that do too much
- In existing codebases, follow established patterns; if a file you're modifying is unwieldy, include a targeted split as part of the plan

This structure informs the task decomposition. Each task produces self-contained changes that make sense independently.

### Step 3: Dependency Graph

Map what depends on what. Build foundations first:

```
Database schema
    │
    ├── API models/types
    │       ├── API endpoints ── Frontend API client ── UI components
    │       └── Validation logic
    └── Seed data / migrations
```

### Step 4: Slice Vertically

Build one complete feature path at a time, not all layers then integration:

**Bad (horizontal slicing):**
```
Task 1: Build entire database schema
Task 2: Build all API endpoints
Task 3: Build all UI components
Task 4: Connect everything
```

**Good (vertical slicing):**
```
Task 1: User can register (schema + API + UI for registration)
Task 2: User can log in (auth schema + API + UI for login)
Task 3: User can create a task (task schema + API + UI for creation)
Task 4: User can view task list (query + API + UI for list view)
```

Each vertical slice delivers working, testable functionality. Every task leaves the system in a working state.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# <Feature Name> Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `devstack:flow/subagent-driven-development` (recommended) or `devstack:flow/executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax.

**Goal:** <One sentence describing what this builds>

**Architecture:** <2-3 sentences about approach>

**Tech Stack:** <Key technologies and libraries>

**Spec:** `docs/devstack/specs/<spec-file>.md`

---
```

## Task Structure

Each task combines SP's bite-sized step layout with AS's acceptance criteria and verification block:

````markdown
### Task N: <Component Name>

**Description:** One paragraph — what this task accomplishes.

**Acceptance criteria:**
- [ ] <Specific, testable condition>
- [ ] <Specific, testable condition>

**Dependencies:** <Task numbers this depends on, or "None">

**Estimated scope:** <XS | S | M | L> (see sizing guide below)

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test_file.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test_file.py::test_specific_behavior -v`
Expected: FAIL with "NameError: function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test_file.py::test_specific_behavior -v`
Expected: PASS

- [ ] **Step 5: Run full test suite (regression check)**

Run: `pytest`
Expected: all tests pass

- [ ] **Step 6: Commit**

```bash
git add tests/path/test_file.py src/path/file.py
git commit -m "feat: add <specific behavior>"
```

**Verification after task:**
- Tests pass: `pytest`
- Build succeeds: `<build command>`
- Manual check: `<specific thing to verify, if applicable>`
````

## Task Sizing

| Size | Files | Scope | Example |
|------|-------|-------|---------|
| **XS** | 1 | Single function / config change | Add a validation rule |
| **S** | 1–2 | One component or endpoint | Add a new API endpoint |
| **M** | 3–5 | One feature slice | User registration flow |
| **L** | 5–8 | Multi-component feature | Search with filtering + pagination |
| **XL** | 8+ | **Too large — break it down further** | — |

Agents perform best on **S** and **M** tasks. If a task is **L** or larger, break it down.

**Break down further when:**
- It would take more than one focused session (~2h of agent work)
- Acceptance criteria would exceed 3 bullet points
- It touches two or more independent subsystems
- The title contains "and" (a sign it's two tasks)

## Checkpoints Between Phases

Group tasks into phases with explicit checkpoints:

```markdown
## Phase 1: Foundation
- [ ] Task 1: ...
- [ ] Task 2: ...

### Checkpoint: Foundation
- [ ] All tests pass
- [ ] Build succeeds
- [ ] Review with human partner before proceeding

## Phase 2: Core Features
- [ ] Task 3: ...
- [ ] Task 4: ...

### Checkpoint: Core Features
- [ ] End-to-end flow works
- [ ] Review with human partner

## Phase 3: Polish
- [ ] Task 5: ...

### Checkpoint: Complete
- [ ] All acceptance criteria met
- [ ] Ready for /review and /ship
```

## Risks and Open Questions

End the plan with:

```markdown
## Risks and Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| <Risk> | <High/Med/Low> | <Strategy> |

## Open Questions
- <Question needing human input before Phase N>
```

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:

- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may read tasks out of order)
- Steps that describe what to do without showing how (code steps require code blocks)
- References to types, functions, or methods not defined in any task

## Remember

- Exact file paths always
- Complete code in every step — if the step changes code, show the code
- Exact commands with expected output
- Acceptance criteria per task, verification per task
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing the complete plan, re-read it against the spec:

1. **Spec coverage** — skim each section/requirement in the spec; point to a task that implements it. List any gaps.
2. **Placeholder scan** — search the plan for the red-flag patterns above. Fix them.
3. **Type consistency** — do types, method signatures, and property names used in later tasks match what was defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.
4. **Dependency check** — are task dependencies ordered correctly? Does any task reference state or code produced by a later task?
5. **Size check** — any XL tasks? Break them down.
6. **Checkpoint check** — checkpoints every 2–3 tasks or at phase boundaries?

Fix issues inline. If a spec requirement has no task, add the task.

## Parallelization Opportunities

Note in the plan which tasks are safely parallelizable:

- **Safe to parallelize:** independent feature slices, tests for already-implemented features, documentation
- **Must be sequential:** database migrations, shared state changes, dependency chains
- **Needs coordination:** features sharing an API contract (define the contract first, then parallelize)

This information feeds into `devstack:flow/dispatching-parallel-agents` during execution.

## Execution Handoff

After saving the plan:

> "Plan complete and saved to `docs/devstack/plans/<filename>.md`. Two execution options:
>
> **1. Subagent-Driven (recommended)** — dispatch a fresh subagent per task with two-stage review (spec compliance, then code quality). Fast iteration, no context pollution.
>
> **2. Inline Execution** — execute tasks in this session with batch checkpoints for human review.
>
> Which approach?"

**If Subagent-Driven:**
- REQUIRED SUB-SKILL: `devstack:flow/subagent-driven-development`
- Fresh subagent per task + two-stage review

**If Inline:**
- REQUIRED SUB-SKILL: `devstack:flow/executing-plans`
- Batch execution with human checkpoints

## Red Flags

- Starting implementation before the plan is written and reviewed
- Tasks without acceptance criteria
- Tasks without verification steps
- All tasks sized **L** or larger
- No checkpoints between phases
- Dependencies not considered or ordered
- Placeholder text anywhere in the plan
- Referring to code/types not defined in any task

## Verification

Before handing off to execution:

- [ ] Every task has description, acceptance criteria, verification
- [ ] Every code step contains actual code (not placeholder)
- [ ] Task dependencies are ordered correctly
- [ ] No task is **L** or larger
- [ ] Checkpoints exist between phases
- [ ] Spec coverage checked — no gaps
- [ ] Plan is committed to git
- [ ] Human partner has reviewed and approved the plan
