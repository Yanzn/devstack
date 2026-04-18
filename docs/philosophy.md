# Philosophy

> [中文版](philosophy_zh-CN.md)

devstack is built on five beliefs. If you disagree with any of them, this plugin will fight you.

## 1. Process is how good code gets made

Left alone, AI agents take the shortest path to a plausible answer. That path skips specs, skips tests, skips review, and produces code that works in a demo and breaks in production. devstack makes the long path cheaper than the short path by encoding it as mandatory workflow.

This belief comes from [Superpowers](https://github.com/obra/superpowers). It is non-negotiable in the `flow/` and `core/` layers.

## 2. Standards are how good code stays good

Process discipline without content knowledge produces well-tested mediocre code. devstack's `standards/` layer teaches the agent *what good looks like* for APIs, UIs, security, performance, docs, and deployment — drawing on widely-accepted bodies of practice (OWASP Top 10, Core Web Vitals, Hyrum's Law, trunk-based development, Google's engineering guide).

This belief comes from [agent-skills](https://github.com/addyosmani/agent-skills).

## 3. Process and standards are orthogonal — combine them

The two upstream projects each solved half the problem. Process skills say *when* to do things. Standards skills say *how* to do them well. devstack's thesis is that you need both, and the right abstraction is three stacked layers that don't know about each other:

```
┌─────────────────────────────────────────────────┐
│  flow/      brainstorm → plan → work → review   │  ← workflow spine
├─────────────────────────────────────────────────┤
│  core/      TDD · debug · verify · increment    │  ← always-on disciplines
├─────────────────────────────────────────────────┤
│  standards/ API · security · UI · perf · ship   │  ← domain knowledge
└─────────────────────────────────────────────────┘
```

Swap a layer, the other two keep working. Add iOS skills to `standards/` without touching `flow/`. Rewrite `flow/` without touching `standards/`.

## 4. Small tasks don't deserve ceremony. Big tasks demand it.

- **Small**: fix a typo, rename a variable, adjust a config. The `core/` layer runs automatically (TDD when adding behavior, verification before claiming done). Nothing else fires. No brainstorming, no plan, no formal review.
- **Medium**: a feature touching a few files. The flow starts at `/plan` (skip brainstorm if requirements are already clear).
- **Large**: a new feature, a subsystem, anything spanning modules or teams. Full flow: `/brainstorm` → `/plan` → `/work` → `/review` → `/ship`.

You choose the entry point. The skills don't force a larger-than-needed ceremony, but once inside a phase, they are strict about finishing it properly.

## 5. Evidence beats claims

Every skill ends with a verification gate. "Looks right" doesn't close a task — a passing test, a clean build log, or runtime data does. This applies equally to agent output (they must prove their work) and to devstack itself (every skill has exit criteria you can check).

This belief is shared by both upstream projects.

---

## What this means in practice

- When you type `/brainstorm`, the agent will **not** let you skip to code. Period.
- When you start writing implementation code without a failing test, the TDD skill will delete your code.
- When you claim a feature is done without running verification, the agent asks for evidence and waits.
- When you build an API, the API-design skill will push you to define a contract first and think about error semantics, even if you "just want to prototype."

This is intentional. If you want a permissive agent that tells you what you want to hear, don't use devstack.

---

## Attribution-aware design

Every devstack skill keeps an HTML comment identifying its upstream origin (see [CREDITS.md](../CREDITS.md)). This means:

- When Superpowers or agent-skills update, you can diff their new version against the origin noted in our skill and decide whether to pull the change.
- When you're reading a skill and want more depth, the comment points you to the source repo for further reading.
- When you extend devstack with new skills (e.g., for iOS development), you mark them `[NEW]` or point at a new upstream source, keeping the same tracking discipline.
