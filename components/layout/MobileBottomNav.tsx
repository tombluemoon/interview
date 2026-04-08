import Link from "next/link";

export function MobileBottomNav() {
  return (
    <nav className="mobile-nav">
      <Link href="/app/today">Today</Link>
      <Link href="/app/plans">Plans</Link>
      <Link href="/questions">Questions</Link>
      <Link href="/app/reports">Reports</Link>
      <Link href="/app/profile">Me</Link>
    </nav>
  );
}
