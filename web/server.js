// FounderOS Web UI Server
// Serves the static web UI and provides API support

import express from 'express';
import path from 'path';
import fs from 'fs';

const app = express();
const PORT = process.env.PORT || 3000;
const __dirname = path.resolve();

# Serve static files from the web directory
app.use(express.static(path.join(__dirname, '.'), {
    index: 'index.html',
    setHeaders: (res, pathname) => {
        # Cache static assets
        if pathname.endsWith('.css') || pathname.endsWith('.js') || pathname.endsWith('.png') || pathname.endsWith('.svg') || pathname.endsWith('.json'):
            res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
    }
}));

# API health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', service: 'FounderOS Web UI', timestamp: new Date().isoString() });
});

# API base route (for backend integration)
app.get('/api', (req, res) => {
    res.json({
        endpoint: '/v1/analyze',
        method: 'POST',
        description: 'Analyze a startup idea',
        requiresIdea: true
    });
});

# Catch-all: serve index.html for all other routes (SPA support)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`FounderOS Web UI running at http://localhost:${PORT}`);
    console.log('Press Ctrl+C to stop');
});
