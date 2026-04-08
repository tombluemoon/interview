import Link from "next/link";

export function AdminSidebar() {
  return (
    <aside className="sidebar sidebar-admin">
      <div className="sidebar-panel">
        <p className="sidebar-kicker">Admin</p>
        <h2>Content Management</h2>
        <p className="sidebar-copy">
          Keep the initial admin tooling intentionally small: table views,
          simple filters, and one editor form.
        </p>
      </div>
      <nav className="sidebar-nav">
        <Link href="/admin/questions">Questions</Link>
        <Link href="/admin/categories">Categories</Link>
      </nav>
    </aside>
  );
}
