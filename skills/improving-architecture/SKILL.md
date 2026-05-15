---
name: improving-architecture
description: "Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, make a codebase more testable and AI-navigable, or run a periodic anti-entropy pass. Recommended cadence: every few working days for active projects, or after every major feature merge."
---

<!--
origin: [MP]
sources:
  - mattpocock-skills:improve-codebase-architecture @ 2026-04-26
notes: |
  Direct graft from mattpocock/skills. Skill renamed `improve-codebase-architecture` → `improving-architecture` for devstack gerund convention. Cross-references to ../domain-model/* rewritten to ../domain-modeling/* (devstack name). Three-phase process (Explore → Present → Grilling) preserved verbatim. Companion files LANGUAGE.md, DEEPENING.md, INTERFACE-DESIGN.md grafted alongside.

  v0.11: framed as a periodic anti-entropy ritual rather than a one-shot intervention. Added "Cadence" section at top, slash-command entry point `/architecture`, and language tying the skill into devstack's broader rhythm (run after feature merges, before plan-heavy weeks). Inspired by MP's recommendation to "run this on your codebase once every few days" — no skill-content change, only framing.
-->

# Improving Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

## Cadence

This skill is most valuable when run **periodically**, not just when a refactor is forced on you. Agent-assisted codebases accumulate entropy faster than human-written ones: more code per unit time means more shallow modules, more inconsistent vocabulary, more half-finished seams. A short, regular ritual catches this before it compounds.

Recommended invocation points:

- **Every few working days** on an active project — a 15-minute pass to surface candidates, even if none are picked.
- **After every major feature merge** — the codebase's shape just shifted; check whether the seams still hold.
- **Before a plan-heavy week** — a clean architecture makes the upcoming plan smaller.
- **When `/zoom-out` repeatedly finds the same friction** — that's a signal this skill is overdue.

A periodic invocation that finds no candidates is still valuable — it's evidence the architecture is holding. Don't fabricate candidates to justify the ritual.

Slash command: `/architecture`.

## Glossary

Use these terms exactly in every suggestion. Consistent language is the point — don't drift into "component," "service," "API," or "boundary." Full definitions in [LANGUAGE.md](LANGUAGE.md).

- **Module** — anything with an interface and an implementation (function, class, package, slice).
- **Interface** — everything a caller must know to use the module: types, invariants, error modes, ordering, config. Not just the type signature.
- **Implementation** — the code inside.
- **Depth** — leverage at the interface: a lot of behaviour behind a small interface. **Deep** = high leverage. **Shallow** = interface nearly as complex as the implementation.
- **Seam** — where an interface lives; a place behaviour can be altered without editing in place. (Use this, not "boundary.")
- **Adapter** — a concrete thing satisfying an interface at a seam.
- **Leverage** — what callers get from depth.
- **Locality** — what maintainers get from depth: change, bugs, knowledge concentrated in one place.

Key principles (see [LANGUAGE.md](LANGUAGE.md) for the full list):

- **Deletion test**: imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.**
- **One adapter = hypothetical seam. Two adapters = real seam.**

This skill is _informed_ by the project's domain model — `CONTEXT.md` and any `docs/adr/`. The domain language gives names to good seams; ADRs record decisions the skill should not re-litigate. See `devstack:domain-modeling` (companion files [CONTEXT-FORMAT.md](../domain-modeling/CONTEXT-FORMAT.md) and [ADR-FORMAT.md](../domain-modeling/ADR-FORMAT.md)).

## Process

### 1. Explore

Read existing documentation first:

- `CONTEXT.md` (or `CONTEXT-MAP.md` + each `CONTEXT.md` in a multi-context repo)
- Relevant ADRs in `docs/adr/` (and any context-scoped `docs/adr/` directories)

If any of these files don't exist, proceed silently — don't flag their absence or suggest creating them upfront.

Then use the Agent tool with `subagent_type=Explore` to walk the codebase. Don't follow rigid heuristics — explore organically and note where you experience friction:

- Where does understanding one concept require bouncing between many small modules?
- Where are modules **shallow** — interface nearly as complex as the implementation?
- Where have pure functions been extracted just for testability, but the real bugs hide in how they're called (no **locality**)?
- Where do tightly-coupled modules leak across their seams?
- Which parts of the codebase are untested, or hard to test through their current interface?

Apply the **deletion test** to anything you suspect is shallow: would deleting it concentrate complexity, or just move it? A "yes, concentrates" is the signal you want.

### 2. Present candidates

Present a numbered list of deepening opportunities. For each candidate:

- **Files** — which files/modules are involved
- **Problem** — why the current architecture is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — explained in terms of locality and leverage, and also in how tests would improve

**Use CONTEXT.md vocabulary for the domain, and [LANGUAGE.md](LANGUAGE.md) vocabulary for the architecture.** If `CONTEXT.md` defines "Order," talk about "the Order intake module" — not "the FooBarHandler," and not "the Order service."

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is real enough to warrant revisiting the ADR. Mark it clearly (e.g. _"contradicts ADR-0007 — but worth reopening because…"_). Don't list every theoretical refactor an ADR forbids.

Do NOT propose interfaces yet. Ask the user: "Which of these would you like to explore?"

### 3. Grilling loop

Once the user picks a candidate, drop into a grilling conversation. Walk the design tree with them — constraints, dependencies, the shape of the deepened module, what sits behind the seam, what tests survive.

Side effects happen inline as decisions crystallize:

- **Naming a deepened module after a concept not in `CONTEXT.md`?** Add the term to `CONTEXT.md` — same discipline as `devstack:domain-modeling` (see [CONTEXT-FORMAT.md](../domain-modeling/CONTEXT-FORMAT.md)). Create the file lazily if it doesn't exist.
- **Sharpening a fuzzy term during the conversation?** Update `CONTEXT.md` right there.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR, framed as: _"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ Only offer when the reason would actually be needed by a future explorer to avoid re-suggesting the same thing — skip ephemeral reasons ("not worth it right now") and self-evident ones. See [ADR-FORMAT.md](../domain-modeling/ADR-FORMAT.md) for the lightweight 1–3 sentence format. For the full template (Status / Context / Decision / Consequences) used for heavyweight platform decisions, see `devstack:documentation-and-adrs`.
- **Want to explore alternative interfaces for the deepened module?** See [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md).
