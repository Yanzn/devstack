---
description: "Adversarially stress-test an existing plan, spec, design decision, or in-flight choice — one question at a time, walking every branch of the decision tree, with CONTEXT.md and ADR awareness."
---

Invoke the `devstack:challenging-plans` skill.

This is adversarial grilling against an **existing artifact** (a spec, plan, ADR draft, or proposed implementation choice). If no artifact exists yet, redirect to `/brainstorm` first — challenging-plans cannot grill what hasn't been written.

Follow the skill's discipline:

- One question per turn, with your recommended answer attached.
- Explore the codebase yourself when the answer lives there — don't make the user recite.
- Surface CONTEXT.md / ADR contradictions the moment they appear.
- Update CONTEXT.md, write a new ADR, or revise the spec **inline** as decisions crystallize — don't batch to the end.

Terminate when the artifact survives intact, needs revision (hand back to the originating flow), or is fundamentally unsound (recommend going back to `/brainstorm`).
