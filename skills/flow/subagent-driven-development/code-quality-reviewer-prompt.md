# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent from `devstack:flow/subagent-driven-development`.

**Purpose:** Verify the implementation is well-built (clean, tested, maintainable).

**Only dispatch after spec compliance review passes.**

```
Use template at: ../requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: <from implementer's report>
  PLAN_OR_REQUIREMENTS: Task N from <plan file path>
  BASE_SHA: <commit before task>
  HEAD_SHA: <current commit>
  DESCRIPTION: <task summary>
```

**In addition to the standard code-quality checklist, the reviewer should verify:**

- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)
- Does the code apply any relevant `devstack:standards/*` skill? (API design, security, performance, etc.)

**Code reviewer returns:** Strengths, Issues (Critical / Important / Minor), Assessment.
