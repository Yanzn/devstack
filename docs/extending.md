# Extending devstack

> [中文版](extending_zh-CN.md)

devstack is designed so that adding new platforms and tech stacks does **not** require modifying `flow/` or `core/`. You only add to `standards/`.

## Adding a New Tech-Stack Skill

### Step 1: Identify the gap

Ask: what does a senior engineer on this stack know that a generic agent doesn't? Examples:

- **iOS:** Swift concurrency, SwiftUI state management, App Store guidelines, Core Data migrations, XCTest patterns
- **Android:** Kotlin coroutines, Jetpack Compose, ProGuard/R8, Espresso, Play Store policy
- **Rust:** ownership patterns, `Result`/`Option` idioms, cargo workspaces, unsafe boundaries
- **Go:** error wrapping, context propagation, goroutine lifecycle, table-driven tests
- **Embedded:** memory budgets, deterministic timing, interrupt safety

Each becomes one or more skills under `skills/standards/<domain>/`.

### Step 2: Draft the SKILL.md

Use `meta/writing-skills` for the structure:

```
skills/standards/ios-swift-concurrency/
└── SKILL.md
```

Frontmatter follows the devstack convention:

```yaml
---
name: ios-swift-concurrency
description: Guides safe and idiomatic Swift async/await, actors, and structured concurrency. Use when building concurrent iOS code — async operations, actor isolation, task cancellation, or data races.
---
```

Include the origin comment at top:

```html
<!--
origin: [NEW]
notes: Original skill for devstack. Written from Apple documentation and WWDC sessions on Swift concurrency.
-->
```

### Step 3: Body structure

Follow the two-voice rule from [docs/philosophy.md](philosophy.md):

- If the skill **enforces behavior** (e.g., "always cancel parent task on child failure"), use the imperative SP voice — HARD-GATEs, rationalization tables, red flags.
- If the skill **teaches principles** (e.g., "choose `actor` over `@MainActor class` when..."), use the AS voice — Overview / When to Use / Process / Rationalizations / Red Flags / Verification, rich with code examples.

Most standards skills are the second kind.

### Step 4: Wire it in

- Add a row to the `standards/` table in [CREDITS.md](../CREDITS.md).
- Add a row to [docs/origins.md](origins.md).
- Mention the domain in `skills/using-devstack/SKILL.md`'s "when each standard fires" section so the agent knows to pick it up.
- If the skill is meant to auto-trigger on specific contexts (e.g., `.swift` files being edited), write the `description` field to include those triggers, since Claude Code and most harnesses use `description` for discovery matching.

### Step 5: Validate

Run:

```bash
./scripts/validate-skills.sh
```

(Shipped in batch 2.) Checks frontmatter, cross-references, and dead links.

## Adding a New Slash Command

devstack commands are thin shells that invoke one or more skills (the Superpowers pattern). Example for an iOS-specific command:

```markdown
---
description: "iOS pre-submission checklist — App Store review, privacy manifest, screenshots, entitlements"
---

Invoke the devstack:standards/ios-app-store-submission skill.
Walk through the submission checklist. Report any failing items.
```

Commands should be reserved for **workflow entry points**, not for every skill. Most skills are invoked via auto-discovery from `description`.

## Swapping a Layer

If you want to replace devstack's `flow/` with your own (e.g., a stricter brainstorming dialog), you can:

1. Write your replacement skills under `skills/flow/`.
2. Leave `core/` and `standards/` untouched.
3. Update `skills/using-devstack/SKILL.md`'s flow-layer section to point at the new skill names.

This works because the three layers reference each other by skill name only, not by implementation.

## Contributing Back Upstream

If a skill you wrote would benefit *all* devstack users (not just your team/project), consider upstreaming it. But read Superpowers' and agent-skills' contribution guidelines first — both projects are opinionated about what belongs in core.

Most domain-specific skills belong in a standalone plugin that extends devstack, not in core devstack itself.
