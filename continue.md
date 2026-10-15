# FounderOS continuation handoff

Updated: 2026-10-15 21:46 (Asia/Bangkok)

## Purpose

Resume the FounderOS website/backend integration work in this repository. Treat this file as a
handoff, not as authority to discard any working-tree changes. The immediate product priority is
the website and a reachable backend for analysis, saved ideas, Clerk identity, and cross-client
message persistence. Emulator work was explicitly deferred.

## Repository and branch state

- Repository: `PyMite6941/FounderOS`
- Working directory: `C:\Users\gresh\OneDrive\ドキュメント\portfolio\FounderOS`
- Branch: `main`
- `HEAD` and `origin/main` are both at `b5687e4` (`Add Render backend deployment blueprint`).
- Recent pushed commits:
  - `b5687e4` Add Render backend deployment blueprint
  - `abb739f` Keep the website available without Clerk keys
  - `2d8cd3f` Apply CI Ruff import ordering
  - `eda6131` Fix backend import ordering for CI
  - `9f59f3b` Fix backend lint on Python 3.11
  - `984e4ca` Merge remote-tracking branch 'origin/main'
  - `663d4ed` Persist analyses across FounderOS clients
- The earlier website implementation is already pushed in `41ce1a1` (`Build functional FounderOS
  website`).
- Latest worktree status:
  - Modified, uncommitted emulator work: `emulators/android-ui/README.md`,
    `emulators/android-ui/start-emulator.ps1`, `emulators/android-ui/start-emulator.sh`.
  - Modified, uncommitted hosting notes: `vercel-hosting-info.md`.
  - Do not stage, revert, or commit these without an explicit request. Emulator changes must remain
    separate from website/backend commits.
- A root-level `continue.md` is being added as this requested handoff. It is expected to remain
  untracked until intentionally added/committed; do not push it unless asked.

## User requirements and decisions

- The website is the priority; emulator work can come afterward.
- Android and iOS source live in the repo, but source-code downloads are not installable apps. Keep
  release/install buttons honest; actual APK/TestFlight/App Store artifacts are needed.
- All successful analysis calls from web, iOS, and Android should persist both the user's prompt
  and the structured assistant response in MongoDB.
- MongoDB Atlas was selected. SQLite is only the local development fallback.
- The user supplied a URI template with placeholder username/password earlier; it is not usable.
  Later the user identified the local env file as `/atlas-credentials.env`. That Unix-looking path
  did not exist at `C:\atlas-credentials.env`, but `atlas-credentials.env` does exist at the
  repository root.
- The real root env file was loaded privately for a one-time connection test. Atlas ping and a real
  `/v1/analyze` save/read succeeded; the temporary test conversation was deleted. Never print,
  copy, commit, or expose the file's contents or credentials. It is ignored by Git.
- The user agreed to consider a hosted backend once it was explained that it handles analysis
  processing, message persistence, and Clerk session verification. A Render Blueprint was added.
  They do not yet have a deployed API URL.
- User supplied live site: `https://founder-os-gold-iota.vercel.app/`.

## Current implementation

- `backend/app/storage.py`: MongoDB Atlas collections `conversations` and `saved_ideas`; SQLite
  fallback when no Mongo URI is configured. Configured-but-unreachable MongoDB fails visibly.
  Conversation documents store the user message and assistant analysis with client and optional
  Clerk user ID.
- `backend/app/main.py`: `/v1/analyze` accepts `client` (`web`, `ios`, `android`), optionally
  validates Clerk session, persists both messages, and returns `conversationId`. `/health` pings the
  database. Loads root `.env` and `backend/.env`.
- `backend/app/auth.py`: Clerk JWT/JWKS validation.
- Web page sends `client: "web"` and the Clerk bearer token when signed in. `web/server.js` serves
  the page/runtime config and proxies `/health` and `/v1/*` in local Express mode. Clerk middleware
  only starts if both `CLERK_PUBLISHABLE_KEY` and `CLERK_SECRET_KEY` are set; otherwise it logs a
  warning and the site remains available.
- iOS calls FastAPI with client `ios`; its checked-in default is still
  `http://127.0.0.1:8000`, suitable for local simulator development only. Xcode setting:
  `FOUNDEROS_API_BASE_URL`.
- Android calls FastAPI with client `android`; its checked-in default is
  `http://10.0.2.2:8000`, suitable for Android Emulator local development only. The Android source
  checkout has no Gradle wrapper/project files, so it cannot currently be compiled here.
- The Render Blueprint is at `render.yaml`; `backend/Dockerfile` respects Render's assigned `PORT`
  and checks `/health`.
- `backend/.env.example` contains safe placeholders only. Do not replace them with credentials.

