---
description: "Run a periodic anti-entropy pass over the codebase — surface deepening opportunities (shallow modules to consolidate, broken seams, missing locality) informed by CONTEXT.md and docs/adr/. Recommended every few working days or after a major feature merge."
---

Invoke the `devstack:improving-architecture` skill.

This is a **periodic ritual**, not a one-off intervention. A clean run that surfaces no candidates is a valid outcome — it's evidence the architecture is holding. Do not fabricate candidates to justify the invocation.

The skill follows three phases:

1. **Explore** — read CONTEXT.md / docs/adr/ if present (silently if absent), then walk the codebase via the Agent tool with `subagent_type=Explore`. Note friction points.
2. **Present candidates** — numbered list of deepening opportunities, each with Files / Problem / Solution / Benefits, using `CONTEXT.md` vocabulary for the domain and `LANGUAGE.md` (in the skill folder) vocabulary for the architecture. Flag ADR conflicts only when worth reopening.
3. **Grilling loop** — once the user picks a candidate, walk the design tree together. Update CONTEXT.md inline; offer ADRs for load-bearing rejections.

If the user wants to grill a specific plan or design (not the codebase as a whole), redirect to `/grill` — that's the right scope for `devstack:challenging-plans`.
