from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import uuid
import datetime

app = FastAPI(title="FounderOS Backend", version="0.1.0")

# --- Request/Response Models ---

class IdeaRequest(BaseModel):
    idea: str

class StartupAnalysis(BaseModel):
    id: str = uuid.uuid4().hex
    startupName: str
    tagline: str = ""
    problem: str
    targetUsers: List[str]
    solution: str
    mvpFeatures: List[str]
    businessModel: str
    validationQuestions: List[str]
    nextStep: str
    laterFeatures: List[str] = []

class AIResponse(BaseModel):
    analysis: StartupAnalysis
    error: str = ""

# --- In-memory "database" ---

analyses_db: dict = {}

# --- API Routes ---

@app.get("/health")
def health():
    return {"status": "ok", "service": "founderos-backend"}

@app.post("/v1/analyze", response_model=AIResponse)
def analyze_idea(request: IdeaRequest):
    """Analyze a startup idea and return structured analysis.
    
    This is the endpoint that the iOS and Android clients call.
    """
    if not request.idea.strip():
        raise HTTPException(status_code=400, detail="Idea cannot be empty")
    
    # Generate a basic AI analysis based on the idea
    idea_lower = request.idea.lower()
    
    # Simple heuristic-based analysis
    startup_name = None
    tagline = ""
    problem = ""
    target_users = []
    solution = ""
    mvp_features = []
    business_model = ""
    validation_questions = []
    next_step = ""
    later_features = []
    
    # Try to extract a startup name
    if "ai" in idea_lower or "artificial intelligence" in idea_lower:
        startup_name = "AI-Powered Idea"
        tagline = "Intelligent solution for modern problems"
        problem = "Automate routine tasks and improve decision-making"
        target_users = ["Business professionals", "Entrepreneurs"]
        solution = "AI platform that analyzes data and provides actionable insights"
        mvp_features = ["Dashboard", "Reporting", "User analytics"]
        business_model = "SaaS subscription"
        validation_questions = ["What data sources do you have?", "How do you measure success?"]
        next_step = "Build MVP prototype"
        later_features = ["Advanced ML models", "Predictive analytics"]
    
    elif "app" in idea_lower or "application" in idea_lower:
        startup_name = "Mobile App Idea"
        tagline = "App that solves a specific problem"
        problem = "Users need a mobile solution for daily tasks"
        target_users = ["Mobile users", "Consumers"]
        solution = "Native or cross-platform mobile application"
        mvp_features = ["User onboarding", "Core functionality", "Push notifications"]
        business_model = "Freemium"
        validation_questions = ["What problem does it solve?", "How will you acquire users?"]
        next_step = "Design UI/UX prototype"
        later_features = ["iOS and Android versions", "Monetization features"]
    
    elif "web" in idea_lower or "website" in idea_lower:
        startup_name = "Web Platform"
        tagline = "Web-based solution for businesses"
        problem = "Companies need an online presence and tools"
        target_users = ["Business owners", "Decision makers"]
        solution = "Full-stack web application"
        mvp_features = ["User authentication", "Dashboard", "API endpoints"]
        business_model = "SaaS subscription"
        validation_questions = ["What's your pricing model?", "Who are your competitors?"]
        next_step = "Set up database and auth"
        later_features = ["Admin panel", "Integration marketplace"]
    
    elif "finance" in idea_lower or "financial" in idea_lower or "budget" in idea_lower:
        startup_name = "Finance Management"
        tagline = "Take control of your finances"
        problem = "People struggle with budgeting and financial tracking"
        target_users = ["Individuals", "Small business owners"]
        solution = "Personal finance management app"
        mvp_features = ["Expense tracking", "Budget planning", "Reports"]
        business_model = "Freemium"
        validation_questions = ["What accounts do you track?", "How often do you review?"]
        next_step = "Set up account linking"
        later_features = ["Investment tracking", "Tax assistance"]
    
    elif "health" in idea_lower or "medical" in idea_lower or "doctor" in idea_lower:
        startup_name = "Health Tech"
        tagline = "Improving healthcare access"
        problem = "Patients face barriers to healthcare services"
        target_users = ["Patients", "Healthcare providers"]
        solution = "Digital health platform"
        mvp_features = ["Appointment scheduling", " symptom tracker", "Provider directory"]
        business_model = "B2B subscription"
        validation_questions = ["HIPAA compliance?", "How do you ensure privacy?"]
        next_step = "Get regulatory clearance"
        later_features = ["Telemedicine", "Wearable integration"]
    
    else:
        # Generic fallback
        startup_name = "Innovative Startup"
        tagline = "Turning ideas into reality"
        problem = "Identify the core problem your idea solves"
        target_users = ["Early adopters", "Visionaries"]
        solution = "Custom solution based on your unique idea"
        mvp_features = ["Core feature", "User feedback loop", "Iterative development"]
        business_model = "Consulting"
        validation_questions = ["What makes this unique?", "Who is your target market?"]
        next_step = "Validate with potential users"
        later_features = ["Scaling", "Product expansion"]
    
    # If we couldn't extract a name, use a hash-based one
    if not startup_name:
        startup_name = f"Startup-{uuid.uuid4().hex[:8]}"
    
    analysis = StartupAnalysis(
        id=uuid.uuid4().hex,
        startupName=startup_name,
        tagline=tagline,
        problem=problem,
        targetUsers=target_users,
        solution=solution,
        mvpFeatures=mvp_features,
        businessModel=business_model,
        validationQuestions=validation_questions,
        nextStep=next_step,
        laterFeatures=later_features
    )
    
    # Store in DB
    analyses_db[analysis.id] = analysis
    
    return AIResponse(analysis=analysis)