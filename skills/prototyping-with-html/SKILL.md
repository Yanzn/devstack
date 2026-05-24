---
name: prototyping-with-html
description: "Optional clarification aid offered by brainstorming when a requirement has a visible UI and the user opts in — turns the discussed design into a clickable hi-fi HTML prototype the user opens in a browser, iterates on, and approves as the visual contract for the spec. UI-only; skipped when the user declines or the feature has no visible surface."
---

<!--
origin: [NEW]
inspired_by:
  - gstack:design-shotgun (multi-variant exploration)
  - gstack:frontend-design (hi-fi HTML generation)
  - gstack:design-html (Pretext-native HTML/CSS finalization)
notes: |
  Original to devstack. Inserts a prototype-driven approval gate between
  brainstorming's "propose approaches" step and spec-writing. The HTML prototype
  becomes the source of truth for visual/interaction decisions; the written spec
  references it instead of describing it in prose. Reuses any available hi-fi
  HTML skill when present (frontend-design, design-html), otherwise writes HTML
  directly. Browser preview reuses devstack:browser-testing-with-devtools or any
  available playwright/browse MCP, otherwise prints a file:// URL the user opens.
  v0.10.0: added "Commit to aesthetic direction" step between "Choose generation
  tool" and "Generate the prototype" (Process step 4). New "Aesthetic Direction"
  section enforces a one-sentence direction statement before generation; defers
  the full flavor / font / atmosphere / motion / anti-convergence guidance to
  devstack:frontend-ui-engineering § Aesthetic Direction (Greenfield) to avoid
  duplication. Two prototype-specific rules added: "show direction in first
  30 seconds" and "don't reuse previous prototype's palette/font in same
  session". Anti-patterns and process flow diagram updated. Inspired by
  anthropics/skills frontend-design SKILL.md.
-->

# Prototyping With HTML

Turn an in-progress UI design into a clickable, hi-fi HTML prototype that the user opens in a real browser, interacts with, and approves. The approved prototype becomes the **visual contract** the spec references — not a paragraph of UI prose.

<HARD-GATE>
Once the user opts into a prototype, do NOT write the spec's UI description, hand off to the next phase, or scaffold any production code until the user has opened the prototype in a browser AND approved it in writing. "Approval" means an explicit "looks good / ship it / approved" — not silence and not "looks OK, but…". If the user requests changes, iterate the prototype and ask again. (If the user never opts into a prototype, this gate doesn't apply — brainstorming captures the UI in spec prose instead.)
</HARD-GATE>

## When to Use

**Offered** by `devstack:brainstorming` as an **optional** clarification aid when the requirement has a **visible end-user surface** and the user opts in:

- Web pages, dashboards, marketing sites
- App screens, modals, wizards, forms
- Component libraries with visible primitives
- Any flow where a human will look at pixels and click things

This skill is a tool, not a gate. brainstorming offers it; the user decides. It pays off when the visual decisions are the hard part and prose is failing to pin them down. When the user is confident describing the UI in words, or the UI is trivial, the spec captures it in prose and this skill is skipped.

**Skip this skill** when the user declines the offer, or when the feature has no visual surface:

- CLI tools, daemons, cron jobs
- Backend APIs consumed only by other code
- Library/SDK internals
- Database migrations, schema changes
- Infrastructure / CI / build tooling

If you're unsure whether there's a visual surface worth prototyping, ask the user one question: *"Will an end user look at pixels and click things? If yes, want a quick HTML prototype before we lock the spec?"*

## What "Hi-Fi" Means Here

Not lorem ipsum. Not gray boxes. The prototype should look like a screenshot of the shipped product:

- Real strings (the actual button labels, headings, empty-state copy)
- Realistic mock data (plausible names, dates, numbers, lengths)
- Production-grade typography, spacing, and color
- Hover/focus/active states for interactive elements
- Clickable links between pages/screens that exist in the flow
- Loading/empty/error states for at least one canonical case

**Mock data, not real data.** No backend calls. Everything client-side. No persistence beyond `localStorage` if a stateful interaction is being demonstrated.

## Process

Create a TodoWrite task per item. Work in order.

