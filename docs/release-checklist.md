# Release Checklist

## Scope

This checklist is for promoting the app to a production-like environment without demo seed data.

## Pre-release

1. Confirm required environment variables are set:
   `DATABASE_URL`, `APP_TIME_ZONE`, and optionally `PORT`.
2. Run quality gates:
   `npm run lint`
   `npm run test:coverage`
   `npm run test:integration`
   `npm run build`
3. Review database state and make sure production does not contain duplicate `question_categories.name` values before applying schema changes.

## Database

1. Apply schema only:
   `npm run db:migrate`
2. Do not run `npm run db:seed` in production.
   `db:seed` is only for local demo environments or disposable staging databases.

## Deploy

1. Build the container image:
   `docker build -t interview-review-web:release .`
2. Run the app:
   `docker run --rm -p 3000:3000 --env-file .env.local interview-review-web:release`

## Smoke Checks

1. Open `/login`.
2. Open `/api/v1/health` and confirm it returns `status: ok`.
3. Log in with a non-admin user and verify:
   `/app/today`
   `/app/reports`
4. Log in with an admin user and verify:
   `/admin/categories`
   `/admin/questions`

## Rollback Notes

1. Roll back the application image first if the problem is app-only.
2. Treat schema changes separately and use your database backup or migration rollback process if data changes must be reverted.
