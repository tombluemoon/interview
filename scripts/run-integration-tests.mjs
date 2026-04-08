import { spawnSync } from "node:child_process";

import { buildTestEnv, ensureTestDatabaseReady } from "./test-db.mjs";

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    stdio: options.capture ? "pipe" : "inherit",
    encoding: "utf8",
    env: options.env ?? process.env,
  });

  if (result.error) {
    throw result.error;
  }

  if (result.status !== 0 && !options.allowFailure) {
    throw new Error(result.stderr || `${command} ${args.join(" ")} failed.`);
  }

  return result;
}

function runVitest() {
  return run(
    process.execPath,
    ["./node_modules/vitest/vitest.mjs", "run", "--config", "vitest.integration.config.ts"],
    {
      env: buildTestEnv(),
      allowFailure: true,
    },
  );
}

try {
  await ensureTestDatabaseReady({
    label: "integration test",
  });
  const result = runVitest();

  process.exit(result.status ?? 1);
} catch (error) {
  console.error("Integration test run failed.");
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
}
