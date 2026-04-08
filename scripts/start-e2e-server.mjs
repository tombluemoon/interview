import { spawnSync } from "node:child_process";

import {
  buildTestEnv,
  ensureTestDatabaseReady,
  spawnWithTestEnv,
} from "./test-db.mjs";

const port = process.env.PORT ?? "3001";

function run(command, args, env) {
  const result = spawnSync(command, args, {
    stdio: "inherit",
    env,
  });

  if (result.error) {
    throw result.error;
  }

  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed.`);
  }
}

try {
  await ensureTestDatabaseReady({
    label: "e2e test",
  });

  const serverEnv = buildTestEnv({
    PORT: port,
  });

  console.log("Building Next.js app for E2E...");
  run(process.execPath, ["./node_modules/next/dist/bin/next", "build"], serverEnv);

  const child = spawnWithTestEnv(
    process.execPath,
    [
      "./node_modules/next/dist/bin/next",
      "start",
      "--hostname",
      "127.0.0.1",
      "--port",
      port,
    ],
    serverEnv,
  );

  const forwardSignal = (signal) => {
    if (!child.killed) {
      child.kill(signal);
    }
  };

  process.on("SIGINT", () => {
    forwardSignal("SIGINT");
  });
  process.on("SIGTERM", () => {
    forwardSignal("SIGTERM");
  });

  child.on("exit", (code) => {
    process.exit(code ?? 0);
  });
} catch (error) {
  console.error("E2E server failed to start.");
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
}
