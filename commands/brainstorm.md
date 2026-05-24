---
description: "Turn an idea into an approved written spec — socratic dialogue + adversarial grilling, optional HTML prototype for UI, section-by-section approval. Hands off to /plan or straight to /work."
---

Invoke the `devstack:brainstorming` skill.

Follow its HARD-GATE: no code, no scaffolding, no implementation action until a written spec exists at `docs/devstack/specs/` and the user has approved it.

Clarifying the requirement is the main work — grill hard (one question at a time, each with a recommended answer, probing boundaries and failure modes), and scale the grilling to complexity. For features with a visible UI, **offer** an optional clickable HTML prototype before locking the spec; the user opts in. If a prototype is built, it becomes the UI source of truth and the spec references it instead of describing the UI in prose.

The terminal state is a branch: for complex work invoke `devstack:writing-plans` (`/plan`); for small, self-contained work hand off straight to execution (`/work`) — no separate plan needed. Do not invoke any other implementation skill.
