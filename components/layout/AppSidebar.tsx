import Link from "next/link";

interface AppSidebarProps {
  userName: string;
}

export function AppSidebar({ userName }: AppSidebarProps) {
  return (
    <aside className="sidebar">
      <div className="sidebar-panel">
        <p className="sidebar-kicker">Study workspace</p>
        <h2>{userName}</h2>
        <p className="sidebar-copy">
          Keep today&apos;s execution small, visible, and easy to sustain across
          your interview prep loop.
        </p>
      </div>
      <nav className="sidebar-nav">
        <Link href="/app/today">Today</Link>
        <Link href="/app/plans">Plans</Link>
        <Link href="/questions">Questions</Link>
        <Link href="/app/reports">Reports</Link>
        <Link href="/app/profile">Profile</Link>
      </nav>
    </aside>
  );
}
