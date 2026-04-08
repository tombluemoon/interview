# VPS and Cloudflare Deployment

This guide covers one production layout with two internet-facing options:

- VPS + Caddy for a direct HTTPS deployment
- VPS + Cloudflare Tunnel for a private-origin deployment without opening inbound HTTP or HTTPS ports

## Recommended Topology

- `db`: PostgreSQL 16 with a persistent Docker volume
- `app`: Next.js production server
- `migrate`: one-shot schema migration job
- `caddy`: optional TLS reverse proxy for direct VPS exposure
- `cloudflared`: optional Cloudflare Tunnel connector

The `app` container binds to `127.0.0.1` by default so it is not exposed publicly unless you intentionally place `caddy` or Cloudflare in front of it.

## Files

- `docker-compose.prod.yml`
- `.env.prod.example`
- `ops/Caddyfile`

## 1. Prepare Environment Variables

```bash
cp .env.prod.example .env.prod
```

Set these values before the first deploy:

- `POSTGRES_PASSWORD`
- `DATABASE_URL`
- `APP_DOMAIN`
- `LETSENCRYPT_EMAIL`

If your database password contains special characters, URL-encode that password inside `DATABASE_URL`.

## 2. Build the Release Image

```bash
docker build -t interview-review-web:release .
```

## 3. Run the Database Migration

Run schema-only migration before starting the long-running services:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml run --rm migrate
```

Do not run `db:seed` in production.

## 4A. Direct VPS Deployment with HTTPS

Use this when you want the VPS to accept public traffic directly.

1. Point `APP_DOMAIN` to the VPS public IP.
2. Open inbound ports `80` and `443` in the VPS firewall.
3. Start the app stack plus the `caddy` profile:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml --profile vps-proxy up -d
```

4. Verify:

```bash
curl "https://${APP_DOMAIN}/api/v1/health"
```

`caddy` terminates HTTPS and forwards requests to `app:3000`.
This HTTPS layer is required because the app uses secure auth cookies in production.

## 4B. Cloudflare Deployment on Top of the VPS

Use this when you want Cloudflare to publish the site while the origin stays private.

1. Add the domain to Cloudflare and move DNS to Cloudflare nameservers.
2. In Cloudflare Zero Trust, create a Tunnel using the Docker connector flow.
3. Copy the generated tunnel token into `.env.prod` as `CLOUDFLARE_TUNNEL_TOKEN`.
4. In the tunnel dashboard, create a public hostname for your app and point it to:

```text
http://app:3000
```

5. Start the app stack with the Cloudflare profile:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml --profile cloudflare up -d
```

6. Verify from the public hostname and from the VPS locally:

```bash
curl http://127.0.0.1:${APP_PORT:-3000}/api/v1/health
```

With this layout you normally only need SSH open on the VPS. The web traffic reaches the site through the tunnel connector.
The `cloudflare` profile requires a non-empty `CLOUDFLARE_TUNNEL_TOKEN`.

## 5. Operations Commands

Show status:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml ps
```

Tail logs:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml logs -f app
docker compose --env-file .env.prod -f docker-compose.prod.yml logs -f caddy
docker compose --env-file .env.prod -f docker-compose.prod.yml logs -f cloudflared
```

Restart only the application:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml up -d --no-deps app
```

## 6. Smoke Test Checklist

- `/api/v1/health` returns `status: ok`
- `/login` loads successfully over HTTPS
- a normal user can log in and open `/app/today`
- an admin can log in and open `/admin/questions`

## 7. Rollback

1. Roll back the app image tag in `.env.prod` if you are versioning images externally.
2. Redeploy only the app-facing services:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml up -d --no-deps app caddy
```

If you use Cloudflare Tunnel instead of `caddy`, redeploy `app` and `cloudflared`.
