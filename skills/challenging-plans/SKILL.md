---
name: challenging-plans
description: "Adversarial grilling of an existing plan, spec, design decision, or in-flight implementation choice. Asks one sharp question at a time, walks every branch of the decision tree, and tests the artifact against the project's domain language (CONTEXT.md) and prior decisions (docs/adr/). Use when the user says \"grill me\", \"challenge this plan\", \"stress-test this\", \"poke holes\", or invokes /grill."
---

<!--
origin: [MP]
sources:
  - mattpocock-skills:grill-me @ 2026-04-26
  - mattpocock-skills:grill-with-docs @ 2026-04-26
notes: |
  Merger of MP's two grilling skills into a single devstack flow skill. MP keeps grill-me (productivity, no doc awareness) and grill-with-docs (engineering, hooks into CONTEXT.md + ADRs) as separate skills. devstack collapses them: doc-awareness is always on, gated by lazy detection — if CONTEXT.md / docs/adr/ don't exist, the skill operates in pure-grilling mode without flagging their absence. Side-effects (sharpening glossary, recording ADR for load-bearing rejections) are imported verbatim from grill-with-docs but defer their file formats to devstack:domain-modeling (CONTEXT-FORMAT.md / ADR-FORMAT.md), matching the same pattern used by devstack:improving-architecture's grilling loop.

  Renamed to devstack gerund convention. Distinct from devstack:brainstorming (forward-going socratic dialogue that builds a spec from scratch) — challenging-plans operates against an existing artifact and is adversarial by design. Also distinct from improving-architecture's step-3 grilling loop, which is scoped to a selected deepening candidate.
-->

# Challenging Plans

Stress-test an existing plan, spec, design decision, or implementation choice by **interviewing the user adversarially** until every branch of the decision tree has been resolved out loud.

This skill is **not exploratory** — it assumes an artifact already exists (or is being proposed) and tries to break it. If no artifact exists yet, use `devstack:brainstorming` instead.

## When to Use

Invoke when:

