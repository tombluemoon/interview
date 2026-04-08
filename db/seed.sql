INSERT INTO users (
  id,
  display_name,
  email,
  role,
  preferred_tracks,
  password_hash
)
VALUES
  (
    'user_demo',
    'Alex Zhang',
    'alex@example.com',
    'USER',
    ARRAY['Java Core', 'SQL', 'Algorithms', 'AI']::TEXT[],
    'scrypt$14a757ae90acfb844827e4e65197f47f$73e4bb43e64cb3bd046743f2daa896260e97b4f2a8b4020fd3d0ff8202783b68068f64fca3998542e6664191fd370c41ba9fa68e43625ecd5a27a7dcee2d33fa'
  ),
  (
    'admin_demo',
    'Content Admin',
    'admin@example.com',
    'ADMIN',
    ARRAY['Algorithms', 'AI']::TEXT[],
    'scrypt$6d6b29d6ec3a26e3a71b9a4691382efc$f8d3f06766f6d21da60730025f6bf45ffcc0daa121e7f888295d51d7fad19008153f6e30ae54dc353581e5fdff4e8aebe9c8f3e2e70289833d7dd9bd17a44c72'
  )
ON CONFLICT (id) DO UPDATE
SET
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  role = EXCLUDED.role,
  preferred_tracks = EXCLUDED.preferred_tracks,
  password_hash = EXCLUDED.password_hash;

INSERT INTO question_categories (id, name, slug, description)
VALUES
  (
    'cat_algorithms',
    'Algorithms',
    'algorithms',
    'Core coding and data structure questions.'
  ),
  (
    'cat_java',
    'Java Core',
    'java-core',
    'JVM, concurrency, collections, and Spring basics.'
  ),
  (
    'cat_sql',
    'SQL',
    'sql',
    'Transactions, indexing, query tuning, and modeling.'
  ),
  (
    'cat_ai',
    'AI',
    'ai',
    'RAG, evaluation, deployment, and LLM application design.'
  ),
  (
    'cat_system',
    'System Design',
    'system-design',
    'Backend architecture, scaling, and distributed systems.'
  )
ON CONFLICT (id) DO UPDATE
SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug,
  description = EXCLUDED.description;

