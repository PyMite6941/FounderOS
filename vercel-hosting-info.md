# Vercel Hosting — FounderOS Web UI

The FounderOS web UI can be deployed to Vercel in under 5 minutes. This guide covers the complete setup.

## 🚀 One-Click Deploy

[![Deploy to Vercel](https://vercel.com/button)](https://vercel.com/import/template)

## Manual Deployment Steps

### 1. Prepare the Repository

Ensure your repo structure looks like this:

```
FounderOS/
├── backend/          # FastAPI backend (separate deployment)
├── appleUI/          # iOS client
├── androidUI/        # Android client
├── web/              # <-- Web UI (this folder)
│   └── index.html    # Static web UI
├── .gitignore
├── LICENSE
└── CONTRIBUTING.md
```

### 2. Vercel Dashboard Setup

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click "New Project" → "Import Repository"
3. Select the `FounderOS` repository
4. Vercel will auto-detect it's a static site

### 3. Configuration — Two Deployment Options

**Option A: Static HTML (Easiest)**
Vercel will auto-configure these settings:

| Setting | Value |
|---------|-------|
| **Framework** | None (Static HTML) |
| **Build Command** | `npm run build` (or leave blank) |
| **Publish Directory** | `web` |
| **Root Directory** | `/home/pymite6941/services/local_storage/FounderOS` |

**Option B: Node.js + Express** 
If you want the web UI to serve dynamically and have a backend API:

| Setting | Value |
|---------|-------|
| **Framework** | Node.js (Express) |
| **Build Command** | `npm run build && npm run start` |
| **Publish Directory** | `web` |
| **Root Directory** | `/home/pymite6941/services/local_storage/FounderOS` |

### 4. Environment Variables (Optional)

If you want the web UI to connect to a backend:

| Variable | Description | Default |
|----------|-------------|---------|
| `API_BASE` | Backend API URL | `http://127.0.0.1:8787` (local) or empty (production) |

The web UI already handles this dynamically:
- `window.location.hostname === 'localhost'` → uses `http://127.0.0.1:8787`
- Otherwise → uses relative path (works with Vercel deployments)

### 5. Custom Domain (Optional)

1. In Vercel project → Settings → Domains
2. Add your domain (e.g., `founderos.io`)
3. Vercel will provide DNS configuration

## 📡 Backend Integration

The web UI connects to the backend at `POST /v1/analyze`. For Vercel deployment:

### Option A: Separate Backend on Vercel

1. Deploy the `backend/` FastAPI folder to Vercel as a separate project
2. Note the Vercel URL (e.g., `https://founderos-backend.vercel.app`)
3. Add environment variable in the Web UI project:
   - `API_BASE=https://founderos-backend.vercel.app`

### Option B: Backend on Render/Docker

1. Deploy backend elsewhere (Render, Railway, Docker, etc.)
2. Set `API_BASE` to your backend URL
3. The web UI will automatically use it

### Example API Base Configuration

The web UI reads the API base at runtime:

```javascript
const API_BASE = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
  ? 'http://127.0.0.1:8787'  // Local development
  : '';  // Production - relative path (Vercel)
```

For Vercel-to-Vercel backend connection, set `API_BASE` in Vercel project settings.

## 🛠️ Development Workflow

### Local Development

```bash
# Start the web UI (open index.html in browser)
open web/index.html

# Or serve locally
cd FounderOS/web
npx serve .  # or: python3 -m http.web
```

### Testing Backend Connection

The UI auto-checks backend availability on load:

```javascript
checkAPI().then(available => {
  if (!available) {
    showError('Backend API not running. Please start the backend server at http://127.0.0.1:8787');
  }
});
```

### Download Features

Android/iOS download popups work immediately — they show setup information
and simulate download flows. No backend required for the download UI itself.

## 📦 Build & Deploy Checklist

- [ ] Repository pushed to GitHub/GitLab
- [ ] Vercel project created, importing `FounderOS`
- [ ] Publish directory set to `web`
- [ ] (Optional) `API_BASE` environment variable set for backend connection
- [ ] Custom domain configured (if desired)
- [ ] Test deployment: `vercel deploy` or visit the Vercel URL

## 🐛 Known Limitations

- Web UI is static HTML — no server-side processing
- Backend must be running separately for idea analysis
- Android APK download is simulated (shows setup info; real APK needs native build)
- iOS App details show App Store/TestFlight info (actual app requires Apple Developer account)

## ✅ Quick Test After Deploy

Visit your Vercel URL and verify:

1. ✓ Page loads without errors
2. ✓ "Analyze Idea" form works (shows error if backend not running on localhost)
3. ✓ "Mobile Apps" section displays Android and iOS cards
4. ✓ Download buttons show setup popups
5. ✓ Light/dark mode toggle works

---

**Last updated:** 2026-10-15

For issues, see: https://github.com/PyMite6941/FounderOS/issues