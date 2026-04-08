export type Difficulty = "Easy" | "Medium" | "Hard";
export type QuestionVisibility = "PUBLIC" | "PRIVATE";
export type QuestionContentStatus = "DRAFT" | "PUBLISHED" | "ARCHIVED";

export type ProgressStatus =
  | "NOT_STARTED"
  | "PLANNED"
  | "IN_PROGRESS"
  | "REVIEWED"
  | "MASTERED";

export type TaskType = "QUESTION_LINKED" | "CATEGORY_PRACTICE" | "FREEFORM";
export type TaskStatus = "PENDING" | "COMPLETED" | "SKIPPED" | "CARRIED_OVER";
export type UserRole = "USER" | "ADMIN";

export interface Category {
  id: string;
  name: string;
  slug: string;
  description: string;
  questionCount: number;
}

export interface Question {
  id: string;
  slug: string;
  title: string;
  categoryId: string;
  categoryName: string;
  difficulty: Difficulty;
  tags: string[];
  excerpt: string;
  body: string;
  hint?: string;
  referenceAnswer?: string;
  progressStatus?: ProgressStatus;
  relatedSlugs: string[];
  visibility?: QuestionVisibility;
  contentStatus?: QuestionContentStatus;
}

export interface StudyTask {
  id: string;
  title: string;
  taskType: TaskType;
  status: TaskStatus;
  priority: number;
  categoryName?: string;
  linkedQuestionSlug?: string;
  linkedQuestionTitle?: string;
  completedAt?: string;
}

export interface ScheduledStudyTask extends StudyTask {
  planDate: string;
}

export interface TodaySummary {
  taskCount: number;
  completedCount: number;
  pendingCount: number;
}

export interface DailyPlan {
  planDate: string;
  summary: TodaySummary;
  tasks: StudyTask[];
  pendingTasks: StudyTask[];
  completedTasks: StudyTask[];
}

export interface ReportSummary {
  tasksCompletedInRange: number;
  reviewedQuestions: number;
  masteredQuestions: number;
  currentStreak: number;
}

export interface CategoryProgress {
  categoryName: string;
  reviewedCount: number;
  totalCount: number;
}

export interface BacklogItem {
  id: string;
  title: string;
  detail: string;
}

export interface TrendPoint {
  label: string;
  value: number;
}

export interface UserProfile {
  id: string;
  displayName: string;
  email: string;
  role: UserRole;
  preferredTracks: string[];
}
