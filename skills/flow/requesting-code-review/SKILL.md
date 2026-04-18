---
name: requesting-code-review
description: "Use when completing tasks, implementing major features, or before merging — dispatches a code-reviewer subagent with precisely crafted context to catch issues before they cascade. For the five-axis review criteria themselves, see devstack:standards/code-review-and-quality."
---

<!--
origin: [SP]
sources:
  - superpowers:requesting-code-review @ 5.0.7
notes: |
  Direct port. Namespace rewritten. Now cross-references
  devstack:standards/code-review-and-quality for the actual review criteria,
  keeping this skill focused on the request mechanics.
-->

# Requesting Code Review

Dispatch a code-reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation — never your session's history. This keeps the reviewer focused on the work product, not your thought process, and preserves your own context for continued work.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in `devstack:flow/subagent-driven-development`
- After completing a major feature
- Before merging to main

**Optional but valuable:**
- When stuck — fresh perspective
- Before a risky refactor — establish baseline
- After fixing a complex bug

## Review Criteria

This skill handles the *request mechanics*. The *review criteria* — five-axis review, change sizing, severity labels — live in `devstack:standards/code-review-and-quality`. The reviewer subagent applies that skill when evaluating the diff.

For domain-specific deep review, the reviewer also pulls in relevant standards skills:
- Touches auth / user input / secrets → `devstack:standards/security-and-hardening`
- UI / accessibility → `devstack:standards/frontend-ui-engineering`
- DB queries / hot paths → `devstack:standards/performance-optimization`
- API contracts → `devstack:standards/api-and-interface-design`

## How to Request

### 1. Get git SHAs

```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main, or the commit before this task
HEAD_SHA=$(git rev-parse HEAD)
```

### 2. Dispatch Code-Reviewer Subagent

Use the Task tool with the template at `./code-reviewer.md`. Fill placeholders:

- `{WHAT_WAS_IMPLEMENTED}` — what you just built
- `{PLAN_OR_REQUIREMENTS}` — what it should do (path to plan task / spec section)
- `{BASE_SHA}` — starting commit
- `{HEAD_SHA}` — ending commit
- `{DESCRIPTION}` — brief summary

### 3. Act on Feedback

- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if the reviewer is wrong — with reasoning

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch code-reviewer subagent using ./code-reviewer.md]
  WHAT_WAS_IMPLEMENTED: Verification and repair functions for conversation index
  PLAN_OR_REQUIREMENTS: Task 2 from docs/devstack/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators]
[Continue to Task 3]
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task (code quality reviewer, after spec compliance passes)
- Catch issues before they compound
- Fix before moving to next task

**Executing Plans:**
- Review after each batch (2–3 tasks)
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If the reviewer is wrong:**
- Push back with technical reasoning
- Show code / tests that prove it works
- Request clarification

Review-receiving behavior lives in `devstack:flow/receiving-code-review`. Template lives in `./code-reviewer.md`.