1. **Identify the UI surfaces** — what screens / pages / modals does this feature touch? List them.
2. **Identify the canonical user flow** — the happy path the prototype must support clicking through.
3. **Choose generation tool** — prefer an available hi-fi HTML skill, otherwise write HTML directly (see [Generation Tools](#generation-tools)).
4. **Commit to an aesthetic direction** — name it in one sentence before generating (see [Aesthetic Direction](#aesthetic-direction)). Skip this only when an established design system applies.
5. **Generate the prototype** — save to `docs/devstack/prototypes/<topic>/index.html` plus any sibling pages.
6. **Add realistic mock data** — populate every visible element with content that resembles real production data.
7. **Wire interactions** — clickable links between pages, hover states, form submission to a "success" page, at least one empty/loading/error state.
8. **Open the prototype in a browser** — use [Browser Preview](#browser-preview) to give the user a URL they can open right now.
9. **Capture feedback** — wait for the user to interact and respond. Ask one focused question per round (see [Feedback Loop](#feedback-loop)).
10. **Iterate** — apply changes, re-open, ask again. Keep going until the user explicitly approves.
11. **Hand back to brainstorming** — return the prototype path + a short Visual Contract note for the spec.

## Process Flow

```dot
digraph prototyping {
    "Identify UI surfaces & flow" [shape=box];
    "Choose generation tool" [shape=box];
    "Commit to aesthetic direction\n(one-sentence statement)" [shape=box];
    "Generate hi-fi HTML\n+ mock data\n+ clickable interactions" [shape=box];
    "Open prototype in browser" [shape=box];
    "User interacts & responds" [shape=box];
    "User approves?" [shape=diamond];
    "Apply requested changes" [shape=box];
    "Hand back to brainstorming\nwith prototype path" [shape=doublecircle];

    "Identify UI surfaces & flow" -> "Choose generation tool";
    "Choose generation tool" -> "Commit to aesthetic direction\n(one-sentence statement)";
    "Commit to aesthetic direction\n(one-sentence statement)" -> "Generate hi-fi HTML\n+ mock data\n+ clickable interactions";
    "Generate hi-fi HTML\n+ mock data\n+ clickable interactions" -> "Open prototype in browser";
    "Open prototype in browser" -> "User interacts & responds";
    "User interacts & responds" -> "User approves?";
    "User approves?" -> "Apply requested changes" [label="no"];
    "Apply requested changes" -> "Open prototype in browser";
    "User approves?" -> "Hand back to brainstorming\nwith prototype path" [label="yes, explicit"];
}
```

## Generation Tools

Prefer an existing skill if present in the environment:

| Tool                              | Use for                                          |
|-----------------------------------|--------------------------------------------------|
| `frontend-design` (gstack)        | Hi-fi distinctive UIs that avoid AI-slop look    |
| `design-html` (gstack)            | Production-quality dynamic HTML/CSS              |
| `design-shotgun` (gstack)         | Multiple variants for side-by-side comparison    |
| Direct HTML/CSS                   | Fallback when none of the above are available    |

If you write HTML directly, follow these defaults:

- One `index.html` plus sibling pages (`settings.html`, `detail.html`, etc.) — flat, no build step
- Inline `<style>` block at top, or one `styles.css` sibling — no preprocessor
- Inline `<script>` for interactions and mock data — no bundler, no framework
- Use a system font stack and modern CSS (grid, flexbox, custom properties)
- Keep it self-contained: a user can `open index.html` and the whole prototype works

**Never use a build step for prototypes.** A prototype that requires `npm install` defeats its own purpose.

## Aesthetic Direction

Most prototypes are greenfield — no design system to defer to. Without an explicit direction, generation drifts to AI defaults (Inter on white, purple gradient, identical layouts across runs). Before generating, **state the aesthetic direction in one sentence the user can quote back.**

Examples of a valid statement:

- *"Editorial magazine — large serif display, wide gutters, drop caps on section openers."*
- *"Brutally minimal — single accent color, mono numbers, near-zero decoration."*
- *"Retro-futuristic dashboard — neon-on-dark, scanline overlay, monospace labels."*

If you can't say the sentence, you haven't picked.

**Full flavor table, font bans, atmosphere vocabulary, motion stance, and the "don't converge across generations" rule live in `devstack:frontend-ui-engineering` § Aesthetic Direction (Greenfield). Use that section as the source of truth; this skill only enforces the gate.**

Two prototype-specific additions:

- **Show the direction in the first 30 seconds.** Hero / first-fold / above-the-fold must read the direction immediately. If the user has to scroll to see what you picked, the prototype is hedging.
- **Don't reuse the previous prototype's palette and font in this session.** If the last prototype was warm-luxury-serif, this one shouldn't open with warm-luxury-serif unless the user asked. The point of generating prototypes is to give the user options, not converge on your favorite.

When a design system DOES exist in the project (an existing `tokens.css`, brand guide, or component library), skip this gate and follow the system. The prototype's job is then to apply the system to the new surface, not invent a look.

## Browser Preview

Three options, in preference order:

1. **`devstack:browser-testing-with-devtools`** — if the project already uses it, hand off the prototype path
2. **Available playwright/browse MCP** (e.g., `playwright`, gstack `browse`) — open the file URL programmatically and snapshot for the user
3. **Plain file URL** — print `open docs/devstack/prototypes/<topic>/index.html` and ask the user to run it

Always print the URL alongside any programmatic preview, so the user can re-open it themselves between rounds without your help.

## Feedback Loop

After opening the prototype, ask **one focused question** at a time:

- "Try clicking through the empty-state flow on the projects page. Does the empty-state copy land?"
- "On a 1280-wide window, the sidebar is 240px. Want it wider, narrower, or that?"
- "I added a destructive-action confirmation modal. Open the delete button on the first row. Right friction level?"

**Avoid:**

- "What do you think?" — too vague, generates vague feedback
- Multiple questions in one message — user can only answer one well
- Asking about things the prototype doesn't yet show — build it first

When the user requests a change:

1. Make the change
2. Reopen the file (or hot-reload if your preview supports it)
3. Confirm what changed in one sentence: *"Sidebar widened to 280px and added a collapse toggle."*
4. Ask the next question

## Approval Gate

Approval is **explicit and written**:

- ✅ "Approved", "ship it", "looks good — proceed", "this is what I want"
- ❌ "Looks OK", "I guess that works", silence, "let's just move on" — these are NOT approvals; ask again or surface what's making the user hesitant

When approved, summarize what you're locking in (1–3 bullets) and write the Visual Contract note (next section).

## Visual Contract Note

Hand back to `devstack:brainstorming` with this payload:

```markdown
## Visual Contract

**Prototype:** `docs/devstack/prototypes/<topic>/index.html`
**Approved:** <YYYY-MM-DD>

**Surfaces locked in:**
- <page/screen 1> — <one-line purpose>
- <page/screen 2> — <one-line purpose>

**Interaction decisions worth calling out:**
- <decision 1, e.g., "Destructive actions use a confirm modal, not inline confirm">
- <decision 2, e.g., "Empty state shows a single CTA, not multiple options">

**Out of scope for this prototype:**
- <thing 1 deliberately not shown>
- <thing 2 deferred to v2>
```

This block goes into the spec under a `## Visual Contract` heading. The rest of the spec (data model, API, success criteria, boundaries) is written normally — but UI prose is replaced by a pointer to the prototype.

## Anti-Patterns

- **Lorem ipsum or `Lorem ipsum dolor sit amet`** — write real-looking copy
- **Dead links** in the canonical flow — every link the user clicks must go somewhere
- **One-screen prototype for a multi-screen flow** — show the flow, not just a snapshot
- **Skipping mobile when mobile is in scope** — at minimum, set up a `@media` query and verify at 390px
- **Build step / npm install required** — defeats the point of a prototype
- **Asking "what do you think?"** instead of one focused question
- **Treating "looks OK" as approval** — push for explicit yes
- **Re-describing the prototype in spec prose** — the prototype IS the description; spec only captures non-visual contracts
- **Generating without naming an aesthetic direction** — greenfield prototypes that skip the one-sentence direction converge on AI defaults
- **Reusing the previous prototype's palette / display font / hero layout** in the same session — convergence is a tell

## Red Flags

- Writing the spec's UI section before the prototype is approved
- Generating a prototype with placeholder text and asking the user to "imagine the real content"
- Building screens that aren't part of the canonical flow because they "might be useful later" — out of scope
- Using a real backend or real user data in the prototype
- Iterating more than ~5 rounds without convergence — stop, ask the user what's structurally wrong

## Iteration Budget

If you've done 5+ rounds and the user is still requesting major changes, **stop iterating** and ask one structural question:

> "We've been iterating on details for a while. Is there a structural decision we got wrong upfront — wrong layout, wrong information architecture, wrong primary flow? I'd rather rebuild than keep patching."

Better to throw out and restart than burn 20 rounds polishing the wrong shape.

## Handoff

```
[User explicitly approves prototype]

You: Prototype approved at docs/devstack/prototypes/<topic>/index.html.
     Returning to devstack:brainstorming with the Visual Contract note for
     the spec. The spec will reference the prototype path instead of
     re-describing the UI in prose.

[Continue brainstorming with section 6 onward, using the Visual Contract
 note as the UI portion of the spec]
```
