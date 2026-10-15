import sys
from pathlib import Path

import httpx
import pytest
from fastapi.testclient import TestClient

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app import main
from app.auth import get_current_user_id
from app.main import app


@pytest.fixture
def client(tmp_path, monkeypatch):
    monkeypatch.setenv("DATABASE_PATH", str(tmp_path / "founderos.sqlite3"))
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_analyze_idea(client):
    response = client.post(
        "/v1/analyze",
        json={"idea": "An AI-powered app that helps people find study partners"},
    )
    assert response.status_code == 200
    analysis = response.json()["analysis"]
    assert analysis["startupName"] == "AI-Powered Idea"
    assert analysis["problem"]
    assert analysis["solution"]
    assert analysis["id"]


def test_analyze_empty_idea(client):
    response = client.post("/v1/analyze", json={"idea": "  "})
    assert response.status_code == 400


def test_analyze_idea_with_app(client):
    response = client.post("/v1/analyze", json={"idea": "A mobile app for tracking fitness goals"})
    assert response.status_code == 200
    assert response.json()["analysis"]["startupName"] == "Mobile App Idea"


def test_saved_ideas_require_clerk_session(client):
    response = client.get("/v1/ideas")
    assert response.status_code == 401


def test_auth_reports_missing_clerk_configuration(client, monkeypatch):
    monkeypatch.delenv("CLERK_ISSUER", raising=False)
    monkeypatch.delenv("CLERK_JWKS_URL", raising=False)
    response = client.get("/v1/auth/me", headers={"Authorization": "Bearer test-token"})
    assert response.status_code == 503
    assert response.json()["detail"] == "Clerk authentication is not configured"


def test_saved_ideas_are_persistent_and_user_scoped(client):
    app.dependency_overrides[get_current_user_id] = lambda: "user_first"
    saved_response = client.post("/v1/ideas", json={"idea": "Help small businesses plan their budget"})
    assert saved_response.status_code == 201
    saved = saved_response.json()
    assert saved["idea"] == "Help small businesses plan their budget"
    assert saved["analysis"]["startupName"] == "Finance Management"

    listed = client.get("/v1/ideas")
    assert [idea["id"] for idea in listed.json()["ideas"]] == [saved["id"]]

    app.dependency_overrides[get_current_user_id] = lambda: "user_second"
    assert client.get("/v1/ideas").json()["ideas"] == []
    assert client.delete(f"/v1/ideas/{saved['id']}").status_code == 404

    app.dependency_overrides[get_current_user_id] = lambda: "user_first"
    assert client.delete(f"/v1/ideas/{saved['id']}").status_code == 204
    assert client.get("/v1/ideas").json()["ideas"] == []


def test_release_catalog_uses_latest_github_apk(client, monkeypatch):
    github_release = {
        "tag_name": "v1.2.3",
        "html_url": "https://github.com/PyMite6941/FounderOS/releases/tag/v1.2.3",
        "assets": [
            {
                "name": "founderos-release.apk",
                "browser_download_url": "https://github.com/PyMite6941/FounderOS/releases/download/v1.2.3/founderos-release.apk",
            }
        ],
    }

    def fake_github_get(*args, **kwargs):
        return httpx.Response(
            200,
            json=github_release,
            request=httpx.Request("GET", "https://api.github.com/repos/PyMite6941/FounderOS/releases/latest"),
        )

    monkeypatch.setattr(main.httpx, "get", fake_github_get)
    monkeypatch.setenv("IOS_DISTRIBUTION_URL", "https://testflight.apple.com/join/example")
    monkeypatch.setenv("IOS_APP_VERSION", "1.2.3")
    monkeypatch.setenv("IOS_DISTRIBUTION_CHANNEL", "TestFlight")

    response = client.get("/v1/apps/releases")
    assert response.status_code == 200
    catalog = response.json()
    assert catalog["android"]["available"] is True
    assert catalog["android"]["version"] == "v1.2.3"
    assert catalog["android"]["downloadUrl"] == github_release["assets"][0]["browser_download_url"]
    assert catalog["ios"]["available"] is True
    assert catalog["ios"]["version"] == "1.2.3"


def test_vercel_origin_is_allowed(client):
    response = client.options(
        "/v1/ideas",
        headers={
            "Origin": "https://founder-os-gold-iota.vercel.app",
            "Access-Control-Request-Method": "GET",
            "Access-Control-Request-Headers": "authorization",
        },
    )
    assert response.status_code == 200
    assert response.headers["access-control-allow-origin"] == "https://founder-os-gold-iota.vercel.app"
