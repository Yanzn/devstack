# Credits

devstack is a remix of four upstream projects. Every skill's provenance is tracked here so future upstream updates can be compared and merged selectively.

## Upstream Projects

| Project | Author | License | Role in devstack |
|---|---|---|---|
| [Superpowers](https://github.com/obra/superpowers) | Jesse Vincent | MIT | Workflow spine, subagent orchestration, voice of flow/core skills |
| [agent-skills](https://github.com/addyosmani/agent-skills) | Addy Osmani | MIT | Engineering-standards content, code-quality criteria, checklists |
| [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | Forrest Chang (distilling [@karpathy](https://x.com/karpathy/status/2015883857489522876)) | MIT | Four behavioral principles: think-before-coding push-back, surgical-change orphan rule, instruction→goal framing |
| [mattpocock/skills](https://github.com/mattpocock/skills) | Matt Pocock | MIT | Architecture vocabulary (module/interface/depth/seam/adapter), deepening workflow, "Design It Twice" parallel-interface pattern, ubiquitous-language grilling |

## Per-Skill Provenance

Legend:
- **[SP]** — sourced from Superpowers, lightly adapted
- **[AS]** — sourced from agent-skills, lightly adapted
- **[KS]** — sourced from karpathy-skills, lightly adapted
- **[MP]** — sourced from mattpocock/skills, lightly adapted
- **[SP+AS]**, **[AS+KS]**, **[AS+MP]**, **[SP+MP]**, **[SP+AS+KS]** — merged from multiple upstreams
- **[NEW]** — original to devstack

### using-devstack (meta)

| Skill | Source |
|---|---|
| `using-devstack` | [NEW] — inspired by `superpowers/using-superpowers` and `agent-skills/using-agent-skills` |

### flow/ layer

| Skill | Source |
|---|---|
| `brainstorming` | [SP+AS] — Superpowers brainstorming + agent-skills idea-refine + spec-driven-development |
| `writing-plans` | [SP+AS+KS] — Superpowers writing-plans + agent-skills planning-and-task-breakdown + karpathy-skills Principle 4 (instruction→goal framing) |
| `executing-plans` | [SP] |
| `subagent-driven-development` | [SP] |
| `dispatching-parallel-agents` | [SP+MP] — SP base port + MP "Design It Twice" pattern grafted as a named application |
| `using-git-worktrees` | [SP] |
| `requesting-code-review` | [SP] |
| `receiving-code-review` | [SP] |
| `finishing-a-development-branch` | [SP+AS] — SP finishing + AS git-workflow-and-versioning (trunk-based, atomic commits) |
| `improving-architecture` | [MP] — mattpocock improve-codebase-architecture skill grafted whole (SKILL + LANGUAGE + DEEPENING + INTERFACE-DESIGN); renamed for gerund convention |
| `domain-modeling` | [MP] — mattpocock domain-model skill grafted whole (SKILL + CONTEXT-FORMAT + lightweight ADR-FORMAT); renamed for gerund convention |

### core/ layer

| Skill | Source |
|---|---|
| `test-driven-development` | [SP+AS] — SP Iron Law/RED-GREEN-REFACTOR + AS test pyramid, DAMP, Beyoncé Rule, test sizes |
| `systematic-debugging` | [SP+AS] — SP 4-phase root-cause + AS 5-step triage (reproduce, localize, reduce, fix, guard) |
| `verification-before-completion` | [SP] |
| `incremental-implementation` | [AS+KS] — agent-skills incremental-implementation + karpathy-skills Principle 3 (surgical-change orphan rule) |
| `context-engineering` | [AS+KS] — agent-skills context-engineering + karpathy-skills Principle 1 (push-back dissent pattern) |

### standards/ layer

| Skill | Source |
|---|---|
| `api-and-interface-design` | [AS+MP] — AS base port + MP architecture vocabulary (module/interface/depth/seam/adapter/leverage/locality) grafted as "Architecture Vocabulary" section |
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

When any of the four upstream projects ships a meaningful update, use `docs/origins.md` and these comment blocks to decide whether to pull the change into devstack.
