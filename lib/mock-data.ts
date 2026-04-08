import type {
  BacklogItem,
  Category,
  CategoryProgress,
  Question,
  ReportSummary,
  StudyTask,
  TodaySummary,
  TrendPoint,
  UserProfile,
} from "@/types/domain";

export const categories: Category[] = [
  {
    id: "cat_algorithms",
    name: "Algorithms",
    slug: "algorithms",
    description: "Core coding and data structure questions.",
    questionCount: 42,
  },
  {
    id: "cat_java",
    name: "Java Core",
    slug: "java-core",
    description: "JVM, concurrency, collections, and Spring basics.",
    questionCount: 36,
  },
  {
    id: "cat_sql",
    name: "SQL",
    slug: "sql",
    description: "Transactions, indexing, query tuning, and modeling.",
    questionCount: 28,
  },
  {
    id: "cat_ai",
    name: "AI",
    slug: "ai",
    description: "RAG, evaluation, deployment, and LLM application design.",
    questionCount: 31,
  },
  {
    id: "cat_system",
    name: "System Design",
    slug: "system-design",
    description: "Backend architecture, scaling, and distributed systems.",
    questionCount: 24,
  },
];

export const questions: Question[] = [
  {
    id: "q_lru",
    slug: "lru-cache",
    title: "How would you implement an O(1) LRU cache?",
    categoryId: "cat_algorithms",
    categoryName: "Algorithms",
    difficulty: "Medium",
    tags: ["hashmap", "linked-list", "design"],
    excerpt: "Explain the data structure choice and the update flow.",
    body: "Design an LRU cache that supports get and put in O(1) time. Explain the data structures you choose, how eviction works, and what trade-offs the design introduces.",
    hint: "A hashmap gives O(1) lookup, while a doubly linked list keeps recency order easy to update.",
    referenceAnswer:
      "A strong answer combines a hashmap from key to node with a doubly linked list ordered by recency. Reads and writes move the node to the front, and eviction removes the least recently used node from the tail.",
    progressStatus: "REVIEWED",
    relatedSlugs: ["rate-limiter", "top-k-frequency"],
  },
  {
    id: "q_rate_limiter",
    slug: "rate-limiter",
    title: "Design a rate limiter using token bucket or leaky bucket.",
    categoryId: "cat_system",
    categoryName: "System Design",
    difficulty: "Medium",
    tags: ["system-design", "traffic-control", "backend"],
    excerpt: "Compare algorithm choices and operational trade-offs.",
    body: "Design a rate limiter for an API platform. Explain when you would choose token bucket or leaky bucket, what state must be stored, and how the design behaves under bursts.",
    hint: "Think about fairness, burst tolerance, and how you would scale the state if the service runs on multiple nodes.",
    referenceAnswer:
      "Token bucket is better when controlled bursts are acceptable, while leaky bucket smooths traffic more aggressively. A strong design also explains per-key storage, expiration, and fallback behavior.",
    progressStatus: "PLANNED",
    relatedSlugs: ["rag-service", "mvcc-explained"],
  },
  {
    id: "q_mvcc",
    slug: "mvcc-explained",
    title: "How do you explain MVCC in practical interview language?",
    categoryId: "cat_sql",
    categoryName: "SQL",
    difficulty: "Medium",
    tags: ["transactions", "mysql", "consistency"],
    excerpt: "Frame MVCC from the perspective of reads, versions, and isolation.",
    body: "Explain multiversion concurrency control in a way that helps an interviewer understand how reads and writes can coexist without excessive locking. Mention snapshots, versions, and transaction visibility.",
    hint: "Anchor your explanation in user-facing behavior: readers often see a consistent snapshot while writers create newer versions.",
    referenceAnswer:
      "MVCC lets readers access an older visible version while writers produce newer row versions. That reduces read-write blocking and helps transactional reads stay consistent within an isolation level.",
    progressStatus: "IN_PROGRESS",
    relatedSlugs: ["feature-store-consistency", "lru-cache"],
  },
  {
    id: "q_rag",
    slug: "rag-service",
    title: "Design a RAG service end to end.",
    categoryId: "cat_ai",
    categoryName: "AI",
    difficulty: "Medium",
    tags: ["rag", "retrieval", "evaluation"],
    excerpt: "Cover chunking, retrieval, reranking, answer generation, and citations.",
    body: "Design an end-to-end retrieval-augmented generation service for interview preparation content. Explain chunking, retrieval, reranking, grounding, and answer generation with citations.",
    hint: "The best answers connect retrieval quality, latency, safety, and observability.",
    referenceAnswer:
      "A practical answer explains offline indexing, metadata-aware retrieval, optional reranking, grounded prompt construction, citation formatting, evaluation loops, and failure fallbacks for hallucinations.",
    progressStatus: "NOT_STARTED",
    relatedSlugs: ["rate-limiter", "audit-ready-llm"],
  },
  {
    id: "q_audit",
    slug: "audit-ready-llm",
    title: "How do you design an auditable LLM system?",
    categoryId: "cat_ai",
    categoryName: "AI",
    difficulty: "Medium",
    tags: ["audit", "logging", "governance"],
    excerpt: "Focus on logs, traceability, and permission boundaries.",
    body: "Design an LLM system that can be audited later. Explain which request logs, retrieval logs, prompt versions, model metadata, and access controls should be preserved.",
    hint: "Separate business observability from governance observability.",
    referenceAnswer:
      "An auditable LLM system records who asked what, which prompt and model version was used, what knowledge sources were retrieved, what policy checks ran, and how the system responded.",
    progressStatus: "NOT_STARTED",
    relatedSlugs: ["rag-service", "feature-store-consistency"],
  },
  {
    id: "q_feature_store",
    slug: "feature-store-consistency",
    title: "How do you keep offline and online feature stores consistent?",
    categoryId: "cat_ai",
    categoryName: "AI",
    difficulty: "Medium",
    tags: ["mlops", "data-platform", "consistency"],
    excerpt: "Explain point-in-time correctness and shared definitions.",
    body: "Describe how to design a feature store that keeps offline training features and online serving features consistent. Explain point-in-time correctness, shared transformations, and backfill strategy.",
    hint: "The interviewer wants to hear about shared definitions, lineage, and replayability.",
    referenceAnswer:
      "A strong answer uses a single transformation definition, controlled backfills, feature versioning, and validation that compares offline and online values under the same entity and timestamp.",
    progressStatus: "MASTERED",
    relatedSlugs: ["rag-service", "mvcc-explained"],
  },
];

