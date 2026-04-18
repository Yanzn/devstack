# Getting Started

> [中文版](getting-started_zh-CN.md)

## Install

### Claude Code (local, during development)

Point Claude Code at your local clone:

```bash
claude --plugin-dir /Users/max/Projects/prompt/devstack
```

Or, once you've pushed to a git host and set up a marketplace:

```bash
/plugin marketplace add <your-org>/devstack
/plugin install devstack@devstack
```

### Other agents

Because every skill is a plain Markdown file with YAML frontmatter, devstack works anywhere skills can be loaded:

- **Cursor** — copy `skills/**/SKILL.md` into `.cursor/rules/`
- **Gemini CLI** — `gemini skills install /path/to/devstack/skills`
- **OpenCode / Codex / Copilot** — see upstream setup guides in [Superpowers docs](https://github.com/obra/superpowers/tree/main/docs) and [agent-skills docs](https://github.com/addyosmani/agent-skills/tree/main/docs); the same patterns apply to devstack.

## Your First Session

After install, in any project:

```bash
/devstack
```

This loads `using-devstack`, which introduces the three-layer model, the slash commands, and when each fires.

## Day-to-day Workflow

### Small fix (1 file, <10 min of work)

Just describe the fix. `core/` skills (TDD, debugging, verification) fire automatically. No ceremony.

### Medium change (a few files, clear requirements)

Start with `/plan`. Skip `/brainstorm` if the spec is already obvious. The plan becomes bite-sized tasks. Then `/work` to execute.

### Large change (new feature, new subsystem, architectural)

Full flow:

```bash
/brainstorm   # refine idea into spec, get approval, save to docs/devstack/specs/
/plan         # turn spec into plan with exact tasks, save to docs/devstack/plans/
/work         # subagent-driven execution with two-stage review per task
/review       # five-axis review across the diff before merge
/ship         # pre-launch checklist + merge or PR
```

Every step has a HARD-GATE — you can't skip ahead until the current phase is validated.

## When Things Go Wrong

- **Agent skipped a step.** Tell it explicitly which skill to invoke — it will reset to that phase.
- **A skill seems wrong for your task.** Tell the agent; the skill system allows opting out with a stated reason.
- **Upstream update you want to pull.** Read [docs/origins.md](origins.md) for per-skill provenance, diff the upstream change, decide.

## Next

- [docs/philosophy.md](philosophy.md) — the five beliefs devstack is built on
- [docs/extending.md](extending.md) — how to add iOS / Android / Rust / Go skills
- [CREDITS.md](../CREDITS.md) — what came from where
