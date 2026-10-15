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

The current analyzer uses local keyword-based heuristics; it does not call an external AI
service. The Dockerfile remains an alternative containerized install and run path.

## What goes here

- API routes + request/response schemas
- Persistence layer (models, migrations) — currently in-memory, swap in Neon/Supabase/SQLite as needed
- Auth / session handling — device-scoped tokens via JWT
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
| GET    | /health     | none | —                | `{status, service}`                           | Health check                    |
| POST   | /v1/analyze | none | `{idea: string}` | `{analysis: StartupAnalysis, error?: string}` | Analyze a startup idea using AI |

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
- Database and where it's hosted? → Neon (PostgreSQL) or SQLite for local dev
- Auth: accounts, or device-scoped tokens? → JWT device tokens
- Deploy target, and does it need to be free-tier? → Docker + Railway/Render free tier
