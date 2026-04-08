import Link from "next/link";
import { redirect } from "next/navigation";

import { loginAction } from "@/app/actions";
import { TopNav } from "@/components/layout/TopNav";
import { Card } from "@/components/ui/Card";
import { getSession } from "@/lib/auth";
import { getPostAuthRedirectPath } from "@/modules/auth/auth.helpers";

interface LoginPageProps {
  searchParams: Promise<{
    error?: string;
    logged_out?: string;
    password_changed?: string;
    next?: string;
  }>;
}

function getLoginBanner(params: {
  error?: string;
  logged_out?: string;
  password_changed?: string;
}) {
  if (params.password_changed === "1") {
    return "Password updated. Please log in again.";
  }

  if (params.logged_out === "1") {
    return "You have been logged out.";
  }

  switch (params.error) {
    case "invalid_credentials":
      return "Invalid email or password.";
    case "auth_unavailable":
      return "Authentication requires a configured database connection.";
    case "login_failed":
      return "Login failed. Please try again.";
    default:
      return null;
  }
}

export default async function LoginPage({ searchParams }: LoginPageProps) {
  const params = await searchParams;
  const session = await getSession();

  if (session) {
    redirect(getPostAuthRedirectPath(session.role, params.next));
  }

  const banner = getLoginBanner(params);

  return (
    <>
      <TopNav />
      <main className="page-shell page-stack">
        {banner ? <div className="demo-banner">{banner}</div> : null}
        <div className="grid-two">
          <Card title="Log In" eyebrow="Simple V1 auth screen">
            <form action={loginAction} className="form-grid">
              <input type="hidden" name="nextPath" value={params.next ?? ""} />
              <label className="field-full">
                Email
                <input
                  type="email"
                  name="email"
                  placeholder="user@example.com"
                  defaultValue="alex@example.com"
                />
              </label>
              <label className="field-full">
                Password
                <input
                  type="password"
                  name="password"
                  placeholder="Enter your password"
                  defaultValue="demo1234"
                />
              </label>
              <div className="field-full">
                <button type="submit" className="button-primary">
                  Log In
                </button>
              </div>
            </form>
            <p className="muted-copy">
              No account yet?{" "}
              <Link
                href={`/signup${
                  params.next ? `?next=${encodeURIComponent(params.next)}` : ""
                }`}
              >
                Create one here.
              </Link>
            </p>
          </Card>
          <Card title="Seeded local accounts" eyebrow="Ready after db:init">
            <ul className="plain-list">
              <li>User: `alex@example.com` / `demo1234`</li>
              <li>Admin: `admin@example.com` / `admin1234`</li>
              <li>New sign-ups create a separate PostgreSQL-backed account.</li>
            </ul>
          </Card>
        </div>
      </main>
    </>
  );
}
