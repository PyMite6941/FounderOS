# FounderOS website deployment

The production website is [https://founder-os-gold-iota.vercel.app/](https://founder-os-gold-iota.vercel.app/).
Vercel hosts the static site; the FastAPI backend runs as a separate service.

## Vercel project settings

Configure the Vercel project to use this repository and set:

| Setting | Value |
| --- | --- |
| Root Directory | `web` |
| Framework Preset | Other |
| Build Command | `npm run build` |
| Output Directory | `.` |

Set these Vercel environment variables for Production and Preview as appropriate:

| Variable | Value |
| --- | --- |
| `CLERK_PUBLISHABLE_KEY` | Clerk publishable key for the selected Clerk application |
| `API_BASE_URL` | HTTPS base URL of the deployed FastAPI backend, with no trailing slash |

`npm run build` writes a public `config.js` containing only the API base URL and Clerk publishable
key. Do not add `CLERK_SECRET_KEY` to the static website's Vercel environment. The Express
development server uses the Clerk secret key from its local `.env.local` file.

## Backend deployment

Deploy `backend/` as a separate Python 3.11+ service using the Dockerfile or the setup instructions
in [`backend/README.md`](./backend/README.md). Configure:

- `CLERK_ISSUER` from the selected Clerk instance; the backend derives its JWKS URL from this.
- `DATABASE_PATH` on a mounted persistent volume. Saved ideas are stored in SQLite and will be
  lost if the host's filesystem is ephemeral.
- `WEB_ORIGINS` and `CLERK_AUTHORIZED_PARTIES` to include
  `https://founder-os-gold-iota.vercel.app`.
- `GITHUB_REPOSITORY=PyMite6941/FounderOS` for APK release discovery.
- `IOS_DISTRIBUTION_URL` once an App Store or TestFlight listing exists.

The Android download is enabled only when the latest public GitHub Release contains an `.apk`
asset. iOS installation is linked through Apple's App Store or TestFlight; a website cannot
install a normally signed iOS app directly.

The website also links to both native source projects and a repository ZIP. Those links provide
source code only and do not install the apps on a phone.

## Local development

1. In `backend/`, copy `.env.example` to `.env`, set `CLERK_ISSUER`, then install and start the API:

   ```powershell
   .\install.ps1
   .\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000
   ```

2. In `web/`, preserve the Clerk CLI-generated `.env.local`. Set `CLERK_PUBLISHABLE_KEY` and
   `CLERK_SECRET_KEY` there. Leave `API_BASE_URL` empty to use the local Express proxy:

   ```powershell
   npm install
   npm run dev
   ```

3. Open `http://localhost:3000`. The Express development server proxies `/health` and `/v1/*` to
   the FastAPI server on port 8000.

Run backend tests from `backend/` with `.venv\Scripts\python.exe -m pytest`.
