import { clerkMiddleware } from "@clerk/express";
import express from "express";
import path from "node:path";
import { fileURLToPath } from "node:url";

const app = express();
const port = Number(process.env.PORT || 3000);
const webDirectory = path.dirname(fileURLToPath(import.meta.url));
const backendUrl = process.env.BACKEND_URL || "http://127.0.0.1:8000";

if (process.env.CLERK_PUBLISHABLE_KEY?.trim() && process.env.CLERK_SECRET_KEY?.trim()) {
  app.use(clerkMiddleware());
} else {
  console.warn("Clerk middleware is disabled until both Clerk keys are configured.");
}
app.use(express.json({ limit: "1mb" }));

app.get("/config.js", (_request, response) => {
  response
    .set("Cache-Control", "no-store")
    .type("application/javascript")
    .send(
      `window.FOUNDEROS_CONFIG = Object.freeze(${JSON.stringify({
        apiBase: process.env.API_BASE_URL || "",
        clerkPublishableKey: process.env.CLERK_PUBLISHABLE_KEY || "",
      })});`,
    );
});

app.use(["/health", "/v1"], async (request, response) => {
  try {
    const upstreamUrl = new URL(request.originalUrl, backendUrl);
    const headers = new Headers();
    for (const name of ["authorization", "content-type", "accept"]) {
      const value = request.get(name);
      if (value) headers.set(name, value);
    }

    const hasBody = request.method !== "GET" && request.method !== "HEAD";
    const upstream = await fetch(upstreamUrl, {
      method: request.method,
      headers,
      body: hasBody ? JSON.stringify(request.body ?? {}) : undefined,
    });
    const body = Buffer.from(await upstream.arrayBuffer());
    response.status(upstream.status);
    const contentType = upstream.headers.get("content-type");
    if (contentType) response.set("Content-Type", contentType);
    response.send(body);
  } catch (error) {
    console.error("Backend proxy request failed:", error);
    response.status(502).json({ detail: "The FounderOS backend could not be reached." });
  }
});

app.use(
  express.static(webDirectory, {
    index: false,
    setHeaders: (response, filePath) => {
      if (/\.(css|js|png|svg|json)$/i.test(filePath) && !filePath.endsWith("config.js")) {
        response.setHeader("Cache-Control", "public, max-age=31536000, immutable");
      }
    },
  }),
);

app.get("/", (_request, response) => {
  response.sendFile(path.join(webDirectory, "index.html"));
});

app.use((request, response) => {
  if (request.path.startsWith("/v1/") || request.path === "/health") {
    response.status(404).json({ detail: "API route not found." });
    return;
  }
  response.status(404).send("Not found");
});

if (!process.env.VERCEL) {
  app.listen(port, () => {
    console.log(`FounderOS website running at http://localhost:${port}`);
    console.log(`Proxying backend API to ${backendUrl}`);
  });
}

export default app;
