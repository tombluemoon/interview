import Link from "next/link";
import { redirect } from "next/navigation";

import { signupAction } from "@/app/actions";
import { TopNav } from "@/components/layout/TopNav";
import { Card } from "@/components/ui/Card";
import { getSession } from "@/lib/auth";
import { getPostAuthRedirectPath } from "@/modules/auth/auth.helpers";

interface SignupPageProps {
  searchParams: Promise<{
    error?: string;
    next?: string;
  }>;
}

function getSignupBanner(params: { error?: string }) {
  switch (params.error) {
    case "email_taken":
      return "An account with this email already exists.";
    case "auth_unavailable":
      return "Authentication requires a configured database connection.";
    case "signup_failed":
      return "Signup failed. Please try again.";
    default:
      return null;
  }
}

export default async function SignupPage({ searchParams }: SignupPageProps) {
  const params = await searchParams;
  const session = await getSession();

  if (session) {
    redirect(getPostAuthRedirectPath(session.role, params.next));
  }

  const banner = getSignupBanner(params);

  return (
    <>
      <TopNav />
      <main className="page-shell page-stack">
        {banner ? <div className="demo-banner">{banner}</div> : null}
        <div className="grid-two">
          <Card title="Create Account" eyebrow="Low-friction onboarding">
            <form action={signupAction} className="form-grid">
              <input type="hidden" name="nextPath" value={params.next ?? ""} />
              <label className="field-full">
                Display Name
                <input type="text" name="displayName" placeholder="Alex Zhang" />
              </label>
              <label className="field-full">
                Email
                <input type="email" name="email" placeholder="user@example.com" />
              </label>
              <label className="field">
                Password
                <input
                  type="password"
                  name="password"
                  placeholder="Create a password"
                />
              </label>
              <label className="field">
                Confirm Password
                <input
                  type="password"
                  name="confirmPassword"
                  placeholder="Repeat the password"
                />
              </label>
              <div className="field-full">
                <button type="submit" className="button-primary">
                  Create Account
                </button>
              </div>
            </form>
            <p className="muted-copy">
              Already registered?{" "}
              <Link
                href={`/login${
                  params.next ? `?next=${encodeURIComponent(params.next)}` : ""
                }`}
              >
                Log in.
              </Link>
            </p>
          </Card>
          <Card title="Version 1 scope" eyebrow="Keep it focused">
            <ul className="plain-list">
              <li>Questions are shared across public and logged-in users.</li>
              <li>Planning, progress, and reports unlock after sign-up.</li>
              <li>The first release keeps forms simple and lightweight.</li>
            </ul>
          </Card>
        </div>
      </main>
    </>
  );
}
