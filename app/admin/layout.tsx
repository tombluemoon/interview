import type { ReactNode } from "react";

import { AdminSidebar } from "@/components/layout/AdminSidebar";
import { requireAdminSession } from "@/lib/auth";

export default async function AdminLayout({
  children,
}: {
  children: ReactNode;
}) {
  await requireAdminSession();

  return (
    <div className="admin-layout">
      <AdminSidebar />
      <main className="admin-main">
        {children}
      </main>
    </div>
  );
}
