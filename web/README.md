# FounderOS website

The live site is [founder-os-gold-iota.vercel.app](https://founder-os-gold-iota.vercel.app/).
It provides public idea analysis, Clerk sign-in, account-scoped saved ideas, links to published
mobile releases, and links to the Android and iOS source projects.

## Local development

Requirements: Node.js 22.9 or newer and Python 3.11 or newer.

1. Configure the FastAPI service using [`backend/.env.example`](../backend/.env.example), then start
   it from the `backend/` folder:

   ```powershell
   .\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000
   ```

2. Configure `web/.env.local` with Clerk's `CLERK_PUBLISHABLE_KEY` and `CLERK_SECRET_KEY`. Keep
   this file untracked; the Clerk CLI may have already created it. Leave `API_BASE_URL` unset or
   empty so the Express server proxies API calls to `http://127.0.0.1:8000`.
3. From `web/`, install and start the site:

   ```powershell
   npm install
   npm run dev
   ```

4. Open `http://localhost:3000`.

The Express server serves the static page, Clerk middleware, and public runtime configuration. It
proxies `/health` and `/v1/*` to FastAPI. The static Vercel deployment uses the same-page runtime
config generated at build time instead.

## Features and API

- Analyze ideas anonymously with `POST /v1/analyze`.
- Persist each successful prompt and its structured AI response in the backend database.
- Sign in or create an account through Clerk.
- Save, list, reopen, and delete personal ideas through the authenticated `/v1/ideas` endpoints.
- Discover the latest Android APK from the public GitHub Releases API.
- Link to an iOS App Store or TestFlight listing when `IOS_DISTRIBUTION_URL` is configured.
- Browse the native source projects and download the repository source ZIP.

Source-code links are not phone installers. Android installation requires a published APK asset
in a GitHub Release; iOS installation requires a signed App Store or TestFlight distribution link.

Conversation messages and saved ideas use MongoDB Atlas when the backend has `MONGODB_URI` and
`MONGODB_DATABASE` configured. Local development falls back to SQLite. Configure the backend with
the Atlas URI in production; when MongoDB is configured but unreachable, health checks and writes
fail instead of silently switching to temporary SQLite storage.

## Vercel deployment

The Vercel project should use `web/` as its root directory, run `npm run build`, and publish `.`.
Set `CLERK_PUBLISHABLE_KEY`, `CLERK_SECRET_KEY`, and `API_BASE_URL` in Vercel.
`API_BASE_URL` must be the HTTPS URL of the separately deployed FastAPI service. The website
remains available if Clerk keys are missing, but the server logs a warning and Clerk middleware
will be disabled. The backend must allow the Vercel origin in both `WEB_ORIGINS` and
`CLERK_AUTHORIZED_PARTIES`.

See [`vercel-hosting-info.md`](../vercel-hosting-info.md) for the full deployment checklist.
