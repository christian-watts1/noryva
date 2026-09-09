import { build } from "esbuild";
import { mkdir } from "node:fs/promises";
import { execFileSync } from "node:child_process";
await mkdir("dist", { recursive: true });
await build({
  entryPoints: ["src/app/lambda.ts"],
  outfile: "dist/index.cjs",
  bundle: true,
  platform: "node",
  target: "node24",
  format: "cjs",
  sourcemap: false,
  legalComments: "none",
});
execFileSync("zip", ["-j", "-q", "dist/lambda.zip", "dist/index.cjs"], {
  stdio: "inherit",
});
