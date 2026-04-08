import Link from "next/link";

import { Badge } from "@/components/ui/Badge";
import { EmptyState } from "@/components/ui/EmptyState";
import { formatPlanDateLabel } from "@/modules/daily-plan/daily-plan.dates";
import type { ScheduledStudyTask } from "@/types/domain";

interface TaskHistoryListProps {
  tasks: ScheduledStudyTask[];
  emptyTitle: string;
  emptyDescription: string;
}

function getHistoryTone(status: ScheduledStudyTask["status"]) {
  if (status === "COMPLETED") {
    return "success" as const;
  }

  if (status === "CARRIED_OVER") {
    return "accent" as const;
  }

  return "neutral" as const;
}

function getHistoryDetail(task: ScheduledStudyTask) {
  if (task.status === "COMPLETED" && task.completedAt) {
    return `Completed on ${formatPlanDateLabel(task.planDate)} at ${task.completedAt}`;
  }

  if (task.status === "CARRIED_OVER") {
    return `Carried over from ${formatPlanDateLabel(task.planDate)}`;
  }

  return `Scheduled on ${formatPlanDateLabel(task.planDate)}`;
}

export function TaskHistoryList({
  tasks,
  emptyTitle,
  emptyDescription,
}: TaskHistoryListProps) {
  if (!tasks.length) {
    return <EmptyState title={emptyTitle} description={emptyDescription} />;
  }

  return (
    <ul className="history-list">
      {tasks.map((task) => (
        <li key={task.id} className="history-item">
          <div className="history-copy">
            <h3>{task.title}</h3>
            <p>{getHistoryDetail(task)}</p>
            <div className="meta-row">
              <Badge tone={getHistoryTone(task.status)}>{task.status}</Badge>
              {task.categoryName ? <Badge>{task.categoryName}</Badge> : null}
              <Badge tone="accent">P{task.priority}</Badge>
            </div>
          </div>
          {task.linkedQuestionSlug ? (
            <Link
              href={`/questions/${task.linkedQuestionSlug}`}
              className="button-secondary"
            >
              Open
            </Link>
          ) : null}
        </li>
      ))}
    </ul>
  );
}
