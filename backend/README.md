# backend

The single source of truth for FounderOS data and logic. Both `appleUI/` and `androidUI/` are
clients of this — no business logic gets duplicated into either app.

## Status

Empty. Stack not chosen (see the decisions table in the root `README.md`).

## What goes here once the stack lands

- API routes + request/response schemas
- Persistence layer (models, migrations)
- Auth / session handling
- Any scheduled or background work
- Tests

## API contract

Write the contract here *before* either UI is built, so both clients target the same shape.

```
METHOD /path
  auth:     <required? how?>
  request:  { ... }
  response: { ... }
  errors:   { code, message }
```

_(nothing defined yet)_

## Open questions

- Language/framework?
- Database and where it's hosted?
- Auth: accounts, or device-scoped tokens?
- Deploy target, and does it need to be free-tier?