INSERT INTO questions (
  id,
  slug,
  title,
  category_id,
  difficulty,
  tags,
  excerpt,
  body,
  hint,
  reference_answer,
  related_slugs,
  visibility,
  content_status
)
VALUES
  (
    'q_lru',
    'lru-cache',
    'How would you implement an O(1) LRU cache?',
    'cat_algorithms',
    'Medium',
    ARRAY['hashmap', 'linked-list', 'design']::TEXT[],
    'Explain the data structure choice and the update flow.',
    'Design an LRU cache that supports get and put in O(1) time. Explain the data structures you choose, how eviction works, and what trade-offs the design introduces.',
    'A hashmap gives O(1) lookup, while a doubly linked list keeps recency order easy to update.',
    'A strong answer combines a hashmap from key to node with a doubly linked list ordered by recency. Reads and writes move the node to the front, and eviction removes the least recently used node from the tail.',
    ARRAY['rate-limiter', 'top-k-frequency']::TEXT[],
    'PUBLIC',
    'PUBLISHED'
  ),
  (
    'q_rate_limiter',
    'rate-limiter',
    'Design a rate limiter using token bucket or leaky bucket.',
    'cat_system',
    'Medium',
    ARRAY['system-design', 'traffic-control', 'backend']::TEXT[],
    'Compare algorithm choices and operational trade-offs.',
    'Design a rate limiter for an API platform. Explain when you would choose token bucket or leaky bucket, what state must be stored, and how the design behaves under bursts.',
    'Think about fairness, burst tolerance, and how you would scale the state if the service runs on multiple nodes.',
    'Token bucket is better when controlled bursts are acceptable, while leaky bucket smooths traffic more aggressively. A strong design also explains per-key storage, expiration, and fallback behavior.',
    ARRAY['rag-service', 'mvcc-explained']::TEXT[],
    'PUBLIC',
    'PUBLISHED'
  ),
  (
    'q_mvcc',
    'mvcc-explained',
    'How do you explain MVCC in practical interview language?',
    'cat_sql',
    'Medium',
    ARRAY['transactions', 'mysql', 'consistency']::TEXT[],
    'Frame MVCC from the perspective of reads, versions, and isolation.',
    'Explain multiversion concurrency control in a way that helps an interviewer understand how reads and writes can coexist without excessive locking. Mention snapshots, versions, and transaction visibility.',
    'Anchor your explanation in user-facing behavior: readers often see a consistent snapshot while writers create newer versions.',
    'MVCC lets readers access an older visible version while writers produce newer row versions. That reduces read-write blocking and helps transactional reads stay consistent within an isolation level.',
    ARRAY['feature-store-consistency', 'lru-cache']::TEXT[],
    'PUBLIC',
    'PUBLISHED'
  ),
  (
    'q_rag',
    'rag-service',
    'Design a RAG service end to end.',
    'cat_ai',
    'Medium',
    ARRAY['rag', 'retrieval', 'evaluation']::TEXT[],
    'Cover chunking, retrieval, reranking, answer generation, and citations.',
    'Design an end-to-end retrieval-augmented generation service for interview preparation content. Explain chunking, retrieval, reranking, grounding, and answer generation with citations.',
    'The best answers connect retrieval quality, latency, safety, and observability.',
    'A practical answer explains offline indexing, metadata-aware retrieval, optional reranking, grounded prompt construction, citation formatting, evaluation loops, and failure fallbacks for hallucinations.',
    ARRAY['rate-limiter', 'audit-ready-llm']::TEXT[],
    'PUBLIC',
    'PUBLISHED'
  ),
  (
    'q_audit',
    'audit-ready-llm',
    'How do you design an auditable LLM system?',
    'cat_ai',
    'Medium',
    ARRAY['audit', 'logging', 'governance']::TEXT[],
    'Focus on logs, traceability, and permission boundaries.',
    'Design an LLM system that can be audited later. Explain which request logs, retrieval logs, prompt versions, model metadata, and access controls should be preserved.',
    'Separate business observability from governance observability.',
    'An auditable LLM system records who asked what, which prompt and model version was used, what knowledge sources were retrieved, what policy checks ran, and how the system responded.',
    ARRAY['rag-service', 'feature-store-consistency']::TEXT[],
    'PUBLIC',
    'PUBLISHED'
  ),
  (
    'q_feature_store',
    'feature-store-consistency',
    'How do you keep offline and online feature stores consistent?',
    'cat_ai',
    'Medium',
    ARRAY['mlops', 'data-platform', 'consistency']::TEXT[],
    'Explain point-in-time correctness and shared definitions.',
    'Describe how to design a feature store that keeps offline training features and online serving features consistent. Explain point-in-time correctness, shared transformations, and backfill strategy.',
    'The interviewer wants to hear about shared definitions, lineage, and replayability.',
    'A strong answer uses a single transformation definition, controlled backfills, feature versioning, and validation that compares offline and online values under the same entity and timestamp.',
    ARRAY['rag-service', 'mvcc-explained']::TEXT[],
    'PUBLIC',
    'PUBLISHED'
  )
ON CONFLICT (id) DO UPDATE
SET
  slug = EXCLUDED.slug,
  title = EXCLUDED.title,
  category_id = EXCLUDED.category_id,
  difficulty = EXCLUDED.difficulty,
  tags = EXCLUDED.tags,
  excerpt = EXCLUDED.excerpt,
  body = EXCLUDED.body,
  hint = EXCLUDED.hint,
  reference_answer = EXCLUDED.reference_answer,
  related_slugs = EXCLUDED.related_slugs,
  visibility = EXCLUDED.visibility,
  content_status = EXCLUDED.content_status;

INSERT INTO user_question_progress (
  user_id,
  question_id,
  progress_status,
  review_count
)
VALUES
  ('user_demo', 'q_lru', 'REVIEWED', 2),
  ('user_demo', 'q_rate_limiter', 'PLANNED', 0),
  ('user_demo', 'q_mvcc', 'IN_PROGRESS', 1),
  ('user_demo', 'q_rag', 'NOT_STARTED', 0),
  ('user_demo', 'q_audit', 'NOT_STARTED', 0),
  ('user_demo', 'q_feature_store', 'MASTERED', 3)
ON CONFLICT (user_id, question_id) DO UPDATE
SET
  progress_status = EXCLUDED.progress_status,
  review_count = EXCLUDED.review_count,
  updated_at = NOW();

