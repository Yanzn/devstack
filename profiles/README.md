# Profiles

Stack-specific manifests. Each profile declares which devstack `standards/`, `core/`, `flow/` skills a given stack should activate, plus stack-focused review areas.

## Available profiles

| Profile | Stack | Reference |
|---------|-------|-----------|
| [django](./django.json) | Django + DRF + pytest | geyoto |
| [spring](./spring.json) | Spring Boot + Gradle 多模块 + MQTT | photovoltaic-upgrade |
| [vue](./vue.json) | Vue CLI + pnpm | energy-web |

## Schema

```jsonc
{
  "name": "<profile-id>",
  "description": "...",
  "stack": { "language": "...", "framework": "...", ... },
  "standards": {
    "enabled":  ["api-and-interface-design", ...],
    "disabled": ["frontend-ui-engineering", ...]
  },
  "core": ["test-driven-development", ...],
  "flow": ["writing-plans", ...],
  "focus_areas": ["Django ORM N+1 ...", ...]
}
```

- `standards.enabled` — skill 目录名，路径 `skills/standards/<name>/SKILL.md`。
- `standards.disabled` — 显式关闭，用来告诉 agent 该栈无需加载这些。
- `focus_areas` — 栈专属的 review 关注点，供 `/review`、`code-reviewer` agent 读取。

## 使用

在项目 `CLAUDE.md` 里声明：

```markdown
# DevStack Profile
profile: django
```

agent 启动时读取对应 JSON，加载声明的 skills，把 `focus_areas` 注入 review 上下文。

## 扩展

新栈直接加 `<name>.json`，不改任何 core 逻辑。命名：全小写、连字符、与社区惯例一致（`nextjs`、`rails`、`fastapi`）。
