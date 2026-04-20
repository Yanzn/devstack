# devstack

**An opinionated development stack for AI coding agents.** Process discipline from brainstorm to ship, fused with production-grade engineering standards. Built to work across web frontends, Python/Django, Java/Spring — and extensible to iOS, Android, and anything else you build next.

> [中文版 README](README_zh-CN.md)

---

## What this is

devstack packages a complete, working methodology for getting AI coding agents to build software the way senior engineers build software:

1. **Think before you code** — refine rough ideas into a written spec, get approval.
2. **Plan in bite-sized tasks** — every step has exact files, exact code, exact verification.
3. **Execute with discipline** — fresh subagent per task, two-stage review, TDD always.
4. **Review against standards** — five-axis code review, security, performance, a11y.
5. **Ship with confidence** — pre-launch checklists, feature flags, rollback plans.

It's organized into three layers:

| Layer | What it does | When it fires |
|-------|---|---|
| **flow/** | The workflow spine: brainstorm → plan → work → review → ship | Triggered by `/devstack`, `/brainstorm`, `/plan`, `/work`, `/review`, `/ship` |
| **core/** | Cross-cutting disciplines: TDD, systematic debugging, verification | Auto-triggered during implementation work |
| **standards/** | Domain knowledge: API design, security, frontend, performance, docs, git, CI/CD, shipping | Auto-triggered when working in that domain, or explicitly during `/review` / `/ship` |

Read **[docs/philosophy.md](docs/philosophy.md)** for the design principles.

---

## Origin

devstack is a remix. Three open-source projects contributed raw material:

- **[Superpowers](https://github.com/obra/superpowers)** by Jesse Vincent — gave us the workflow spine, subagent orchestration, git worktree patterns, and the opinionated "process as enforcement" voice.
- **[agent-skills](https://github.com/addyosmani/agent-skills)** by Addy Osmani — gave us the engineering-standards content: Hyrum's Law API design, OWASP-based hardening, Core Web Vitals performance, ADRs, trunk-based git, CI/CD, shipping checklists, and the phase taxonomy.
- **[andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)** by Forrest Chang (distilling [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls) — gave us four sharp behavioral principles, three of which were grafted into existing skills: push-back dissent (`core/context-engineering`), surgical-change orphan rule (`core/incremental-implementation`), and instruction→goal framing (`flow/writing-plans`).

devstack is not a loader or a bundler. It is a **new, independent project** built on their ideas. Every skill has been reviewed, merged where overlapping, and adapted to a single coherent voice and namespace.

See **[CREDITS.md](CREDITS.md)** for the per-skill provenance table and **[docs/origins.md](docs/origins.md)** for upgrade-tracking notes.

All three upstream projects are MIT-licensed. devstack is also MIT-licensed.

---

## Quick Start

Install as a Claude Code plugin:

```bash
/plugin marketplace add Yanzn/devstack
/plugin install devstack@devstack
```

Then in any session:

```bash
/devstack         # introduction to the three layers
/brainstorm       # start a new feature — refine idea into spec
/plan             # turn spec into bite-sized task list
/work             # execute the plan with subagent-driven development
/review           # five-axis code review before merge
/ship             # pre-launch checklist and deploy
```

For day-to-day small fixes, you don't need any slash command — the `core/` layer (TDD, debugging, verification) fires automatically.

---

## Extending

Adding a new technology stack (iOS, Android, Rust, Go, …) means adding **`standards/`** skills without touching `flow/` or `core/`. See **[docs/extending.md](docs/extending.md)**.

---

## Status

**v0.2.0 — Full skill set delivered** (29 `SKILL.md`, 6 slash commands, 3 agents, 4 reference checklists) plus the karpathy-skills behavioral graft. See [CHANGELOG.md](CHANGELOG.md).

---

## License

MIT. See [LICENSE](LICENSE).
