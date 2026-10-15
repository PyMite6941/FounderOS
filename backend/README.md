# backend

The single source of truth for FounderOS data and logic. Both `appleUI/` and `androidUI/` are
clients of this — no business logic gets duplicated into either app.

## Local setup

Requires Python 3.11 or newer. The installer creates a local `.venv` and installs the API
and test dependencies; it does not change the iOS or Android projects.

Windows PowerShell:

```powershell
cd backend
.\install.ps1
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000
```

macOS/Linux:

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

Copy `.env.example` to `.env` and configure Clerk before using account endpoints. Set `MONGODB_URI`
and `MONGODB_DATABASE` for MongoDB Atlas. When no MongoDB URI is set, local development uses SQLite
at `backend/data/founderos.sqlite3`; `DATABASE_PATH` can override that local path. The Dockerfile
remains an alternative containerized run path.

If your Atlas connection string is in the ignored repository-root `atlas-credentials.env`, add
`--env-file ..\atlas-credentials.env` to the Uvicorn command on Windows or
`--env-file ../atlas-credentials.env` on macOS/Linux. Never commit that file.

The current analyzer uses local keyword-based heuristics; it does not call an external AI service.

## Production deployment

The root [`render.yaml`](../render.yaml) defines a Render Blueprint for the FastAPI service. In
Render, create a Blueprint from this repository and provide the requested `MONGODB_URI` and
`CLERK_ISSUER` environment values. The service builds `backend/Dockerfile`, binds to Render's
`PORT`, and uses `/health` as its health check.

After Render assigns the service an HTTPS URL, set that URL as `API_BASE_URL` in the Vercel project
and redeploy the website. If the public website domain changes, update `WEB_ORIGINS` and
`CLERK_AUTHORIZED_PARTIES` on the backend service as well.

## What goes here

- API routes + request/response schemas
- MongoDB persistence for conversation messages and saved ideas, with SQLite for local development
- Clerk session-token verification for account endpoints
- Mobile app release metadata from GitHub Releases and an App Store/TestFlight URL
- Scheduled or background work
- Tests

## API contract

```yaml
METHOD /path
  auth:     <required? how?>
  request:  { ... }
  response: { ... }
  errors:   { code, message }
```

### Defined routes

| Method | Path        | Auth | Request          | Response                                      | Description                     |
| ------ | ----------- | ---- | ---------------- | --------------------------------------------- | ------------------------------- |
| GET    | /health                   | none          | —                | `{status, service, database}`                       | Database-backed health check |
| POST   | /v1/analyze               | optional Clerk | `{idea, client?}` | `{analysis, conversationId}`                       | Analyze and persist user + assistant messages |
| GET    | /v1/apps/releases         | none          | —                | `{android, ios}`                                    | Published mobile build links |
| GET    | /v1/auth/me               | Clerk session | Bearer token     | `{userId}`                                          | Verify the current Clerk user |
| POST   | /v1/ideas                 | Clerk session | `{idea: string}` | `{id, idea, analysis, createdAt}`                   | Analyze and save an idea |
| GET    | /v1/ideas                 | Clerk session | Bearer token     | `{ideas: [...]}`                                    | List the signed-in user's saved ideas |
| DELETE | /v1/ideas/{idea_id}       | Clerk session | Bearer token     | `204 No Content`                                    | Delete one of the signed-in user's ideas |

### Configuration

`CLERK_ISSUER` is the issuer shown in a Clerk session token. `CLERK_JWKS_URL` is optional; when
omitted, the backend loads keys from `{CLERK_ISSUER}/.well-known/jwks.json`. The backend verifies
the token signature, issuer, expiry, and (when present) the authorized-party origin. Never put a
Clerk secret key in the web client.

`WEB_ORIGINS` and `CLERK_AUTHORIZED_PARTIES` default to the production website
(`https://founder-os-gold-iota.vercel.app`) plus local development origins. Set them explicitly
when using a different domain.

`GITHUB_REPOSITORY` selects the public GitHub repository whose latest release is checked for an
APK (defaults to `PyMite6941/FounderOS`). The iOS card is enabled only when
`IOS_DISTRIBUTION_URL` is set to an HTTPS App Store or TestFlight link. iOS apps must be
distributed through Apple's signing and distribution flow; the site cannot install an arbitrary
IPA directly.

The website also links to the Android and iOS source directories and a repository ZIP. These
source downloads are not installable phone apps.

Set `MONGODB_URI` and `MONGODB_DATABASE` for production. The backend uses the `conversations` and
`saved_ideas` collections in that database. If `MONGODB_URI` is unset, SQLite is used for local
development. MongoDB health is checked by `/health`; a configured but unreachable MongoDB instance
causes the health check and database writes to fail rather than silently switching databases.

Every successful `/v1/analyze` call stores the trimmed user prompt and structured assistant
analysis as two message entries in the `conversations` collection. Both entries share a
conversation ID and record the client (`web`, `ios`, or `android`); valid Clerk sessions are
associated with the Clerk user ID. Requests without a session are still persisted with a null user
ID. Message content is not written to application logs. Local SQLite stores the same entries as
rows in `conversation_messages`.

### StartupAnalysis schema

| Field               | Type          | Description                       |
| ------------------- | ------------- | --------------------------------- |
| id                  | string (UUID) | Unique analysis ID                |
| startupName         | string        | Generated startup name            |
| tagline             | string        | Short tagline                     |
| problem             | string        | The problem being solved          |
| targetUsers         | [string]      | Target user description           |
| solution            | string        | The proposed solution             |
| mvpFeatures         | [string]      | MVP features (3-5 items)          |
| businessModel       | string        | Proposed business model           |
| validationQuestions | [string]      | Validation interview questions    |
| nextStep            | string        | Recommended next step             |
| laterFeatures       | [string]      | Features to build later (not MVP) |

### Example request

```json
POST /v1/analyze
{
  "idea": "An AI-powered app that helps people find study partners",
  "client": "web"
}
```

### Example response

```json
{
	"analysis": {
		"id": "abc123def456",
		"startupName": "AI-Powered Idea",
		"tagline": "Intelligent solution for modern problems",
		"problem": "Automate routine tasks and improve decision-making",
		"targetUsers": ["Business professionals", "Entrepreneurs"],
		"solution": "AI platform that analyzes data and provides actionable insights",
		"mvpFeatures": ["Dashboard", "Reporting", "User analytics"],
		"businessModel": "SaaS subscription",
		"validationQuestions": [
			"What data sources do you have?",
			"How do you measure success?"
		],
		"nextStep": "Build MVP prototype",
		"laterFeatures": ["Advanced ML models", "Predictive analytics"]
	},
	"conversationId": "abc123def456"
}
```

## Open questions

- Language/framework? → FastAPI (Python) selected
- Web account provider? → Clerk
- Local persistence? → SQLite for development; MongoDB Atlas for production
- Android distribution? → APK asset on a GitHub Release
- iOS distribution? → App Store or TestFlight URL configured by the release owner
- Backend hosting? → Still needs to be selected; Vercel hosts the static website
