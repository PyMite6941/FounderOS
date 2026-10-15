import logging
import os
import uuid
from pathlib import Path
from typing import Literal
from urllib.parse import urlparse

import httpx
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from app import storage
from app.auth import get_current_user_id, get_optional_current_user_id


repository_root = Path(__file__).resolve().parents[2]
load_dotenv(repository_root / ".env", override=False)
load_dotenv(repository_root / "backend" / ".env", override=False)
logger = logging.getLogger(__name__)
app = FastAPI(title="FounderOS Backend", version="0.2.0")

default_origins = [
    "https://founder-os-gold-iota.vercel.app",
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
allowed_origins = [
    origin.strip().rstrip("/")
    for origin in os.environ.get("WEB_ORIGINS", ",".join(default_origins)).split(",")
    if origin.strip()
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type"],
)


class IdeaRequest(BaseModel):
    idea: str = Field(max_length=4000)
    client: Literal["web", "ios", "android"] = "web"


class StartupAnalysis(BaseModel):
    id: str = Field(default_factory=lambda: uuid.uuid4().hex)
    startupName: str
    tagline: str = ""
    problem: str
    targetUsers: list[str]
    solution: str
    mvpFeatures: list[str]
    businessModel: str
    validationQuestions: list[str]
    nextStep: str
    laterFeatures: list[str] = Field(default_factory=list)


class AIResponse(BaseModel):
    analysis: StartupAnalysis
    error: str = ""
    conversationId: str


class SaveIdeaRequest(BaseModel):
    idea: str = Field(max_length=4000)


def analyze_idea_text(idea: str) -> StartupAnalysis:
    idea_lower = idea.lower()

    if "ai" in idea_lower or "artificial intelligence" in idea_lower:
        values = {
            "startupName": "AI-Powered Idea",
            "tagline": "Intelligent solution for modern problems",
            "problem": "Automate routine tasks and improve decision-making",
            "targetUsers": ["Business professionals", "Entrepreneurs"],
            "solution": "AI platform that analyzes data and provides actionable insights",
            "mvpFeatures": ["Dashboard", "Reporting", "User analytics"],
            "businessModel": "SaaS subscription",
            "validationQuestions": ["What data sources do you have?", "How do you measure success?"],
            "nextStep": "Build MVP prototype",
            "laterFeatures": ["Advanced ML models", "Predictive analytics"],
        }
    elif "app" in idea_lower or "application" in idea_lower:
        values = {
            "startupName": "Mobile App Idea",
            "tagline": "App that solves a specific problem",
            "problem": "Users need a mobile solution for daily tasks",
            "targetUsers": ["Mobile users", "Consumers"],
            "solution": "Native or cross-platform mobile application",
            "mvpFeatures": ["User onboarding", "Core functionality", "Push notifications"],
            "businessModel": "Freemium",
            "validationQuestions": ["What problem does it solve?", "How will you acquire users?"],
            "nextStep": "Design UI/UX prototype",
            "laterFeatures": ["iOS and Android versions", "Monetization features"],
        }
    elif "web" in idea_lower or "website" in idea_lower:
        values = {
            "startupName": "Web Platform",
            "tagline": "Web-based solution for businesses",
            "problem": "Companies need an online presence and tools",
            "targetUsers": ["Business owners", "Decision makers"],
            "solution": "Full-stack web application",
            "mvpFeatures": ["User authentication", "Dashboard", "API endpoints"],
            "businessModel": "SaaS subscription",
            "validationQuestions": ["What's your pricing model?", "Who are your competitors?"],
            "nextStep": "Set up database and auth",
            "laterFeatures": ["Admin panel", "Integration marketplace"],
        }
    elif "finance" in idea_lower or "financial" in idea_lower or "budget" in idea_lower:
        values = {
            "startupName": "Finance Management",
            "tagline": "Take control of your finances",
            "problem": "People struggle with budgeting and financial tracking",
            "targetUsers": ["Individuals", "Small business owners"],
            "solution": "Personal finance management app",
            "mvpFeatures": ["Expense tracking", "Budget planning", "Reports"],
            "businessModel": "Freemium",
            "validationQuestions": ["What accounts do you track?", "How often do you review?"],
            "nextStep": "Set up account linking",
            "laterFeatures": ["Investment tracking", "Tax assistance"],
        }
    elif "health" in idea_lower or "medical" in idea_lower or "doctor" in idea_lower:
        values = {
            "startupName": "Health Tech",
            "tagline": "Improving healthcare access",
            "problem": "Patients face barriers to healthcare services",
            "targetUsers": ["Patients", "Healthcare providers"],
            "solution": "Digital health platform",
            "mvpFeatures": ["Appointment scheduling", "symptom tracker", "Provider directory"],
            "businessModel": "B2B subscription",
            "validationQuestions": ["HIPAA compliance?", "How do you ensure privacy?"],
            "nextStep": "Get regulatory clearance",
            "laterFeatures": ["Telemedicine", "Wearable integration"],
        }
    else:
        values = {
            "startupName": "Innovative Startup",
            "tagline": "Turning ideas into reality",
            "problem": "Identify the core problem your idea solves",
            "targetUsers": ["Early adopters", "Visionaries"],
            "solution": "Custom solution based on your unique idea",
            "mvpFeatures": ["Core feature", "User feedback loop", "Iterative development"],
            "businessModel": "Consulting",
            "validationQuestions": ["What makes this unique?", "Who is your target market?"],
            "nextStep": "Validate with potential users",
            "laterFeatures": ["Scaling", "Product expansion"],
        }

    return StartupAnalysis(**values)


def _github_repository() -> str:
    repository = os.environ.get("GITHUB_REPOSITORY", "PyMite6941/FounderOS").strip("/")
    if len(repository.split("/")) != 2:
        raise HTTPException(status_code=500, detail="GITHUB_REPOSITORY must use owner/repository format")
    return repository


def _latest_android_release() -> dict:
    repository = _github_repository()
    release_page = f"https://github.com/{repository}/releases/latest"
    api_url = f"https://api.github.com/repos/{repository}/releases/latest"
    try:
        response = httpx.get(
            api_url,
            headers={
                "Accept": "application/vnd.github+json",
                "User-Agent": "FounderOS",
                "X-GitHub-Api-Version": "2022-11-28",
            },
            timeout=5,
        )
    except httpx.RequestError as exc:
        logger.exception("Could not reach GitHub Releases")
        raise HTTPException(status_code=502, detail="Could not retrieve Android release information") from exc

    if response.status_code == 404:
        return {
            "available": False,
            "version": None,
            "downloadUrl": None,
            "releaseUrl": release_page,
            "fileName": None,
        }
    try:
        response.raise_for_status()
        release = response.json()
    except (httpx.HTTPStatusError, ValueError) as exc:
        logger.exception("GitHub Releases returned an invalid response")
        raise HTTPException(status_code=502, detail="Could not retrieve Android release information") from exc

    apk = next(
        (
            asset
            for asset in release.get("assets", [])
            if isinstance(asset.get("name"), str) and asset["name"].lower().endswith(".apk")
        ),
        None,
    )
    return {
        "available": apk is not None,
        "version": release.get("tag_name"),
        "downloadUrl": apk.get("browser_download_url") if apk else None,
        "releaseUrl": release.get("html_url", release_page),
        "fileName": apk.get("name") if apk else None,
    }


def _ios_release() -> dict:
    distribution_url = os.environ.get("IOS_DISTRIBUTION_URL", "").strip()
    if distribution_url:
        parsed_url = urlparse(distribution_url)
        if parsed_url.scheme != "https" or not parsed_url.netloc:
            raise HTTPException(status_code=500, detail="IOS_DISTRIBUTION_URL must be a valid HTTPS URL")

    channel = os.environ.get("IOS_DISTRIBUTION_CHANNEL", "TestFlight").strip()
    return {
        "available": bool(distribution_url),
        "version": os.environ.get("IOS_APP_VERSION"),
        "downloadUrl": distribution_url or None,
        "channel": channel,
    }


@app.get("/health")
def health():
    storage.check_database()
    return {
        "status": "ok",
        "service": "founderos-backend",
        "database": storage.database_backend(),
    }


@app.get("/v1/apps/releases")
def app_releases():
    return {
        "android": _latest_android_release(),
        "ios": _ios_release(),
    }


@app.get("/v1/auth/me")
def current_user(user_id: str = Depends(get_current_user_id)):
    return {"userId": user_id}


@app.post("/v1/analyze", response_model=AIResponse)
def analyze_idea(
    request: IdeaRequest,
    user_id: str | None = Depends(get_optional_current_user_id),
):
    idea = request.idea.strip()
    if not idea:
        raise HTTPException(status_code=400, detail="Idea cannot be empty")
    analysis = analyze_idea_text(idea)
    conversation_id = storage.save_analysis_messages(
        user_id,
        request.client,
        idea,
        analysis.model_dump(mode="json"),
    )
    return AIResponse(analysis=analysis, conversationId=conversation_id)


@app.post("/v1/ideas", status_code=201)
def save_idea(request: SaveIdeaRequest, user_id: str = Depends(get_current_user_id)):
    idea = request.idea.strip()
    if not idea:
        raise HTTPException(status_code=400, detail="Idea cannot be empty")
    analysis = analyze_idea_text(idea).model_dump(mode="json")
    return storage.save_idea(user_id, idea, analysis)


@app.get("/v1/ideas")
def saved_ideas(user_id: str = Depends(get_current_user_id)):
    return {"ideas": storage.list_ideas(user_id)}


@app.delete("/v1/ideas/{idea_id}", status_code=204)
def remove_saved_idea(idea_id: str, user_id: str = Depends(get_current_user_id)):
    if not storage.delete_idea(user_id, idea_id):
        raise HTTPException(status_code=404, detail="Saved idea not found")
