import Link from "next/link";
import { notFound } from "next/navigation";

import {
  addQuestionToTodayAction,
  updateQuestionProgressAction,
} from "@/app/actions";
import { TopNav } from "@/components/layout/TopNav";
import { PageHeader } from "@/components/layout/PageHeader";
import { Badge } from "@/components/ui/Badge";
import { Card } from "@/components/ui/Card";
import { getSession } from "@/lib/auth";
import {
  findQuestionBySlug,
  listRelatedQuestions,
} from "@/modules/question-bank/question-bank.service";

export const dynamic = "force-dynamic";

interface QuestionDetailPageProps {
  params: Promise<{
    slug: string;
  }>;
  searchParams: Promise<{
    task?: string;
    progress?: string;
    error?: string;
  }>;
}

export default async function QuestionDetailPage({
  params,
  searchParams,
}: QuestionDetailPageProps) {
  const { slug } = await params;
  const query = await searchParams;
  const session = await getSession();
  const question = await findQuestionBySlug(slug, session?.user.id);

  if (!question) {
    notFound();
  }

  const relatedQuestions = await listRelatedQuestions(
    question.relatedSlugs,
    session?.user.id,
  );
  const banner =
    query.task === "added"
      ? "Question added to today's task list."
      : query.progress === "updated"
        ? "Progress status updated."
        : query.error === "progress"
          ? "Progress update failed."
          : query.error === "task"
            ? "Task creation failed."
            : null;

  return (
    <>
      <TopNav authenticated={Boolean(session)} role={session?.role} />
      <main className="page-shell page-stack">
        {banner ? <div className="demo-banner">{banner}</div> : null}
        <PageHeader
          title={question.title}
          description={`Full question content for ${question.categoryName}.`}
          actions={
            session ? (
              <div className="button-row">
                <form action={addQuestionToTodayAction} className="inline-form">
                  <input type="hidden" name="slug" value={question.slug} />
                  <input
                    type="hidden"
                    name="linkedQuestionTitle"
                    value={question.title}
                  />
                  <input
                    type="hidden"
                    name="title"
                    value={`Review ${question.title}`}
                  />
                  <input
                    type="hidden"
                    name="categoryName"
                    value={question.categoryName}
                  />
                  <button type="submit" className="button-primary">
                    Add to Today&apos;s Plan
                  </button>
                </form>
                <Link href="/app/today" className="button-secondary">
                  Open Today
                </Link>
              </div>
            ) : (
              <div className="button-row">
                <Link
                  href={`/login?next=/questions/${question.slug}`}
                  className="button-primary"
                >
                  Log In to Plan
                </Link>
                <Link
                  href={`/signup?next=/questions/${question.slug}`}
                  className="button-secondary"
                >
                  Create Account
                </Link>
              </div>
            )
          }
        />

        <section className="content-grid">
          <Card eyebrow="Full Question Content">
            <div className="meta-row">
              <Badge>{question.categoryName}</Badge>
              <Badge tone="accent">{question.difficulty}</Badge>
              {question.progressStatus ? (
                <Badge tone="success">{question.progressStatus}</Badge>
              ) : null}
            </div>
            <h3>Summary</h3>
            <p>{question.excerpt}</p>
            <h3>Question</h3>
            <p>{question.body}</p>
            {question.hint ? (
              <>
                <h3>Hint</h3>
                <p>{question.hint}</p>
              </>
            ) : null}
            {question.referenceAnswer ? (
              <>
                <h3>Reference answer</h3>
                <p>{question.referenceAnswer}</p>
              </>
            ) : null}
          </Card>

          <div className="page-stack">
            {session ? (
              <Card title="Your actions" eyebrow="Logged-in layer">
                <form action={updateQuestionProgressAction} className="form-grid">
                  <input type="hidden" name="questionId" value={question.id} />
                  <input type="hidden" name="slug" value={question.slug} />
                  <label className="field-full">
                    Progress Status
                    <select
                      name="progressStatus"
                      defaultValue={question.progressStatus ?? "NOT_STARTED"}
                    >
                      <option value="NOT_STARTED">NOT_STARTED</option>
                      <option value="PLANNED">PLANNED</option>
                      <option value="IN_PROGRESS">IN_PROGRESS</option>
                      <option value="REVIEWED">REVIEWED</option>
                      <option value="MASTERED">MASTERED</option>
                    </select>
                  </label>
                  <div className="field-full button-row">
                    <button type="submit" className="button-secondary">
                      Update Progress
                    </button>
                  </div>
                </form>
                <form action={addQuestionToTodayAction} className="inline-form">
                  <input type="hidden" name="slug" value={question.slug} />
                  <input
                    type="hidden"
                    name="linkedQuestionTitle"
                    value={question.title}
                  />
                  <input
                    type="hidden"
                    name="title"
                    value={`Review ${question.title}`}
                  />
                  <input
                    type="hidden"
                    name="categoryName"
                    value={question.categoryName}
                  />
                  <button type="submit" className="button-secondary">
                    Add to Plan
                  </button>
                </form>
                <div className="tag-row">
                  {question.tags.map((tag) => (
                    <span key={tag} className="tag-chip">
                      {tag}
                    </span>
                  ))}
                </div>
              </Card>
            ) : (
              <Card title="Unlock planning and progress" eyebrow="Signed-in layer">
                <p>
                  Guests can browse every public question. Log in when you want
                  to add this question to today&apos;s plan or save your progress.
                </p>
                <div className="button-row">
                  <Link
                    href={`/login?next=/questions/${question.slug}`}
                    className="button-primary"
                  >
                    Log In
                  </Link>
                  <Link
                    href={`/signup?next=/questions/${question.slug}`}
                    className="button-secondary"
                  >
                    Sign Up
                  </Link>
                </div>
                <div className="tag-row">
                  {question.tags.map((tag) => (
                    <span key={tag} className="tag-chip">
                      {tag}
                    </span>
                  ))}
                </div>
              </Card>
            )}

            <Card title="Related questions">
              <div className="page-stack">
                {relatedQuestions.map((relatedQuestion) => (
                  <Link
                    key={relatedQuestion.id}
                    href={`/questions/${relatedQuestion.slug}`}
                    className="button-secondary"
                  >
                    {relatedQuestion.title}
                  </Link>
                ))}
              </div>
            </Card>
          </div>
        </section>
      </main>
    </>
  );
}