- The user says "grill me", "challenge this", "poke holes", "stress-test this plan", or invokes `/grill`.
- A spec, plan, or design decision is about to be approved and the user wants one more adversarial pass.
- An in-flight implementation choice feels too easy — the user wants to make sure nothing is being hand-waved.
- A proposal contradicts something already established (a CONTEXT.md term, a prior ADR, an existing module's contract) and the user wants the contradiction surfaced.

Do **not** invoke when:

- There is no artifact to challenge — use `devstack:brainstorming` to produce one first.
- The user wants implementation guidance, not adversarial review — use the relevant flow/standards skill.
- A candidate refactor has been picked and needs design-tree walking — that's already `devstack:improving-architecture` step 3.

## Process

### 1. Locate the artifact

Identify what is being challenged. Be explicit so both sides agree on the surface:

- A spec at `docs/devstack/specs/<file>.md`
- A plan at `docs/devstack/plans/<file>.md`
- An ADR draft or proposed decision in the conversation
- A specific in-flight code choice (which file, which line range)

If the artifact is implicit ("this approach we just discussed"), restate it in one sentence before grilling. If the user can't agree with your restatement, the artifact isn't ready — surface that first.

### 2. Load domain context

Read existing documentation **lazily**:

- `CONTEXT.md` (or `CONTEXT-MAP.md` + per-context `CONTEXT.md`)
- Relevant ADRs in `docs/adr/`

If none exist, proceed in pure-grilling mode. Do **not** flag their absence or suggest creating them upfront — let them appear lazily as decisions crystallize (see Side Effects below).

### 3. Grill — one question at a time

Walk down each branch of the decision tree, resolving dependencies between decisions one by one. Rules:

- **One question per turn.** Wait for the user's answer before the next question. Do not batch.
- **For each question, provide your recommended answer.** Make the user push back against a position, not against silence.
- **If a question can be answered by exploring the codebase, explore the codebase instead.** Use the Agent tool with `subagent_type=Explore` rather than asking the user to recite what's already in the repo.
- **Surface contradictions immediately.** When the user uses a term that conflicts with `CONTEXT.md`, or proposes something that contradicts an existing ADR, call it out the moment it happens. Don't store it up for a summary.
- **Test the boundaries.** Don't grill the happy path; grill the edges, the failure modes, the upgrade path, the rollback story, and the second-order consequences.

Question types to rotate through:

| Type | Example |
|---|---|
| Definitional | "When you say 'cancellation' — is that the user-facing action, the internal state transition, or the refund event? Your glossary defines it as X." |
| Boundary | "What happens at the seam between A and B when both write to the same record concurrently?" |
| Failure mode | "If this step fails halfway, what's the recovery? Is it idempotent on retry?" |
| Cost | "What does this cost us in the worst case — latency, dollars, on-call pages?" |
| Reversibility | "Once shipped, what's the rollback story if we learn this was the wrong call?" |
| Prior art | "ADR-0007 chose Y over X — does this proposal reopen that decision? If so, why now?" |
| Scope | "Is this really one change, or three changes you're hoping to ship as one?" |
| Verification | "How will you know this is working — what's the metric, the test, the SLO?" |

### 4. Side effects (inline)

As decisions crystallize during the grilling, write them down in the right place. Don't batch to the end — do it the moment the resolution happens.

- **A new domain term is named or sharpened?** Add or update it in `CONTEXT.md`. Defer to `devstack:domain-modeling` ([CONTEXT-FORMAT.md](../domain-modeling/CONTEXT-FORMAT.md)) for the entry format. Create the file lazily if it doesn't exist.
- **A load-bearing decision is made — especially a rejection?** Offer an ADR, framed as: _"Want me to record this as an ADR so we don't re-litigate it next quarter?"_ Only offer when the reason would actually be needed by a future explorer to avoid re-asking the same question. Skip ephemeral reasons ("not worth it right now") and self-evident ones. See [ADR-FORMAT.md](../domain-modeling/ADR-FORMAT.md) for the lightweight 1–3 sentence format. For platform-scale decisions use the heavier Status / Context / Decision / Consequences template from `devstack:documentation-and-adrs`.
- **The artifact itself changes during the grill?** Update the spec / plan / proposal in place. Don't accumulate a verbal "here's what we'd change" list — write it.

### 5. Terminal state

The grilling ends when one of:

- **The artifact survives intact.** Every branch resolved, no open questions. Announce: _"No further questions. Artifact is approved as-is."_
- **The artifact needs revision.** Summarize the deltas, hand back to the originating flow (`brainstorming` for a spec, `writing-plans` for a plan), and wait for the revised artifact before re-grilling.
- **The artifact is fundamentally wrong.** Surface this explicitly: _"The premise of this plan appears unsound — recommend going back to `/brainstorm` before continuing."_ Do not pretend a broken artifact is fixable by one more question.

## Anti-Patterns

| Anti-pattern | Why it's wrong | Fix |
|---|---|---|
| Batching questions ("here are 12 things to think about") | User can't engage with 12 things at once; they pick the easiest 2 and ignore the rest | One question per turn |
| Grilling without a recommendation | Forces user to do all the thinking; you're a sounding board, not an interviewer | For each question, state your recommended answer |
| Sycophantic grilling ("great plan, but have you considered…") | Defangs the adversarial mode; user reads it as approval | Be direct — "this step assumes X, which I don't see evidence for" |
| Ignoring CONTEXT.md drift | Lets the team accumulate two terms for the same thing | Call out term conflicts the moment they appear |
| Asking the user to recite the codebase | Wastes the user's time; you have file-reading tools | Explore yourself when the answer lives in the repo |
| Ending without writing things down | Decisions made verbally during a grill evaporate within hours | Update CONTEXT.md / ADR / spec inline as decisions crystallize |

## Rationalizations to Reject

| Thought | Reality |
|---|---|
| "The plan looks fine, no need to grill hard" | If the plan is fine, grilling confirms that in 5 minutes. If it's not, you just saved a week. |
| "I should ask several questions at once to save time" | Saves your time, costs the user's clarity. Batch grilling becomes batch hand-waving. |
| "The user already approved the spec, I shouldn't re-open it" | `/grill` is invoked precisely to re-open it. Refusing to grill defeats the skill. |
| "Recording this as an ADR is overkill" | If the user makes a load-bearing decision with a non-obvious reason, the next session will re-ask. Capture it. |

## Red Flags

- You asked more than one question in a single turn.
- You stated a question without your own recommended answer.
- The user used a domain term and you didn't check it against `CONTEXT.md`.
- The grill ended and no file was written or updated.
- You're grilling the happy path, not the failure modes.

## Cross-References

- `devstack:brainstorming` — use **before** challenging-plans when no artifact exists yet.
- `devstack:domain-modeling` — owns the `CONTEXT.md` and `docs/adr/` formats this skill writes into.
- `devstack:improving-architecture` — its step-3 grilling loop is the architecture-scoped specialization of this skill; use it when the artifact is a deepening candidate, not a general plan.
- `devstack:writing-plans` — use **after** challenging-plans if the grill revealed the plan needs revision.
