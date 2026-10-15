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

Copy `.env.example` to `.env` and configure Clerk before using account endpoints. The local
database defaults to `backend/data/founderos.sqlite3`; set `DATABASE_PATH` to a persistent
volume path on the backend host. The Dockerfile remains an alternative containerized run path.

The current analyzer uses local keyword-based heuristics; it does not call an external AI service.

## What goes here

- API routes + request/response schemas
- SQLite persistence for saved ideas
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
| GET    | /health                   | none          | —                | `{status, service}`                                 | Health check |
| POST   | /v1/analyze               | none          | `{idea: string}` | `{analysis: StartupAnalysis, error?: string}`       | Analyze an idea without saving it |
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

SQLite needs persistent disk storage in production. Set `DATABASE_PATH` to a mounted persistent
volume; do not use an ephemeral serverless filesystem for saved ideas.

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
  "idea": "An AI-powered app that helps people find study partners"
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
	}
}
```

## Open questions

- Language/framework? → FastAPI (Python) selected
- Web account provider? → Clerk
- Local persistence? → SQLite; production requires a persistent volume
- Android distribution? → APK asset on a GitHub Release
- iOS distribution? → App Store or TestFlight URL configured by the release owner
- Backend hosting? → Still needs to be selected; Vercel hosts the static website
