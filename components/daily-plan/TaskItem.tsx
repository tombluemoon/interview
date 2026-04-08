import Link from "next/link";

import {
  carryOverTaskAction,
  completeTaskAction,
  deleteTaskAction,
  reopenTaskAction,
  updateTaskAction,
} from "@/app/actions";
import { Badge } from "@/components/ui/Badge";
import type { StudyTask } from "@/types/domain";

interface TaskItemProps {
  task: StudyTask;
  categoryNames: string[];
}

export function TaskItem({ task, categoryNames }: TaskItemProps) {
  const editableCategories =
    task.categoryName && !categoryNames.includes(task.categoryName)
      ? [task.categoryName, ...categoryNames]
      : categoryNames;

  return (
    <li className="task-item">
      <div className="task-main">
        <input
          type="checkbox"
          checked={task.status === "COMPLETED"}
          readOnly
          aria-label={task.title}
        />
        <div>
          <h3>{task.title}</h3>
          <div className="meta-row">
            {task.categoryName ? <Badge>{task.categoryName}</Badge> : null}
            <Badge tone="accent">P{task.priority}</Badge>
            <Badge>{task.taskType}</Badge>
          </div>
        </div>
      </div>
      <div className="task-actions">
        <div className="button-row">
          {task.linkedQuestionSlug ? (
            <Link
              href={`/questions/${task.linkedQuestionSlug}`}
              className="button-secondary"
            >
              Open
            </Link>
          ) : null}
          {task.status === "PENDING" ? (
            <>
              <form action={completeTaskAction} className="inline-form">
                <input type="hidden" name="taskId" value={task.id} />
                <input type="hidden" name="returnTo" value="/app/today" />
                <button type="submit" className="button-secondary">
                  Complete
                </button>
              </form>
              <form action={carryOverTaskAction} className="inline-form">
                <input type="hidden" name="taskId" value={task.id} />
                <input type="hidden" name="returnTo" value="/app/today" />
                <button type="submit" className="button-secondary">
                  Carry Over
                </button>
              </form>
            </>
          ) : (
            <>
              <span className="task-completed-note">
                Completed{task.completedAt ? ` at ${task.completedAt}` : ""}
              </span>
              <form action={reopenTaskAction} className="inline-form">
                <input type="hidden" name="taskId" value={task.id} />
                <input type="hidden" name="returnTo" value="/app/today" />
                <button type="submit" className="button-secondary">
                  Reopen
                </button>
              </form>
            </>
          )}
          <form action={deleteTaskAction} className="inline-form">
            <input type="hidden" name="taskId" value={task.id} />
            <input type="hidden" name="returnTo" value="/app/today" />
            <button type="submit" className="button-secondary">
              Delete
            </button>
          </form>
        </div>

        <details className="task-edit-details">
          <summary className="button-secondary task-edit-summary">Edit</summary>
          <form action={updateTaskAction} className="form-grid task-edit-form">
            <input type="hidden" name="taskId" value={task.id} />
            <input type="hidden" name="returnTo" value="/app/today" />
            <input type="hidden" name="taskType" value={task.taskType} />
            <input
              type="hidden"
              name="linkedQuestionSlug"
              value={task.linkedQuestionSlug ?? ""}
            />
            <input
              type="hidden"
              name="linkedQuestionTitle"
              value={task.linkedQuestionTitle ?? ""}
            />
            <label className="field-full">
              Title
              <input type="text" name="title" defaultValue={task.title} />
            </label>
            <label className="field">
              Category
              <select name="categoryName" defaultValue={task.categoryName ?? ""}>
                <option value="">None</option>
                {editableCategories.map((categoryName) => (
                  <option key={categoryName} value={categoryName}>
                    {categoryName}
                  </option>
                ))}
              </select>
            </label>
            <label className="field">
              Priority
              <select name="priority" defaultValue={String(task.priority)}>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
              </select>
            </label>
            <div className="field-full">
              <button type="submit" className="button-primary">
                Save Changes
              </button>
            </div>
          </form>
        </details>
      </div>
    </li>
  );
}
