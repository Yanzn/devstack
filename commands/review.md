---
description: "Request code review on the current diff — five-axis review plus domain standards (security, performance, API, frontend, etc.)."
---

Invoke `devstack:requesting-code-review` for the request mechanics.

The dispatched reviewer subagent must apply `devstack:code-review-and-quality` for the five-axis criteria (correctness, readability, architecture, security, performance) and pull in any relevant domain standards skill based on what the diff touches:

- User input / auth / secrets → `devstack:security-and-hardening`
- UI / accessibility → `devstack:frontend-ui-engineering`
- DB queries / hot paths → `devstack:performance-optimization`
- API contracts / module boundaries → `devstack:api-and-interface-design`
- Migrations / removing systems → `devstack:deprecation-and-migration`

Report Strengths, Issues (Critical / Important / Minor with file:line), Recommendations, and a clear merge verdict.
