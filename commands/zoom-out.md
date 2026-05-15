---
description: "Step back from a specific file or function and explain it in the context of the larger system — direct callers, domain concept, deletion test, where related decisions live."
---

Invoke the `devstack:zooming-out` skill.

The skill produces exactly four answers about the pinned local view:

1. Who calls this (direct + indirect, grouped by responsibility, with entry points named)
2. What concept it represents in the domain (mapped to CONTEXT.md if present)
3. What would happen if it disappeared (deletion test — pass-through vs earning-its-keep)
4. Where related decisions live (ADR, spec section, sibling modules)

End with a recommendation: proceed with the local change, widen the change (and wait for approval), or escalate to `/grill` or `/architecture`.

If the user didn't pin a local view, ask once which file or function to zoom out from, then proceed.
