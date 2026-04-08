import Link from "next/link";

import { TopNav } from "@/components/layout/TopNav";
import { PageHeader } from "@/components/layout/PageHeader";
import { QuestionCard } from "@/components/question-bank/QuestionCard";
import { Card } from "@/components/ui/Card";
import { getSession } from "@/lib/auth";
import { listCategories, listQuestions } from "@/modules/question-bank/question-bank.service";

export const dynamic = "force-dynamic";

interface QuestionsPageProps {
  searchParams: Promise<{
    q?: string;
    category?: string;
  }>;
}

export default async function QuestionsPage({
  searchParams,
}: QuestionsPageProps) {
  const params = await searchParams;
  const session = await getSession();
  const categories = await listCategories();
  const selectedCategory = categories.find(
    (category) => category.id === params.category,
  );
  const questions = await listQuestions({
    q: params.q,
    category: params.category,
  }, session?.user.id);

  return (
    <>
      <TopNav authenticated={Boolean(session)} role={session?.role} />
      <main className="page-shell page-stack">
        <PageHeader
          title="Question Bank"
          description="Browse public interview questions, then add logged-in context like planning and progress."
          actions={
            session ? (
              <Link href="/app/today" className="button-secondary">
                Open Today
              </Link>
            ) : (
              <Link href="/login?next=/questions" className="button-secondary">
                Log In to Track Progress
              </Link>
            )
          }
        />

        <section className="content-grid">
          <Card title="Filters" eyebrow="Simple V1 controls">
            <form className="form-grid" action="/questions">
              <label className="field-full">
                Search
                <input
                  type="text"
                  name="q"
                  defaultValue={params.q}
                  placeholder="LRU cache, MVCC, RAG..."
                />
              </label>
              <label className="field">
                Category
                <select name="category" defaultValue={params.category ?? ""}>
                  <option value="">All categories</option>
                  {categories.map((category) => (
                    <option key={category.id} value={category.id}>
                      {category.name}
                    </option>
                  ))}
                </select>
              </label>
              <div className="field">
                <span>&nbsp;</span>
                <button type="submit" className="button-primary">
                  Apply Filters
                </button>
              </div>
            </form>
            <div className="tag-row">
              <Link
                href="/questions"
                className={`tag-chip${!params.category ? ' tag-chip-active' : ''}`}
              >
                All
              </Link>
              {categories.map((category) => (
                <Link
                  key={category.id}
                  href={`/questions?category=${category.id}`}
                  className={`tag-chip${params.category === category.id ? ' tag-chip-active' : ''}`}
                >
                  {category.name}
                </Link>
              ))}
            </div>
          </Card>

          <section className="page-stack">
            <Card
              title={`${questions.length} questions found`}
              eyebrow={
                selectedCategory ? `Filtered by ${selectedCategory.name}` : "All public categories"
              }
            >
              <p>
                This page is shared by anonymous and logged-in users. Logged-in
                users simply get extra actions.
              </p>
            </Card>
            <div className="page-stack">
              {questions.map((question) => (
                <QuestionCard
                  key={question.id}
                  question={question}
                  showActions={Boolean(session)}
                />
              ))}
            </div>
          </section>
        </section>
      </main>
    </>
  );
}
