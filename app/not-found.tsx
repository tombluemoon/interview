import Link from "next/link";

import { TopNav } from "@/components/layout/TopNav";
import { Card } from "@/components/ui/Card";
import { getSession } from "@/lib/auth";

export default async function NotFound() {
  const session = await getSession();

  return (
    <>
      <TopNav authenticated={Boolean(session)} role={session?.role} />
      <main className="page-shell">
        <Card title="Page not found" eyebrow="404">
          <p>The page you opened does not exist in this starter yet.</p>
          <div className="button-row">
            <Link href="/" className="button-primary">
              Back Home
            </Link>
            <Link href="/questions" className="button-secondary">
              Browse Questions
            </Link>
          </div>
        </Card>
      </main>
    </>
  );
}
