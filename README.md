# Interview Review Web

A simple full-stack interview preparation app built with Next.js App Router and PostgreSQL.

The product supports three main flows:

- Anonymous users can browse the public question bank.
- Logged-in users can manage daily study tasks, review progress, reports, and profile settings.
- Admin users can manage categories and question content.

## Stack

- Next.js 16
- React 19
- PostgreSQL
- `postgres` for SQL access
- Vitest for unit tests
- Docker-backed PostgreSQL integration tests
- Playwright browser E2E tests

## Local Setup

1. Create a PostgreSQL database.
2. Copy the environment file:

```bash
cp .env.example .env.local
```

3. Update `DATABASE_URL` in `.env.local` if needed. `APP_TIME_ZONE` controls the daily plan and reporting boundary and defaults to `Asia/Tokyo`.
4. Initialize the schema and seed data:

```bash
npm install
npm run db:init
```

5. Start the app:

```bash
npm run dev
```

The app runs at [http://localhost:3000](http://localhost:3000).

## Docker Example

If you want a quick local database with Docker Desktop:

```bash
docker run --name interview-review-postgres \
  -e POSTGRES_DB=interview_review \
  -e POSTGRES_USER=interview \
  -e POSTGRES_PASSWORD=interview \
  -p 5432:5432 \
  -d postgres:16-alpine
```

Then keep `.env.local` as:

```bash
DATABASE_URL=postgresql://interview:interview@localhost:5432/interview_review
APP_TIME_ZONE=Asia/Tokyo
PORT=3000
```

## Seeded Accounts

After `npm run db:init`, these accounts are available:

- User: `alex@example.com` / `demo1234`
- Admin: `admin@example.com` / `admin1234`

## Main Features

### Public

- Browse published interview questions
- Filter by category
- Search by title and tags
- Read detailed question pages with related questions

### Authenticated User

- Sign up, log in, and log out
- Add questions to today’s plan
- Create, edit, complete, reopen, delete, and carry over tasks
- View plan history and overdue tasks
- Track question progress
- View filtered reports
- Update profile details, preferred tracks, and password

### Admin

- Create, edit, and delete categories
- Prevent category deletion when questions still belong to it
- Create, edit, publish, draft, archive, and fetch questions
- Manage content through both UI and API routes

## API Overview

### Public API

- `GET /api/v1/public/categories`
- `GET /api/v1/public/questions`
- `GET /api/v1/public/questions/[questionId]`

### Auth API

- `POST /api/v1/auth/signup`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/logout`

### User API

- `GET /api/v1/me`
- `PUT /api/v1/me`
- `PUT /api/v1/me/password`
- `GET /api/v1/me/daily-plans/[date]`
- `GET/POST /api/v1/me/tasks`
- `PUT/DELETE /api/v1/me/tasks/[taskId]`
- `POST /api/v1/me/tasks/[taskId]/complete`
- `POST /api/v1/me/tasks/[taskId]/reopen`
- `POST /api/v1/me/tasks/[taskId]/carry-over`
- `PUT /api/v1/me/question-progress/[questionId]`
- `GET /api/v1/me/reports/overview`

### Admin API

- `GET/POST /api/v1/admin/categories`
- `GET/PUT/DELETE /api/v1/admin/categories/[categoryId]`
- `GET/POST /api/v1/admin/questions`
- `GET/PUT /api/v1/admin/questions/[questionId]`

## Scripts

```bash
npm run dev
npm run build
npm run lint
npm run db:migrate
npm run db:seed
npm run db:init
npm run test:run
npm run test:integration
npm run test:e2e
```

## Production Release

Use these commands for a production-style release:

1. Install dependencies and validate the release candidate:

```bash
npm ci
npm run lint
npm run test:coverage
npm run test:integration
npm run build
```

2. Apply schema changes without demo data:

```bash
npm run db:migrate
```

3. Start the application:

```bash
npm run start
```

4. Verify the health endpoint:

```bash
curl http://localhost:3000/api/v1/health
```

Do not run `npm run db:seed` in production. It is intended only for local demo environments or disposable staging databases.

## Docker Release

Build and run the production image:

```bash
docker build -t interview-review-web:release .
docker run --rm -p 3000:3000 --env-file .env.local interview-review-web:release
```

The container exposes a health endpoint at `/api/v1/health`.

## Production Compose

For a production-style multi-container deployment, use:

- [`docker-compose.prod.yml`](docker-compose.prod.yml)
- [`.env.prod.example`](.env.prod.example)
- [`docs/deployment-vps-cloudflare.md`](docs/deployment-vps-cloudflare.md)

The recommended path is:

1. Build the release image:

```bash
docker build -t interview-review-web:release .
```

2. Copy and fill the production environment file:

```bash
cp .env.prod.example .env.prod
```

3. Apply schema changes:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml run --rm migrate
```

4. Start either:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml --profile vps-proxy up -d
```

or:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml --profile cloudflare up -d
```

The `vps-proxy` profile uses Caddy for HTTPS termination. The `cloudflare` profile keeps the app private and publishes it through Cloudflare Tunnel.

## Release Checklist

See [`docs/release-checklist.md`](docs/release-checklist.md) for the pre-release and smoke-test checklist.

## Verification

The project is currently validated with:

- `npm run lint`
- `npm run test:run`
- `npm run test:integration`
- `npm run test:e2e`
- `npm run build`
- GitHub Actions workflow: [`.github/workflows/ci.yml`](.github/workflows/ci.yml)

Recent smoke tests also covered:

- profile update and password change
- admin category create/delete and delete protection
- admin question API create/update/get

## Integration Tests

Run the integration suite with:

```bash
npm run test:integration
```

This command will:

- start or reuse a dedicated Docker container named `interview-review-postgres-test`
- reset a separate PostgreSQL database on `localhost:55432`
- apply `db/schema.sql` and `db/seed.sql`
- run the route and service integration tests against the real database

## Browser E2E Tests

Run the browser suite with:

```bash
npm run test:e2e
```

This command will:

- reuse the dedicated Docker test database on `localhost:55432`
- reset schema and seed data before the app boots
- start a dedicated Next.js test server on `127.0.0.1:3001`
- run Playwright browser flows for the highest-value user and admin pages

## CI

GitHub Actions is configured in [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

The workflow runs three jobs on every push, pull request, and manual dispatch:

- `quality`: lint, unit coverage, and production build
- `integration`: PostgreSQL-backed route and service integration tests
- `e2e`: Playwright browser tests with failure artifact upload
