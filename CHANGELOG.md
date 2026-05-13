# Changelog

All notable changes to devstack will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.0] — 2026-05-13

### Added — executing-plans: conditional delivery manifest at checkpoint

The Step 3 batch checkpoint now optionally includes a **delivery manifest** — a conditional block listing what changed outside the source tree, so the user can reproduce the batch's environment without diffing.

- `flow/executing-plans` — Step 3 checkpoint template extended with a `Delivery manifest` block covering new/renamed files, new dependencies (with exact install command), new env vars (name + example + where read), schema/migration changes (apply + rollback), and new scripts/entry points. The rule is **strictly conditional**: include only categories that changed in this batch; omit the entire block if nothing outside the source tree changed. Explicit no-noise rule forbids `Dependencies: none` lines. New "Why the manifest matters" paragraph frames it as the difference between a checkpoint the user can act on and one they have to investigate.
- `CREDITS.md` — `executing-plans` row annotated; the manifest section is explicitly no-upstream (inspired by [awesome-llm-apps `fullstack-developer` Output Format](https://github.com/Shubhamsaboo/awesome-llm-apps/tree/main/awesome_agent_skills/fullstack-developer), reshaped from a persona-style response template into a checkpoint-time conditional manifest).

### Notes

No skill name changes, no profile schema changes, no breaking changes. Skills validation unaffected.

## [0.7.0] — 2026-05-13

### Added — nextjs profile

Fourth stack profile, covering Next.js App Router full-stack TypeScript projects. Fills the gap between the existing backend-only (`django`, `spring`) and frontend-only (`vue`) profiles.

- `profiles/nextjs.json` _(new)_ — full-stack TS profile. Stack: Next.js App Router + TypeScript + Prisma + Postgres + Zod + pnpm + Vitest, deployed on Vercel. All 13 standards enabled (frontend + backend together); no skills disabled. `focus_areas` cover Next.js-specific risks the framework introduces: RSC/Client component boundary, Server Actions auth + CSRF, Route Handler schema-first validation (Zod), Next.js cache semantics (`fetch`/`revalidate`/`unstable_cache`), middleware Edge runtime constraints, `NEXT_PUBLIC_*` env-var leak boundary, bundle splitting via `next/dynamic`, `next/image`/`next/font` optimization, NextAuth session strategy, metadata/SEO API, RSC test boundaries.
- `profiles/README.md` — profile table updated with `nextjs` row.
- Inspired by [awesome-llm-apps `fullstack-developer` SKILL.md](https://github.com/Shubhamsaboo/awesome-llm-apps/tree/main/awesome_agent_skills/fullstack-developer) (stack composition reference only — devstack keeps stack details in profiles, not in a mega-skill).

### Notes

No skill content changes, no schema changes, no breaking changes. All 26 referenced skills exist; validation passes.

## [0.6.0] — 2026-05-13

### Added — context-engineering: pattern-conflict and conformance rules

Two behavioral additions to `core/context-engineering` covering failure modes that the existing skill described as symptoms (anti-patterns) but did not constrain as actions. Both close gaps surfaced by community discussion of multi-pattern codebases.

- `core/context-engineering` — added `When Internal Patterns Conflict` subsection under Confusion Management. When the codebase itself contains two co-existing patterns for the same job, default LLM behavior is to blend them; the new rule mandates picking one (more recent / more tested), explaining the choice, flagging the other as a separate cleanup task, and never producing "compromise code" that satisfies both. Complements the existing `When Context Conflicts` (which covers spec ↔ code) by addressing code ↔ code.
- `core/context-engineering` — added top-level `Acting on Conventions` section between Confusion Management and Anti-Patterns. Converts the descriptive anti-pattern "Agent invents a new style" into a prescriptive default: conformance beats taste inside a codebase. Lists two legitimate exceptions (active migration, harmful convention surfaced as a separate conversation) and one Red Flag (writing in a style that doesn't match the surrounding file without explicitly noting it).
- `CREDITS.md` — `context-engineering` row annotated; new sections are explicitly **no-upstream** (community-discussion-inspired). No additions to the Upstream Projects table.

### Notes

No skill name changes, no profile schema changes, no breaking changes. Skills validation unaffected.

## [0.5.0] — 2026-05-13

### Added — prototyping-with-html flow skill + brainstorming UI Gate

For features with a visible end-user surface, brainstorming now produces a clickable hi-fi HTML prototype the user opens in a real browser, iterates on, and explicitly approves *before* the spec is written. The approved prototype becomes the spec's **Visual Contract** — spec prose no longer re-describes the UI, it points to the prototype path. Words about UI rot fast; pixels lock decisions.

- `flow/prototyping-with-html` _(new)_ — produces clickable hi-fi HTML prototype, mock data, real interactions, real copy. HARD-GATE on explicit user approval. Reuses any available HTML-generation skill (gstack `frontend-design` / `design-html` / `design-shotgun`) when present, otherwise writes self-contained HTML directly (no build step). Browser preview reuses `browser-testing-with-devtools` or any playwright/browse MCP, otherwise prints a `file://` URL. ≤5-iteration budget triggers structural-question reflection. Prototypes saved to `docs/devstack/prototypes/<topic>/`.
- `flow/brainstorming` — inserted **UI Gate** as checklist step 5 between "Propose 2–3 approaches" and "Present spec section by section". UI features hand off to `prototyping-with-html` and resume after approval. Spec template gained `## Visual Contract` section (prototype path + locked decisions + out-of-scope). The Architecture section is now scoped to non-visual concerns. The old optional "Visual Companion" block is replaced by lighter "Visual Aids During Brainstorming" guidance (ASCII / mermaid for early clarifying questions; full prototype lives in the gate). Two new Red Flags cover writing UI prose before / instead of the prototype.
- `using-devstack` — Terminal States table now records the brainstorming → prototyping detour and the prototyping → brainstorming return.
- `profiles/{vue,django,spring}.json` — added `prototyping-with-html` to each `flow` array. The UI Gate self-skips for non-UI features, so loading everywhere is harmless and keeps the brainstorming handoff reliable.
- `CREDITS.md` — added row for `prototyping-with-html` ([NEW], inspired by gstack design skills); annotated `brainstorming` row with v0.5 change.

## [0.4.0] — 2026-05-12

### Changed — flatten skill layout (BREAKING)

Plugin-style skill loaders (Claude Code's Skill tool, etc.) treat the skill name as a single segment and do not resolve `<layer>/<name>` paths. Calling `devstack:flow/subagent-driven-development` fails with `Unknown skill`.

- Moved every `skills/<layer>/<name>/` to `skills/<name>/`. Removed empty `skills/{flow,core,standards,meta}/` directories.
- Rewrote all cross-references from `devstack:<layer>/<name>` → `devstack:<name>` across `commands/`, `skills/**/*.md`, `references/`, `docs/`, prompt templates.
- Updated `docs/extending.md` / `docs/extending_zh-CN.md` / `README_zh-CN.md` / `profiles/README.md` to reflect the flat layout. The three-layer model (flow / core / standards) is preserved as a *conceptual* classification — still recorded in `profiles/*.json` arrays and narrated by `using-devstack` — but no longer encoded in directory paths.

### Migration

Any project, command, or template that invoked a skill via `devstack:flow/...`, `devstack:core/...`, `devstack:standards/...`, or `devstack:meta/...` must drop the layer segment. `skills/<layer>/<name>` filesystem references must drop the layer segment as well.

## [0.3.0] — 2026-04-26

### Added — mattpocock-skills graft

Grafted two skills whole and injected vocabulary + patterns into two existing skills, all sourced from [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock. The graft establishes a single shared vocabulary for talking about module shape (depth, seam, adapter, leverage, locality) across review, planning, and architecture-improvement workflows.

- `flow/improving-architecture` _(new)_ — full graft of mattpocock's `improve-codebase-architecture` skill: three-phase process (Explore → Present → Grilling), the **deletion test**, the **two-adapter rule**, and the deepening discipline that turns shallow modules into deep ones. Companion files `LANGUAGE.md` (seven-term architecture vocabulary), `DEEPENING.md` (four dependency categories → testing strategy), `INTERFACE-DESIGN.md` (parallel sub-agent "Design It Twice" pattern). Skill renamed from `improve-codebase-architecture` to fit devstack's gerund convention.
- `flow/domain-modeling` _(new)_ — full graft of mattpocock's `domain-model` skill: ubiquitous-language grilling session that updates `CONTEXT.md` inline as terms are resolved and offers lightweight ADRs only when hard-to-reverse + surprising + real-tradeoff all hold. Companion files `CONTEXT-FORMAT.md` (single-context and multi-context layouts) and `ADR-FORMAT.md` (lightweight 1–3 sentence variant). Marked `disable-model-invocation: true` — fires manually, typically as a side effect of `flow/improving-architecture` proposing new domain terms.
- `standards/api-and-interface-design` — grafted MP's seven-term architecture vocabulary as a new "Architecture Vocabulary" section. Single source of truth that `flow/improving-architecture`, `standards/code-review-and-quality`, and any planning conversation point to.
- `flow/dispatching-parallel-agents` — grafted MP's "Design It Twice" pattern as a named application of the parallel-dispatch primitive: spawn three or more agents that each produce radically different interface designs for the same problem, then compare and recommend.
- `standards/documentation-and-adrs` — added cross-reference to the lightweight ADR variant in `flow/domain-modeling`. The standards skill remains the source of truth for the heavyweight Status / Date / Context / Decision / Consequences template; the lightweight 1–3 sentence variant lives next to the grilling skills that produce it.
- `README.md` — added mattpocock/skills as fourth upstream. Bumped status line.
- `CREDITS.md` — added `[MP]` legend entry, new merge tags `[AS+MP]` and `[SP+MP]`, new upstream row, new per-skill rows.
- `docs/origins.md` — added pin (mattpocock/skills @ 2026-04-26), new flow/standards rows, change-review-log entry.

## [0.2.0] — 2026-04-20

### Added — karpathy-skills graft

Adopted three of the four principles from [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (a distillation of Karpathy's observations on LLM coding pitfalls). Principle 2 (Simplicity First) was skipped — already fully covered by `core/incremental-implementation` Rule 0 and `standards/code-simplification`.

- `core/context-engineering` — grafted Principle 1 (Think Before Coding): added `When You Disagree — Push Back` pattern in Confusion Management. Provides a template for surfacing dissent when the user's approach looks wrong, before executing.
- `core/incremental-implementation` — grafted Principle 3 (Surgical Changes): sharpened Rule 0.5 Scope Discipline with an orphan-cleanup table. Orphans *your* changes created are in scope; pre-existing dead code is not.
- `flow/writing-plans` — grafted Principle 4 (Goal-Driven Execution): added `Framing Tasks as Verifiable Goals` section. Every acceptance-criteria bullet must be machine- or human-decidable; weak goals ("make it work") get rewritten before execution.
- `CREDITS.md` — added karpathy-skills as third upstream, new `[KS]` legend entry, updated per-skill provenance for the three grafted skills.

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