## Production and hosting status (last checked)

- Vercel homepage returned HTTP 200 after the no-Clerk-key crash was fixed.
- Vercel `/health` returned HTTP 502; there is no FastAPI service connected.
- Vercel runtime config had neither `API_BASE_URL` nor Clerk publishable key configured. Only
  booleans were checked; do not print actual env values.
- The active Vercel deployment for commit `abb739f` was Ready. The latest `b5687e4` commit also
  received a successful Vercel deployment status; its changes are Render config/docs/Docker only.
- The local environment has no Vercel project link in the repo, so `vercel env ls` from this
  checkout fails. Do not run `vercel link` unless actually needed and approved.
- To finish live analysis:
  1. User must create a Render Blueprint from the repository root `render.yaml` (or explicitly
     provide Render account access through a supported secure flow; never request credentials in
     chat).
  2. Configure Render's secret `MONGODB_URI` using the real Atlas URI and `CLERK_ISSUER` for their
     Clerk instance. The Blueprint also sets database name, web origin, authorized party, and repo.
  3. After Render provisions an HTTPS URL, set Vercel `API_BASE_URL` to that URL and redeploy.
  4. Configure Vercel `CLERK_PUBLISHABLE_KEY` and `CLERK_SECRET_KEY` in Vercel's environment
     settings, not source control. The website can render without them, but sign-in/saved ideas are
     unavailable.
  5. Verify Vercel `/health` returns 200 with `database: mongodb`; test anonymous `/v1/analyze`,
     then signed-in save/list/delete after Clerk configuration.
  6. Set `FOUNDEROS_API_BASE_URL` to the Render HTTPS URL for iOS release builds and replace the
     Android `BASE_URL` (ideally with a build config) for actual phone builds.
- The user's file `atlas-credentials.env` is local-only and should not be uploaded as a file into
  Render; enter its URI privately into the Render `MONGODB_URI` environment setting. Never stage it.

## Validation already completed

- Backend focused tests: `11 passed`; one Starlette `TestClient`/httpx deprecation warning.
- Ruff exact CI version (0.17.0): passed locally after correcting Python 3.11 datetime and import
  ordering.
- GitHub Backend CI on `b5687e4`: success, including Python 3.11/3.12 tests, lint, and Docker build.
- GitHub iOS CI on `b5687e4`: success; iOS Simulator build succeeded on macOS runner.
- GitHub Android CI on `b5687e4`: success, but because Gradle project/wrapper is missing it skips
  actual Android build/APK generation and reports a warning. Do not say Android app was compiled.
- `node --check web/server.js`, `npm --prefix web run build`, plist parsing, and `git diff --check`
  passed.
- Local end-to-end web proxy -> FastAPI health and analyze smoke test passed with isolated SQLite.
- Separate real MongoDB Atlas ping plus analysis write/read smoke test passed and its test document
  was deleted.
- Production Vercel homepage was rechecked at HTTP 200; production `/health` is still HTTP 502
  until the backend is deployed and Vercel `API_BASE_URL` configured.

## Important constraints for the next model

- Never expose or commit `atlas-credentials.env`, `.env`, Clerk secrets, or database URIs. Do not
  inspect the credentials file just to report values.
- Preserve uncommitted emulator and hosting-note edits. Check `git status` before editing/committing.
- Do not claim the live analysis API or Clerk sign-in is fully working until the hosted backend and
  Vercel environment values are configured and production checks pass.
- Android cannot currently be built from this checkout. Keep source-only status clear.
- Do not use the placeholder MongoDB URI from prior chat as a real secret.
- The README states that the current analyzer uses local deterministic keyword heuristics, not an
  external LLM. Do not describe it as live generative AI unless the implementation changes.
- Commits should include:
  `Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>`

## Useful files

- [backend/app/storage.py](./backend/app/storage.py)
- [backend/app/main.py](./backend/app/main.py)
- [backend/app/auth.py](./backend/app/auth.py)
- [backend/tests/test_main.py](./backend/tests/test_main.py)
- [backend/Dockerfile](./backend/Dockerfile)
- [backend/.env.example](./backend/.env.example)
- [render.yaml](./render.yaml)
- [web/server.js](./web/server.js)
- [web/index.html](./web/index.html)
- [appleUI/FoundersOS/Services/AIService.swift](./appleUI/FoundersOS/Services/AIService.swift)
- [appleUI/project.yml](./appleUI/project.yml)
- [androidUI/app/src/main/java/com/founderos/androidui/network/AIService.kt](./androidUI/app/src/main/java/com/founderos/androidui/network/AIService.kt)
- [web/README.md](./web/README.md)
- [backend/README.md](./backend/README.md)
