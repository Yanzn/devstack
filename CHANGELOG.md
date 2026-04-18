# Changelog

All notable changes to devstack will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — 2026-04-18

Complete skill set across all four batches.

### Batch 4 — standards/ layer + references + agents + meta

- 13 standards skills under `skills/standards/` (all [AS] direct ports with origin comments + namespace rewrite):
  - `api-and-interface-design`
  - `frontend-ui-engineering`
  - `security-and-hardening`
  - `performance-optimization`
  - `code-review-and-quality`
  - `code-simplification`
  - `documentation-and-adrs`
  - `git-workflow-and-versioning`
  - `ci-cd-and-automation`
  - `shipping-and-launch`
  - `deprecation-and-migration`
  - `source-driven-development`
  - `browser-testing-with-devtools`
- 4 reference checklists under `references/` (all [AS]):
  - `testing-patterns.md`, `security-checklist.md`, `performance-checklist.md`, `accessibility-checklist.md`
- 3 agent personas under `agents/` (all [AS]):
  - `code-reviewer`, `test-engineer`, `security-auditor`
- Meta skill `skills/meta/writing-skills/` ([SP] direct port, used for extending devstack with new standards like iOS, Android, Rust, Go)
- `scripts/validate-skills.sh` — frontmatter + origin-comment check

### Batch 3 — core/ layer

- 5 cross-cutting skills under `skills/core/`:
  - `test-driven-development` (merged SP+AS): SP Iron Law + AS test pyramid, DAMP, Beyoncé Rule, Prove-It pattern
  - `systematic-debugging` (merged SP+AS): SP 4-phase + AS 5-step triage (Reproduce/Localize/Reduce/Fix/Guard) + Stop-the-Line + non-reproducible playbook + error-output-as-untrusted-data
  - `verification-before-completion` (from SP): evidence-before-claims, no-shortcut rule
  - `incremental-implementation` (from AS): thin vertical slices, simplicity first, scope discipline
  - `context-engineering` (from AS): rules files, context hierarchy, confusion management

### Batch 2 — flow/ layer

- 9 process skills under `skills/flow/`:
  - `brainstorming` (merged SP+AS): HARD-GATE + socratic questioning + AS six-area spec template + "surface assumptions" + "not doing" list
  - `writing-plans` (merged SP+AS): bite-sized 2-5min tasks + AS acceptance criteria + dependency ordering + task sizing + checkpoints
  - `executing-plans` (from SP): batch execution with human checkpoints
  - `subagent-driven-development` (from SP): fresh subagent per task + two-stage review, plus 3 prompt templates
  - `dispatching-parallel-agents` (from SP): one agent per independent problem domain
  - `using-git-worktrees` (from SP): isolated workspace setup with auto-detected project init (added Java/Gradle/Maven + Swift/Xcode)
  - `requesting-code-review` (from SP): request mechanics, cross-references standards/code-review-and-quality
  - `receiving-code-review` (from SP): technical rigor, no performative agreement
  - `finishing-a-development-branch` (merged SP+AS): 4-option workflow + commit hygiene audit + change summary
- 5 slash commands (thin shells):
  - `/brainstorm` → `flow/brainstorming`
  - `/plan` → `flow/writing-plans`
  - `/work` → `flow/subagent-driven-development` (with `executing-plans` fallback)
  - `/review` → `flow/requesting-code-review` + `standards/code-review-and-quality`
  - `/ship` → `flow/finishing-a-development-branch` + `standards/shipping-and-launch`

### Batch 1 — Scaffold & Entry

- `plugin.json` manifest and MIT license
- `README.md` with origin story and quick start
- `CREDITS.md` mapping every upcoming skill to its source (superpowers / agent-skills / original / merged)
- `docs/philosophy.md` — the three-layer model (flow / core / standards)
- `docs/getting-started.md`
- `docs/extending.md` — how to add iOS/Android/other platform skills later
- `docs/origins.md` — per-skill provenance table
- `skills/using-devstack/SKILL.md` — entry meta-skill
- `commands/devstack.md` — `/devstack` entry command

### Planned

- **Batch 3** — `core/` layer: 5 always-on skills (TDD, debugging, verification, incremental-impl, context-engineering)
- **Batch 4** — `standards/` layer: 13 code-quality skills + references + agents