INSERT INTO study_tasks (
  id,
  user_id,
  plan_date,
  title,
  task_type,
  status,
  priority,
  category_id,
  category_name,
  linked_question_slug,
  linked_question_title,
  completed_at
)
VALUES
  (
    'task_sql_today_01',
    'user_demo',
    CURRENT_DATE,
    'Review 3 SQL locking questions',
    'CATEGORY_PRACTICE',
    'PENDING',
    3,
    'cat_sql',
    'SQL',
    NULL,
    NULL,
    NULL
  ),
  (
    'task_alg_today_01',
    'user_demo',
    CURRENT_DATE,
    'Revisit LRU Cache',
    'QUESTION_LINKED',
    'PENDING',
    2,
    'cat_algorithms',
    'Algorithms',
    'lru-cache',
    'How would you implement an O(1) LRU cache?',
    NULL
  ),
  (
    'task_ai_today_01',
    'user_demo',
    CURRENT_DATE,
    'Practice one AI design answer',
    'FREEFORM',
    'PENDING',
    3,
    'cat_ai',
    'AI',
    NULL,
    NULL,
    NULL
  ),
  (
    'task_java_today_01',
    'user_demo',
    CURRENT_DATE,
    'Review Java memory model',
    'CATEGORY_PRACTICE',
    'COMPLETED',
    2,
    'cat_java',
    'Java Core',
    NULL,
    NULL,
    NOW() - INTERVAL '6 hours'
  ),
  (
    'task_sql_today_02',
    'user_demo',
    CURRENT_DATE,
    'Read SQL isolation notes',
    'FREEFORM',
    'COMPLETED',
    2,
    'cat_sql',
    'SQL',
    NULL,
    NULL,
    NOW() - INTERVAL '5 hours'
  ),
  (
    'task_ai_day_01',
    'user_demo',
    CURRENT_DATE - 1,
    'Answer one RAG system design question',
    'QUESTION_LINKED',
    'COMPLETED',
    3,
    'cat_ai',
    'AI',
    'rag-service',
    'Design a RAG service end to end.',
    NOW() - INTERVAL '1 day'
  ),
  (
    'task_alg_day_02',
    'user_demo',
    CURRENT_DATE - 2,
    'Review rate limiter trade-offs',
    'QUESTION_LINKED',
    'COMPLETED',
    3,
    'cat_system',
    'System Design',
    'rate-limiter',
    'Design a rate limiter using token bucket or leaky bucket.',
    NOW() - INTERVAL '2 day'
  ),
  (
    'task_sql_day_03',
    'user_demo',
    CURRENT_DATE - 3,
    'Write an MVCC explanation from memory',
    'QUESTION_LINKED',
    'COMPLETED',
    3,
    'cat_sql',
    'SQL',
    'mvcc-explained',
    'How do you explain MVCC in practical interview language?',
    NOW() - INTERVAL '3 day'
  ),
  (
    'task_ai_day_04',
    'user_demo',
    CURRENT_DATE - 4,
    'Summarize offline and online feature consistency',
    'QUESTION_LINKED',
    'COMPLETED',
    2,
    'cat_ai',
    'AI',
    'feature-store-consistency',
    'How do you keep offline and online feature stores consistent?',
    NOW() - INTERVAL '4 day'
  ),
  (
    'task_overdue_01',
    'user_demo',
    CURRENT_DATE - 1,
    'Catch up on AI backlog',
    'CATEGORY_PRACTICE',
    'PENDING',
    4,
    'cat_ai',
    'AI',
    NULL,
    NULL,
    NULL
  ),
  (
    'task_tomorrow_01',
    'user_demo',
    CURRENT_DATE + 1,
    'Practice one system design answer out loud',
    'CATEGORY_PRACTICE',
    'PENDING',
    3,
    'cat_system',
    'System Design',
    NULL,
    NULL,
    NULL
  )
ON CONFLICT (id) DO UPDATE
SET
  user_id = EXCLUDED.user_id,
  plan_date = EXCLUDED.plan_date,
  title = EXCLUDED.title,
  task_type = EXCLUDED.task_type,
  status = EXCLUDED.status,
  priority = EXCLUDED.priority,
  category_id = EXCLUDED.category_id,
  category_name = EXCLUDED.category_name,
  linked_question_slug = EXCLUDED.linked_question_slug,
  linked_question_title = EXCLUDED.linked_question_title,
  completed_at = EXCLUDED.completed_at;
