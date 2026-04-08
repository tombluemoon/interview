import { spawn, spawnSync } from "node:child_process";

export const TEST_DB = {
  containerName: "interview-review-postgres-test",
  database: "interview_review_test",
  user: "interview",
  password: "interview",
  host: "127.0.0.1",
  port: "55432",
  image: "postgres:16-alpine",
};

export const testDatabaseUrl = `postgresql://${TEST_DB.user}:${TEST_DB.password}@${TEST_DB.host}:${TEST_DB.port}/${TEST_DB.database}`;

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

function inspectContainer() {
  return run(
    "docker",
    [
      "container",
      "inspect",
      TEST_DB.containerName,
      "--format",
      "{{.State.Status}}|{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}",
    ],
    { capture: true, allowFailure: true },
  );
}

function sleep(milliseconds) {
  return new Promise((resolve) => {
    setTimeout(resolve, milliseconds);
  });
}

function ensureDockerAvailable() {
  run("docker", ["version", "--format", "{{.Server.Version}}"], {
    capture: true,
  });
}

function createContainer() {
  console.log("Starting PostgreSQL test container...");
  run("docker", [
    "run",
    "-d",
    "--name",
    TEST_DB.containerName,
    "-e",
    `POSTGRES_DB=${TEST_DB.database}`,
    "-e",
    `POSTGRES_USER=${TEST_DB.user}`,
    "-e",
    `POSTGRES_PASSWORD=${TEST_DB.password}`,
    "-p",
    `${TEST_DB.port}:5432`,
    "--health-cmd",
    `pg_isready -U ${TEST_DB.user} -d ${TEST_DB.database}`,
    "--health-interval",
    "1s",
    "--health-timeout",
    "5s",
    "--health-retries",
    "30",
    TEST_DB.image,
  ]);
}

function startContainer() {
  console.log("Starting existing PostgreSQL test container...");
  run("docker", ["start", TEST_DB.containerName]);
}

async function ensureContainerRunning() {
  const inspection = inspectContainer();

  if (inspection.status !== 0) {
    createContainer();
    return;
  }

  const [status] = inspection.stdout.trim().split("|");

  if (status !== "running") {
    startContainer();
  } else {
    console.log("Reusing running PostgreSQL test container.");
  }
}

async function waitForHealthy() {
  for (let attempt = 0; attempt < 30; attempt += 1) {
    const inspection = inspectContainer();

    if (inspection.status === 0) {
      const [, health] = inspection.stdout.trim().split("|");

      if (health === "healthy" || health === "none") {
        return;
      }
    }

    await sleep(1000);
  }

  throw new Error("PostgreSQL test container did not become healthy in time.");
}

export function buildTestEnv(overrides = {}) {
  const env = {
    ...process.env,
    DATABASE_URL: testDatabaseUrl,
    INTEGRATION_DATABASE_URL: testDatabaseUrl,
    E2E_DATABASE_URL: testDatabaseUrl,
    ...overrides,
  };

  delete env.NO_COLOR;

  return env;
}

export async function ensureTestDatabaseReady(options = {}) {
  ensureDockerAvailable();
  await ensureContainerRunning();
  await waitForHealthy();
  console.log(`Preparing ${options.label ?? "test"} database...`);
  run(process.execPath, ["./scripts/db-init.mjs"], {
    env: buildTestEnv(),
  });
}

export function spawnWithTestEnv(command, args, overrides = {}) {
  return spawn(command, args, {
    stdio: "inherit",
    env: buildTestEnv(overrides),
  });
}
