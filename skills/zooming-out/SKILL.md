---
name: zooming-out
description: "Anti-tunnel-vision skill. Steps back from a specific file, function, or module and explains it in the context of the larger system — who calls it, what concept in the domain it represents, what would change if it disappeared. Use when the user asks for broader context, says \"zoom out\", \"give me the big picture\", \"how does this fit\", or invokes /zoom-out. Also use proactively when an implementation discussion has been bouncing inside a single file for many turns."
---

<!--
origin: [MP]
sources:
  - mattpocock-skills:zoom-out @ 2026-04-26
notes: |
  Port of MP's zoom-out, kept lightweight and single-pass. devstack adaptation: uses Agent subagent_type=Explore for the upward walk (matches the pattern in improving-architecture), reads CONTEXT.md / docs/adr/ if present (matches the lazy-detection pattern in challenging-plans and improving-architecture), and is explicitly marked as a core/ skill that can fire mid-implementation when tunnel-vision is detected — not just on explicit slash-command invocation.

  The four-question structure (who calls / what does this represent / what would deletion do / where do related decisions live) is original to devstack but maps onto the architecture vocabulary (module / interface / locality / deletion test) defined in devstack:improving-architecture § Glossary, so the answers compose with that skill's analysis without re-defining terms.
-->

# Zooming Out

Step back from the local view (a function, a file, a single module) and explain the code in the context of the **system that contains it**. The goal is to escape tunnel vision before the next decision, not to write documentation.

## When to Use

Invoke when:

- The user says "zoom out", "give me the big picture", "how does this fit", "what is this part of", or invokes `/zoom-out`.
- A long implementation thread has been bouncing inside one file for many turns and you're about to make a non-trivial change without knowing what calls into it.
- A code review surfaces a question that can't be answered by reading the file under review alone.
- You're onboarding to an unfamiliar section of the codebase and the user wants a system-level walkthrough before edits begin.

Do **not** invoke when:

- The question is genuinely local (a typo, a one-line tweak, a self-contained function).
- The user is asking for a feature roadmap or product vision — that's not a code-zoom-out.
- An architecture refactor is on the table — use `devstack:improving-architecture` instead; this skill is a smaller, one-pass cousin.

## Process

### 1. Pin the local view

State plainly what you're zooming out from. One sentence:

> "Zooming out from `src/orders/cancel.ts:resolveCancellation()`."

If the user invoked `/zoom-out` without context, ask once which file or function to zoom out from. Then proceed.

### 2. Load domain context (if present)

Read lazily:

- `CONTEXT.md` (or `CONTEXT-MAP.md` + per-context `CONTEXT.md`)
- Any ADR in `docs/adr/` whose title mentions a concept the local view touches

If none exist, proceed without flagging — invent no documentation gap.

### 3. Walk upward

Use the Agent tool with `subagent_type=Explore` for a focused upward walk. Find:

- **Direct callers** — every place that imports or invokes the local view.
- **Indirect callers** — the route handlers, jobs, or entry points reachable from those callers.
- **Sibling modules at the same seam** — other adapters or implementations of the same interface (see `devstack:improving-architecture` § Glossary for the vocabulary).

Do not enumerate every file. Group callers by responsibility (e.g. "three route handlers and one cron job, all in the `orders/` slice").

### 4. Answer four questions

Present the zoom-out as exactly four answers, in this order. Keep each to 2–4 sentences:

1. **Who calls this?** Direct and indirect callers, grouped by responsibility. Name the entry points.
2. **What concept does this represent in the domain?** Map the code to a term in `CONTEXT.md` if one applies. If the code doesn't correspond to a named concept, say so — that itself is a finding.
3. **What would happen if this disappeared?** Apply the deletion test from `devstack:improving-architecture`. Does the complexity vanish (pass-through), or does it reappear across N callers (earning its keep)?
4. **Where do related decisions live?** Point to the relevant ADR, spec section, or sibling module. If none, say so — a missing decision record is also a finding.

### 5. Suggest the next move

End with one of:

- **Proceed with the local change.** "The local view is self-contained enough that the original task can continue as planned."
- **Widen the change.** "The local view is one of three places implementing the same seam — the change should touch all three or none."
- **Surface a deeper question.** "Before proceeding, the user should decide [X] — recommend `/grill` or `/architecture`."

Do not silently expand scope. Recommend, then wait.

## Anti-Patterns

| Anti-pattern | Why it's wrong | Fix |
|---|---|---|
| Listing every file in the repo | Overwhelms; the point is concision | Group callers by responsibility, not by filename |
| Skipping the deletion test | Misses the "is this earning its keep" signal | Always answer question 3 |
| Inventing domain terms | Adds drift to the team's language | If `CONTEXT.md` doesn't name the concept, say so — don't coin a name |
| Writing documentation instead of answers | Zoom-out is a working tool, not a doc deliverable | 2–4 sentences per question, no headings beyond the four |
| Quietly expanding the original task | User loses control of scope | Recommend the wider change; wait for approval |

## Rationalizations to Reject

| Thought | Reality |
|---|---|
| "I already know what this code does" | Knowing the code is local view. Zoom-out is about callers and seams, which change without the code changing. |
| "The user just wants a quick answer" | Quick answers without the deletion test are how shallow modules get deepened in the wrong place. |
| "There's no CONTEXT.md so I'll skip domain mapping" | Then say "no named concept in CONTEXT.md" — that's a finding, not a reason to skip. |

## Red Flags

- You answered fewer than four questions.
- You named callers without naming the entry points behind them.
- You didn't apply the deletion test.
- You silently widened the change instead of recommending the widening.

## Cross-References

- `devstack:improving-architecture` — owns the architecture vocabulary (module / interface / depth / seam / deletion test) this skill uses. Invoke `/architecture` if zoom-out reveals systemic friction across many modules.
- `devstack:domain-modeling` — owns the `CONTEXT.md` and ADR formats this skill reads from.
- `devstack:context-engineering` — if the zoom-out reveals that the agent is operating on stale or wrong context, refresh via context-engineering before continuing.
