import { EmptyState } from "@/components/ui/EmptyState";
import type { StudyTask } from "@/types/domain";

import { TaskItem } from "./TaskItem";

interface TaskListProps {
  title: string;
  tasks: StudyTask[];
  categoryNames: string[];
  emptyTitle: string;
  emptyDescription: string;
}

export function TaskList({
  title,
  tasks,
  categoryNames,
  emptyTitle,
  emptyDescription,
}: TaskListProps) {
  return (
    <section className="list-section">
      <div className="section-heading">
        <h2>{title}</h2>
      </div>
      {tasks.length === 0 ? (
        <EmptyState title={emptyTitle} description={emptyDescription} />
      ) : (
        <ul className="task-list">
          {tasks.map((task) => (
            <TaskItem key={task.id} task={task} categoryNames={categoryNames} />
          ))}
        </ul>
      )}
    </section>
  );
}
