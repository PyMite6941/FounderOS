import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

def test_analyze_idea():
    response = client.post("/v1/analyze", json={"idea": "An AI-powered app that helps people find study partners"})
    assert response.status_code == 200
    data = response.json()
    assert data["analysis"] is not None
    analysis = data["analysis"]
    assert analysis["startupName"] is not None
    assert analysis["problem"] is not None
    assert analysis["solution"] is not None

def test_analyze_empty_idea():
    response = client.post("/v1/analyze", json={"idea": ""})
    assert response.status_code == 400

def test_analyze_idea_with_app():
    response = client.post("/v1/analyze", json={"idea": "A mobile app for tracking fitness goals"})
    assert response.status_code == 200
    data = response.json()
    assert data["analysis"] is not None