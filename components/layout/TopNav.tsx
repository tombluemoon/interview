import Link from "next/link";

import type { UserRole } from "@/types/domain";

interface TopNavProps {
  authenticated?: boolean;
  role?: UserRole;
}

export function TopNav({ authenticated = false, role }: TopNavProps) {
  return (
    <header className="top-nav">
      <div className="top-nav-inner">
        <Link href="/" className="brand">
          Interview Review
        </Link>
        <nav className="top-nav-links">
          <Link href="/questions">Questions</Link>
          {authenticated ? (
            <>
              {role === "ADMIN" ? <Link href="/admin/questions">Admin</Link> : null}
              <Link href="/app/today">Today</Link>
              <Link href="/app/reports">Reports</Link>
              <Link href="/app/profile">Profile</Link>
            </>
          ) : (
            <>
              <Link href="/login">Login</Link>
              <Link href="/signup" className="button-link">
                Sign Up
              </Link>
            </>
          )}
        </nav>
      </div>
    </header>
  );
}
