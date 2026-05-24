# Changelog

All notable changes to devstack will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.13.0] — 2026-05-24

### Changed — decoupled flow (`/work` no longer requires a plan) + requirement-first brainstorming

Real-world use surfaced over-coupling in the phase spine: simple tasks don't need the full `spec → plan → work` ceremony, but `/work` hard-required a plan file. This release decouples the phases and reframes brainstorming around clarifying the requirement — the highest-leverage step — with the UI prototype demoted from a mandatory gate to an optional tool.

- `commands/work.md` — **decoupled from `/plan`.** `/work` now routes by what exists: a plan → `subagent-driven-development` (per-task, two-stage review, unchanged); only an approved spec → a **lightweight in-session path** (`incremental-implementation` + `test-driven-development`, no task graph), for small self-contained work. Both paths end at `requesting-code-review` → `finishing-a-development-branch`. If a spec-only run turns out large, it stops and routes to `/plan`. The lightweight path also **drops the worktree requirement** (optional — a feature branch in the current checkout is enough; never land on `main` without consent), keeping it genuinely low-ceremony; the plan path still wants an isolated worktree for subagent execution. No new skill — the lightweight path reuses existing core skills.
- `flow/brainstorming` — **reframed around requirement clarification as the job**, with two interchangeable clarification tools: adversarial **grilling** (verbal) and the HTML **prototype** (visual, optional). The old socratic "Ask clarifying questions" step is now "Clarify the Requirement — Grill It": one question per turn each with a recommended answer, probing boundaries / failure modes / reversibility (discipline borrowed from `challenging-plans`), explicitly **scaled to complexity** so trivial requests aren't ground through a full decision tree. Terminal state changed from "always `writing-plans`" to a **branch**: `/plan` for complex work, straight to `/work` for simple work — with an Implementation Handoff section that asks the user which and recommends one. New key principle "Plan is optional, spec is not"; red flags updated.
- `flow/brainstorming` UI gate — **demoted from HARD gate to optional offer.** The old v0.5 "does this have a UI surface? → must prototype before spec" gate is now step 6 "Optional — Prototype the Visuals": brainstorming *offers* a prototype when the visual decisions are the hard part; the **user opts in**. If built, the prototype stays the UI source of truth (spec references it, no prose re-description) — the good part of v0.5 is preserved. If declined or trivial, the spec captures the UI in prose. Spec template's `## Visual Contract` is now conditional ("include only if a prototype was built"); the `## Architecture` note covers both prototype and prose-UI cases.
- `flow/prototyping-with-html` — softened to match: description and "When to Use" reframed as an **optional, opt-in** clarification aid (a tool, not a gate); the HARD-GATE now applies only *once the user opts into a prototype* (don't lock visuals until explicit written approval), and explicitly notes it doesn't apply when no prototype is requested. Body (hi-fi standards, mock data, aesthetic direction, browser preview, feedback loop, Visual Contract handoff) unchanged.
- `flow/challenging-plans` — cross-reference to `brainstorming` sharpened: brainstorming's clarify step is the *forward* form of this grilling (interrogating a requirement into existence); `/grill` is the *adversarial* form against an existing artifact. Same discipline, different moment.
- `commands/brainstorm.md` — terminal-state language updated to the `/plan`-or-`/work` branch; grilling + optional-prototype framing added.
- `commands/plan.md` — marked **optional**; states when a plan earns its keep vs. when to skip straight to `/work`.
- `skills/using-devstack` — slash-command table updated (`/plan` marked optional, `/work` notes plan-or-spec). "Do not skip phase commands" replaced with "plan is optional and decoupled from work" (brainstorm/review/ship gates still hold). New "When NOT to use the full flow" bullet for spec-only direct work. Terminal States section updated for the brainstorming branch and the dual-path `/work` exit.

### Notes

No new skills, no skill renames, no profile schema changes. The lightweight `/work` path is composed from existing `core/` skills (`incremental-implementation`, `test-driven-development`, `verification-before-completion`), so profiles need no changes. **Behavior change worth calling out:** `/work` against a bare spec (no plan) is now valid where it previously expected a plan; and brainstorming will no longer force a prototype for every UI feature — it offers one.

## [0.12.0] — 2026-05-24

### Added — resumable execution (`/resume`)

Execution progress now survives interruption — session end, context reset, or crash. This closes the one structural gap found by auditing devstack's own execution loop against [12-factor-agents](https://github.com/humanlayer/12-factor-agents): progress lived only in ephemeral TodoWrite + conversation context, so a dead session lost the thread. The fix applies factors 5 (unify execution + business state), 6 (launch/pause/resume), and 12 (stateless reducer) to devstack itself — without inventing a separate state store.

- `flow/resumable-execution` (new) — makes the plan file the single durable source of execution state. Two artifacts, both inside the plan: task/step checkboxes checked **on disk** (`- [ ]` → `- [x]`), and an `## Execution Log` appended to the plan with a per-task entry (commit SHAs, one-line result, and delivery-manifest deltas — new files / deps / env vars / migrations). Defines the resume procedure as a pure reduction of `(plan + git) → next task`: locate plan, parse checkboxes + log, reconcile against `git log` / `git status` (surface any discrepancy, never guess), restore the worktree, rebuild TodoWrite, continue at the first unfinished task. Never re-runs a task already marked done. Absorbs the delivery manifest that `executing-plans` v0.8 emitted only conversationally, persisting it into the log instead. Provenance `[NEW]`, inspired by 12-factor-agents (factors 5/6/12) and gstack's `checkpoint` (conceptual sibling, not a port).
- `flow/writing-plans` — every plan now ends with an empty `## Execution Log` stub, the durable home the executor fills during implementation. New verification bullet.
- `flow/executing-plans` — added a "Persist before the checkpoint" step: check completed tasks' boxes on disk and append their Execution Log entries (with the manifest) before emitting the conversational checkpoint summary. The chat summary is for the human now; the log is for the next session.
- `flow/subagent-driven-development` — added a "Persisting Progress" section: the orchestrator (never the subagent) checks boxes on disk and writes the Execution Log entry after each task's two-stage review, before dispatching the next implementer. New red flag against TodoWrite-only progress.
- `skills/using-devstack` — slash-command reference gains a **Recovery command** entry (`/resume`), kept distinct from both the gated phase spine and the no-gate sharpening commands. Terminal States section notes that an interrupted run re-enters via `/resume`.
- `commands/resume.md` (new) — forwards to `flow/resumable-execution` and restates the reconcile-before-continue discipline.
- `CREDITS.md` — new flow-section row for `resumable-execution`.

### Notes

No skill name changes for existing skills. No profile schema changes. No breaking changes. Profiles (`nextjs.json` / `django.json` / `vue.json` / `spring.json`) intentionally do **not** list `resumable-execution` in their `flow` arrays — same pattern as the sharpening skills: it's invoked transitively by `executing-plans` / `subagent-driven-development` during execution and on demand via `/resume`, not part of the automatic per-implementation skill set.

## [0.11.0] — 2026-05-15

### Added — sharpening commands (`/grill`, `/zoom-out`, `/architecture`)

Three new cross-cutting entry points, distinct from the phase spine (`/brainstorm` → `/plan` → `/work` → `/review` → `/ship`). The phase spine is sequential and gated; sharpening commands have no gates and fire at any phase when the signal appears. This closes devstack's gap around adversarial review of existing artifacts, anti-tunnel-vision context elevation, and periodic architecture maintenance. All three are ported or reframed from [mattpocock/skills](https://github.com/mattpocock/skills); see `CREDITS.md` for per-skill provenance.

- `flow/challenging-plans` (new) — merger of mattpocock's `grill-me` (productivity, no doc awareness) and `grill-with-docs` (engineering, hooks into CONTEXT.md + ADRs) into a single doc-aware adversarial grilling skill. Lazy detection of `CONTEXT.md` / `docs/adr/` means it operates in pure-grilling mode when those files are absent and writes into them when present. Discipline: one question per turn with attached recommended answer; explore the codebase yourself when the answer lives there; surface CONTEXT.md / ADR contradictions the moment they appear; update glossary / write ADR / revise spec **inline** as decisions crystallize (no batched verbal summary). Eight question types (Definitional / Boundary / Failure mode / Cost / Reversibility / Prior art / Scope / Verification) rotate through. Three terminal states (artifact survives intact / needs revision / fundamentally unsound — recommend going back to `/brainstorm`). Distinct from `flow/brainstorming` (forward-going socratic dialogue against no existing artifact) and from `flow/improving-architecture` step 3 (grilling scoped to a selected deepening candidate, architecture-only). Slash command: `/grill`.

- `core/zooming-out` (new) — port of mattpocock's `zoom-out`, kept lightweight and single-pass. devstack adaptation: uses Agent `subagent_type=Explore` for the upward walk (matches the pattern in `improving-architecture`); reads `CONTEXT.md` / `docs/adr/` lazily; produces exactly four answers (Who calls this / What concept it represents / Deletion test / Where related decisions live) in 2–4 sentences each. Four-question structure maps onto the architecture vocabulary defined in `improving-architecture` § Glossary, so answers compose with that skill's analysis. Ends with one of three explicit recommendations (proceed locally / widen the change and wait for approval / escalate to `/grill` or `/architecture`) — never silently expands scope. Slash command: `/zoom-out`.

- `flow/improving-architecture` (reframed) — content unchanged; added a top-level **Cadence** section that positions the skill as a periodic anti-entropy ritual rather than a one-shot intervention. Recommended invocation points: every few working days on an active project, after every major feature merge, before a plan-heavy week, when `/zoom-out` repeatedly finds the same friction. Explicit rule that a clean run finding no candidates is a valid outcome — do not fabricate candidates to justify the ritual. Slash command: `/architecture` (new).

- `skills/using-devstack` — slash-command table split into two sections: **Phase commands** (workflow spine, sequential, gated, do not skip) and **Sharpening commands** (cross-cutting, no gates, any phase). The split makes the architectural distinction visible to the agent on first read.

- `commands/` — three new files (`grill.md`, `zoom-out.md`, `architecture.md`), each forwarding to its skill and restating the load-bearing discipline.

- `CREDITS.md` — `improving-architecture` row annotated with v0.11 framing change; two new rows added for `challenging-plans` (flow/) and `zooming-out` (core/).

### Notes

No skill name changes for existing skills. No profile schema changes. No breaking changes. Skills validation unaffected. Profiles (`nextjs.json` / `django.json` / `vue.json` / `spring.json`) intentionally do **not** list the three new sharpening skills in their `flow` / `core` arrays — same pattern as the existing `improving-architecture` skill, since these are on-demand utility skills invoked by name or slash command, not part of the automatic per-implementation skill set.

## [0.10.0] — 2026-05-14

### Added — aesthetic-direction discipline for greenfield UI

Two coordinated additions that close devstack's gap on **positive design direction** for greenfield work. The existing `frontend-ui-engineering` skill enforced engineering quality (a11y, spacing scale, responsive states) and listed AI-aesthetic anti-patterns, but offered no forward guidance for "what should this look like" when no design system existed. New content fills that gap and chains into the prototype gate.

- `standards/frontend-ui-engineering` — added **Aesthetic Direction (Greenfield)** section between "Design System Adherence" and "Accessibility". Activates only when no established design system applies (existing-design-system projects defer to their tokens, unchanged). Contents: 11-flavor flavor table (brutally minimal / maximalist / editorial / brutalist / retro-futuristic / art deco / luxury / organic / playful / pastel / industrial) with the rule "state the direction as one sentence the user can quote back"; specific font bans (`Inter` / `Roboto` / `Arial` / `Helvetica Neue` / system stack for display + the `Space Grotesk` / `Manrope` convergence trap); atmosphere vocabulary (gradient mesh / SVG noise / geometric pattern / translucent layers / exceeded-default shadows / decorative borders) with a hard cap of two layers; motion stance (CSS-only first, single orchestrated page-load reveal over scattered micro-interactions, mandatory `prefers-reduced-motion` fallback); complexity-matching rule (minimal demands precision, maximalist demands elaboration — half-maximalism reads as broken); anti-convergence rule (vary theme / display font / accent / hero layout across consecutive generations). Two new rationalization rows ("no design system, look doesn't matter" / "Inter is neutral"), three new red flags (no direction stated, banned display fonts, three+ atmosphere layers), one new verification item.
- `flow/prototyping-with-html` — added **"Commit to aesthetic direction"** as Process step 4, between "Choose generation tool" and "Generate the prototype". Process flow diagram updated. New top-level "Aesthetic Direction" section enforces the one-sentence direction statement before generation and defers full guidance to `frontend-ui-engineering` § Aesthetic Direction (Greenfield) to avoid duplication. Two prototype-specific additions: "show the direction in the first 30 seconds" (no scroll-to-find-the-look) and "don't reuse the previous prototype's palette / font / hero layout in this session" (the point of prototypes is options, not convergence). Two new anti-patterns match.
- `CREDITS.md` — `frontend-ui-engineering` and `prototyping-with-html` rows annotated; aesthetic-direction content is explicitly no-upstream (inspired by [anthropics/skills `frontend-design`](https://github.com/anthropics/skills/tree/main/skills/frontend-design), kept conditional so existing-design-system projects continue to defer to their tokens).

### Notes

No skill name changes, no profile schema changes, no breaking changes. `frontend-ui-engineering` Aesthetic Direction section is explicitly opt-in (greenfield-only); projects with a design system are unaffected. Skills validation unaffected.

## [0.9.0] — 2026-05-13

### Added — api-and-interface-design: schema-first principle

New principle 3.5 codifying **schema as the single source of truth** for boundary contracts. The existing skill already enforced "validate at boundaries" and showed Zod usage; this addition generalizes the discipline into a polyglot rule and makes the schema/type split an explicit anti-pattern.

- `standards/api-and-interface-design` — added principle `3.5. Schema-First: One Definition, Multiple Outputs` between sections 3 and 4. Mandates deriving the static type from the schema (`z.infer`, Pydantic model class, generated DTO) rather than hand-writing parallel `interface` + `validate()` pairs. Cross-language table covers TypeScript (Zod / Valibot / ArkType / io-ts), Python (Pydantic / attrs+cattrs), Java/Kotlin (Bean Validation / JSON Schema codegen), Go (validator struct tags / ogen), Rust (serde + validator macros), and cross-stack OpenAPI codegen. Rules: schema co-located with type; one schema per boundary shape (no `Create` reuse for `Update` — use `.partial()` / `.pick()` or write explicit); explicit coercion only; schema as documentation source (OpenAPI generation, not hand-maintained docs). Anti-pattern example shows `interface` + `validateCreateTask()` drift. New rationalization row ("I'll write the type, then the validator"), new red flag, new verification item ("Schema is the single source of truth — the static type is derived from it, not hand-written in parallel").
- `CREDITS.md` — `api-and-interface-design` row annotated; the 3.5 addition is explicitly no-upstream (inspired by [awesome-llm-apps `fullstack-developer` SKILL.md](https://github.com/Shubhamsaboo/awesome-llm-apps/tree/main/awesome_agent_skills/fullstack-developer)'s Zod-everywhere pattern, generalized to a polyglot single-source-of-truth rule).

### Notes

No skill name changes, no profile schema changes, no breaking changes. Skills validation unaffected.

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
