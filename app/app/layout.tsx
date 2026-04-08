import type { ReactNode } from "react";

import { AppSidebar } from "@/components/layout/AppSidebar";
import { MobileBottomNav } from "@/components/layout/MobileBottomNav";
import { requireSession } from "@/lib/auth";

export default async function AuthenticatedLayout({
  children,
}: {
  children: ReactNode;
}) {
  const session = await requireSession();

  return (
    <div className="app-layout">
      <AppSidebar userName={session.user.displayName} />
      <main className="app-main">
        {children}
      </main>
      <MobileBottomNav />
    </div>
  );
}
