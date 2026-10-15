# FounderOS website
The live site is [founder-os-gold-iota.vercel.app](https://founder-os-gold-iota.vercel.app/).
It provides public idea analysis, Clerk sign-in, account-scoped saved ideas, links to published
mobile releases, and links to the Android and iOS source projects.

## Local development
Requirements: Node.js 22.9 or newer and Python 3.11 or newer.

### 1. Configure the FastAPI service
Using [`backend/.env.example`](../backend/.env.example), then start it from the `backend/` folder:

```powershell
cd backend
.\install.ps1
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000
```

or macOS/Linux:
```sh
cd backend
sh install.sh
.venv/bin/python -m uvicorn app.main:app --reload --port 8000
```

The API is available at `http://localhost:8000`; interactive API docs are at
`http://localhost:8000/docs`. Run the backend tests with:
```sh
.venv/bin/python -m pytest
```

On Windows, use `.venv\Scripts\python.exe -m pytest` instead.

### 2. Configure environment files
- Copy `.env.example` to `.env.local` and set `CLERK_PUBLISHABLE_KEY` and `CLERK_SECRET_KEY`
- Keep `.env.local` untracked (it's covered by `.gitignore`)
- Leave `API_BASE_URL` empty in `.env.local` so the Express server proxies API calls to `http://127.0.0.1:8000`
- **Note**: `web/config.js` is tracked in `.gitignore` — do not put real Clerk keys in it, as the
  current `config.js` has an empty `apiBase` that will be overwritten at build time from env vars

### 3. Install and start the site
From `web/`:
```powershell
npm install
npm run dev
```

Open `http://localhost:3000`.

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

Conversation messages and saved ideas use the backend's configured database. The Render Blueprint
sets `STORAGE_BACKEND=sqlite` to avoid the MongoDB Atlas TLS failure reported for this deployment.
Render's free filesystem is ephemeral, so SQLite records may be lost on restart or redeploy; use
persistent storage if records must survive those events.

## Vercel deployment
The Vercel project should use `web/` as its root directory, run `npm run build`, and publish `.`.
Set `CLERK_PUBLISHABLE_KEY`, `CLERK_SECRET_KEY`, and `API_BASE_URL` in Vercel.

 [`render.yaml`](../render.yaml) defines a Render Blueprint for the FastAPI backend; after creating
it, set `API_BASE_URL` to the Render service's HTTPS URL and redeploy the website. The website
remains available if Clerk keys are missing, but the server logs a warning and Clerk middleware
will be disabled. The backend must allow the Vercel origin in both `WEB_ORIGINS` and
`CLERK_AUTHORIZED_PARTIES`.

See [`vercel-hosting-info.md`](../vercel-hosting-info.md) for the full deployment checklist.

## Known Issues
- `web/package.json` engines `node >=22.9.0` — may not match your installed Node version; scripts
  will still work with newer Node if `npm` is available
- `web/config.js` has empty `apiBase` until `API_BASE_URL` is set in the deployment environment
- `web/config.js` is tracked in `.gitignore` — do not commit real Clerk publishable keys
- Backend `IOS_DISTRIBUTION_URL` must be set to a valid HTTPS URL for iOS release card to show
- Android release card requires a GitHub Release with an `.apk` asset