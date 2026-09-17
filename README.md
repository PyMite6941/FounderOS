# FounderOS

> Status: **scaffold only.** Stack and product scope are not decided yet — Matt is sending the details.

Repo: https://github.com/PyMite6941/FounderOS

## Layout

```
FounderOS/
├── backend/     # API + data + business logic (one shared backend for both apps)
├── appleUI/     # iOS / iPadOS / macOS client
├── androidUI/   # Android client
├── MEMORY.md    # local scratch memory — gitignored, never committed
└── .gitignore
```

Each folder has its own `README.md` with the open questions for that layer.

## Working agreement

- **One backend, two thin clients.** `appleUI/` and `androidUI/` should not duplicate business
  logic — anything both apps need lives behind the backend API.
- **The API contract is the interface between the three folders.** Once the backend routes are
  settled, write them down in `backend/README.md` first; both UIs build against that.
- **Nothing is chosen yet.** Don't install frameworks or generate project files until the stack
  decisions below are filled in — an early wrong choice is more expensive than an empty folder.

## Decisions still open

| # | Decision | Notes |
|---|---|---|
| 1 | What FounderOS *is* | Product scope / who it's for / the one job it does |
| 2 | Backend language + framework | e.g. FastAPI, Node/Hono, Go |
| 3 | Database + hosting | Neon/Supabase/SQLite; Vercel / Cloud Run / CF Workers |
| 4 | Auth model | Accounts? Clerk/Supabase Auth/custom? Device tokens? |
| 5 | Apple stack | Native SwiftUI vs shared cross-platform layer |
| 6 | Android stack | Native Kotlin/Compose vs shared cross-platform layer |
| 7 | Offline behaviour | Does the app work with no network? Sync strategy? |
| 8 | Monetisation | Free / subscription / licence (GRID Store?) |

## Getting going once the stack is known

1. Fill in the table above, in this file.
2. Write the API contract into `backend/README.md` (routes, payloads, error shape).
3. Scaffold `backend/` and get one real endpoint returning real data.
4. Scaffold whichever UI is the priority and wire it to that endpoint end to end.
5. Only then start the second UI.
