import { writeFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";

const outputPath = fileURLToPath(new URL("./config.js", import.meta.url));
const config = {
  apiBase: process.env.API_BASE_URL || "",
  clerkPublishableKey: process.env.CLERK_PUBLISHABLE_KEY || "",
};
const serializedConfig = JSON.stringify(config).replaceAll("<", "\\u003c");

await writeFile(
  outputPath,
  `window.FOUNDEROS_CONFIG = Object.freeze(${serializedConfig});\n`,
  "utf8",
);
console.log("Wrote the public website runtime configuration.");