export const featuredQuestionIds = ["q_lru", "q_mvcc", "q_rate_limiter", "q_rag"];

export const todayTasks: StudyTask[] = [
  {
    id: "task_sql_01",
    title: "Review 3 SQL locking questions",
    taskType: "CATEGORY_PRACTICE",
    status: "PENDING",
    priority: 3,
    categoryName: "SQL",
  },
  {
    id: "task_alg_01",
    title: "Revisit LRU Cache",
    taskType: "QUESTION_LINKED",
    status: "PENDING",
    priority: 2,
    categoryName: "Algorithms",
    linkedQuestionSlug: "lru-cache",
    linkedQuestionTitle: "How would you implement an O(1) LRU cache?",
  },
  {
    id: "task_ai_01",
    title: "Practice one AI design answer",
    taskType: "FREEFORM",
    status: "PENDING",
    priority: 3,
    categoryName: "AI",
  },
  {
    id: "task_java_01",
    title: "Review Java memory model",
    taskType: "CATEGORY_PRACTICE",
    status: "COMPLETED",
    priority: 2,
    categoryName: "Java Core",
    completedAt: "09:20",
  },
  {
    id: "task_sql_02",
    title: "Read SQL isolation notes",
    taskType: "FREEFORM",
    status: "COMPLETED",
    priority: 2,
    categoryName: "SQL",
    completedAt: "10:10",
  },
];

export const todaySummary: TodaySummary = {
  taskCount: todayTasks.length,
  completedCount: todayTasks.filter((task) => task.status === "COMPLETED").length,
  pendingCount: todayTasks.filter((task) => task.status === "PENDING").length,
};

export const reportSummary: ReportSummary = {
  tasksCompletedInRange: 18,
  reviewedQuestions: 24,
  masteredQuestions: 6,
  currentStreak: 5,
};

export const dailyTrend: TrendPoint[] = [
  { label: "Mon", value: 3 },
  { label: "Tue", value: 2 },
  { label: "Wed", value: 4 },
  { label: "Thu", value: 1 },
  { label: "Fri", value: 5 },
  { label: "Sat", value: 2 },
  { label: "Sun", value: 4 },
];

export const categoryProgress: CategoryProgress[] = [
  { categoryName: "SQL", reviewedCount: 12, totalCount: 20 },
  { categoryName: "Algorithms", reviewedCount: 9, totalCount: 20 },
  { categoryName: "AI", reviewedCount: 5, totalCount: 25 },
  { categoryName: "Java Core", reviewedCount: 8, totalCount: 18 },
];

export const backlogItems: BacklogItem[] = [
  {
    id: "backlog_01",
    title: "3 overdue tasks",
    detail: "Carry over unfinished SQL and AI practice tasks into tomorrow's plan.",
  },
  {
    id: "backlog_02",
    title: "AI has low coverage",
    detail: "Only 5 of 25 AI questions are marked reviewed.",
  },
  {
    id: "backlog_03",
    title: "Java Core cooling down",
    detail: "No Java Core review recorded in the last 4 days.",
  },
];

export const demoUser: UserProfile = {
  id: "user_demo",
  displayName: "Alex Zhang",
  email: "alex@example.com",
  role: "USER",
  preferredTracks: ["Java Core", "SQL", "Algorithms", "AI"],
};

export const demoAdmin: UserProfile = {
  id: "admin_demo",
  displayName: "Content Admin",
  email: "admin@example.com",
  role: "ADMIN",
  preferredTracks: ["Algorithms", "AI"],
};

export function getCategories() {
  return categories;
}

export function getFeaturedQuestions() {
  return questions.filter((question) => featuredQuestionIds.includes(question.id));
}

export function getQuestionBySlug(slug: string) {
  return questions.find((question) => question.slug === slug);
}

export function getQuestionById(id: string) {
  return questions.find((question) => question.id === id);
}

export function getQuestionSummaries(filters?: {
  q?: string;
  category?: string;
}) {
  return questions.filter((question) => {
    const matchesQuery =
      !filters?.q ||
      question.title.toLowerCase().includes(filters.q.toLowerCase()) ||
      question.tags.some((tag) => tag.toLowerCase().includes(filters.q!.toLowerCase()));
    const matchesCategory =
      !filters?.category || question.categoryId === filters.category;

    return matchesQuery && matchesCategory;
  });
}

export function getRelatedQuestions(slugs: string[]) {
  return questions.filter((question) => slugs.includes(question.slug));
}

export function getPendingTasks() {
  return todayTasks.filter((task) => task.status === "PENDING");
}

export function getCompletedTasks() {
  return todayTasks.filter((task) => task.status === "COMPLETED");
}
