import Link from "next/link";

import { addQuestionToTodayAction } from "@/app/actions";
import { Badge } from "@/components/ui/Badge";
import { Card } from "@/components/ui/Card";
import type { Question } from "@/types/domain";

interface QuestionCardProps {
  question: Question;
  showActions?: boolean;
}

export function QuestionCard({
  question,
  showActions = false,
}: QuestionCardProps) {
  return (
    <Card className="question-card">
      <div className="question-card-header">
        <div>
          <h3>
            <Link href={`/questions/${question.slug}`}>{question.title}</Link>
          </h3>
          <div className="meta-row">
            <Badge>{question.categoryName}</Badge>
            <Badge tone="accent">{question.difficulty}</Badge>
            {question.progressStatus ? (
              <Badge tone="success">{question.progressStatus}</Badge>
            ) : null}
          </div>
        </div>
      </div>
      <p className="muted-copy">{question.excerpt}</p>
      <div className="tag-row">
        {question.tags.map((tag) => (
          <span key={tag} className="tag-chip">
            {tag}
          </span>
        ))}
      </div>
      <div className="button-row">
        <Link href={`/questions/${question.slug}`} className="button-secondary">
          View Full Content
        </Link>
        {showActions ? (
          <>
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
            <Link
              href={`/questions/${question.slug}`}
              className="button-secondary"
            >
              Track Progress
            </Link>
          </>
        ) : null}
      </div>
    </Card>
  );
}
