# Credits

devstack is a remix of two upstream projects. Every skill's provenance is tracked here so future upstream updates can be compared and merged selectively.

## Upstream Projects

| Project | Author | License | Role in devstack |
|---|---|---|---|
| [Superpowers](https://github.com/obra/superpowers) | Jesse Vincent | MIT | Workflow spine, subagent orchestration, voice of flow/core skills |
| [agent-skills](https://github.com/addyosmani/agent-skills) | Addy Osmani | MIT | Engineering-standards content, code-quality criteria, checklists |

## Per-Skill Provenance

Legend:
- **[SP]** — sourced from Superpowers, lightly adapted
- **[AS]** — sourced from agent-skills, lightly adapted
- **[SP+AS]** — merged from both, substantial rewrite
- **[NEW]** — original to devstack

### using-devstack (meta)

| Skill | Source |
|---|---|
| `using-devstack` | [NEW] — inspired by `superpowers/using-superpowers` and `agent-skills/using-agent-skills` |

### flow/ layer

| Skill | Source |
|---|---|
| `brainstorming` | [SP+AS] — Superpowers brainstorming + agent-skills idea-refine + spec-driven-development |
| `writing-plans` | [SP+AS] — Superpowers writing-plans + agent-skills planning-and-task-breakdown |
| `executing-plans` | [SP] |
| `subagent-driven-development` | [SP] |
| `dispatching-parallel-agents` | [SP] |
| `using-git-worktrees` | [SP] |
| `requesting-code-review` | [SP] |
| `receiving-code-review` | [SP] |
| `finishing-a-development-branch` | [SP+AS] — SP finishing + AS git-workflow-and-versioning (trunk-based, atomic commits) |

### core/ layer

| Skill | Source |
|---|---|
| `test-driven-development` | [SP+AS] — SP Iron Law/RED-GREEN-REFACTOR + AS test pyramid, DAMP, Beyoncé Rule, test sizes |
| `systematic-debugging` | [SP+AS] — SP 4-phase root-cause + AS 5-step triage (reproduce, localize, reduce, fix, guard) |
| `verification-before-completion` | [SP] |
| `incremental-implementation` | [AS] |
| `context-engineering` | [AS] |

### standards/ layer

| Skill | Source |
|---|---|
| `api-and-interface-design` | [AS] |
| `frontend-ui-engineering` | [AS] |
| `security-and-hardening` | [AS] |
| `performance-optimization` | [AS] |
| `code-review-and-quality` | [AS] |
| `code-simplification` | [AS] |
| `documentation-and-adrs` | [AS] |
| `git-workflow-and-versioning` | [AS] |
| `ci-cd-and-automation` | [AS] |
| `shipping-and-launch` | [AS] |
| `deprecation-and-migration` | [AS] |
| `source-driven-development` | [AS] |
| `browser-testing-with-devtools` | [AS] |

### meta/ layer

| Skill | Source |
|---|---|
| `writing-skills` | [SP] |

### agents/

| Agent | Source |
|---|---|
| `code-reviewer` | [SP+AS] — SP code-reviewer + AS code-reviewer persona |
| `test-engineer` | [AS] |
| `security-auditor` | [AS] |

### references/

All four reference checklists (`testing-patterns.md`, `security-checklist.md`, `performance-checklist.md`, `accessibility-checklist.md`) are **[AS]**.

### commands/

devstack follows Superpowers' "commands are thin shells over skills" pattern:

| Command | Invokes |
|---|---|
| `/devstack` | `using-devstack` skill |
| `/brainstorm` | `flow/brainstorming` skill |
| `/plan` | `flow/writing-plans` skill |
| `/work` | `flow/subagent-driven-development` (primary) or `executing-plans` skill |
| `/review` | `flow/requesting-code-review` + `standards/code-review-and-quality` |
| `/ship` | `flow/finishing-a-development-branch` + `standards/shipping-and-launch` |

---

## How Attribution Works Inside Skill Files

Every SKILL.md in devstack opens with an HTML comment block identifying its source:

```markdown
<!--
origin: [SP+AS]
sources:
  - superpowers:brainstorming @ 5.0.7
  - agent-skills:idea-refine @ 1.0.0
  - agent-skills:spec-driven-development @ 1.0.0
notes: Kept SP HARD-GATE and socratic questioning. Grafted AS six-area spec template and "surface assumptions" pattern.
-->
```

This keeps upstream traceability explicit without cluttering the skill body.

---

## Upstream Updates

When Superpowers or agent-skills ship a meaningful update, use `docs/origins.md` and these comment blocks to decide whether to pull the change into devstack.
