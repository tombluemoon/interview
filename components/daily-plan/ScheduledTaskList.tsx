import Link from "next/link";

import { carryOverTaskAction } from "@/app/actions";
import { Badge } from "@/components/ui/Badge";
import { EmptyState } from "@/components/ui/EmptyState";
import { formatPlanDateLabel } from "@/modules/daily-plan/daily-plan.dates";
import type { ScheduledStudyTask } from "@/types/domain";

interface ScheduledTaskListProps {
  tasks: ScheduledStudyTask[];
  emptyTitle: string;
  emptyDescription: string;
  allowCarryOver?: boolean;
  returnTo?: string;
}

export function ScheduledTaskList({
  tasks,
  emptyTitle,
  emptyDescription,
  allowCarryOver = false,
  returnTo = "/app/plans",
}: ScheduledTaskListProps) {
  if (!tasks.length) {
    return <EmptyState title={emptyTitle} description={emptyDescription} />;
  }

  return (
    <ul className="task-preview-list">
      {tasks.map((task) => (
        <li key={task.id} className="task-preview-item">
          <div className="task-preview-copy">
            <h3>{task.title}</h3>
            <div className="meta-row">
              <Badge>{formatPlanDateLabel(task.planDate)}</Badge>
              {task.categoryName ? <Badge>{task.categoryName}</Badge> : null}
              <Badge tone="accent">P{task.priority}</Badge>
              <Badge>{task.taskType}</Badge>
              {task.status !== "PENDING" ? (
                <Badge tone={task.status === "COMPLETED" ? "success" : "accent"}>
                  {task.status}
                </Badge>
              ) : null}
            </div>
          </div>
          <div className="button-row">
            {task.linkedQuestionSlug ? (
              <Link
                href={`/questions/${task.linkedQuestionSlug}`}
                className="button-secondary"
              >
                Open
              </Link>
            ) : null}
            {allowCarryOver ? (
              <form action={carryOverTaskAction} className="inline-form">
                <input type="hidden" name="taskId" value={task.id} />
                <input type="hidden" name="returnTo" value={returnTo} />
                <button type="submit" className="button-secondary">
                  Carry Over
                </button>
              </form>
            ) : null}
          </div>
        </li>
      ))}
    </ul>
  );
}
