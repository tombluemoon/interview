-- Interview Questions Imported from Notion
-- Generated: 2026-04-08T02:57:10.508Z
-- Total Questions: 348

-- Ensure all required categories exist
INSERT INTO question_categories (id, name, slug, description)
VALUES 
  ('cat_java', 'Java Core', 'java-core', 'JVM, concurrency, collections, and Spring basics.'),
  ('cat_sql', 'SQL', 'sql', 'Transactions, indexing, query tuning, and modeling.'),
  ('cat_system', 'System Design', 'system-design', 'Backend architecture, scaling, and distributed systems.'),
  ('cat_ai', 'AI', 'ai', 'RAG, evaluation, deployment, and LLM application design.'),
  ('cat_behavioral', 'Behavioral', 'behavioral', 'Behavioral and situational interview questions.')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug,
  description = EXCLUDED.description;


-- When CPU usage is high in production, how do you decide whether GC is the real p...
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
) VALUES (
  'notion_q_0',
  'when-cpu-usage-is-high-in-production-how-do-you-decide-whether-gc-is-the-real-pr-0',
  'When CPU usage is high in production, how do you decide whether GC is the real problem?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'memory', 'jvm']::TEXT[],
  'I would not blame GC just because CPU is high.',
  'I would not blame GC just because CPU is high.
I would correlate CPU, GC pause time, allocation rate, old-gen usage after GC, and request latency.
If CPU is high but GC is quiet, the issue is more likely serialization, regex, encryption, logging, or inefficient application code.
If Full GC increased and old-gen usage stays high after collection, I would investigate object retention or cache growth.',
  NULL,
  'I would not blame GC just because CPU is high.
I would correlate CPU, GC pause time, allocation rate, old-gen usage after GC, and request latency.
If CPU is high but GC is quiet, the issue is more likely serialization, regex, encryption, logging, or inefficient application code.
If Full GC increased and old-gen usage stays high after collection, I would investigate object retention or cache growth.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does increasing heap size not always fix OOM?...
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
) VALUES (
  'notion_q_1',
  'why-does-increasing-heap-size-not-always-fix-oom-1',
  'Why does increasing heap size not always fix OOM?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'heap', 'memory', 'jvm']::TEXT[],
  'If the problem is a memory leak, more heap only delays failure.',
  'If the problem is a memory leak, more heap only delays failure.
If traffic increased and the workload legitimately needs more memory, increasing heap may help.
The key question is whether memory comes down after GC. If it does not, that points more to retention than capacity.',
  NULL,
  'If the problem is a memory leak, more heap only delays failure.
If traffic increased and the workload legitimately needs more memory, increasing heap may help.
The key question is whether memory comes down after GC. If it does not, that points more to retention than capacity.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the most common fake “GC issue” you see in backend services?...
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
) VALUES (
  'notion_q_2',
  'what-is-the-most-common-fake-gc-issue-you-see-in-backend-services-2',
  'What is the most common fake “GC issue” you see in backend services?',
  'cat_java',
  'Easy',
  ARRAY['gc', 'memory', 'jvm']::TEXT[],
  'Slow database or remote dependency calls are often blamed on JVM first.',
  'Slow database or remote dependency calls are often blamed on JVM first.
Another common false alarm is excessive logging or large JSON payloads driving CPU and allocation pressure.
In many incidents, GC is a symptom, not the root cause.',
  NULL,
  'Slow database or remote dependency calls are often blamed on JVM first.
Another common false alarm is excessive logging or large JSON payloads driving CPU and allocation pressure.
In many incidents, GC is a symptom, not the root cause.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Which JVM metrics do you check first besides heap usage?...
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
) VALUES (
  'notion_q_3',
  'which-jvm-metrics-do-you-check-first-besides-heap-usage-3',
  'Which JVM metrics do you check first besides heap usage?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'heap', 'memory', 'jvm']::TEXT[],
  'GC frequency and pause time',
  'GC frequency and pause time
Old-gen usage after GC
Allocation rate
Thread count
Metaspace usage
Safepoint time
Process RSS and container memory limit',
  NULL,
  'GC frequency and pause time
Old-gen usage after GC
Allocation rate
Thread count
Metaspace usage
Safepoint time
Process RSS and container memory limit',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose between G1GC and ZGC?...
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
) VALUES (
  'notion_q_4',
  'how-do-you-choose-between-g1gc-and-zgc-4',
  'How do you choose between G1GC and ZGC?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'memory', 'jvm']::TEXT[],
  'I start with G1GC for most normal business services because it is stable and operationally simple.',
  'I start with G1GC for most normal business services because it is stable and operationally simple.
I consider ZGC when low latency matters and heap size is large enough that GC pauses affect tail latency.
I would not choose ZGC because it sounds advanced. I would choose it because measured pause behavior justifies it.',
  NULL,
  'I start with G1GC for most normal business services because it is stable and operationally simple.
I consider ZGC when low latency matters and heap size is large enough that GC pauses affect tail latency.
I would not choose ZGC because it sounds advanced. I would choose it because measured pause behavior justifies it.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Full GC suddenly became frequent after a release. What is your first instinct?...
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
) VALUES (
  'notion_q_5',
  'full-gc-suddenly-became-frequent-after-a-release-what-is-your-first-instinct-5',
  'Full GC suddenly became frequent after a release. What is your first instinct?',
  'cat_java',
  'Easy',
  ARRAY['gc', 'memory', 'jvm']::TEXT[],
  'Compare the release diff before touching JVM flags.',
  'Compare the release diff before touching JVM flags.
Look for new caches, larger payloads, more temporary objects, background jobs, ThreadLocal retention, or proxy/class generation growth.
If the problem started right after a code change, I investigate allocation behavior before I tune GC.',
  NULL,
  'Compare the release diff before touching JVM flags.
Look for new caches, larger payloads, more temporary objects, background jobs, ThreadLocal retention, or proxy/class generation growth.
If the problem started right after a code change, I investigate allocation behavior before I tune GC.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you actually investigate a Java memory leak?...
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
) VALUES (
  'notion_q_6',
  'how-do-you-actually-investigate-a-java-memory-leak-6',
  'How do you actually investigate a Java memory leak?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'memory', 'jvm']::TEXT[],
  'Check whether old-gen usage after GC keeps climbing.',
  'Check whether old-gen usage after GC keeps climbing.
Capture a heap dump.
Use MAT or a similar tool to inspect dominator tree and retained heap.
Identify which objects are retaining memory.
Trace that back to business code and reference chains.',
  NULL,
  'Check whether old-gen usage after GC keeps climbing.
Capture a heap dump.
Use MAT or a similar tool to inspect dominator tree and retained heap.
Identify which objects are retaining memory.
Trace that back to business code and reference chains.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What real scenarios can cause Metaspace OOM?...
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
) VALUES (
  'notion_q_7',
  'what-real-scenarios-can-cause-metaspace-oom-7',
  'What real scenarios can cause Metaspace OOM?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'memory', 'metaspace', 'jvm']::TEXT[],
  'Dynamic proxies or excessive class generation',
  'Dynamic proxies or excessive class generation
ClassLoader leaks in plugin or hot-reload systems
Framework-heavy applications that create many generated classes
This is especially relevant in Spring, CGLIB, ByteBuddy, or custom loading environments.',
  NULL,
  'Dynamic proxies or excessive class generation
ClassLoader leaks in plugin or hot-reload systems
Framework-heavy applications that create many generated classes
This is especially relevant in Spring, CGLIB, ByteBuddy, or custom loading environments.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you proactively enable heap dumps and GC logs?...
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
) VALUES (
  'notion_q_8',
  'when-do-you-proactively-enable-heap-dumps-and-gc-logs-8',
  'When do you proactively enable heap dumps and GC logs?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'heap', 'memory', 'jvm']::TEXT[],
  'I usually enable OOM heap dump in production by default.',
  'I usually enable OOM heap dump in production by default.
I also keep GC logs enabled with file rotation.
When an incident happens, having historical GC evidence is far more useful than trying to reconstruct the past from memory.',
  NULL,
  'I usually enable OOM heap dump in production by default.
I also keep GC logs enabled with file rotation.
When an incident happens, having historical GC evidence is far more useful than trying to reconstruct the past from memory.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about your JVM tuning experience” without sounding sh...
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
) VALUES (
  'notion_q_9',
  'how-do-you-answer-tell-me-about-your-jvm-tuning-experience-without-sounding-shal-9',
  'How do you answer “Tell me about your JVM tuning experience” without sounding shallow?',
  'cat_java',
  'Medium',
  ARRAY['gc', 'memory', 'jvm']::TEXT[],
  'I focus on method, not on memorizing flags.',
  'I focus on method, not on memorizing flags.
I explain that I establish a baseline, observe metrics, inspect GC logs, change one variable at a time, and verify impact.
Interviewers usually care more about that discipline than about a long list of flags.',
  NULL,
  'I focus on method, not on memorizing flags.
I explain that I establish a baseline, observe metrics, inspect GC logs, change one variable at a time, and verify impact.
Interviewers usually care more about that discipline than about a long list of flags.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why are equals() and hashCode() still such common interview topics?...
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
) VALUES (
  'notion_q_10',
  'why-are-equals-and-hashcode-still-such-common-interview-topics-10',
  'Why are equals() and hashCode() still such common interview topics?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because they directly affect correctness of HashMap and HashSet behavior.',
  'Because they directly affect correctness of HashMap and HashSet behavior.
A very real bug is when objects look logically equal but fail deduplication because the contract is broken.
If you override equals() but not hashCode(), collection behavior becomes inconsistent.',
  NULL,
  'Because they directly affect correctness of HashMap and HashSet behavior.
A very real bug is when objects look logically equal but fail deduplication because the contract is broken.
If you override equals() but not hashCode(), collection behavior becomes inconsistent.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When are you especially careful with BigDecimal in real systems?...
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
) VALUES (
  'notion_q_11',
  'when-are-you-especially-careful-with-bigdecimal-in-real-systems-11',
  'When are you especially careful with BigDecimal in real systems?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Pricing, settlement, billing, discounts, or anything financial.',
  'Pricing, settlement, billing, discounts, or anything financial.
I avoid double for money-related calculations.
I also avoid new BigDecimal(0.1) and prefer BigDecimal.valueOf() or string-based construction.',
  NULL,
  'Pricing, settlement, billing, discounts, or anything financial.
I avoid double for money-related calculations.
I also avoid new BigDecimal(0.1) and prefer BigDecimal.valueOf() or string-based construction.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the most common misuse of Optional in Java projects?...
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
) VALUES (
  'notion_q_12',
  'what-is-the-most-common-misuse-of-optional-in-java-projects-12',
  'What is the most common misuse of Optional in Java projects?',
  'cat_java',
  'Easy',
  ARRAY['general']::TEXT[],
  'Using it as a field type in DTOs or entities.',
  'Using it as a field type in DTOs or entities.
It is much better suited for method return values than for persistence or serialization models.
Overusing fluent Optional chains can also reduce readability.',
  NULL,
  'Using it as a field type in DTOs or entities.
It is much better suited for method return values than for persistence or serialization models.
Overusing fluent Optional chains can also reduce readability.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Why is String immutable?” in a non-generic way?...
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
) VALUES (
  'notion_q_13',
  'how-do-you-answer-why-is-string-immutable-in-a-non-generic-way-13',
  'How do you answer “Why is String immutable?” in a non-generic way?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'I would mention thread safety, String pool sharing, security, hashCode caching, and safe use as a HashMap key.',
  'I would mention thread safety, String pool sharing, security, hashCode caching, and safe use as a HashMap key.
That is a stronger answer than just saying “because it is thread-safe.”',
  NULL,
  'I would mention thread safety, String pool sharing, security, hashCode caching, and safe use as a HashMap key.
That is a stronger answer than just saying “because it is thread-safe.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain final, finally, and finalize() like a senior engineer?...
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
) VALUES (
  'notion_q_14',
  'how-do-you-explain-final-finally-and-finalize-like-a-senior-engineer-14',
  'How do you explain final, finally, and finalize() like a senior engineer?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Start by separating the three clearly.',
  'Start by separating the three clearly.
Then add that finalize() is deprecated and should not be used for reliable cleanup.
Mention try-with-resources or Cleaner as practical alternatives.',
  NULL,
  'Start by separating the three clearly.
Then add that finalize() is deprecated and should not be used for reliable cleanup.
Mention try-with-resources or Cleaner as practical alternatives.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you actually use checked vs unchecked exceptions in service code?...
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
) VALUES (
  'notion_q_15',
  'how-do-you-actually-use-checked-vs-unchecked-exceptions-in-service-code-15',
  'How do you actually use checked vs unchecked exceptions in service code?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Recoverable external failures are conceptually closer to checked exceptions.',
  'Recoverable external failures are conceptually closer to checked exceptions.
Programming errors and invalid state are better represented as unchecked exceptions.
In real systems, I care more about exception boundaries, error mapping, and logging discipline than about ideology.',
  NULL,
  'Recoverable external failures are conceptually closer to checked exceptions.
Programming errors and invalid state are better represented as unchecked exceptions.
In real systems, I care more about exception boundaries, error mapping, and logging discipline than about ideology.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain deep copy vs shallow copy without sounding theoretical?...
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
) VALUES (
  'notion_q_16',
  'how-do-you-explain-deep-copy-vs-shallow-copy-without-sounding-theoretical-16',
  'How do you explain deep copy vs shallow copy without sounding theoretical?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'I tie it to shared mutable state.',
  'I tie it to shared mutable state.
If a configuration object, request object, or cached object is reused across flows, shallow copy can create hard-to-debug side effects.
In practice, I prefer explicit copy constructors or mapping tools over casual use of clone().',
  NULL,
  'I tie it to shared mutable state.
If a configuration object, request object, or cached object is reused across flows, shallow copy can create hard-to-debug side effects.
In practice, I prefer explicit copy constructors or mapping tools over casual use of clone().',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Does StringBuilder vs StringBuffer still matter in interviews?...
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
) VALUES (
  'notion_q_17',
  'does-stringbuilder-vs-stringbuffer-still-matter-in-interviews-17',
  'Does StringBuilder vs StringBuffer still matter in interviews?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Yes, but as a fundamentals check.',
  'Yes, but as a fundamentals check.
The real point is whether you can give sensible usage guidance.
In most application code, StringBuilder is the right default. StringBuffer is rarely justified.',
  NULL,
  'Yes, but as a fundamentals check.
The real point is whether you can give sensible usage guidance.
In most application code, StringBuilder is the right default. StringBuffer is rarely justified.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain ? extends and ? super clearly?...
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
) VALUES (
  'notion_q_18',
  'how-do-you-explain-extends-and-super-clearly-18',
  'How do you explain ? extends and ? super clearly?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'I use PECS: Producer Extends, Consumer Super.',
  'I use PECS: Producer Extends, Consumer Super.
If I only read from the collection, extends is usually appropriate.
If I write values into it, super is often safer.
I explain usage semantics before talking about type erasure.',
  NULL,
  'I use PECS: Producer Extends, Consumer Super.
If I only read from the collection, extends is usually appropriate.
If I write values into it, super is often safer.
I explain usage semantics before talking about type erasure.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer questions about modern Java features without sounding like you...
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
) VALUES (
  'notion_q_19',
  'how-do-you-answer-questions-about-modern-java-features-without-sounding-like-you-19',
  'How do you answer questions about modern Java features without sounding like you memorized release notes?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'I connect the feature to maintainability.',
  'I connect the feature to maintainability.
record helps model immutable data cleanly.
sealed helps constrain type hierarchies.
switch expressions reduce boilerplate and make return logic easier to read.',
  NULL,
  'I connect the feature to maintainability.
record helps model immutable data cleanly.
sealed helps constrain type hierarchies.
switch expressions reduce boilerplate and make return logic easier to read.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose between HashMap and ConcurrentHashMap in real code?...
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
) VALUES (
  'notion_q_20',
  'how-do-you-choose-between-hashmap-and-concurrenthashmap-in-real-code-20',
  'How do you choose between HashMap and ConcurrentHashMap in real code?',
  'cat_java',
  'Medium',
  ARRAY['hashmap', 'collections', 'concurrency']::TEXT[],
  'If the map is local to a method or single-threaded flow, HashMap is enough.',
  'If the map is local to a method or single-threaded flow, HashMap is enough.
I only reach for ConcurrentHashMap when shared mutable access is real, not hypothetical.
I do not default to concurrent collections “just in case.”',
  NULL,
  'If the map is local to a method or single-threaded flow, HashMap is enough.
I only reach for ConcurrentHashMap when shared mutable access is real, not hypothetical.
I do not default to concurrent collections “just in case.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is LinkedList rarely the best answer in business code?...
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
) VALUES (
  'notion_q_21',
  'why-is-linkedlist-rarely-the-best-answer-in-business-code-21',
  'Why is LinkedList rarely the best answer in business code?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'Many people only quote insertion/deletion complexity.',
  'Many people only quote insertion/deletion complexity.
In practice, you usually have to find the position first, and that traversal dominates.
It is also less cache-friendly than array-backed structures.',
  NULL,
  'Many people only quote insertion/deletion complexity.
In practice, you usually have to find the position first, and that traversal dominates.
It is also less cache-friendly than array-backed structures.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is ArrayList growth behavior a useful interview topic?...
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
) VALUES (
  'notion_q_22',
  'why-is-arraylist-growth-behavior-a-useful-interview-topic-22',
  'Why is ArrayList growth behavior a useful interview topic?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'It shows whether you understand hidden allocation and copy cost.',
  'It shows whether you understand hidden allocation and copy cost.
In real systems, if I already know expected size, I may pre-size a list to reduce growth overhead.',
  NULL,
  'It shows whether you understand hidden allocation and copy cost.
In real systems, if I already know expected size, I may pre-size a list to reduce growth overhead.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the most common reason HashSet deduplication fails?...
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
) VALUES (
  'notion_q_23',
  'what-is-the-most-common-reason-hashset-deduplication-fails-23',
  'What is the most common reason HashSet deduplication fails?',
  'cat_java',
  'Easy',
  ARRAY['collections']::TEXT[],
  'Broken equals/hashCode contract.',
  'Broken equals/hashCode contract.
Another subtle bug is mutating fields that participate in hash calculation after insertion.
That second case sounds much more like real production experience.',
  NULL,
  'Broken equals/hashCode contract.
Another subtle bug is mutating fields that participate in hash calculation after insertion.
That second case sounds much more like real production experience.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When does TreeMap genuinely make sense?...
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
) VALUES (
  'notion_q_24',
  'when-does-treemap-genuinely-make-sense-24',
  'When does TreeMap genuinely make sense?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'When I need ordered keys, range scans, or interval-style logic.',
  'When I need ordered keys, range scans, or interval-style logic.
If I only need lookup, I do not use it just because it sounds more advanced.',
  NULL,
  'When I need ordered keys, range scans, or interval-style logic.
If I only need lookup, I do not use it just because it sounds more advanced.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain fail-fast vs fail-safe in a practical way?...
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
) VALUES (
  'notion_q_25',
  'how-do-you-explain-fail-fast-vs-fail-safe-in-a-practical-way-25',
  'How do you explain fail-fast vs fail-safe in a practical way?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'Fail-fast collections surface concurrent modification problems quickly.',
  'Fail-fast collections surface concurrent modification problems quickly.
Fail-safe or weakly consistent structures give you a safer iteration model in concurrent scenarios.
A useful real-world point is that CopyOnWriteArrayList makes reads easy but writes expensive.',
  NULL,
  'Fail-fast collections surface concurrent modification problems quickly.
Fail-safe or weakly consistent structures give you a safer iteration model in concurrent scenarios.
A useful real-world point is that CopyOnWriteArrayList makes reads easy but writes expensive.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you implement LRU, and why is that question still common?...
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
) VALUES (
  'notion_q_26',
  'how-would-you-implement-lru-and-why-is-that-question-still-common-26',
  'How would you implement LRU, and why is that question still common?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'Standard answer: HashMap + doubly linked list.',
  'Standard answer: HashMap + doubly linked list.
In Java, I would also mention LinkedHashMap if that is acceptable.
The value of the question is that it tests both data structure understanding and API judgment.',
  NULL,
  'Standard answer: HashMap + doubly linked list.
In Java, I would also mention LinkedHashMap if that is acceptable.
The value of the question is that it tests both data structure understanding and API judgment.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is CopyOnWriteArrayList a good idea, and when is it not?...
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
) VALUES (
  'notion_q_27',
  'when-is-copyonwritearraylist-a-good-idea-and-when-is-it-not-27',
  'When is CopyOnWriteArrayList a good idea, and when is it not?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'Good for read-heavy and write-light scenarios such as listener lists or configuration snapshots.',
  'Good for read-heavy and write-light scenarios such as listener lists or configuration snapshots.
Bad for frequent writes because every write copies the array.
That trade-off is what the interviewer wants, not just the phrase “thread-safe.”',
  NULL,
  'Good for read-heavy and write-light scenarios such as listener lists or configuration snapshots.
Bad for frequent writes because every write copies the array.
That trade-off is what the interviewer wants, not just the phrase “thread-safe.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is ConcurrentHashMap not enough to make business logic safe?...
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
) VALUES (
  'notion_q_28',
  'why-is-concurrenthashmap-not-enough-to-make-business-logic-safe-28',
  'Why is ConcurrentHashMap not enough to make business logic safe?',
  'cat_java',
  'Medium',
  ARRAY['hashmap', 'collections', 'concurrency']::TEXT[],
  'Because the map can be thread-safe while multi-step business logic is still racy.',
  'Because the map can be thread-safe while multi-step business logic is still racy.
get, decide, and put is not automatically atomic as a business operation.
Sometimes computeIfAbsent, CAS, locking, or a different design is required.',
  NULL,
  'Because the map can be thread-safe while multi-step business logic is still racy.
get, decide, and put is not automatically atomic as a business operation.
Sometimes computeIfAbsent, CAS, locking, or a different design is required.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- If the interviewer asks, “Have you ever seen a real collection-related bug?”, wh...
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
) VALUES (
  'notion_q_29',
  'if-the-interviewer-asks-have-you-ever-seen-a-real-collection-related-bug-what-wo-29',
  'If the interviewer asks, “Have you ever seen a real collection-related bug?”, what would you say?',
  'cat_java',
  'Medium',
  ARRAY['collections']::TEXT[],
  'Mutable keys in maps or sets',
  'Mutable keys in maps or sets
Loading too much data into memory at once
Treating a map as a cache with no expiry strategy
Accidentally sharing non-thread-safe collections across threads
Those answers sound more realistic than a pure theory response.',
  NULL,
  'Mutable keys in maps or sets
Loading too much data into memory at once
Treating a map as a cache with no expiry strategy
Accidentally sharing non-thread-safe collections across threads
Those answers sound more realistic than a pure theory response.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose between synchronized, volatile, and atomic classes?...
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
) VALUES (
  'notion_q_30',
  'how-do-you-choose-between-synchronized-volatile-and-atomic-classes-30',
  'How do you choose between synchronized, volatile, and atomic classes?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'volatile is for visibility and ordering, not for compound atomicity.',
  'volatile is for visibility and ordering, not for compound atomicity.
Atomic types are good for simple atomic state transitions.
If correctness depends on multiple related operations, locking is often clearer.',
  NULL,
  'volatile is for visibility and ordering, not for compound atomicity.
Atomic types are good for simple atomic state transitions.
If correctness depends on multiple related operations, locking is often clearer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can adding a thread pool actually make a system slower?...
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
) VALUES (
  'notion_q_31',
  'why-can-adding-a-thread-pool-actually-make-a-system-slower-31',
  'Why can adding a thread pool actually make a system slower?',
  'cat_java',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'Too many threads increase context switching.',
  'Too many threads increase context switching.
If the workload is I/O-bound, more threads may just overwhelm downstream systems faster.
A thread pool controls concurrency; it does not magically increase throughput.',
  NULL,
  'Too many threads increase context switching.
If the workload is I/O-bound, more threads may just overwhelm downstream systems faster.
A thread pool controls concurrency; it does not magically increase throughput.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you think about thread pool sizing?...
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
) VALUES (
  'notion_q_32',
  'how-do-you-think-about-thread-pool-sizing-32',
  'How do you think about thread pool sizing?',
  'cat_java',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'CPU-bound work starts near available cores.',
  'CPU-bound work starts near available cores.
I/O-bound work may justify more threads, but I still consider downstream latency, queueing, connection pools, and timeout policy.
I do not trust formulas blindly without end-to-end measurement.',
  NULL,
  'CPU-bound work starts near available cores.
I/O-bound work may justify more threads, but I still consider downstream latency, queueing, connection pools, and timeout policy.
I do not trust formulas blindly without end-to-end measurement.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Which thread pool parameters matter most in real incidents?...
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
) VALUES (
  'notion_q_33',
  'which-thread-pool-parameters-matter-most-in-real-incidents-33',
  'Which thread pool parameters matter most in real incidents?',
  'cat_java',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'Queue type and queue size',
  'Queue type and queue size
Rejection policy
Core/max size in relation to workload and downstream capacity
In practice, unbounded queues are often more dangerous than slightly undersized pools.',
  NULL,
  'Queue type and queue size
Rejection policy
Core/max size in relation to workload and downstream capacity
In practice, unbounded queues are often more dangerous than slightly undersized pools.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you diagnose deadlock or thread starvation in production?...
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
) VALUES (
  'notion_q_34',
  'how-do-you-diagnose-deadlock-or-thread-starvation-in-production-34',
  'How do you diagnose deadlock or thread starvation in production?',
  'cat_java',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'Capture thread dumps.',
  'Capture thread dumps.
Look at blocked/waiting distribution and lock ownership.
Check lock ordering, long critical sections, and whether external calls are made while holding locks.',
  NULL,
  'Capture thread dumps.
Look at blocked/waiting distribution and lock ownership.
Check lock ordering, long critical sections, and whether external calls are made while holding locks.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Where does ReentrantLock really beat synchronized?...
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
) VALUES (
  'notion_q_35',
  'where-does-reentrantlock-really-beat-synchronized-35',
  'Where does ReentrantLock really beat synchronized?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Interruptible lock acquisition',
  'Interruptible lock acquisition
Timeout support
Fairness options
Multiple condition variables
But I do not use it everywhere. For simple cases, synchronized is often better because the code is shorter and safer.',
  NULL,
  'Interruptible lock acquisition
Timeout support
Fairness options
Multiple condition variables
But I do not use it everywhere. For simple cases, synchronized is often better because the code is shorter and safer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does volatile not make i++ safe?...
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
) VALUES (
  'notion_q_36',
  'why-does-volatile-not-make-i-safe-36',
  'Why does volatile not make i++ safe?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because i++ is read, modify, write.',
  'Because i++ is read, modify, write.
volatile gives visibility, not atomic multi-step behavior.
This is a classic filter question for concurrency fundamentals.',
  NULL,
  'Because i++ is read, modify, write.
volatile gives visibility, not atomic multi-step behavior.
This is a classic filter question for concurrency fundamentals.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you actually use ThreadLocal?...
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
) VALUES (
  'notion_q_37',
  'when-do-you-actually-use-threadlocal-37',
  'When do you actually use ThreadLocal?',
  'cat_java',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'Request context',
  'Request context
Trace IDs
User context
Per-thread instances of non-thread-safe helpers
In thread pools, cleanup is mandatory.',
  NULL,
  'Request context
Trace IDs
User context
Per-thread instances of non-thread-safe helpers
In thread pools, cleanup is mandatory.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What are common CompletableFuture mistakes?...
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
) VALUES (
  'notion_q_38',
  'what-are-common-completablefuture-mistakes-38',
  'What are common CompletableFuture mistakes?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Using the wrong executor',
  'Using the wrong executor
Forgetting timeout handling
Ignoring exception flow
Parallelizing too aggressively and crushing downstream services
Assuming async always means faster',
  NULL,
  'Using the wrong executor
Forgetting timeout handling
Ignoring exception flow
Parallelizing too aggressively and crushing downstream services
Assuming async always means faster',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain concurrency vs parallelism in a useful way?...
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
) VALUES (
  'notion_q_39',
  'how-do-you-explain-concurrency-vs-parallelism-in-a-useful-way-39',
  'How do you explain concurrency vs parallelism in a useful way?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Concurrency is about progress among multiple tasks.',
  'Concurrency is about progress among multiple tasks.
Parallelism is about actual simultaneous execution.
A useful extra sentence is that more threads do not automatically mean more true parallel work.',
  NULL,
  'Concurrency is about progress among multiple tasks.
Parallelism is about actual simultaneous execution.
A useful extra sentence is that more threads do not automatically mean more true parallel work.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does HashMap not always treeify as soon as a bucket reaches length 8?...
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
) VALUES (
  'notion_q_40',
  'why-does-hashmap-not-always-treeify-as-soon-as-a-bucket-reaches-length-8-40',
  'Why does HashMap not always treeify as soon as a bucket reaches length 8?',
  'cat_java',
  'Medium',
  ARRAY['hashmap']::TEXT[],
  'Because capacity also matters.',
  'Because capacity also matters.
If the table is still too small, resize can be preferred over treeification.
That question separates memorization from actual understanding.',
  NULL,
  'Because capacity also matters.
If the table is still too small, resize can be preferred over treeification.
That question separates memorization from actual understanding.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is notifyAll() often safer than notify()?...
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
) VALUES (
  'notion_q_41',
  'why-is-notifyall-often-safer-than-notify-41',
  'Why is notifyAll() often safer than notify()?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because you do not control which waiting thread wakes up.',
  'Because you do not control which waiting thread wakes up.
The wrong thread may wake, fail its condition, and go back to waiting.
Unless the wait model is very simple, notifyAll() is usually the safer answer.',
  NULL,
  'Because you do not control which waiting thread wakes up.
The wrong thread may wake, fail its condition, and go back to waiting.
Unless the wait model is very simple, notifyAll() is usually the safer answer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why should wait() usually be guarded by while, not if?...
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
) VALUES (
  'notion_q_42',
  'why-should-wait-usually-be-guarded-by-while-not-if-42',
  'Why should wait() usually be guarded by while, not if?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because of spurious wakeups.',
  'Because of spurious wakeups.
Wakeup does not guarantee the condition is now true.
while makes the code re-check the condition before continuing.',
  NULL,
  'Because of spurious wakeups.
Wakeup does not guarantee the condition is now true.
while makes the code re-check the condition before continuing.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do we usually restore interrupt status after catching InterruptedException?...
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
) VALUES (
  'notion_q_43',
  'why-do-we-usually-restore-interrupt-status-after-catching-interruptedexception-43',
  'Why do we usually restore interrupt status after catching InterruptedException?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because the interrupt flag is typically cleared when the exception is thrown.',
  'Because the interrupt flag is typically cleared when the exception is thrown.
If you swallow the exception, upper layers may never know the thread was asked to stop.
A very common correct pattern is Thread.currentThread().interrupt().',
  NULL,
  'Because the interrupt flag is typically cleared when the exception is thrown.
If you swallow the exception, upper layers may never know the thread was asked to stop.
A very common correct pattern is Thread.currentThread().interrupt().',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is submit() vs execute() a useful detail question?...
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
) VALUES (
  'notion_q_44',
  'why-is-submit-vs-execute-a-useful-detail-question-44',
  'Why is submit() vs execute() a useful detail question?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'submit() wraps exceptions inside Future.',
  'submit() wraps exceptions inside Future.
execute() lets exceptions surface differently.
In real code, many teams think tasks “did not fail” when they actually failed and nobody called Future.get().',
  NULL,
  'submit() wraps exceptions inside Future.
execute() lets exceptions surface differently.
In real code, many teams think tasks “did not fail” when they actually failed and nobody called Future.get().',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can ConcurrentHashMap still allow a race in business logic?...
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
) VALUES (
  'notion_q_45',
  'why-can-concurrenthashmap-still-allow-a-race-in-business-logic-45',
  'Why can ConcurrentHashMap still allow a race in business logic?',
  'cat_java',
  'Medium',
  ARRAY['hashmap', 'concurrency']::TEXT[],
  'Because thread-safe data structure operations are not the same as atomic business workflows.',
  'Because thread-safe data structure operations are not the same as atomic business workflows.
get, check, and update across multiple steps can still race.',
  NULL,
  'Because thread-safe data structure operations are not the same as atomic business workflows.
get, check, and update across multiple steps can still race.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is volatile required in double-checked locking?...
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
) VALUES (
  'notion_q_46',
  'why-is-volatile-required-in-double-checked-locking-46',
  'Why is volatile required in double-checked locking?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Not only for visibility, but to prevent dangerous instruction reordering.',
  'Not only for visibility, but to prevent dangerous instruction reordering.
Without it, another thread can observe a reference to a partially constructed object.',
  NULL,
  'Not only for visibility, but to prevent dangerous instruction reordering.
Without it, another thread can observe a reference to a partially constructed object.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do static synchronized methods and instance synchronized methods not block e...
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
) VALUES (
  'notion_q_47',
  'why-do-static-synchronized-methods-and-instance-synchronized-methods-not-block-e-47',
  'Why do static synchronized methods and instance synchronized methods not block each other?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because they lock different monitors.',
  'Because they lock different monitors.
Instance methods lock this; static methods lock the Class object.',
  NULL,
  'Because they lock different monitors.
Instance methods lock this; static methods lock the Class object.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can ThreadLocal still leak even though its key is weakly referenced?...
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
) VALUES (
  'notion_q_48',
  'why-can-threadlocal-still-leak-even-though-its-key-is-weakly-referenced-48',
  'Why can ThreadLocal still leak even though its key is weakly referenced?',
  'cat_java',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'Because the value can remain attached to the thread until cleanup.',
  'Because the value can remain attached to the thread until cleanup.
In thread pools, long-lived worker threads amplify this problem.',
  NULL,
  'Because the value can remain attached to the thread until cleanup.
In thread pools, long-lived worker threads amplify this problem.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “LinkedList has O(1) insertion” often an incomplete or misleading answer?...
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
) VALUES (
  'notion_q_49',
  'why-is-linkedlist-has-o1-insertion-often-an-incomplete-or-misleading-answer-49',
  'Why is “LinkedList has O(1) insertion” often an incomplete or misleading answer?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because asymptotic insertion cost ignores the cost of finding the insertion point.',
  'This page is intentionally broad and detailed. The same structure will be used for Week 2, Week 3, Week 4, and the algorithm explanation bank.',
  NULL,
  'Because asymptotic insertion cost ignores the cost of finding the insertion point.
It also ignores cache locality and object overhead.
Strong candidates mention that theory and practical runtime behavior are not always aligned.
JVM answers should connect to metrics, GC behavior, and incident diagnosis.
Core Java answers should connect to correctness, maintainability, and common bugs.
Collection answers should connect to real misuse, not just time complexity tables.
Concurrency answers should connect to thread pools, downstream protection, retries, idempotency, and failure modes.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain happens-before in a practical way?...
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
) VALUES (
  'notion_q_50',
  'how-do-you-explain-happens-before-in-a-practical-way-50',
  'How do you explain happens-before in a practical way?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'It defines when one thread''s writes are guaranteed to be visible to another thread.',
  'It defines when one thread''s writes are guaranteed to be visible to another thread.
The common sources are locks, volatile write-read pairs, thread start and join, and completion through thread-safe concurrency primitives.
A strong practical answer connects happens-before to real bugs such as stale flags, partially visible state, or broken publication.',
  NULL,
  'It defines when one thread''s writes are guaranteed to be visible to another thread.
The common sources are locks, volatile write-read pairs, thread start and join, and completion through thread-safe concurrency primitives.
A strong practical answer connects happens-before to real bugs such as stale flags, partially visible state, or broken publication.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does volatile fix visibility but not compound actions?...
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
) VALUES (
  'notion_q_51',
  'why-does-volatile-fix-visibility-but-not-compound-actions-51',
  'Why does volatile fix visibility but not compound actions?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'volatile guarantees visibility and ordering around that variable, but it does not make read-modify-write sequences atomic.',
  'volatile guarantees visibility and ordering around that variable, but it does not make read-modify-write sequences atomic.
Operations like i++ can still lose updates because multiple threads interleave the read and write steps.
If the invariant is compound, use synchronization, locks, or atomic classes designed for that operation.',
  NULL,
  'volatile guarantees visibility and ordering around that variable, but it does not make read-modify-write sequences atomic.
Operations like i++ can still lose updates because multiple threads interleave the read and write steps.
If the invariant is compound, use synchronization, locks, or atomic classes designed for that operation.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do class loading, linking, and initialization differ in a practical explanat...
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
) VALUES (
  'notion_q_52',
  'how-do-class-loading-linking-and-initialization-differ-in-a-practical-explanatio-52',
  'How do class loading, linking, and initialization differ in a practical explanation?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'Loading brings the class bytecode into the JVM and creates class metadata.',
  'Loading brings the class bytecode into the JVM and creates class metadata.
Linking verifies the class, prepares static storage, and resolves symbolic references when needed.
Initialization is the point where static initializers and static field assignments actually run.
This explanation is useful because it helps you reason about static-order bugs, lazy loading, and classloader problems.',
  NULL,
  'Loading brings the class bytecode into the JVM and creates class metadata.
Linking verifies the class, prepares static storage, and resolves symbolic references when needed.
Initialization is the point where static initializers and static field assignments actually run.
This explanation is useful because it helps you reason about static-order bugs, lazy loading, and classloader problems.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What actually happens when a Java object is created?...
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
) VALUES (
  'notion_q_53',
  'what-actually-happens-when-a-java-object-is-created-53',
  'What actually happens when a Java object is created?',
  'cat_java',
  'Medium',
  ARRAY['general']::TEXT[],
  'The JVM allocates memory, zero-initializes fields, sets the object header, runs the constructor chain, and then returns the reference.',
  'The JVM allocates memory, zero-initializes fields, sets the object header, runs the constructor chain, and then returns the reference.
A strong answer also mentions that publication to other threads is a separate concern from construction itself.
This is why object creation and safe publication should be discussed together in concurrent services.',
  NULL,
  'The JVM allocates memory, zero-initializes fields, sets the object header, runs the constructor chain, and then returns the reference.
A strong answer also mentions that publication to other threads is a separate concern from construction itself.
This is why object creation and safe publication should be discussed together in concurrent services.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is safe publication, and why does it matter in backend services?...
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
) VALUES (
  'notion_q_54',
  'what-is-safe-publication-and-why-does-it-matter-in-backend-services-54',
  'What is safe publication, and why does it matter in backend services?',
  'cat_java',
  'Easy',
  ARRAY['general']::TEXT[],
  'An object is safely published when other threads cannot observe a partially constructed or stale version of it.',
  'An object is safely published when other threads cannot observe a partially constructed or stale version of it.
Common safe publication paths include final fields, static initialization, volatile references, locks, and thread-safe containers.
Unsafe publication creates rare and painful bugs because the code may look correct in tests but fail under concurrency.',
  NULL,
  'An object is safely published when other threads cannot observe a partially constructed or stale version of it.
Common safe publication paths include final fields, static initialization, volatile references, locks, and thread-safe containers.
Unsafe publication creates rare and painful bugs because the code may look correct in tests but fail under concurrency.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What exactly does the Spring container do for you?...
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
) VALUES (
  'notion_q_55',
  'what-exactly-does-the-spring-container-do-for-you-55',
  'What exactly does the Spring container do for you?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'More than IoC and DI, it manages object lifecycle, dependency wiring, configuration binding, proxies, and cross-cutting concerns.',
  'More than IoC and DI, it manages object lifecycle, dependency wiring, configuration binding, proxies, and cross-cutting concerns.
A strong answer is: Spring manages application objects and infrastructure concerns so business code stays focused.',
  NULL,
  'More than IoC and DI, it manages object lifecycle, dependency wiring, configuration binding, proxies, and cross-cutting concerns.
A strong answer is: Spring manages application objects and infrastructure concerns so business code stays focused.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain the Bean lifecycle in a way that sounds practical?...
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
) VALUES (
  'notion_q_56',
  'how-do-you-explain-the-bean-lifecycle-in-a-way-that-sounds-practical-56',
  'How do you explain the Bean lifecycle in a way that sounds practical?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Instantiation',
  'Instantiation
Dependency injection
Bean post-processing / aware callbacks
Initialization
Ready for use
Destruction on shutdown
The point is not just to list callbacks, but to show you understand where frameworks can extend object behavior.',
  NULL,
  'Instantiation
Dependency injection
Bean post-processing / aware callbacks
Initialization
Ready for use
Destruction on shutdown
The point is not just to list callbacks, but to show you understand where frameworks can extend object behavior.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is field injection often discouraged?...
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
) VALUES (
  'notion_q_57',
  'why-is-field-injection-often-discouraged-57',
  'Why is field injection often discouraged?',
  'cat_java',
  'Medium',
  ARRAY['spring', 'rag']::TEXT[],
  'Hidden dependencies',
  'Hidden dependencies
Harder testing
Harder immutability
Constructor injection makes design clearer and easier to validate.',
  NULL,
  'Hidden dependencies
Harder testing
Harder immutability
Constructor injection makes design clearer and easier to validate.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Is a Spring singleton bean automatically thread-safe?...
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
) VALUES (
  'notion_q_58',
  'is-a-spring-singleton-bean-automatically-thread-safe-58',
  'Is a Spring singleton bean automatically thread-safe?',
  'cat_java',
  'Medium',
  ARRAY['concurrency', 'spring']::TEXT[],
  'No.',
  'No.
Spring ensures a single instance, not safe mutable state.
If the bean has mutable shared fields, concurrency bugs are still possible.',
  NULL,
  'No.
Spring ensures a single instance, not safe mutable state.
If the bean has mutable shared fields, concurrency bugs are still possible.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does @Transactional sometimes appear to do nothing?...
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
) VALUES (
  'notion_q_59',
  'why-does-transactional-sometimes-appear-to-do-nothing-59',
  'Why does @Transactional sometimes appear to do nothing?',
  'cat_java',
  'Medium',
  ARRAY['spring', 'transactions']::TEXT[],
  'Self-invocation bypasses the proxy.',
  'Self-invocation bypasses the proxy.
Private methods are a common trap.
Rollback rules may not match the thrown exception type.
In some cases the database or storage layer may not support the semantics you expect.',
  NULL,
  'Self-invocation bypasses the proxy.
Private methods are a common trap.
Rollback rules may not match the thrown exception type.
In some cases the database or storage layer may not support the semantics you expect.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When does Spring transaction rollback happen by default?...
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
) VALUES (
  'notion_q_60',
  'when-does-spring-transaction-rollback-happen-by-default-60',
  'When does Spring transaction rollback happen by default?',
  'cat_java',
  'Medium',
  ARRAY['spring', 'transactions']::TEXT[],
  'By default, on runtime exceptions and errors.',
  'By default, on runtime exceptions and errors.
Checked exceptions do not trigger rollback unless configured.
This is a common detail question and worth answering precisely.',
  NULL,
  'By default, on runtime exceptions and errors.
Checked exceptions do not trigger rollback unless configured.
This is a common detail question and worth answering precisely.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Which transaction propagation modes do you actually use most?...
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
) VALUES (
  'notion_q_61',
  'which-transaction-propagation-modes-do-you-actually-use-most-61',
  'Which transaction propagation modes do you actually use most?',
  'cat_java',
  'Medium',
  ARRAY['spring', 'transactions']::TEXT[],
  'REQUIRED is the default and most common.',
  'REQUIRED is the default and most common.
REQUIRES_NEW is useful for audit records, compensation logs, or side actions that should commit independently.
The real signal is whether you use propagation for a business reason, not because you memorized all options.',
  NULL,
  'REQUIRED is the default and most common.
REQUIRES_NEW is useful for audit records, compensation logs, or side actions that should commit independently.
The real signal is whether you use propagation for a business reason, not because you memorized all options.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Does readOnly = true really improve performance?...
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
) VALUES (
  'notion_q_62',
  'does-readonly-true-really-improve-performance-62',
  'Does readOnly = true really improve performance?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Sometimes, depending on framework and database.',
  'Sometimes, depending on framework and database.
I treat it more as an intent signal and possible optimization hint than as a guaranteed performance feature.
It is useful, but not magic.',
  NULL,
  'Sometimes, depending on framework and database.
I treat it more as an intent signal and possible optimization hint than as a guaranteed performance feature.
It is useful, but not magic.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain Spring AOP without sounding abstract?...
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
) VALUES (
  'notion_q_63',
  'how-do-you-explain-spring-aop-without-sounding-abstract-63',
  'How do you explain Spring AOP without sounding abstract?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'I immediately connect it to logging, auditing, tracing, security, and transactions.',
  'I immediately connect it to logging, auditing, tracing, security, and transactions.
Then I mention that Spring AOP is proxy-based and that this creates limitations around self-invocation and method visibility.',
  NULL,
  'I immediately connect it to logging, auditing, tracing, security, and transactions.
Then I mention that Spring AOP is proxy-based and that this creates limitations around self-invocation and method visibility.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you distinguish Filter, Interceptor, and AOP?...
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
) VALUES (
  'notion_q_64',
  'how-do-you-distinguish-filter-interceptor-and-aop-64',
  'How do you distinguish Filter, Interceptor, and AOP?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Filter is closest to the servlet layer.',
  'Filter is closest to the servlet layer.
Interceptor is closer to Spring MVC request handling.
AOP is better for method-level cross-cutting concerns.
In real systems, they often coexist for different reasons.',
  NULL,
  'Filter is closest to the servlet layer.
Interceptor is closer to Spring MVC request handling.
AOP is better for method-level cross-cutting concerns.
In real systems, they often coexist for different reasons.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- A Spring Boot service starts slowly. How do you investigate?...
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
) VALUES (
  'notion_q_65',
  'a-spring-boot-service-starts-slowly-how-do-you-investigate-65',
  'A Spring Boot service starts slowly. How do you investigate?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Check component scanning scope.',
  'Check component scanning scope.
Check auto-configuration that you do not actually need.
Check external dependency initialization, configuration loading, database warmup, and bean creation timing.
Slow startup is often caused by too much framework work before the app even handles traffic.',
  NULL,
  'Check component scanning scope.
Check auto-configuration that you do not actually need.
Check external dependency initialization, configuration loading, database warmup, and bean creation timing.
Slow startup is often caused by too much framework work before the app even handles traffic.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you think about circular dependency issues?...
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
) VALUES (
  'notion_q_66',
  'how-do-you-think-about-circular-dependency-issues-66',
  'How do you think about circular dependency issues?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'I treat them first as a design smell.',
  'I treat them first as a design smell.
Field injection and framework tricks can sometimes hide them, but that does not mean the design is healthy.
In most cases, splitting responsibilities is cleaner than “getting Spring to allow it.”',
  NULL,
  'I treat them first as a design smell.
Field injection and framework tricks can sometimes hide them, but that does not mean the design is healthy.
In most cases, splitting responsibilities is cleaner than “getting Spring to allow it.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is @Async frequently misused?...
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
) VALUES (
  'notion_q_67',
  'why-is-async-frequently-misused-67',
  'Why is @Async frequently misused?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Wrong executor',
  'Wrong executor
No timeout discipline
No context propagation
No downstream protection
Many teams use async to hide latency instead of reducing real bottlenecks.',
  NULL,
  'Wrong executor
No timeout discipline
No context propagation
No downstream protection
Many teams use async to hide latency instead of reducing real bottlenecks.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you use @ConfigurationProperties instead of @Value?...
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
) VALUES (
  'notion_q_68',
  'when-do-you-use-configurationproperties-instead-of-value-68',
  'When do you use @ConfigurationProperties instead of @Value?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'I use @Value for small, isolated values.',
  'I use @Value for small, isolated values.
I use @ConfigurationProperties for structured config because it is easier to validate, maintain, and reason about.',
  NULL,
  'I use @Value for small, isolated values.
I use @ConfigurationProperties for structured config because it is easier to validate, maintain, and reason about.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Walk me through a normal Spring MVC request....
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
) VALUES (
  'notion_q_69',
  'walk-me-through-a-normal-spring-mvc-request-69',
  'Walk me through a normal Spring MVC request.',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Filter chain',
  'Filter chain
DispatcherServlet
Handler mapping
Interceptors
Controller
Service / repository path
Response conversion or exception mapping
A clean explanation shows you understand the request lifecycle, not just controller annotations.',
  NULL,
  'Filter chain
DispatcherServlet
Handler mapping
Interceptors
Controller
Service / repository path
Response conversion or exception mapping
A clean explanation shows you understand the request lifecycle, not just controller annotations.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why should a controller avoid mutable shared state?...
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
) VALUES (
  'notion_q_70',
  'why-should-a-controller-avoid-mutable-shared-state-70',
  'Why should a controller avoid mutable shared state?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Controllers are usually singleton beans.',
  'Controllers are usually singleton beans.
Mutable fields inside them can become shared state across concurrent requests.
Request-specific state belongs in method parameters, local variables, or scoped context.',
  NULL,
  'Controllers are usually singleton beans.
Mutable fields inside them can become shared state across concurrent requests.
Request-specific state belongs in method parameters, local variables, or scoped context.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you use Spring application events?...
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
) VALUES (
  'notion_q_71',
  'when-do-you-use-spring-application-events-71',
  'When do you use Spring application events?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Small in-process decoupling cases such as internal notifications, metrics hooks, or post-action side effects.',
  'Small in-process decoupling cases such as internal notifications, metrics hooks, or post-action side effects.
I would not use them as a replacement for reliable inter-service messaging.',
  NULL,
  'Small in-process decoupling cases such as internal notifications, metrics hooks, or post-action side effects.
I would not use them as a replacement for reliable inter-service messaging.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer Spring Security questions like someone who has used it?...
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
) VALUES (
  'notion_q_72',
  'how-do-you-answer-spring-security-questions-like-someone-who-has-used-it-72',
  'How do you answer Spring Security questions like someone who has used it?',
  'cat_java',
  'Medium',
  ARRAY['spring']::TEXT[],
  'Talk about filter chain, authentication flow, token validation, authorization boundaries, and method-level protection.',
  'Talk about filter chain, authentication flow, token validation, authorization boundaries, and method-level protection.
If JWT is involved, mention expiry, refresh, logout semantics, and revocation strategy.',
  NULL,
  'Talk about filter chain, authentication flow, token validation, authorization boundaries, and method-level protection.
If JWT is involved, mention expiry, refresh, logout semantics, and revocation strategy.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does InnoDB use B+Tree indexes?...
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
) VALUES (
  'notion_q_73',
  'why-does-innodb-use-btree-indexes-73',
  'Why does InnoDB use B+Tree indexes?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'indexing', 'transactions']::TEXT[],
  'Low tree height, fewer disk I/Os, and efficient range scanning.',
  'Low tree height, fewer disk I/Os, and efficient range scanning.
The linked leaf nodes are especially useful for ordered and range-based access patterns.
The best answer connects index design to storage behavior, not just to asymptotic complexity.',
  NULL,
  'Low tree height, fewer disk I/Os, and efficient range scanning.
The linked leaf nodes are especially useful for ordered and range-based access patterns.
The best answer connects index design to storage behavior, not just to asymptotic complexity.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you decide the column order in a composite index?...
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
) VALUES (
  'notion_q_74',
  'how-do-you-decide-the-column-order-in-a-composite-index-74',
  'How do you decide the column order in a composite index?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'indexing', 'transactions']::TEXT[],
  'I look at real query patterns first.',
  'I look at real query patterns first.
Equality predicates, sorting, range conditions, and covering-index opportunities all matter.
“Most selective first” is not always enough.',
  NULL,
  'I look at real query patterns first.
Equality predicates, sorting, range conditions, and covering-index opportunities all matter.
“Most selective first” is not always enough.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can a query ignore an index even when the index exists?...
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
) VALUES (
  'notion_q_75',
  'why-can-a-query-ignore-an-index-even-when-the-index-exists-75',
  'Why can a query ignore an index even when the index exists?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'indexing', 'transactions']::TEXT[],
  'Function on indexed column',
  'Function on indexed column
Implicit type conversion
Leading wildcard in LIKE
Low selectivity
Optimizer deciding full scan is cheaper
This is where real EXPLAIN experience shows up.',
  NULL,
  'Function on indexed column
Implicit type conversion
Leading wildcard in LIKE
Low selectivity
Optimizer deciding full scan is cheaper
This is where real EXPLAIN experience shows up.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you analyze a slow SQL query?...
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
) VALUES (
  'notion_q_76',
  'how-do-you-analyze-a-slow-sql-query-76',
  'How do you analyze a slow SQL query?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Get the real SQL and parameters.',
  'Get the real SQL and parameters.
Check execution plan.
Look at scanned rows, join strategy, sorting, temporary tables, and whether the index path is reasonable.
Then decide whether the problem is SQL shape, indexing, data distribution, or a broader design issue.',
  NULL,
  'Get the real SQL and parameters.
Check execution plan.
Look at scanned rows, join strategy, sorting, temporary tables, and whether the index path is reasonable.
Then decide whether the problem is SQL shape, indexing, data distribution, or a broader design issue.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does a covering index often help so much?...
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
) VALUES (
  'notion_q_77',
  'why-does-a-covering-index-often-help-so-much-77',
  'Why does a covering index often help so much?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'indexing', 'transactions']::TEXT[],
  'Because it avoids going back to the base table.',
  'Because it avoids going back to the base table.
If all required columns are already in the index, the read path is shorter and cheaper.
This is a very practical reason to avoid select * when you do not need it.',
  NULL,
  'Because it avoids going back to the base table.
If all required columns are already in the index, the read path is shorter and cheaper.
This is a very practical reason to avoid select * when you do not need it.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain count(*) vs count(1) vs count(column) like an engineer, not l...
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
) VALUES (
  'notion_q_78',
  'how-do-you-explain-count-vs-count1-vs-countcolumn-like-an-engineer-not-like-a-fo-78',
  'How do you explain count(*) vs count(1) vs count(column) like an engineer, not like a forum post?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'In InnoDB, count(*) and count(1) are usually similar.',
  'In InnoDB, count(*) and count(1) are usually similar.
count(column) ignores nulls.
The more useful discussion is whether the query shape is reasonable for a large table at all.',
  NULL,
  'In InnoDB, count(*) and count(1) are usually similar.
count(column) ignores nulls.
The more useful discussion is whether the query shape is reasonable for a large table at all.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Which transaction isolation level matters most in MySQL interviews?...
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
) VALUES (
  'notion_q_79',
  'which-transaction-isolation-level-matters-most-in-mysql-interviews-79',
  'Which transaction isolation level matters most in MySQL interviews?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'InnoDB defaults to REPEATABLE READ.',
  'InnoDB defaults to REPEATABLE READ.
But what matters is that you understand phantom reads, next-key locking, and practical concurrency effects.
Strong candidates connect theory to blocking behavior.',
  NULL,
  'InnoDB defaults to REPEATABLE READ.
But what matters is that you understand phantom reads, next-key locking, and practical concurrency effects.
Strong candidates connect theory to blocking behavior.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why are gap locks and next-key locks important in interviews?...
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
) VALUES (
  'notion_q_80',
  'why-are-gap-locks-and-next-key-locks-important-in-interviews-80',
  'Why are gap locks and next-key locks important in interviews?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Because they explain why writes can block wider ranges than people expect.',
  'Because they explain why writes can block wider ranges than people expect.
If you know only isolation-level names but not locking behavior, your answer sounds incomplete.',
  NULL,
  'Because they explain why writes can block wider ranges than people expect.
If you know only isolation-level names but not locking behavior, your answer sounds incomplete.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose between optimistic and pessimistic locking?...
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
) VALUES (
  'notion_q_81',
  'how-do-you-choose-between-optimistic-and-pessimistic-locking-81',
  'How do you choose between optimistic and pessimistic locking?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Optimistic locking is better when contention is low and retries are acceptable.',
  'Optimistic locking is better when contention is low and retries are acceptable.
Pessimistic locking makes more sense when conflict is high and retry cost is too expensive.
I always tie that decision back to the specific business path.',
  NULL,
  'Optimistic locking is better when contention is low and retries are acceptable.
Pessimistic locking makes more sense when conflict is high and retry cost is too expensive.
I always tie that decision back to the specific business path.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you handle database deadlocks in practice?...
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
) VALUES (
  'notion_q_82',
  'how-do-you-handle-database-deadlocks-in-practice-82',
  'How do you handle database deadlocks in practice?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'I do not assume they can be eliminated entirely.',
  'I do not assume they can be eliminated entirely.
I standardize lock order where possible, keep transactions short, and implement retry on deadlock.
The real mistake is treating deadlocks as “should never happen.”',
  NULL,
  'I do not assume they can be eliminated entirely.
I standardize lock order where possible, keep transactions short, and implement retry on deadlock.
The real mistake is treating deadlocks as “should never happen.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What problem does read/write splitting introduce most often?...
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
) VALUES (
  'notion_q_83',
  'what-problem-does-readwrite-splitting-introduce-most-often-83',
  'What problem does read/write splitting introduce most often?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Replica lag.',
  'Replica lag.
After writing, a read routed to a replica may return stale data.
Important workflows often need primary-read guarantees or consistency-aware routing.',
  NULL,
  'Replica lag.
After writing, a read routed to a replica may return stale data.
Important workflows often need primary-read guarantees or consistency-aware routing.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do you avoid oversized transactions?...
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
) VALUES (
  'notion_q_84',
  'why-do-you-avoid-oversized-transactions-84',
  'Why do you avoid oversized transactions?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Long lock hold time',
  'Long lock hold time
Higher rollback cost
More contention
Greater deadlock risk
In real systems, shrinking the transaction boundary is often better than adding complexity later.',
  NULL,
  'Long lock hold time
Higher rollback cost
More contention
Greater deadlock risk
In real systems, shrinking the transaction boundary is often better than adding complexity later.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does LIMIT offset pagination become slow?...
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
) VALUES (
  'notion_q_85',
  'why-does-limit-offset-pagination-become-slow-85',
  'Why does LIMIT offset pagination become slow?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Because the database still has to skip through the earlier rows.',
  'Because the database still has to skip through the earlier rows.
Large offsets create waste.
Cursor-style or keyset pagination is often a better production answer.',
  NULL,
  'Because the database still has to skip through the earlier rows.
Large offsets create waste.
Cursor-style or keyset pagination is often a better production answer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why should you avoid sharding too early?...
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
) VALUES (
  'notion_q_86',
  'why-should-you-avoid-sharding-too-early-86',
  'Why should you avoid sharding too early?',
  'cat_sql',
  'Medium',
  ARRAY['database', 'transactions']::TEXT[],
  'Because it increases routing, aggregation, transaction, pagination, and scaling complexity dramatically.',
  'Because it increases routing, aggregation, transaction, pagination, and scaling complexity dramatically.
Before sharding, I prefer to exhaust indexing, query design, archiving, caching, and replica strategies.',
  NULL,
  'Because it increases routing, aggregation, transaction, pagination, and scaling complexity dramatically.
Before sharding, I prefer to exhaust indexing, query design, archiving, caching, and replica strategies.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Is Redis only a cache in your systems?...
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
) VALUES (
  'notion_q_87',
  'is-redis-only-a-cache-in-your-systems-87',
  'Is Redis only a cache in your systems?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'No.',
  'No.
It can also support counters, rate limits, idempotency markers, short-lived state, leaderboards, and distributed coordination.
But I do not force long-lived business truth into Redis if a database is the correct source of record.',
  NULL,
  'No.
It can also support counters, rate limits, idempotency markers, short-lived state, leaderboards, and distributed coordination.
But I do not force long-lived business truth into Redis if a database is the correct source of record.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you distinguish cache penetration, breakdown, and avalanche?...
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
) VALUES (
  'notion_q_88',
  'how-do-you-distinguish-cache-penetration-breakdown-and-avalanche-88',
  'How do you distinguish cache penetration, breakdown, and avalanche?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Penetration: requests for data that does not exist',
  'Penetration: requests for data that does not exist
Breakdown: a hot key expires and DB gets hammered
Avalanche: many keys expire together
A strong answer always includes mitigation, not just definitions.',
  NULL,
  'Penetration: requests for data that does not exist
Breakdown: a hot key expires and DB gets hammered
Avalanche: many keys expire together
A strong answer always includes mitigation, not just definitions.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you handle a hot key problem?...
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
) VALUES (
  'notion_q_89',
  'how-do-you-handle-a-hot-key-problem-89',
  'How do you handle a hot key problem?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Multi-layer caching',
  'Multi-layer caching
TTL jitter
Pre-warming
Request coalescing
Special protection for extremely hot keys',
  NULL,
  'Multi-layer caching
TTL jitter
Pre-warming
Request coalescing
Special protection for extremely hot keys',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why are big keys dangerous?...
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
) VALUES (
  'notion_q_90',
  'why-are-big-keys-dangerous-90',
  'Why are big keys dangerous?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Heavy network transfer',
  'Heavy network transfer
Serialization/deserialization cost
Slow deletion
Higher single-operation blast radius
In practice, I prefer splitting large structures instead of storing giant monolith values.',
  NULL,
  'Heavy network transfer
Serialization/deserialization cost
Slow deletion
Higher single-operation blast radius
In practice, I prefer splitting large structures instead of storing giant monolith values.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you keep cache and database reasonably consistent?...
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
) VALUES (
  'notion_q_91',
  'how-do-you-keep-cache-and-database-reasonably-consistent-91',
  'How do you keep cache and database reasonably consistent?',
  'cat_system',
  'Medium',
  ARRAY['database', 'redis']::TEXT[],
  'I usually treat this as eventual consistency, not absolute consistency.',
  'I usually treat this as eventual consistency, not absolute consistency.
A common practical pattern is write DB first, then invalidate cache.
For tighter guarantees, I consider MQ, binlog-based synchronization, or retry-based compensation.',
  NULL,
  'I usually treat this as eventual consistency, not absolute consistency.
A common practical pattern is write DB first, then invalidate cache.
For tighter guarantees, I consider MQ, binlog-based synchronization, or retry-based compensation.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “delete cache first, then write DB” risky?...
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
) VALUES (
  'notion_q_92',
  'why-is-delete-cache-first-then-write-db-risky-92',
  'Why is “delete cache first, then write DB” risky?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Because concurrent reads may refill stale data into cache before the DB write completes.',
  'Because concurrent reads may refill stale data into cache before the DB write completes.
Write-DB-then-invalidate is usually safer.
This is one of the most common cache consistency detail questions.',
  NULL,
  'Because concurrent reads may refill stale data into cache before the DB write completes.
Write-DB-then-invalidate is usually safer.
This is one of the most common cache consistency detail questions.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain RDB vs AOF in Redis like someone who has operated it?...
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
) VALUES (
  'notion_q_93',
  'how-do-you-explain-rdb-vs-aof-in-redis-like-someone-who-has-operated-it-93',
  'How do you explain RDB vs AOF in Redis like someone who has operated it?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'RDB is snapshot-oriented, lighter, and faster to restore.',
  'RDB is snapshot-oriented, lighter, and faster to restore.
AOF is append-log based and usually gives better durability at the cost of more I/O and potentially larger files.
The right answer depends on recovery and durability goals, not on ideology.',
  NULL,
  'RDB is snapshot-oriented, lighter, and faster to restore.
AOF is append-log based and usually gives better durability at the cost of more I/O and potentially larger files.
The right answer depends on recovery and durability goals, not on ideology.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is SETNX alone not enough for a distributed lock?...
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
) VALUES (
  'notion_q_94',
  'why-is-setnx-alone-not-enough-for-a-distributed-lock-94',
  'Why is SETNX alone not enough for a distributed lock?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'You need expiry.',
  'You need expiry.
You need a unique token/value.
Unlock must verify ownership before deleting.
Otherwise you can release someone else’s lock or leave stale locks behind.',
  NULL,
  'You need expiry.
You need a unique token/value.
Unlock must verify ownership before deleting.
Otherwise you can release someone else’s lock or leave stale locks behind.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you implement idempotency with Redis?...
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
) VALUES (
  'notion_q_95',
  'how-do-you-implement-idempotency-with-redis-95',
  'How do you implement idempotency with Redis?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Use a well-designed idempotency key.',
  'Use a well-designed idempotency key.
Store request state with expiry.
Decide what happens on retries, partial failures, and timeout cases.
Redis helps, but the hard part is state semantics, not the API call.',
  NULL,
  'Use a well-designed idempotency key.
Store request state with expiry.
Decide what happens on retries, partial failures, and timeout cases.
Redis helps, but the hard part is state semantics, not the API call.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do you not cache everything?...
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
) VALUES (
  'notion_q_96',
  'why-do-you-not-cache-everything-96',
  'Why do you not cache everything?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Poor hit rate may not justify complexity.',
  'Poor hit rate may not justify complexity.
Consistency cost may be too high.
Memory cost matters.
I focus on high-read, hot, and value-dense access paths.',
  NULL,
  'Poor hit rate may not justify complexity.
Consistency cost may be too high.
Memory cost matters.
I focus on high-read, hot, and value-dense access paths.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What happens if Redis goes down?...
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
) VALUES (
  'notion_q_97',
  'what-happens-if-redis-goes-down-97',
  'What happens if Redis goes down?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'First I ask whether Redis is an acceleration component or a correctness dependency.',
  'First I ask whether Redis is an acceleration component or a correctness dependency.
If it is only cache, I need controlled DB fallback and traffic protection.
If it is central for locks, sessions, or throttling, the failure mode is much more serious.',
  NULL,
  'First I ask whether Redis is an acceleration component or a correctness dependency.
If it is only cache, I need controlled DB fallback and traffic protection.
If it is central for locks, sessions, or throttling, the failure mode is much more serious.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is cache hit rate not enough as a health metric?...
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
) VALUES (
  'notion_q_98',
  'why-is-cache-hit-rate-not-enough-as-a-health-metric-98',
  'Why is cache hit rate not enough as a health metric?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'Because latency, connection count, memory fragmentation, eviction behavior, hot keys, and persistence cost all matter.',
  'Because latency, connection count, memory fragmentation, eviction behavior, hot keys, and persistence cost all matter.
A cache can have good hit rate and still be operationally unstable.',
  NULL,
  'Because latency, connection count, memory fragmentation, eviction behavior, hot keys, and persistence cost all matter.
A cache can have good hit rate and still be operationally unstable.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the most realistic Redis incident answer you can give in an interview?...
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
) VALUES (
  'notion_q_99',
  'what-is-the-most-realistic-redis-incident-answer-you-can-give-in-an-interview-99',
  'What is the most realistic Redis incident answer you can give in an interview?',
  'cat_system',
  'Easy',
  ARRAY['redis']::TEXT[],
  'Hot key overload',
  'Hot key overload
Cache expiration stampede
Big key deletion latency
Lock expiry causing duplicate execution
Those sound much more real than simply listing Redis data types.',
  NULL,
  'Hot key overload
Cache expiration stampede
Big key deletion latency
Lock expiry causing duplicate execution
Those sound much more real than simply listing Redis data types.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does @Transactional usually not work on private methods?...
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
) VALUES (
  'notion_q_100',
  'why-does-transactional-usually-not-work-on-private-methods-100',
  'Why does @Transactional usually not work on private methods?',
  'cat_system',
  'Medium',
  ARRAY['transactions']::TEXT[],
  'Because Spring transactions are commonly proxy-based.',
  'Because Spring transactions are commonly proxy-based.
Private methods are not invoked through that proxy in the expected way.',
  NULL,
  'Because Spring transactions are commonly proxy-based.
Private methods are not invoked through that proxy in the expected way.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does self-invocation often break transaction behavior?...
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
) VALUES (
  'notion_q_101',
  'why-does-self-invocation-often-break-transaction-behavior-101',
  'Why does self-invocation often break transaction behavior?',
  'cat_system',
  'Medium',
  ARRAY['transactions']::TEXT[],
  'Because the internal call does not go through the Spring proxy.',
  'Because the internal call does not go through the Spring proxy.
It is a classic proxy-boundary problem.',
  NULL,
  'Because the internal call does not go through the Spring proxy.
It is a classic proxy-boundary problem.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does rollback not happen for checked exceptions by default?...
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
) VALUES (
  'notion_q_102',
  'why-does-rollback-not-happen-for-checked-exceptions-by-default-102',
  'Why does rollback not happen for checked exceptions by default?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because the default rollback rule targets runtime exceptions and errors.',
  'Because the default rollback rule targets runtime exceptions and errors.
If checked exceptions should rollback, you must configure that explicitly.',
  NULL,
  'Because the default rollback rule targets runtime exceptions and errors.
If checked exceptions should rollback, you must configure that explicitly.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can a composite index stop helping after a certain column?...
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
) VALUES (
  'notion_q_103',
  'why-can-a-composite-index-stop-helping-after-a-certain-column-103',
  'Why can a composite index stop helping after a certain column?',
  'cat_system',
  'Medium',
  ARRAY['indexing']::TEXT[],
  'Because of leftmost prefix behavior.',
  'Because of leftmost prefix behavior.
Once the query pattern breaks the usable prefix, later columns may no longer help.',
  NULL,
  'Because of leftmost prefix behavior.
Once the query pattern breaks the usable prefix, later columns may no longer help.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does using a function on an indexed column often kill index usage?...
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
) VALUES (
  'notion_q_104',
  'why-does-using-a-function-on-an-indexed-column-often-kill-index-usage-104',
  'Why does using a function on an indexed column often kill index usage?',
  'cat_system',
  'Medium',
  ARRAY['indexing']::TEXT[],
  'Because the optimizer cannot directly use the original ordered index structure.',
  'Because the optimizer cannot directly use the original ordered index structure.
Examples include date(create_time) or substring operations.',
  NULL,
  'Because the optimizer cannot directly use the original ordered index structure.
Examples include date(create_time) or substring operations.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can select * destroy the benefit of a covering index?...
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
) VALUES (
  'notion_q_105',
  'why-can-select-destroy-the-benefit-of-a-covering-index-105',
  'Why can select * destroy the benefit of a covering index?',
  'cat_system',
  'Medium',
  ARRAY['indexing']::TEXT[],
  'Because fetching extra columns forces a table lookup.',
  'Because fetching extra columns forces a table lookup.
Querying only what you need is both cleaner and often faster.',
  NULL,
  'Because fetching extra columns forces a table lookup.
Querying only what you need is both cleaner and often faster.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why must Redis unlock logic compare the stored token/value?...
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
) VALUES (
  'notion_q_106',
  'why-must-redis-unlock-logic-compare-the-stored-tokenvalue-106',
  'Why must Redis unlock logic compare the stored token/value?',
  'cat_system',
  'Medium',
  ARRAY['redis']::TEXT[],
  'To avoid deleting a lock that belongs to another owner after expiry or retry.',
  'To avoid deleting a lock that belongs to another owner after expiry or retry.
That is why Lua-based compare-and-delete is the standard safe pattern.',
  NULL,
  'To avoid deleting a lock that belongs to another owner after expiry or retry.
That is why Lua-based compare-and-delete is the standard safe pattern.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does readOnly = true not guarantee “no locks”?...
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
) VALUES (
  'notion_q_107',
  'why-does-readonly-true-not-guarantee-no-locks-107',
  'Why does readOnly = true not guarantee “no locks”?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because it is primarily a framework-level hint.',
  'Because it is primarily a framework-level hint.
Real locking behavior still depends on query type, isolation level, and the database implementation.',
  NULL,
  'Because it is primarily a framework-level hint.
Real locking behavior still depends on query type, isolation level, and the database implementation.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “double delete” not a perfect consistency solution?...
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
) VALUES (
  'notion_q_108',
  'why-is-double-delete-not-a-perfect-consistency-solution-108',
  'Why is “double delete” not a perfect consistency solution?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because it reduces some timing windows but does not create strict consistency guarantees.',
  'Because it reduces some timing windows but does not create strict consistency guarantees.
It must still be evaluated against business tolerance and failure handling needs.',
  NULL,
  'Because it reduces some timing windows but does not create strict consistency guarantees.
It must still be evaluated against business tolerance and failure handling needs.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What makes a strong senior-level database answer feel detailed?...
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
) VALUES (
  'notion_q_109',
  'what-makes-a-strong-senior-level-database-answer-feel-detailed-109',
  'What makes a strong senior-level database answer feel detailed?',
  'cat_system',
  'Medium',
  ARRAY['database']::TEXT[],
  'Not just “add index” or “use cache.”',
  'This page is intentionally broad and detailed. The remaining expanded banks will follow the same English-only format.',
  NULL,
  'Not just “add index” or “use cache.”
Strong answers mention execution plan, scanned rows, table lookup cost, lock scope, transaction boundaries, replica lag, and retry/compensation strategy.
Spring answers should connect framework behavior to proxy boundaries, state management, and real request flow.
Database answers should connect indexing and transactions to latency, contention, and consistency.
Redis answers should connect caching to incident handling, fallback strategy, and correctness boundaries.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What ORM or MyBatis / JPA pitfalls do you watch for in real services?...
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
) VALUES (
  'notion_q_110',
  'what-orm-or-mybatis-jpa-pitfalls-do-you-watch-for-in-real-services-110',
  'What ORM or MyBatis / JPA pitfalls do you watch for in real services?',
  'cat_sql',
  'Medium',
  ARRAY['general']::TEXT[],
  'The most common ones are N plus 1 queries, accidental lazy loading, oversized result sets, missing batch writes, and transaction boundaries that are too wide or too narrow.',
  'The most common ones are N plus 1 queries, accidental lazy loading, oversized result sets, missing batch writes, and transaction boundaries that are too wide or too narrow.
A strong answer says you inspect the real generated SQL instead of trusting repository code by itself.
The senior-level point is that query shape must follow data-access intent, not only object shape.',
  NULL,
  'The most common ones are N plus 1 queries, accidental lazy loading, oversized result sets, missing batch writes, and transaction boundaries that are too wide or too narrow.
A strong answer says you inspect the real generated SQL instead of trusting repository code by itself.
The senior-level point is that query shape must follow data-access intent, not only object shape.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain MVCC and read view in MySQL?...
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
) VALUES (
  'notion_q_111',
  'how-do-you-explain-mvcc-and-read-view-in-mysql-111',
  'How do you explain MVCC and read view in MySQL?',
  'cat_sql',
  'Medium',
  ARRAY['database']::TEXT[],
  'MVCC lets readers see a consistent snapshot of data instead of blocking writers in many normal read paths.',
  'MVCC lets readers see a consistent snapshot of data instead of blocking writers in many normal read paths.
The read view determines which row versions are visible to the current transaction based on transaction state.
This is the practical foundation behind repeatable read behavior and versioned row visibility in InnoDB.',
  NULL,
  'MVCC lets readers see a consistent snapshot of data instead of blocking writers in many normal read paths.
The read view determines which row versions are visible to the current transaction based on transaction state.
This is the practical foundation behind repeatable read behavior and versioned row visibility in InnoDB.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the practical difference between snapshot read and current read?...
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
) VALUES (
  'notion_q_112',
  'what-is-the-practical-difference-between-snapshot-read-and-current-read-112',
  'What is the practical difference between snapshot read and current read?',
  'cat_sql',
  'Easy',
  ARRAY['general']::TEXT[],
  'Snapshot read sees a consistent version of data and is what a normal select often uses under InnoDB.',
  'Snapshot read sees a consistent version of data and is what a normal select often uses under InnoDB.
Current read asks for the latest version and usually participates in locking, such as select for update, update, or delete.
This distinction matters because race conditions, blocking behavior, and lock expectations all change depending on which read path you use.',
  NULL,
  'Snapshot read sees a consistent version of data and is what a normal select often uses under InnoDB.
Current read asks for the latest version and usually participates in locking, such as select for update, update, or delete.
This distinction matters because race conditions, blocking behavior, and lock expectations all change depending on which read path you use.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you prefer EXISTS, IN, or JOIN?...
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
) VALUES (
  'notion_q_113',
  'when-do-you-prefer-exists-in-or-join-113',
  'When do you prefer EXISTS, IN, or JOIN?',
  'cat_sql',
  'Medium',
  ARRAY['general']::TEXT[],
  'Use EXISTS when the business question is really about existence and the optimizer can stop early once a match is found.',
  'Use EXISTS when the business question is really about existence and the optimizer can stop early once a match is found.
Use JOIN when you need combined rows or want to shape the result through a relational join plan.
IN is often fine for small lists or simple cases, but the real answer should be validated with execution plans instead of folklore.',
  NULL,
  'Use EXISTS when the business question is really about existence and the optimizer can stop early once a match is found.
Use JOIN when you need combined rows or want to shape the result through a relational join plan.
IN is often fine for small lists or simple cases, but the real answer should be validated with execution plans instead of folklore.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you use window functions and CTEs in interview SQL?...
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
) VALUES (
  'notion_q_114',
  'how-do-you-use-window-functions-and-ctes-in-interview-sql-114',
  'How do you use window functions and CTEs in interview SQL?',
  'cat_sql',
  'Medium',
  ARRAY['general']::TEXT[],
  'Window functions are great for ranking, top N per group, running totals, and lag/lead style comparisons without awkward self joins.',
  'Window functions are great for ranking, top N per group, running totals, and lag/lead style comparisons without awkward self joins.
CTEs help break a complex query into readable stages that are easier to reason about and explain.
A strong interview answer gives both the syntax idea and the reason the query becomes simpler or more maintainable.',
  NULL,
  'Window functions are great for ranking, top N per group, running totals, and lag/lead style comparisons without awkward self joins.
CTEs help break a complex query into readable stages that are easier to reason about and explain.
A strong interview answer gives both the syntax idea and the reason the query becomes simpler or more maintainable.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Walk me through a real EXPLAIN-based slow SQL diagnosis....
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
) VALUES (
  'notion_q_115',
  'walk-me-through-a-real-explain-based-slow-sql-diagnosis-115',
  'Walk me through a real EXPLAIN-based slow SQL diagnosis.',
  'cat_sql',
  'Medium',
  ARRAY['general']::TEXT[],
  'Start from the exact SQL and real bind parameters, not a simplified version.',
  'Start from the exact SQL and real bind parameters, not a simplified version.
Then inspect access type, rows scanned, possible versus chosen indexes, join order, temporary tables, and filesort behavior.
Only after that do you decide whether the real fix is indexing, SQL shape, pagination strategy, data skew handling, or broader schema design.',
  NULL,
  'Start from the exact SQL and real bind parameters, not a simplified version.
Then inspect access type, rows scanned, possible versus chosen indexes, join order, temporary tables, and filesort behavior.
Only after that do you decide whether the real fix is indexing, SQL shape, pagination strategy, data skew handling, or broader schema design.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When should you not split a system into microservices?...
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
) VALUES (
  'notion_q_116',
  'when-should-you-not-split-a-system-into-microservices-116',
  'When should you not split a system into microservices?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'When the team is small, requirements are still unstable, and deployment boundaries are unclear.',
  'When the team is small, requirements are still unstable, and deployment boundaries are unclear.
A monolith is often the better choice when complexity cost would exceed scaling benefit.
A strong answer shows that you do not treat microservices as a default virtue.',
  NULL,
  'When the team is small, requirements are still unstable, and deployment boundaries are unclear.
A monolith is often the better choice when complexity cost would exceed scaling benefit.
A strong answer shows that you do not treat microservices as a default virtue.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you decide service boundaries?...
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
) VALUES (
  'notion_q_117',
  'how-do-you-decide-service-boundaries-117',
  'How do you decide service boundaries?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'I start from business capability and ownership, not from tables or frameworks.',
  'I start from business capability and ownership, not from tables or frameworks.
A good boundary minimizes cross-service coordination and lets one team evolve the service independently.
If every request requires three tightly coupled services, the split is probably wrong.',
  NULL,
  'I start from business capability and ownership, not from tables or frameworks.
A good boundary minimizes cross-service coordination and lets one team evolve the service independently.
If every request requires three tightly coupled services, the split is probably wrong.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose between synchronous calls and asynchronous messaging?...
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
) VALUES (
  'notion_q_118',
  'how-do-you-choose-between-synchronous-calls-and-asynchronous-messaging-118',
  'How do you choose between synchronous calls and asynchronous messaging?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'If the caller needs an immediate answer, synchronous is simpler.',
  'If the caller needs an immediate answer, synchronous is simpler.
If the workflow can tolerate delay or must decouple failure domains, async is often better.
The real decision depends on user experience, consistency requirements, and operational complexity.',
  NULL,
  'If the caller needs an immediate answer, synchronous is simpler.
If the workflow can tolerate delay or must decouple failure domains, async is often better.
The real decision depends on user experience, consistency requirements, and operational complexity.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is idempotency such a central topic in distributed systems interviews?...
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
) VALUES (
  'notion_q_119',
  'why-is-idempotency-such-a-central-topic-in-distributed-systems-interviews-119',
  'Why is idempotency such a central topic in distributed systems interviews?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'Because retries are unavoidable.',
  'Because retries are unavoidable.
If a payment, order, or inventory operation is not idempotent, retries can cause duplicated side effects.
A strong answer ties idempotency to business correctness, not just to API style.',
  NULL,
  'Because retries are unavoidable.
If a payment, order, or inventory operation is not idempotent, retries can cause duplicated side effects.
A strong answer ties idempotency to business correctness, not just to API style.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you think about retries in a production system?...
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
) VALUES (
  'notion_q_120',
  'how-do-you-think-about-retries-in-a-production-system-120',
  'How do you think about retries in a production system?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'Retries can help transient failures, but they can also amplify incidents.',
  'Retries can help transient failures, but they can also amplify incidents.
I usually combine retries with backoff, jitter, timeout discipline, and retry limits.
Retrying everything blindly is a common anti-pattern.',
  NULL,
  'Retries can help transient failures, but they can also amplify incidents.
I usually combine retries with backoff, jitter, timeout discipline, and retry limits.
Retrying everything blindly is a common anti-pattern.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do timeouts matter more than people think?...
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
) VALUES (
  'notion_q_121',
  'why-do-timeouts-matter-more-than-people-think-121',
  'Why do timeouts matter more than people think?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'Without explicit timeouts, threads can hang and cause pool exhaustion.',
  'Without explicit timeouts, threads can hang and cause pool exhaustion.
Timeouts are a first-class concurrency control tool, not just a defensive setting.
A strong answer mentions both client-side and downstream effects.',
  NULL,
  'Without explicit timeouts, threads can hang and cause pool exhaustion.
Timeouts are a first-class concurrency control tool, not just a defensive setting.
A strong answer mentions both client-side and downstream effects.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do circuit breakers help, and what do they not solve?...
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
) VALUES (
  'notion_q_122',
  'how-do-circuit-breakers-help-and-what-do-they-not-solve-122',
  'How do circuit breakers help, and what do they not solve?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'They stop repeated calls to unhealthy downstreams and reduce cascading failure.',
  'They stop repeated calls to unhealthy downstreams and reduce cascading failure.
They do not fix bad timeout settings, overloaded queues, or non-idempotent retries.
In other words, they are one resilience mechanism, not the whole story.',
  NULL,
  'They stop repeated calls to unhealthy downstreams and reduce cascading failure.
They do not fix bad timeout settings, overloaded queues, or non-idempotent retries.
In other words, they are one resilience mechanism, not the whole story.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain eventual consistency in a practical way?...
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
) VALUES (
  'notion_q_123',
  'how-do-you-explain-eventual-consistency-in-a-practical-way-123',
  'How do you explain eventual consistency in a practical way?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'It means the system does not guarantee immediate consistency across components, but converges over time.',
  'It means the system does not guarantee immediate consistency across components, but converges over time.
The real interview value is whether you can name where that delay is acceptable and where it is not.
Inventory reservation and analytics reporting are not the same consistency problem.',
  NULL,
  'It means the system does not guarantee immediate consistency across components, but converges over time.
The real interview value is whether you can name where that delay is acceptable and where it is not.
Inventory reservation and analytics reporting are not the same consistency problem.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain the Saga pattern without sounding academic?...
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
) VALUES (
  'notion_q_124',
  'how-do-you-explain-the-saga-pattern-without-sounding-academic-124',
  'How do you explain the Saga pattern without sounding academic?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'I describe it as a multi-step business workflow where each step has either a forward action or a compensating action.',
  'I describe it as a multi-step business workflow where each step has either a forward action or a compensating action.
It is useful when one distributed transaction would be too expensive or impossible.
The practical concern is compensation correctness, not just drawing arrows on a diagram.',
  NULL,
  'I describe it as a multi-step business workflow where each step has either a forward action or a compensating action.
It is useful when one distributed transaction would be too expensive or impossible.
The practical concern is compensation correctness, not just drawing arrows on a diagram.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the outbox pattern, and why is it so useful?...
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
) VALUES (
  'notion_q_125',
  'what-is-the-outbox-pattern-and-why-is-it-so-useful-125',
  'What is the outbox pattern, and why is it so useful?',
  'cat_system',
  'Easy',
  ARRAY['microservices']::TEXT[],
  'It prevents “DB write succeeded but event publish failed” inconsistencies.',
  'It prevents “DB write succeeded but event publish failed” inconsistencies.
The application writes business data and an outbox record in the same transaction.
A separate worker publishes the outbox record later.
It is a very practical answer for real consistency problems.',
  NULL,
  'It prevents “DB write succeeded but event publish failed” inconsistencies.
The application writes business data and an outbox record in the same transaction.
A separate worker publishes the outbox record later.
It is a very practical answer for real consistency problems.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the biggest mistake teams make with service-to-service calls?...
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
) VALUES (
  'notion_q_126',
  'what-is-the-biggest-mistake-teams-make-with-service-to-service-calls-126',
  'What is the biggest mistake teams make with service-to-service calls?',
  'cat_system',
  'Easy',
  ARRAY['microservices']::TEXT[],
  'Deep synchronous call chains.',
  'Deep synchronous call chains.
They create latency stacking, failure propagation, and hard-to-debug tail behavior.
Strong candidates talk about reducing fan-out and isolating dependencies.',
  NULL,
  'Deep synchronous call chains.
They create latency stacking, failure propagation, and hard-to-debug tail behavior.
Strong candidates talk about reducing fan-out and isolating dependencies.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you think about service discovery and API gateways?...
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
) VALUES (
  'notion_q_127',
  'how-do-you-think-about-service-discovery-and-api-gateways-127',
  'How do you think about service discovery and API gateways?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'Service discovery solves internal routing and instance resolution.',
  'Service discovery solves internal routing and instance resolution.
API gateways handle edge concerns such as authentication, routing, rate limiting, and protocol adaptation.
I separate those concerns rather than treating them as the same thing.',
  NULL,
  'Service discovery solves internal routing and instance resolution.
API gateways handle edge concerns such as authentication, routing, rate limiting, and protocol adaptation.
I separate those concerns rather than treating them as the same thing.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is observability such a big part of distributed system interviews?...
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
) VALUES (
  'notion_q_128',
  'why-is-observability-such-a-big-part-of-distributed-system-interviews-128',
  'Why is observability such a big part of distributed system interviews?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'Because without logs, metrics, traces, and correlation IDs, debugging cross-service incidents becomes guesswork.',
  'Because without logs, metrics, traces, and correlation IDs, debugging cross-service incidents becomes guesswork.
A strong answer includes what you would instrument, not just the word “observability.”',
  NULL,
  'Because without logs, metrics, traces, and correlation IDs, debugging cross-service incidents becomes guesswork.
A strong answer includes what you would instrument, not just the word “observability.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you handle backward compatibility between services?...
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
) VALUES (
  'notion_q_129',
  'how-do-you-handle-backward-compatibility-between-services-129',
  'How do you handle backward compatibility between services?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'Version contracts carefully.',
  'Version contracts carefully.
Prefer additive changes over breaking changes.
Roll out producers and consumers in a safe order.
Compatibility problems are often more operational than technical.',
  NULL,
  'Version contracts carefully.
Prefer additive changes over breaking changes.
Roll out producers and consumers in a safe order.
Compatibility problems are often more operational than technical.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you approach rate limiting in distributed systems?...
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
) VALUES (
  'notion_q_130',
  'how-do-you-approach-rate-limiting-in-distributed-systems-130',
  'How do you approach rate limiting in distributed systems?',
  'cat_system',
  'Medium',
  ARRAY['microservices']::TEXT[],
  'I first define what I am protecting: user fairness, downstream capacity, or abuse prevention.',
  'I first define what I am protecting: user fairness, downstream capacity, or abuse prevention.
Then I choose a scope: per user, per tenant, per API, per region.
The useful answer is not just “token bucket,” but why that policy fits the system.',
  NULL,
  'I first define what I am protecting: user fairness, downstream capacity, or abuse prevention.
Then I choose a scope: per user, per tenant, per API, per region.
The useful answer is not just “token bucket,” but why that policy fits the system.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How should you start a system design interview?...
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
) VALUES (
  'notion_q_131',
  'how-should-you-start-a-system-design-interview-131',
  'How should you start a system design interview?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'Start by clarifying functional and non-functional requirements.',
  'Start by clarifying functional and non-functional requirements.
Do not jump into drawing services in the first 20 seconds.
A clean opening already makes you sound more senior.',
  NULL,
  'Start by clarifying functional and non-functional requirements.
Do not jump into drawing services in the first 20 seconds.
A clean opening already makes you sound more senior.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What kind of clarifying questions make you look strong?...
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
) VALUES (
  'notion_q_132',
  'what-kind-of-clarifying-questions-make-you-look-strong-132',
  'What kind of clarifying questions make you look strong?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Read-heavy or write-heavy?',
  'Read-heavy or write-heavy?
Global or single region?
Latency target?
Consistency expectation?
Traffic scale?
Retention requirement?
Questions that shape architecture are stronger than generic filler.',
  NULL,
  'Read-heavy or write-heavy?
Global or single region?
Latency target?
Consistency expectation?
Traffic scale?
Retention requirement?
Questions that shape architecture are stronger than generic filler.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How much estimation should you do?...
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
) VALUES (
  'notion_q_133',
  'how-much-estimation-should-you-do-133',
  'How much estimation should you do?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Enough to justify major design choices.',
  'Enough to justify major design choices.
QPS, storage growth, bandwidth, and rough fan-out are usually enough.
Overly detailed math is less valuable than good directional reasoning.',
  NULL,
  'Enough to justify major design choices.
QPS, storage growth, bandwidth, and rough fan-out are usually enough.
Overly detailed math is less valuable than good directional reasoning.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Should you design the API first or the database first?...
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
) VALUES (
  'notion_q_134',
  'should-you-design-the-api-first-or-the-database-first-134',
  'Should you design the API first or the database first?',
  'cat_system',
  'Hard',
  ARRAY['database', 'design']::TEXT[],
  'It depends on the problem, but I usually clarify request flow and core entities early.',
  'It depends on the problem, but I usually clarify request flow and core entities early.
I want the API, data model, and traffic path to evolve together instead of treating them as separate exercises.',
  NULL,
  'It depends on the problem, but I usually clarify request flow and core entities early.
I want the API, data model, and traffic path to evolve together instead of treating them as separate exercises.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you decide where to put caching?...
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
) VALUES (
  'notion_q_135',
  'how-do-you-decide-where-to-put-caching-135',
  'How do you decide where to put caching?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I ask which reads are hot, which data is stable enough to cache, and whether stale reads are acceptable.',
  'I ask which reads are hot, which data is stable enough to cache, and whether stale reads are acceptable.
Caching is not just about performance. It changes consistency and invalidation complexity.',
  NULL,
  'I ask which reads are hot, which data is stable enough to cache, and whether stale reads are acceptable.
Caching is not just about performance. It changes consistency and invalidation complexity.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose between SQL and NoSQL in an interview?...
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
) VALUES (
  'notion_q_136',
  'how-do-you-choose-between-sql-and-nosql-in-an-interview-136',
  'How do you choose between SQL and NoSQL in an interview?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I tie the answer to access pattern, consistency, query flexibility, and scalability needs.',
  'I tie the answer to access pattern, consistency, query flexibility, and scalability needs.
I avoid religion.
“Strong consistency and relational queries” versus “high write scale and flexible access” is usually more useful than naming products too early.',
  NULL,
  'I tie the answer to access pattern, consistency, query flexibility, and scalability needs.
I avoid religion.
“Strong consistency and relational queries” versus “high write scale and flexible access” is usually more useful than naming products too early.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does a strong scaling answer sound like?...
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
) VALUES (
  'notion_q_137',
  'what-does-a-strong-scaling-answer-sound-like-137',
  'What does a strong scaling answer sound like?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Separate read scaling, write scaling, storage growth, and traffic spikes.',
  'Separate read scaling, write scaling, storage growth, and traffic spikes.
Mention stateless compute, partitioning, replication, cache layers, and queue-based smoothing where appropriate.
A strong answer scales the bottleneck, not everything blindly.',
  NULL,
  'Separate read scaling, write scaling, storage growth, and traffic spikes.
Mention stateless compute, partitioning, replication, cache layers, and queue-based smoothing where appropriate.
A strong answer scales the bottleneck, not everything blindly.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you discuss consistency vs availability without sounding generic?...
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
) VALUES (
  'notion_q_138',
  'how-do-you-discuss-consistency-vs-availability-without-sounding-generic-138',
  'How do you discuss consistency vs availability without sounding generic?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I tie it to the business domain.',
  'I tie it to the business domain.
For example, a product view counter can be eventually consistent, but inventory deduction often needs stronger correctness.
Abstract CAP answers are weaker than use-case-driven answers.',
  NULL,
  'I tie it to the business domain.
For example, a product view counter can be eventually consistent, but inventory deduction often needs stronger correctness.
Abstract CAP answers are weaker than use-case-driven answers.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you introduce queues into a design?...
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
) VALUES (
  'notion_q_139',
  'when-do-you-introduce-queues-into-a-design-139',
  'When do you introduce queues into a design?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'When I need buffering, asynchronous decoupling, traffic smoothing, or independent retry behavior.',
  'When I need buffering, asynchronous decoupling, traffic smoothing, or independent retry behavior.
I do not insert queues everywhere “because microservices.”
A queue should solve a concrete coupling or throughput problem.',
  NULL,
  'When I need buffering, asynchronous decoupling, traffic smoothing, or independent retry behavior.
I do not insert queues everywhere “because microservices.”
A queue should solve a concrete coupling or throughput problem.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you shard a database?...
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
) VALUES (
  'notion_q_140',
  'when-do-you-shard-a-database-140',
  'When do you shard a database?',
  'cat_system',
  'Medium',
  ARRAY['database', 'design']::TEXT[],
  'After exhausting simpler options such as indexing, query tuning, archiving, and read scaling.',
  'After exhausting simpler options such as indexing, query tuning, archiving, and read scaling.
I also explain the cost: routing logic, rebalancing, aggregation complexity, and operational burden.',
  NULL,
  'After exhausting simpler options such as indexing, query tuning, archiving, and read scaling.
I also explain the cost: routing logic, rebalancing, aggregation complexity, and operational burden.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you talk about CDN usage in system design?...
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
) VALUES (
  'notion_q_141',
  'how-do-you-talk-about-cdn-usage-in-system-design-141',
  'How do you talk about CDN usage in system design?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'CDN is a distribution and latency strategy, not just a box in the diagram.',
  'CDN is a distribution and latency strategy, not just a box in the diagram.
It matters most for static assets, media delivery, and globally distributed read-heavy content.
I mention cache invalidation and regional edge behavior if relevant.',
  NULL,
  'CDN is a distribution and latency strategy, not just a box in the diagram.
It matters most for static assets, media delivery, and globally distributed read-heavy content.
I mention cache invalidation and regional edge behavior if relevant.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you include observability in a design answer?...
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
) VALUES (
  'notion_q_142',
  'how-do-you-include-observability-in-a-design-answer-142',
  'How do you include observability in a design answer?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'I add metrics, logs, tracing, alerts, dashboards, and SLO thinking as part of the system.',
  'I add metrics, logs, tracing, alerts, dashboards, and SLO thinking as part of the system.
Observability is not a bonus section. It is part of how the design stays operable.',
  NULL,
  'I add metrics, logs, tracing, alerts, dashboards, and SLO thinking as part of the system.
Observability is not a bonus section. It is part of how the design stays operable.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer if you do not know the exact technology?...
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
) VALUES (
  'notion_q_143',
  'how-do-you-answer-if-you-do-not-know-the-exact-technology-143',
  'How do you answer if you do not know the exact technology?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I say so directly, then map from first principles.',
  'I say so directly, then map from first principles.
For example: consistency need, throughput shape, storage pattern, or retry model.
Interviewers usually reward structured reasoning more than fake certainty.',
  NULL,
  'I say so directly, then map from first principles.
For example: consistency need, throughput shape, storage pattern, or retry model.
Interviewers usually reward structured reasoning more than fake certainty.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What makes a good “trade-off” answer?...
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
) VALUES (
  'notion_q_144',
  'what-makes-a-good-trade-off-answer-144',
  'What makes a good “trade-off” answer?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Option A improves one dimension but hurts another.',
  'Option A improves one dimension but hurts another.
I explain which dimension matters more for this system and why.
The key is not to pretend there is a perfect design.',
  NULL,
  'Option A improves one dimension but hurts another.
I explain which dimension matters more for this system and why.
The key is not to pretend there is a perfect design.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you keep your design answer from becoming too abstract?...
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
) VALUES (
  'notion_q_145',
  'how-do-you-keep-your-design-answer-from-becoming-too-abstract-145',
  'How do you keep your design answer from becoming too abstract?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'I anchor each major component to a purpose.',
  'I anchor each major component to a purpose.
Cache for what?
Queue between which steps?
Why this database here?
The more each component has a reason, the stronger the design sounds.',
  NULL,
  'I anchor each major component to a purpose.
Cache for what?
Queue between which steps?
Why this database here?
The more each component has a reason, the stronger the design sounds.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “exactly once” usually a dangerous phrase?...
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
) VALUES (
  'notion_q_146',
  'why-is-exactly-once-usually-a-dangerous-phrase-146',
  'Why is “exactly once” usually a dangerous phrase?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because in many systems it is really a combination of at-least-once delivery plus idempotent processing.',
  'Because in many systems it is really a combination of at-least-once delivery plus idempotent processing.
Strong candidates avoid magical language and talk about practical guarantees.',
  NULL,
  'Because in many systems it is really a combination of at-least-once delivery plus idempotent processing.
Strong candidates avoid magical language and talk about practical guarantees.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the real challenge with message queues in production?...
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
) VALUES (
  'notion_q_147',
  'what-is-the-real-challenge-with-message-queues-in-production-147',
  'What is the real challenge with message queues in production?',
  'cat_system',
  'Easy',
  ARRAY['general']::TEXT[],
  'Not publishing messages. Operating consumers.',
  'Not publishing messages. Operating consumers.
Reprocessing, ordering, poison messages, lag, retries, and offset management are the real pain points.',
  NULL,
  'Not publishing messages. Operating consumers.
Reprocessing, ordering, poison messages, lag, retries, and offset management are the real pain points.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can retries make an outage worse?...
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
) VALUES (
  'notion_q_148',
  'why-can-retries-make-an-outage-worse-148',
  'Why can retries make an outage worse?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'They increase pressure on already struggling dependencies.',
  'They increase pressure on already struggling dependencies.
If retries are immediate and unbounded, they become amplification.
Good answers mention backoff and retry budgets.',
  NULL,
  'They increase pressure on already struggling dependencies.
If retries are immediate and unbounded, they become amplification.
Good answers mention backoff and retry budgets.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is a realistic answer to “How do you avoid duplicate message processing?”...
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
) VALUES (
  'notion_q_149',
  'what-is-a-realistic-answer-to-how-do-you-avoid-duplicate-message-processing-149',
  'What is a realistic answer to “How do you avoid duplicate message processing?”',
  'cat_system',
  'Easy',
  ARRAY['general']::TEXT[],
  'I assume duplicates can happen.',
  'I assume duplicates can happen.
Then I build idempotent consumers, dedupe keys, or state checks around the business action.
Avoiding duplicates entirely is usually less realistic than tolerating them safely.',
  NULL,
  'I assume duplicates can happen.
Then I build idempotent consumers, dedupe keys, or state checks around the business action.
Avoiding duplicates entirely is usually less realistic than tolerating them safely.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you think about ordering guarantees?...
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
) VALUES (
  'notion_q_150',
  'how-do-you-think-about-ordering-guarantees-150',
  'How do you think about ordering guarantees?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'First, ask whether ordering actually matters.',
  'First, ask whether ordering actually matters.
If it does, ask whether it must be global, per user, per entity, or per partition.
Strong answers narrow the scope before choosing a mechanism.',
  NULL,
  'First, ask whether ordering actually matters.
If it does, ask whether it must be global, per user, per entity, or per partition.
Strong answers narrow the scope before choosing a mechanism.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why are distributed traces not enough by themselves?...
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
) VALUES (
  'notion_q_151',
  'why-are-distributed-traces-not-enough-by-themselves-151',
  'Why are distributed traces not enough by themselves?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because traces explain request flow, but you still need metrics for trends and logs for detail.',
  'Because traces explain request flow, but you still need metrics for trends and logs for detail.
Real incident response uses all three.',
  NULL,
  'Because traces explain request flow, but you still need metrics for trends and logs for detail.
Real incident response uses all three.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the difference between a correlation ID and a trace ID in interviews?...
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
) VALUES (
  'notion_q_152',
  'what-is-the-difference-between-a-correlation-id-and-a-trace-id-in-interviews-152',
  'What is the difference between a correlation ID and a trace ID in interviews?',
  'cat_system',
  'Easy',
  ARRAY['general']::TEXT[],
  'A trace ID is usually part of structured distributed tracing.',
  'A trace ID is usually part of structured distributed tracing.
A correlation ID is often a broader request or business workflow identifier.
The key is that both help connect events across systems.',
  NULL,
  'A trace ID is usually part of structured distributed tracing.
A correlation ID is often a broader request or business workflow identifier.
The key is that both help connect events across systems.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do synchronous fan-out calls create risk?...
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
) VALUES (
  'notion_q_153',
  'why-do-synchronous-fan-out-calls-create-risk-153',
  'Why do synchronous fan-out calls create risk?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Latency multiplies.',
  'Latency multiplies.
Failure probability multiplies.
Thread and connection consumption multiplies.
This is a very credible answer because it directly reflects production behavior.',
  NULL,
  'Latency multiplies.
Failure probability multiplies.
Thread and connection consumption multiplies.
This is a very credible answer because it directly reflects production behavior.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does a mature answer about graceful degradation sound like?...
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
) VALUES (
  'notion_q_154',
  'what-does-a-mature-answer-about-graceful-degradation-sound-like-154',
  'What does a mature answer about graceful degradation sound like?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'It says what features can fail soft, what must fail hard, and what fallback still protects correctness.',
  'It says what features can fail soft, what must fail hard, and what fallback still protects correctness.
Example: recommendations can degrade; payment authorization usually cannot.',
  NULL,
  'It says what features can fail soft, what must fail hard, and what fallback still protects correctness.
Example: recommendations can degrade; payment authorization usually cannot.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What makes a senior system design answer feel senior?...
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
) VALUES (
  'notion_q_155',
  'what-makes-a-senior-system-design-answer-feel-senior-155',
  'What makes a senior system design answer feel senior?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'Clear assumptions',
  'Clear assumptions
Measured trade-offs
Failure handling
Operability
Business relevance
Senior answers sound less like architecture art and more like systems people can actually run.',
  NULL,
  'Clear assumptions
Measured trade-offs
Failure handling
Operability
Business relevance
Senior answers sound less like architecture art and more like systems people can actually run.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is at-least-once delivery often acceptable when exactly-once is not realisti...
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
) VALUES (
  'notion_q_156',
  'why-is-at-least-once-delivery-often-acceptable-when-exactly-once-is-not-realisti-156',
  'Why is at-least-once delivery often acceptable when exactly-once is not realistic?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because business correctness can often be preserved with idempotency.',
  'Because business correctness can often be preserved with idempotency.
That is usually cheaper and more practical than trying to enforce a mythical perfect guarantee end-to-end.',
  NULL,
  'Because business correctness can often be preserved with idempotency.
That is usually cheaper and more practical than trying to enforce a mythical perfect guarantee end-to-end.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is idempotency key expiry a subtle design detail?...
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
) VALUES (
  'notion_q_157',
  'why-is-idempotency-key-expiry-a-subtle-design-detail-157',
  'Why is idempotency key expiry a subtle design detail?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'Because if the key expires too early, late retries can re-run the action.',
  'Because if the key expires too early, late retries can re-run the action.
If it stays too long, memory cost and reuse semantics get messy.
Good candidates mention retention windows, not just the existence of a key.',
  NULL,
  'Because if the key expires too early, late retries can re-run the action.
If it stays too long, memory cost and reuse semantics get messy.
Good candidates mention retention windows, not just the existence of a key.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can consumer commit timing create duplicate or lost work?...
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
) VALUES (
  'notion_q_158',
  'why-can-consumer-commit-timing-create-duplicate-or-lost-work-158',
  'Why can consumer commit timing create duplicate or lost work?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'If you commit too early, you can lose unprocessed work.',
  'If you commit too early, you can lose unprocessed work.
If you commit too late and crash, you can reprocess completed work.
This is one of the best “operations-aware” details to mention.',
  NULL,
  'If you commit too early, you can lose unprocessed work.
If you commit too late and crash, you can reprocess completed work.
This is one of the best “operations-aware” details to mention.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “just add a queue” sometimes the wrong answer?...
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
) VALUES (
  'notion_q_159',
  'why-is-just-add-a-queue-sometimes-the-wrong-answer-159',
  'Why is “just add a queue” sometimes the wrong answer?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because it adds async complexity, retries, ordering questions, and observability work.',
  'Because it adds async complexity, retries, ordering questions, and observability work.
A queue should solve a concrete problem, not serve as an architecture decoration.',
  NULL,
  'Because it adds async complexity, retries, ordering questions, and observability work.
A queue should solve a concrete problem, not serve as an architecture decoration.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is service decomposition by database table often a weak design?...
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
) VALUES (
  'notion_q_160',
  'why-is-service-decomposition-by-database-table-often-a-weak-design-160',
  'Why is service decomposition by database table often a weak design?',
  'cat_system',
  'Hard',
  ARRAY['database', 'design']::TEXT[],
  'Because it follows storage shape instead of business ownership.',
  'Because it follows storage shape instead of business ownership.
It often creates too much cross-service coordination for normal workflows.',
  NULL,
  'Because it follows storage shape instead of business ownership.
It often creates too much cross-service coordination for normal workflows.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why are write-heavy systems harder to scale than read-heavy systems?...
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
) VALUES (
  'notion_q_161',
  'why-are-write-heavy-systems-harder-to-scale-than-read-heavy-systems-161',
  'Why are write-heavy systems harder to scale than read-heavy systems?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because writes create consistency, locking, replication, and coordination cost.',
  'Because writes create consistency, locking, replication, and coordination cost.
Reads are usually easier to replicate or cache.',
  NULL,
  'Because writes create consistency, locking, replication, and coordination cost.
Reads are usually easier to replicate or cache.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “eventual consistency” a weak answer unless you define the window and imp...
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
) VALUES (
  'notion_q_162',
  'why-is-eventual-consistency-a-weak-answer-unless-you-define-the-window-and-impac-162',
  'Why is “eventual consistency” a weak answer unless you define the window and impact?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because the important question is how eventual and what breaks during that window.',
  'Because the important question is how eventual and what breaks during that window.
Good answers make the consistency delay concrete.',
  NULL,
  'Because the important question is how eventual and what breaks during that window.
Good answers make the consistency delay concrete.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is API backward compatibility such an operational topic?...
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
) VALUES (
  'notion_q_163',
  'why-is-api-backward-compatibility-such-an-operational-topic-163',
  'Why is API backward compatibility such an operational topic?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because deployments are staggered across producers, consumers, and regions.',
  'Because deployments are staggered across producers, consumers, and regions.
A breaking change is not just a code issue; it is a rollout risk.',
  NULL,
  'Because deployments are staggered across producers, consumers, and regions.
A breaking change is not just a code issue; it is a rollout risk.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why should you care about redrive and poison message strategy?...
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
) VALUES (
  'notion_q_164',
  'why-should-you-care-about-redrive-and-poison-message-strategy-164',
  'Why should you care about redrive and poison message strategy?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because some messages will keep failing.',
  'Because some messages will keep failing.
Without dead-letter handling, they can block progress or create infinite retry loops.',
  NULL,
  'Because some messages will keep failing.
Without dead-letter handling, they can block progress or create infinite retry loops.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What detail makes your system design answers sound less generic immediately?...
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
) VALUES (
  'notion_q_165',
  'what-detail-makes-your-system-design-answers-sound-less-generic-immediately-165',
  'What detail makes your system design answers sound less generic immediately?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'Naming one realistic bottleneck, one realistic failure mode, and one realistic safeguard.',
  'This page is intentionally broad and detailed. The same style will be used for the behavioral bank and the algorithm explanation bank.',
  NULL,
  'Naming one realistic bottleneck, one realistic failure mode, and one realistic safeguard.
That shifts the conversation from “diagram memory” to engineering judgment.
They start from business and traffic shape, not from buzzwords.
They explain the trade-off instead of pretending every property can be maximized at once.
They include reliability, observability, and failure handling as part of the design.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- “Tell me about yourself.” What makes this answer strong?...
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
) VALUES (
  'notion_q_166',
  'tell-me-about-yourself-what-makes-this-answer-strong-166',
  '“Tell me about yourself.” What makes this answer strong?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'A strong answer is not a life story.',
  'A strong answer is not a life story.
It gives current role, strongest relevant achievements, career direction, and why this role fits.
A good two-minute answer sounds focused, not improvised.',
  NULL,
  'A strong answer is not a life story.
It gives current role, strongest relevant achievements, career direction, and why this role fits.
A good two-minute answer sounds focused, not improvised.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Why are you looking to leave your current company?”...
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
) VALUES (
  'notion_q_167',
  'how-do-you-answer-why-are-you-looking-to-leave-your-current-company-167',
  'How do you answer “Why are you looking to leave your current company?”',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Stay positive and forward-looking.',
  'Stay positive and forward-looking.
Talk about scale, ownership, technical challenge, growth, or alignment.
Never make the answer sound like a grievance session.',
  NULL,
  'Stay positive and forward-looking.
Talk about scale, ownership, technical challenge, growth, or alignment.
Never make the answer sound like a grievance session.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- “Tell me about a technical challenge you solved.” What do interviewers really wa...
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
) VALUES (
  'notion_q_168',
  'tell-me-about-a-technical-challenge-you-solved-what-do-interviewers-really-want-168',
  '“Tell me about a technical challenge you solved.” What do interviewers really want?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'They want your thought process, not just the final fix.',
  'They want your thought process, not just the final fix.
A strong answer includes ambiguity, failed first attempts, root-cause discovery, trade-offs, and measurable impact.',
  NULL,
  'They want your thought process, not just the final fix.
A strong answer includes ambiguity, failed first attempts, root-cause discovery, trade-offs, and measurable impact.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a failure” without sounding defensive?...
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
) VALUES (
  'notion_q_169',
  'how-do-you-answer-tell-me-about-a-failure-without-sounding-defensive-169',
  'How do you answer “Tell me about a failure” without sounding defensive?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Choose a real failure with limited blast radius.',
  'Choose a real failure with limited blast radius.
Show ownership.
Explain what changed in your behavior afterward.
The key is not the mistake itself, but whether you improved because of it.',
  NULL,
  'Choose a real failure with limited blast radius.
Show ownership.
Explain what changed in your behavior afterward.
The key is not the mistake itself, but whether you improved because of it.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a disagreement with your manager or team” well?...
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
) VALUES (
  'notion_q_170',
  'how-do-you-answer-tell-me-about-a-disagreement-with-your-manager-or-team-well-170',
  'How do you answer “Tell me about a disagreement with your manager or team” well?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'The best answer shows respect, evidence, and collaboration.',
  'The best answer shows respect, evidence, and collaboration.
It should not sound like “I won.”
A stronger framing is that you moved the discussion from opinion to data or experiment.',
  NULL,
  'The best answer shows respect, evidence, and collaboration.
It should not sound like “I won.”
A stronger framing is that you moved the discussion from opinion to data or experiment.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What makes a “most proud achievement” answer convincing?...
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
) VALUES (
  'notion_q_171',
  'what-makes-a-most-proud-achievement-answer-convincing-171',
  'What makes a “most proud achievement” answer convincing?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Specific scope',
  'Specific scope
Clear obstacle
Your exact role
Quantified outcome
Why it mattered to the business or team',
  NULL,
  'Specific scope
Clear obstacle
Your exact role
Quantified outcome
Why it mattered to the business or team',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you worked under pressure” like a senior...
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
) VALUES (
  'notion_q_172',
  'how-do-you-answer-tell-me-about-a-time-you-worked-under-pressure-like-a-senior-e-172',
  'How do you answer “Tell me about a time you worked under pressure” like a senior engineer?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Show prioritization, communication, scope control, and calm execution.',
  'Show prioritization, communication, scope control, and calm execution.
A weak answer sounds like heroics.
A strong answer sounds like controlled delivery under constraints.',
  NULL,
  'Show prioritization, communication, scope control, and calm execution.
A weak answer sounds like heroics.
A strong answer sounds like controlled delivery under constraints.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you learned something quickly” without s...
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
) VALUES (
  'notion_q_173',
  'how-do-you-answer-tell-me-about-a-time-you-learned-something-quickly-without-sou-173',
  'How do you answer “Tell me about a time you learned something quickly” without sounding generic?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Explain what you had to learn, why the time pressure mattered, how you structured learning, and what useful outcome followed.',
  'Explain what you had to learn, why the time pressure mattered, how you structured learning, and what useful outcome followed.
The answer should show learning method, not just learning speed.',
  NULL,
  'Explain what you had to learn, why the time pressure mattered, how you structured learning, and what useful outcome followed.
The answer should show learning method, not just learning speed.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the strongest way to answer “Tell me about a time you improved a process...
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
) VALUES (
  'notion_q_174',
  'what-is-the-strongest-way-to-answer-tell-me-about-a-time-you-improved-a-process-174',
  'What is the strongest way to answer “Tell me about a time you improved a process”?',
  'cat_behavioral',
  'Easy',
  ARRAY['general']::TEXT[],
  'Pick something with clear before-and-after impact.',
  'Pick something with clear before-and-after impact.
Strong examples include build time reduction, on-call reduction, operational tooling, or documentation that changed team effectiveness.',
  NULL,
  'Pick something with clear before-and-after impact.
Strong examples include build time reduction, on-call reduction, operational tooling, or documentation that changed team effectiveness.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you handled a production incident” credi...
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
) VALUES (
  'notion_q_175',
  'how-do-you-answer-tell-me-about-a-time-you-handled-a-production-incident-credibl-175',
  'How do you answer “Tell me about a time you handled a production incident” credibly?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Include triage, prioritization, mitigation, root cause, communication, and follow-up prevention.',
  'Include triage, prioritization, mitigation, root cause, communication, and follow-up prevention.
A very strong answer mentions how you kept stakeholders informed during the incident.',
  NULL,
  'Include triage, prioritization, mitigation, root cause, communication, and follow-up prevention.
A very strong answer mentions how you kept stakeholders informed during the incident.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you mentored someone” in a grounded way?...
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
) VALUES (
  'notion_q_176',
  'how-do-you-answer-tell-me-about-a-time-you-mentored-someone-in-a-grounded-way-176',
  'How do you answer “Tell me about a time you mentored someone” in a grounded way?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Focus on how you changed their trajectory, not just that you were helpful once.',
  'Focus on how you changed their trajectory, not just that you were helpful once.
Good examples include onboarding, review discipline, pairing, or helping a junior become independent.',
  NULL,
  'Focus on how you changed their trajectory, not just that you were helpful once.
Good examples include onboarding, review discipline, pairing, or helping a junior become independent.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “What is your biggest weakness?” without sounding fake?...
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
) VALUES (
  'notion_q_177',
  'how-do-you-answer-what-is-your-biggest-weakness-without-sounding-fake-177',
  'How do you answer “What is your biggest weakness?” without sounding fake?',
  'cat_behavioral',
  'Easy',
  ARRAY['general']::TEXT[],
  'Pick something real but manageable.',
  'Pick something real but manageable.
Explain the mechanism, what you changed, and how you keep it under control now.
Avoid fake weaknesses like “I care too much.”',
  NULL,
  'Pick something real but manageable.
Explain the mechanism, what you changed, and how you keep it under control now.
Avoid fake weaknesses like “I care too much.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Why this company?” well?...
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
) VALUES (
  'notion_q_178',
  'how-do-you-answer-why-this-company-well-178',
  'How do you answer “Why this company?” well?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Show evidence that you researched the company.',
  'Show evidence that you researched the company.
Connect their product, engineering challenge, scale, or culture to what you want next.
A weak answer could apply to any company.',
  NULL,
  'Show evidence that you researched the company.
Connect their product, engineering challenge, scale, or culture to what you want next.
A weak answer could apply to any company.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Where do you see yourself in five years?” without sounding po...
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
) VALUES (
  'notion_q_179',
  'how-do-you-answer-where-do-you-see-yourself-in-five-years-without-sounding-polit-179',
  'How do you answer “Where do you see yourself in five years?” without sounding politically risky?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Emphasize growth in technical depth, ownership, and impact.',
  'Emphasize growth in technical depth, ownership, and impact.
Show long-term intent without sounding rigid.
The safest strong answer is usually some version of deeper technical leadership.',
  NULL,
  'Emphasize growth in technical depth, ownership, and impact.
Show long-term intent without sounding rigid.
The safest strong answer is usually some version of deeper technical leadership.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What makes a behavioral answer memorable?...
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
) VALUES (
  'notion_q_180',
  'what-makes-a-behavioral-answer-memorable-180',
  'What makes a behavioral answer memorable?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'It is specific.',
  'It is specific.
It has numbers.
It shows judgment.
It sounds like something that actually happened.',
  NULL,
  'It is specific.
It has numbers.
It shows judgment.
It sounds like something that actually happened.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “How do you handle competing priorities?”...
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
) VALUES (
  'notion_q_181',
  'how-do-you-answer-how-do-you-handle-competing-priorities-181',
  'How do you answer “How do you handle competing priorities?”',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Explain your framework for urgency vs impact.',
  'Explain your framework for urgency vs impact.
Mention stakeholder alignment.
Show that you communicate trade-offs early instead of silently slipping deadlines.',
  NULL,
  'Explain your framework for urgency vs impact.
Mention stakeholder alignment.
Show that you communicate trade-offs early instead of silently slipping deadlines.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you had no clear requirements”?...
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
) VALUES (
  'notion_q_182',
  'how-do-you-answer-tell-me-about-a-time-you-had-no-clear-requirements-182',
  'How do you answer “Tell me about a time you had no clear requirements”?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Show how you reduced ambiguity.',
  'Show how you reduced ambiguity.
A strong answer includes clarifying assumptions, quick validation, and controlled iteration.',
  NULL,
  'Show how you reduced ambiguity.
A strong answer includes clarifying assumptions, quick validation, and controlled iteration.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does a strong ownership answer sound like?...
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
) VALUES (
  'notion_q_183',
  'what-does-a-strong-ownership-answer-sound-like-183',
  'What does a strong ownership answer sound like?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Ownership is not just taking tasks.',
  'Ownership is not just taking tasks.
It is noticing risk early, fixing problems outside your narrow scope, and following through after the initial task ends.',
  NULL,
  'Ownership is not just taking tasks.
It is noticing risk early, fixing problems outside your narrow scope, and following through after the initial task ends.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you influenced without authority”?...
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
) VALUES (
  'notion_q_184',
  'how-do-you-answer-tell-me-about-a-time-you-influenced-without-authority-184',
  'How do you answer “Tell me about a time you influenced without authority”?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Use evidence, alignment, and credibility.',
  'Use evidence, alignment, and credibility.
Strong answers show how you changed a decision or process without relying on title.',
  NULL,
  'Use evidence, alignment, and credibility.
Strong answers show how you changed a decision or process without relying on title.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you had to say no” without sounding unco...
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
) VALUES (
  'notion_q_185',
  'how-do-you-answer-tell-me-about-a-time-you-had-to-say-no-without-sounding-uncoop-185',
  'How do you answer “Tell me about a time you had to say no” without sounding uncooperative?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'The best answer is not “I blocked it.”',
  'The best answer is not “I blocked it.”
It is “I explained the trade-offs, proposed an alternative, and protected the system or timeline responsibly.”',
  NULL,
  'The best answer is not “I blocked it.”
It is “I explained the trade-offs, proposed an alternative, and protected the system or timeline responsibly.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a conflict with another team” well?...
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
) VALUES (
  'notion_q_186',
  'how-do-you-answer-tell-me-about-a-conflict-with-another-team-well-186',
  'How do you answer “Tell me about a conflict with another team” well?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Show that you understood their incentives, not just your own.',
  'Show that you understood their incentives, not just your own.
Good answers include alignment around shared goals, not just escalation.',
  NULL,
  'Show that you understood their incentives, not just your own.
Good answers include alignment around shared goals, not just escalation.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you made a bad estimate” in a mature way...
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
) VALUES (
  'notion_q_187',
  'how-do-you-answer-tell-me-about-a-time-you-made-a-bad-estimate-in-a-mature-way-187',
  'How do you answer “Tell me about a time you made a bad estimate” in a mature way?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Admit the estimation mistake.',
  'Admit the estimation mistake.
Explain what signals you missed.
Show what changed in your planning process afterward.',
  NULL,
  'Admit the estimation mistake.
Explain what signals you missed.
Show what changed in your planning process afterward.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you improved quality” in a useful way?...
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
) VALUES (
  'notion_q_188',
  'how-do-you-answer-tell-me-about-a-time-you-improved-quality-in-a-useful-way-188',
  'How do you answer “Tell me about a time you improved quality” in a useful way?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Good examples include tests, release controls, observability, PR discipline, review standards, or rollout safety.',
  'Good examples include tests, release controls, observability, PR discipline, review standards, or rollout safety.
The stronger answer explains how quality became repeatable, not just lucky.',
  NULL,
  'Good examples include tests, release controls, observability, PR discipline, review standards, or rollout safety.
The stronger answer explains how quality became repeatable, not just lucky.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is a good answer to “How do you give feedback?”...
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
) VALUES (
  'notion_q_189',
  'what-is-a-good-answer-to-how-do-you-give-feedback-189',
  'What is a good answer to “How do you give feedback?”',
  'cat_behavioral',
  'Easy',
  ARRAY['general']::TEXT[],
  'Be specific, kind, and timely.',
  'Be specific, kind, and timely.
Focus on behavior and impact, not personality.
Strong candidates explain that feedback should help the other person succeed.',
  NULL,
  'Be specific, kind, and timely.
Focus on behavior and impact, not personality.
Strong candidates explain that feedback should help the other person succeed.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is a good answer to “How do you receive feedback?”...
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
) VALUES (
  'notion_q_190',
  'what-is-a-good-answer-to-how-do-you-receive-feedback-190',
  'What is a good answer to “How do you receive feedback?”',
  'cat_behavioral',
  'Easy',
  ARRAY['general']::TEXT[],
  'Show low ego and high curiosity.',
  'Show low ego and high curiosity.
Explain how you validate the feedback, act on it, and improve.
Defensive answers fail quickly here.',
  NULL,
  'Show low ego and high curiosity.
Explain how you validate the feedback, act on it, and improve.
Defensive answers fail quickly here.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you led something” if you were not a man...
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
) VALUES (
  'notion_q_191',
  'how-do-you-answer-tell-me-about-a-time-you-led-something-if-you-were-not-a-manag-191',
  'How do you answer “Tell me about a time you led something” if you were not a manager?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Leadership is coordination, clarity, technical direction, and follow-through.',
  'Leadership is coordination, clarity, technical direction, and follow-through.
A strong answer does not require direct reports.',
  NULL,
  'Leadership is coordination, clarity, technical direction, and follow-through.
A strong answer does not require direct reports.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you made a decision with incomplete data...
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
) VALUES (
  'notion_q_192',
  'how-do-you-answer-tell-me-about-a-time-you-made-a-decision-with-incomplete-data-192',
  'How do you answer “Tell me about a time you made a decision with incomplete data”?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Explain the risk, the assumptions, the fast validation method, and the rollback plan.',
  'Explain the risk, the assumptions, the fast validation method, and the rollback plan.
Good answers show judgment under uncertainty, not recklessness.',
  NULL,
  'Explain the risk, the assumptions, the fast validation method, and the rollback plan.
Good answers show judgment under uncertainty, not recklessness.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Tell me about a time you helped your team succeed” in a stron...
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
) VALUES (
  'notion_q_193',
  'how-do-you-answer-tell-me-about-a-time-you-helped-your-team-succeed-in-a-strong--193',
  'How do you answer “Tell me about a time you helped your team succeed” in a strong way?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Focus on collective outcome, not personal heroics.',
  'Focus on collective outcome, not personal heroics.
Good examples include unblocking others, improving shared tooling, or absorbing operational load during critical moments.',
  NULL,
  'Focus on collective outcome, not personal heroics.
Good examples include unblocking others, improving shared tooling, or absorbing operational load during critical moments.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “What kind of manager/team environment helps you do your best ...
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
) VALUES (
  'notion_q_194',
  'how-do-you-answer-what-kind-of-managerteam-environment-helps-you-do-your-best-wo-194',
  'How do you answer “What kind of manager/team environment helps you do your best work?”',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Choose healthy traits: clarity, trust, accountability, feedback, room for ownership.',
  'Choose healthy traits: clarity, trust, accountability, feedback, room for ownership.
Avoid answers that make you sound fragile or difficult.',
  NULL,
  'Choose healthy traits: clarity, trust, accountability, feedback, room for ownership.
Avoid answers that make you sound fragile or difficult.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “How do you handle stress?” without sounding weak or robotic?...
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
) VALUES (
  'notion_q_195',
  'how-do-you-answer-how-do-you-handle-stress-without-sounding-weak-or-robotic-195',
  'How do you answer “How do you handle stress?” without sounding weak or robotic?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Show method, not emotion alone.',
  'Show method, not emotion alone.
Good answers mention prioritization, communication, boundary management, and long-term sustainability.',
  NULL,
  'Show method, not emotion alone.
Good answers mention prioritization, communication, boundary management, and long-term sustainability.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you buy time in English without sounding lost?...
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
) VALUES (
  'notion_q_196',
  'how-do-you-buy-time-in-english-without-sounding-lost-196',
  'How do you buy time in English without sounding lost?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Use short structured phrases such as:',
  'Use short structured phrases such as:
“That’s a good question. Let me structure my thoughts.”
“I want to make sure I answer this clearly.”
This sounds deliberate, not weak.',
  NULL,
  'Use short structured phrases such as:
“That’s a good question. Let me structure my thoughts.”
“I want to make sure I answer this clearly.”
This sounds deliberate, not weak.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer in English when you are not fully sure about a technical detai...
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
) VALUES (
  'notion_q_197',
  'how-do-you-answer-in-english-when-you-are-not-fully-sure-about-a-technical-detai-197',
  'How do you answer in English when you are not fully sure about a technical detail?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Do not bluff.',
  'Do not bluff.
Say: “I’m not fully certain of the exact implementation detail, but my understanding is…”
Then explain from first principles.',
  NULL,
  'Do not bluff.
Say: “I’m not fully certain of the exact implementation detail, but my understanding is…”
Then explain from first principles.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you stop your English behavioral answers from becoming too long?...
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
) VALUES (
  'notion_q_198',
  'how-do-you-stop-your-english-behavioral-answers-from-becoming-too-long-198',
  'How do you stop your English behavioral answers from becoming too long?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Use a simple structure: situation, decision, action, result.',
  'Use a simple structure: situation, decision, action, result.
If you start adding every background detail, the answer loses force.
Senior answers are usually tighter, not longer.',
  NULL,
  'Use a simple structure: situation, decision, action, result.
If you start adding every background detail, the answer loses force.
Senior answers are usually tighter, not longer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you sound more natural in English interviews?...
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
) VALUES (
  'notion_q_199',
  'how-do-you-sound-more-natural-in-english-interviews-199',
  'How do you sound more natural in English interviews?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Avoid memorized speeches.',
  'Avoid memorized speeches.
Practice transitions and key phrases instead of entire scripts.
Sounding slightly simple but clear is better than sounding ambitious but unnatural.',
  NULL,
  'Avoid memorized speeches.
Practice transitions and key phrases instead of entire scripts.
Sounding slightly simple but clear is better than sounding ambitious but unnatural.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What do Japanese companies often value in behavioral interviews?...
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
) VALUES (
  'notion_q_200',
  'what-do-japanese-companies-often-value-in-behavioral-interviews-200',
  'What do Japanese companies often value in behavioral interviews?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Stability',
  'Stability
Team orientation
Respectful communication
Reliability
Long-term contribution
Detail awareness
The best answers reflect those values without sounding artificial.',
  NULL,
  'Stability
Team orientation
Respectful communication
Reliability
Long-term contribution
Detail awareness
The best answers reflect those values without sounding artificial.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do international companies usually evaluate behavioral answers differently?...
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
) VALUES (
  'notion_q_201',
  'how-do-international-companies-usually-evaluate-behavioral-answers-differently-201',
  'How do international companies usually evaluate behavioral answers differently?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'They often emphasize ownership, initiative, impact, and data-based reasoning.',
  'They often emphasize ownership, initiative, impact, and data-based reasoning.
You can sound more direct, but still structured.
Strong answers show both technical competence and independent judgment.',
  NULL,
  'They often emphasize ownership, initiative, impact, and data-based reasoning.
You can sound more direct, but still structured.
Strong answers show both technical competence and independent judgment.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Why Japan?” or “Why an English-speaking role in Japan?”...
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
) VALUES (
  'notion_q_202',
  'how-do-you-answer-why-japan-or-why-an-english-speaking-role-in-japan-202',
  'How do you answer “Why Japan?” or “Why an English-speaking role in Japan?”',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Connect your answer to environment, market, engineering culture, and long-term career direction.',
  'Connect your answer to environment, market, engineering culture, and long-term career direction.
Avoid making it sound like an impulsive location choice.',
  NULL,
  'Connect your answer to environment, market, engineering culture, and long-term career direction.
Avoid making it sound like an impulsive location choice.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “How do you work in cross-cultural teams?”...
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
) VALUES (
  'notion_q_203',
  'how-do-you-answer-how-do-you-work-in-cross-cultural-teams-203',
  'How do you answer “How do you work in cross-cultural teams?”',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Emphasize clarity, proactive alignment, and respect for communication styles.',
  'Emphasize clarity, proactive alignment, and respect for communication styles.
Good answers show that you reduce misunderstanding instead of blaming culture.',
  NULL,
  'Emphasize clarity, proactive alignment, and respect for communication styles.
Good answers show that you reduce misunderstanding instead of blaming culture.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is a strong answer to “How do you communicate technical topics to non-techn...
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
) VALUES (
  'notion_q_204',
  'what-is-a-strong-answer-to-how-do-you-communicate-technical-topics-to-non-techni-204',
  'What is a strong answer to “How do you communicate technical topics to non-technical stakeholders?”',
  'cat_behavioral',
  'Easy',
  ARRAY['general']::TEXT[],
  'Translate impact, risk, trade-offs, and timeline into business terms.',
  'Translate impact, risk, trade-offs, and timeline into business terms.
Strong candidates know when not to overload people with engineering details.',
  NULL,
  'Translate impact, risk, trade-offs, and timeline into business terms.
Strong candidates know when not to overload people with engineering details.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you answer “Do you have any questions for us?” strategically?...
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
) VALUES (
  'notion_q_205',
  'how-do-you-answer-do-you-have-any-questions-for-us-strategically-205',
  'How do you answer “Do you have any questions for us?” strategically?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Ask about technical priorities, team challenges, onboarding, engineering decision-making, and success metrics.',
  'Ask about technical priorities, team challenges, onboarding, engineering decision-making, and success metrics.
Good questions show seriousness, not just politeness.',
  NULL,
  'Ask about technical priorities, team challenges, onboarding, engineering decision-making, and success metrics.
Good questions show seriousness, not just politeness.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is a failure answer weaker if the “lesson learned” sounds generic?...
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
) VALUES (
  'notion_q_206',
  'why-is-a-failure-answer-weaker-if-the-lesson-learned-sounds-generic-206',
  'Why is a failure answer weaker if the “lesson learned” sounds generic?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because it sounds rehearsed.',
  'Because it sounds rehearsed.
Strong answers show a concrete behavior change, not a vague moral.',
  NULL,
  'Because it sounds rehearsed.
Strong answers show a concrete behavior change, not a vague moral.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is a disagreement answer weak if you never acknowledge the other side’s reas...
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
) VALUES (
  'notion_q_207',
  'why-is-a-disagreement-answer-weak-if-you-never-acknowledge-the-other-sides-reaso-207',
  'Why is a disagreement answer weak if you never acknowledge the other side’s reasoning?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because it makes you sound combative rather than collaborative.',
  'Because it makes you sound combative rather than collaborative.
Senior candidates show that they can disagree without being difficult.',
  NULL,
  'Because it makes you sound combative rather than collaborative.
Senior candidates show that they can disagree without being difficult.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do over-polished STAR answers sometimes backfire?...
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
) VALUES (
  'notion_q_208',
  'why-do-over-polished-star-answers-sometimes-backfire-208',
  'Why do over-polished STAR answers sometimes backfire?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because they sound memorized.',
  'Because they sound memorized.
Interviewers often trust a slightly imperfect but real answer more than a polished script.',
  NULL,
  'Because they sound memorized.
Interviewers often trust a slightly imperfect but real answer more than a polished script.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why should you avoid answers where the team did everything and you did nothing s...
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
) VALUES (
  'notion_q_209',
  'why-should-you-avoid-answers-where-the-team-did-everything-and-you-did-nothing-s-209',
  'Why should you avoid answers where the team did everything and you did nothing specific?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because interviewers are trying to assess your contribution and judgment.',
  'Because interviewers are trying to assess your contribution and judgment.
Team context matters, but your role must still be clear.',
  NULL,
  'Because interviewers are trying to assess your contribution and judgment.
Team context matters, but your role must still be clear.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is a “pressure” answer weak if it only describes working harder?...
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
) VALUES (
  'notion_q_210',
  'why-is-a-pressure-answer-weak-if-it-only-describes-working-harder-210',
  'Why is a “pressure” answer weak if it only describes working harder?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because senior engineers are expected to manage pressure intelligently, not just absorb it physically.',
  'Because senior engineers are expected to manage pressure intelligently, not just absorb it physically.
Prioritization and communication matter more than raw effort.',
  NULL,
  'Because senior engineers are expected to manage pressure intelligently, not just absorb it physically.
Prioritization and communication matter more than raw effort.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is “I’m a perfectionist” still a bad weakness answer?...
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
) VALUES (
  'notion_q_211',
  'why-is-im-a-perfectionist-still-a-bad-weakness-answer-211',
  'Why is “I’m a perfectionist” still a bad weakness answer?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because interviewers have heard it too many times.',
  'Because interviewers have heard it too many times.
It signals performance awareness rather than self-awareness.',
  NULL,
  'Because interviewers have heard it too many times.
It signals performance awareness rather than self-awareness.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is a “why us?” answer weak if it could apply to any company?...
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
) VALUES (
  'notion_q_212',
  'why-is-a-why-us-answer-weak-if-it-could-apply-to-any-company-212',
  'Why is a “why us?” answer weak if it could apply to any company?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because it shows low preparation and low intent.',
  'Because it shows low preparation and low intent.
Specificity is what makes the answer believable.',
  NULL,
  'Because it shows low preparation and low intent.
Specificity is what makes the answer believable.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do some candidates fail even with strong stories?...
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
) VALUES (
  'notion_q_213',
  'why-do-some-candidates-fail-even-with-strong-stories-213',
  'Why do some candidates fail even with strong stories?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because their delivery lacks structure, ownership, or clarity.',
  'Because their delivery lacks structure, ownership, or clarity.
Content matters, but delivery discipline matters too.',
  NULL,
  'Because their delivery lacks structure, ownership, or clarity.
Content matters, but delivery discipline matters too.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why should you be careful with “hero story” answers?...
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
) VALUES (
  'notion_q_214',
  'why-should-you-be-careful-with-hero-story-answers-214',
  'Why should you be careful with “hero story” answers?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Because they can make you sound hard to work with.',
  'Because they can make you sound hard to work with.
Strong candidates show impact without erasing the team.',
  NULL,
  'Because they can make you sound hard to work with.
Strong candidates show impact without erasing the team.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What single detail makes behavioral answers sound much more senior?...
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
) VALUES (
  'notion_q_215',
  'what-single-detail-makes-behavioral-answers-sound-much-more-senior-215',
  'What single detail makes behavioral answers sound much more senior?',
  'cat_behavioral',
  'Medium',
  ARRAY['general']::TEXT[],
  'Naming the decision criteria you used.',
  'This page is intentionally broad and detailed. The final expansion page will cover algorithm explanation, coding-round follow-ups, and how to talk through LeetCode-style problems in English.',
  NULL,
  'Naming the decision criteria you used.
That instantly shifts the answer from storytelling to judgment.
Specific, not theatrical
Measured, not defensive
Structured, not rambling
Honest, but still professional
Focused on decisions, impact, and learning',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you tell whether an AI problem is really a model problem or a product or ...
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
) VALUES (
  'notion_q_216',
  'how-do-you-tell-whether-an-ai-problem-is-really-a-model-problem-or-a-product-or--216',
  'How do you tell whether an AI problem is really a model problem or a product or data problem?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Many failures blamed on the model are actually weak data, vague task definition, poor UX, or missing fallback logic.',
  'Many failures blamed on the model are actually weak data, vague task definition, poor UX, or missing fallback logic.
I first separate input quality, retrieval quality, prompt quality, model capability, and output handling.
If the task itself is underspecified, changing models usually just hides the root issue.',
  NULL,
  'Many failures blamed on the model are actually weak data, vague task definition, poor UX, or missing fallback logic.
I first separate input quality, retrieval quality, prompt quality, model capability, and output handling.
If the task itself is underspecified, changing models usually just hides the root issue.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does overfitting look like in an applied AI system, not just in a textbook?...
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
) VALUES (
  'notion_q_217',
  'what-does-overfitting-look-like-in-an-applied-ai-system-not-just-in-a-textbook-217',
  'What does overfitting look like in an applied AI system, not just in a textbook?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Offline scores look great on a narrow eval set, but real users ask messier questions.',
  'Offline scores look great on a narrow eval set, but real users ask messier questions.
The system performs well on known templates and fails on new customers, new domains, or long-tail inputs.
In practice I fight this with better eval coverage, time-based splits, and adversarial examples, not only more training.',
  NULL,
  'Offline scores look great on a narrow eval set, but real users ask messier questions.
The system performs well on known templates and fails on new customers, new domains, or long-tail inputs.
In practice I fight this with better eval coverage, time-based splits, and adversarial examples, not only more training.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain precision vs recall in a way that sounds practical?...
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
) VALUES (
  'notion_q_218',
  'how-do-you-explain-precision-vs-recall-in-a-way-that-sounds-practical-218',
  'How do you explain precision vs recall in a way that sounds practical?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'It depends on the business cost of false positives versus false negatives.',
  'It depends on the business cost of false positives versus false negatives.
For abuse or fraud, false negatives can be very expensive. For customer-facing automation, false positives can destroy trust.
I always ask which mistake hurts more before picking thresholds.',
  NULL,
  'It depends on the business cost of false positives versus false negatives.
For abuse or fraud, false negatives can be very expensive. For customer-facing automation, false positives can destroy trust.
I always ask which mistake hurts more before picking thresholds.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can offline metrics improve while the product gets worse?...
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
) VALUES (
  'notion_q_219',
  'why-can-offline-metrics-improve-while-the-product-gets-worse-219',
  'Why can offline metrics improve while the product gets worse?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Offline data is usually cleaner, shorter, and less adversarial than real traffic.',
  'Offline data is usually cleaner, shorter, and less adversarial than real traffic.
Users care about latency, trust, tone, recovery after failure, and effort saved, not just benchmark correctness.
Good teams connect offline evals with online outcomes like resolution rate, escalation rate, and retention.',
  NULL,
  'Offline data is usually cleaner, shorter, and less adversarial than real traffic.
Users care about latency, trust, tone, recovery after failure, and effort saved, not just benchmark correctness.
Good teams connect offline evals with online outcomes like resolution rate, escalation rate, and retention.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you distinguish hallucination from retrieval failure or tool failure?...
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
) VALUES (
  'notion_q_220',
  'how-do-you-distinguish-hallucination-from-retrieval-failure-or-tool-failure-220',
  'How do you distinguish hallucination from retrieval failure or tool failure?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'If the relevant fact never entered the context, it is usually a retrieval or context-assembly problem.',
  'If the relevant fact never entered the context, it is usually a retrieval or context-assembly problem.
If a tool returned stale or wrong data, the model may look wrong but the system failed upstream.
I only call it pure hallucination after checking source availability and traces.',
  NULL,
  'If the relevant fact never entered the context, it is usually a retrieval or context-assembly problem.
If a tool returned stale or wrong data, the model may look wrong but the system failed upstream.
I only call it pure hallucination after checking source availability and traces.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is a smaller model actually the better engineering choice?...
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
) VALUES (
  'notion_q_221',
  'when-is-a-smaller-model-actually-the-better-engineering-choice-221',
  'When is a smaller model actually the better engineering choice?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Extraction, classification, moderation, reranking, and short-format tasks often do not need the largest model.',
  'Extraction, classification, moderation, reranking, and short-format tasks often do not need the largest model.
Smaller models can win on latency, cost, throughput, and operational stability.
I prefer the smallest model that reliably clears the quality bar.',
  NULL,
  'Extraction, classification, moderation, reranking, and short-format tasks often do not need the largest model.
Smaller models can win on latency, cost, throughput, and operational stability.
I prefer the smallest model that reliably clears the quality bar.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is distribution shift, and where does it show up in AI products?...
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
) VALUES (
  'notion_q_222',
  'what-is-distribution-shift-and-where-does-it-show-up-in-ai-products-222',
  'What is distribution shift, and where does it show up in AI products?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'The data in production changes from what the system was evaluated or trained on.',
  'The data in production changes from what the system was evaluated or trained on.
It shows up when a product expands to new geographies, new document types, new customer segments, or new attacker behavior.
If you do not monitor drift, your offline confidence becomes fake quickly.',
  NULL,
  'The data in production changes from what the system was evaluated or trained on.
It shows up when a product expands to new geographies, new document types, new customer segments, or new attacker behavior.
If you do not monitor drift, your offline confidence becomes fake quickly.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What data quality problem hurts AI systems the most?...
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
) VALUES (
  'notion_q_223',
  'what-data-quality-problem-hurts-ai-systems-the-most-223',
  'What data quality problem hurts AI systems the most?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Ambiguous labels and inconsistent ground truth.',
  'Ambiguous labels and inconsistent ground truth.
Teams often focus on model architecture while different annotators are judging different things.
If the target definition is unstable, the model cannot become reliably stable.',
  NULL,
  'Ambiguous labels and inconsistent ground truth.
Teams often focus on model architecture while different annotators are judging different things.
If the target definition is unstable, the model cannot become reliably stable.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain the latency-quality-cost triangle?...
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
) VALUES (
  'notion_q_224',
  'how-do-you-explain-the-latency-quality-cost-triangle-224',
  'How do you explain the latency-quality-cost triangle?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Better quality often means more tokens, larger models, more tools, or more retrieval steps.',
  'Better quality often means more tokens, larger models, more tools, or more retrieval steps.
Lower latency usually means smaller models, caching, shallower reasoning, or fewer round trips.
Good engineering is not maximizing one dimension. It is finding the right frontier for the product.',
  NULL,
  'Better quality often means more tokens, larger models, more tools, or more retrieval steps.
Lower latency usually means smaller models, caching, shallower reasoning, or fewer round trips.
Good engineering is not maximizing one dimension. It is finding the right frontier for the product.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do you still build a non-LLM baseline for some AI tasks?...
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
) VALUES (
  'notion_q_225',
  'why-do-you-still-build-a-non-llm-baseline-for-some-ai-tasks-225',
  'Why do you still build a non-LLM baseline for some AI tasks?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'Many tasks are partially structured, and a rules or classical ML baseline tells you whether the LLM is really earning its cost.',
  'Many tasks are partially structured, and a rules or classical ML baseline tells you whether the LLM is really earning its cost.
Baselines help estimate lift instead of excitement.
If regex plus lookup solves most safe cases, the LLM should handle the messy remainder rather than replace everything.',
  NULL,
  'Many tasks are partially structured, and a rules or classical ML baseline tells you whether the LLM is really earning its cost.
Baselines help estimate lift instead of excitement.
If regex plus lookup solves most safe cases, the LLM should handle the messy remainder rather than replace everything.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain a transformer like an engineer, not like a researcher?...
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
) VALUES (
  'notion_q_226',
  'how-do-you-explain-a-transformer-like-an-engineer-not-like-a-researcher-226',
  'How do you explain a transformer like an engineer, not like a researcher?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'It converts text into tokens, builds contextual representations with attention, then predicts the next token repeatedly.',
  'It converts text into tokens, builds contextual representations with attention, then predicts the next token repeatedly.
The key practical point is that every answer is shaped by tokenization, context construction, and decoding strategy.
In interviews I avoid drowning in math unless they ask for it.',
  NULL,
  'It converts text into tokens, builds contextual representations with attention, then predicts the next token repeatedly.
The key practical point is that every answer is shaped by tokenization, context construction, and decoding strategy.
In interviews I avoid drowning in math unless they ask for it.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why does tokenization matter in real systems?...
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
) VALUES (
  'notion_q_227',
  'why-does-tokenization-matter-in-real-systems-227',
  'Why does tokenization matter in real systems?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'Cost is billed per token, latency scales with tokens, and some inputs tokenize much worse than people expect.',
  'Cost is billed per token, latency scales with tokens, and some inputs tokenize much worse than people expect.
Code, JSON, tables, and multilingual text can explode token counts.
Tokenization also affects truncation, prompt design, and chunking decisions.',
  NULL,
  'Cost is billed per token, latency scales with tokens, and some inputs tokenize much worse than people expect.
Code, JSON, tables, and multilingual text can explode token counts.
Tokenization also affects truncation, prompt design, and chunking decisions.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do temperature and top-p change model behavior?...
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
) VALUES (
  'notion_q_228',
  'how-do-temperature-and-top-p-change-model-behavior-228',
  'How do temperature and top-p change model behavior?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'Temperature changes how sharp or random the distribution is.',
  'Temperature changes how sharp or random the distribution is.
Top-p limits sampling to a dynamic probability mass.
I use lower randomness for extraction and tool use, and more randomness only when diversity is useful.',
  NULL,
  'Temperature changes how sharp or random the distribution is.
Top-p limits sampling to a dynamic probability mass.
I use lower randomness for extraction and tool use, and more randomness only when diversity is useful.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is temperature 0 not the same as guaranteed determinism?...
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
) VALUES (
  'notion_q_229',
  'why-is-temperature-0-not-the-same-as-guaranteed-determinism-229',
  'Why is temperature 0 not the same as guaranteed determinism?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'There can still be implementation variance, tie-breaking differences, model version changes, or non-deterministic serving paths.',
  'There can still be implementation variance, tie-breaking differences, model version changes, or non-deterministic serving paths.
Tool outputs and retrieval order can also change the result even if decoding looks fixed.
I promise reproducibility only with controlled inputs, version pinning, and tight evaluation.',
  NULL,
  'There can still be implementation variance, tie-breaking differences, model version changes, or non-deterministic serving paths.
Tool outputs and retrieval order can also change the result even if decoding looks fixed.
I promise reproducibility only with controlled inputs, version pinning, and tight evaluation.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the difference between pretraining, instruction tuning, and preference a...
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
) VALUES (
  'notion_q_230',
  'what-is-the-difference-between-pretraining-instruction-tuning-and-preference-ali-230',
  'What is the difference between pretraining, instruction tuning, and preference alignment?',
  'cat_ai',
  'Easy',
  ARRAY['llm']::TEXT[],
  'Pretraining builds general language and world knowledge.',
  'Pretraining builds general language and world knowledge.
Instruction tuning teaches the model to follow task formats and conversational instructions.
Preference alignment pushes it toward more helpful, safer, or stylistically preferred responses.',
  NULL,
  'Pretraining builds general language and world knowledge.
Instruction tuning teaches the model to follow task formats and conversational instructions.
Preference alignment pushes it toward more helpful, safer, or stylistically preferred responses.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do system prompt, user prompt, retrieved context, and tool results interact?...
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
) VALUES (
  'notion_q_231',
  'how-do-system-prompt-user-prompt-retrieved-context-and-tool-results-interact-231',
  'How do system prompt, user prompt, retrieved context, and tool results interact?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'The system prompt sets high-level policy and task framing.',
  'The system prompt sets high-level policy and task framing.
User input expresses the actual request.
Retrieved context and tool results provide grounding, but only if they are relevant and clean.
In practice most failures come from bad context assembly, not from one magic prompt sentence.',
  NULL,
  'The system prompt sets high-level policy and task framing.
User input expresses the actual request.
Retrieved context and tool results provide grounding, but only if they are relevant and clean.
In practice most failures come from bad context assembly, not from one magic prompt sentence.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is a long context window not a free win?...
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
) VALUES (
  'notion_q_232',
  'why-is-a-long-context-window-not-a-free-win-232',
  'Why is a long context window not a free win?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'More context increases cost and latency, and it can bury the important evidence under noise.',
  'More context increases cost and latency, and it can bury the important evidence under noise.
Retrieval quality matters more than blindly stuffing context.
I prefer sending the right 5 chunks over the wrong 50.',
  NULL,
  'More context increases cost and latency, and it can bury the important evidence under noise.
Retrieval quality matters more than blindly stuffing context.
I prefer sending the right 5 chunks over the wrong 50.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the KV cache, and why should application engineers care?...
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
) VALUES (
  'notion_q_233',
  'what-is-the-kv-cache-and-why-should-application-engineers-care-233',
  'What is the KV cache, and why should application engineers care?',
  'cat_ai',
  'Easy',
  ARRAY['llm']::TEXT[],
  'It stores intermediate attention states so the model does not recompute the whole prefix for every generated token.',
  'It stores intermediate attention states so the model does not recompute the whole prefix for every generated token.
That matters for chat, long prompts, multi-turn conversations, and throughput planning.
If you ignore it, you will misunderstand where latency and GPU memory go.',
  NULL,
  'It stores intermediate attention states so the model does not recompute the whole prefix for every generated token.
That matters for chat, long prompts, multi-turn conversations, and throughput planning.
If you ignore it, you will misunderstand where latency and GPU memory go.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the difference between prefill and decode?...
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
) VALUES (
  'notion_q_234',
  'what-is-the-difference-between-prefill-and-decode-234',
  'What is the difference between prefill and decode?',
  'cat_ai',
  'Easy',
  ARRAY['llm']::TEXT[],
  'Prefill processes the input prompt and usually uses compute efficiently.',
  'Prefill processes the input prompt and usually uses compute efficiently.
Decode generates tokens one by one and is often the long pole for latency.
This is why long answers can feel much slower even when the prompt is small.',
  NULL,
  'Prefill processes the input prompt and usually uses compute efficiently.
Decode generates tokens one by one and is often the long pole for latency.
This is why long answers can feel much slower even when the prompt is small.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you use a reasoning-heavy model versus a faster general model?...
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
) VALUES (
  'notion_q_235',
  'when-do-you-use-a-reasoning-heavy-model-versus-a-faster-general-model-235',
  'When do you use a reasoning-heavy model versus a faster general model?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'I use stronger reasoning when the task needs planning, code generation, tool sequencing, or careful exception handling.',
  'I use stronger reasoning when the task needs planning, code generation, tool sequencing, or careful exception handling.
I use faster models for routing, extraction, short classification, and UI-speed interactions.
Good systems route work instead of forcing every request through the most expensive model.',
  NULL,
  'I use stronger reasoning when the task needs planning, code generation, tool sequencing, or careful exception handling.
I use faster models for routing, extraction, short classification, and UI-speed interactions.
Good systems route work instead of forcing every request through the most expensive model.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you choose RAG over fine-tuning?...
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
) VALUES (
  'notion_q_236',
  'when-do-you-choose-rag-over-fine-tuning-236',
  'When do you choose RAG over fine-tuning?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'I use RAG when the main problem is changing knowledge, private knowledge, or citation needs.',
  'I use RAG when the main problem is changing knowledge, private knowledge, or citation needs.
I use fine-tuning when I want behavior change, format consistency, domain style, or stronger performance on repeated patterns.
If the knowledge changes weekly, tuning is usually the wrong first move.',
  NULL,
  'I use RAG when the main problem is changing knowledge, private knowledge, or citation needs.
I use fine-tuning when I want behavior change, format consistency, domain style, or stronger performance on repeated patterns.
If the knowledge changes weekly, tuning is usually the wrong first move.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the minimum RAG pipeline you would trust in production?...
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
) VALUES (
  'notion_q_237',
  'what-is-the-minimum-rag-pipeline-you-would-trust-in-production-237',
  'What is the minimum RAG pipeline you would trust in production?',
  'cat_ai',
  'Easy',
  ARRAY['rag']::TEXT[],
  'Clean document ingestion',
  'Clean document ingestion
Reasonable chunking and metadata
Retrieval with filtering
Optional reranking
Grounded prompting with citations or source visibility
Logging for retrieved chunks and final answers',
  NULL,
  'Clean document ingestion
Reasonable chunking and metadata
Retrieval with filtering
Optional reranking
Grounded prompting with citations or source visibility
Logging for retrieved chunks and final answers',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose chunk size and chunk overlap?...
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
) VALUES (
  'notion_q_238',
  'how-do-you-choose-chunk-size-and-chunk-overlap-238',
  'How do you choose chunk size and chunk overlap?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'Based on meaning boundaries, not one universal number.',
  'Based on meaning boundaries, not one universal number.
If chunks are too small, you lose context. If they are too big, retrieval becomes noisy and expensive.
I usually start with document-aware chunking and then tune on failure cases.',
  NULL,
  'Based on meaning boundaries, not one universal number.
If chunks are too small, you lose context. If they are too big, retrieval becomes noisy and expensive.
I usually start with document-aware chunking and then tune on failure cases.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is hybrid retrieval often better than embeddings alone?...
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
) VALUES (
  'notion_q_239',
  'why-is-hybrid-retrieval-often-better-than-embeddings-alone-239',
  'Why is hybrid retrieval often better than embeddings alone?',
  'cat_ai',
  'Medium',
  ARRAY['rag', 'embeddings']::TEXT[],
  'Dense retrieval is good at semantic similarity but can miss exact terms, IDs, codes, and rare keywords.',
  'Dense retrieval is good at semantic similarity but can miss exact terms, IDs, codes, and rare keywords.
Sparse retrieval catches lexical matches better.
Hybrid search is often the most pragmatic default for enterprise docs.',
  NULL,
  'Dense retrieval is good at semantic similarity but can miss exact terms, IDs, codes, and rare keywords.
Sparse retrieval catches lexical matches better.
Hybrid search is often the most pragmatic default for enterprise docs.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is a reranker worth the extra latency?...
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
) VALUES (
  'notion_q_240',
  'when-is-a-reranker-worth-the-extra-latency-240',
  'When is a reranker worth the extra latency?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'When first-stage recall is okay but ordering is poor.',
  'When first-stage recall is okay but ordering is poor.
A reranker helps when many retrieved chunks are vaguely relevant and only a few are actually answer-bearing.
I add it when the quality lift beats the latency cost on real evals.',
  NULL,
  'When first-stage recall is okay but ordering is poor.
A reranker helps when many retrieved chunks are vaguely relevant and only a few are actually answer-bearing.
I add it when the quality lift beats the latency cost on real evals.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why are metadata filters underrated in RAG?...
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
) VALUES (
  'notion_q_241',
  'why-are-metadata-filters-underrated-in-rag-241',
  'Why are metadata filters underrated in RAG?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'Retrieval quality is often destroyed by asking the model to search the entire universe.',
  'Retrieval quality is often destroyed by asking the model to search the entire universe.
Filtering by tenant, region, product, doc type, freshness, or permission can improve both precision and safety.
Good retrieval is usually a search-space problem before it is a model problem.',
  NULL,
  'Retrieval quality is often destroyed by asking the model to search the entire universe.
Filtering by tenant, region, product, doc type, freshness, or permission can improve both precision and safety.
Good retrieval is usually a search-space problem before it is a model problem.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you evaluate a RAG system beyond "the answer looks okay"?...
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
) VALUES (
  'notion_q_242',
  'how-do-you-evaluate-a-rag-system-beyond-the-answer-looks-okay-242',
  'How do you evaluate a RAG system beyond "the answer looks okay"?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'I evaluate retrieval separately from generation.',
  'I evaluate retrieval separately from generation.
For retrieval I check whether the right evidence was found in top-k.
For generation I check groundedness, citation quality, completeness, and whether the answer overstates confidence.',
  NULL,
  'I evaluate retrieval separately from generation.
For retrieval I check whether the right evidence was found in top-k.
For generation I check groundedness, citation quality, completeness, and whether the answer overstates confidence.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you handle stale knowledge in a RAG system?...
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
) VALUES (
  'notion_q_243',
  'how-do-you-handle-stale-knowledge-in-a-rag-system-243',
  'How do you handle stale knowledge in a RAG system?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'I track document freshness and make it visible in the answer when relevant.',
  'I track document freshness and make it visible in the answer when relevant.
I design ingestion and re-embedding flows so important updates appear quickly.
I would rather answer "I only found docs up to last month" than sound confidently outdated.',
  NULL,
  'I track document freshness and make it visible in the answer when relevant.
I design ingestion and re-embedding flows so important updates appear quickly.
I would rather answer "I only found docs up to last month" than sound confidently outdated.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is multi-hop retrieval, and when do you need it?...
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
) VALUES (
  'notion_q_244',
  'what-is-multi-hop-retrieval-and-when-do-you-need-it-244',
  'What is multi-hop retrieval, and when do you need it?',
  'cat_ai',
  'Easy',
  ARRAY['rag']::TEXT[],
  'Some questions require finding one fact that points to a second fact in another source.',
  'Some questions require finding one fact that points to a second fact in another source.
This shows up in troubleshooting, policy exceptions, or document sets with cross-references.
Single-shot retrieval fails here because the right second query depends on the first result.',
  NULL,
  'Some questions require finding one fact that points to a second fact in another source.
This shows up in troubleshooting, policy exceptions, or document sets with cross-references.
Single-shot retrieval fails here because the right second query depends on the first result.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What are the most common RAG failure modes you have seen?...
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
) VALUES (
  'notion_q_245',
  'what-are-the-most-common-rag-failure-modes-you-have-seen-245',
  'What are the most common RAG failure modes you have seen?',
  'cat_ai',
  'Medium',
  ARRAY['rag']::TEXT[],
  'Wrong chunk retrieved because of bad chunk boundaries',
  'Wrong chunk retrieved because of bad chunk boundaries
Right chunk retrieved but buried in too much irrelevant context
Tool or permission mismatch causing incomplete evidence
The model answering from prior knowledge instead of the retrieved source
Missing freshness and source visibility',
  NULL,
  'Wrong chunk retrieved because of bad chunk boundaries
Right chunk retrieved but buried in too much irrelevant context
Tool or permission mismatch causing incomplete evidence
The model answering from prior knowledge instead of the retrieved source
Missing freshness and source visibility',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is a workflow better than an agent?...
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
) VALUES (
  'notion_q_246',
  'when-is-a-workflow-better-than-an-agent-246',
  'When is a workflow better than an agent?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'When the steps are known, high-risk, or require consistent latency and explainability.',
  'When the steps are known, high-risk, or require consistent latency and explainability.
Workflows are easier to test and operate.
I use agents when the task genuinely needs dynamic tool selection or adaptive planning, not because "agent" sounds advanced.',
  NULL,
  'When the steps are known, high-risk, or require consistent latency and explainability.
Workflows are easier to test and operate.
I use agents when the task genuinely needs dynamic tool selection or adaptive planning, not because "agent" sounds advanced.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What makes a good tool definition for model tool calling?...
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
) VALUES (
  'notion_q_247',
  'what-makes-a-good-tool-definition-for-model-tool-calling-247',
  'What makes a good tool definition for model tool calling?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Narrow purpose, clear parameters, explicit constraints, and predictable outputs.',
  'Narrow purpose, clear parameters, explicit constraints, and predictable outputs.
Bad tools are vague, overloaded, or force the model to guess missing fields.
A tool should be easy for both the model and the human operator to reason about.',
  NULL,
  'Narrow purpose, clear parameters, explicit constraints, and predictable outputs.
Bad tools are vague, overloaded, or force the model to guess missing fields.
A tool should be easy for both the model and the human operator to reason about.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you prevent destructive tool misuse?...
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
) VALUES (
  'notion_q_248',
  'how-do-you-prevent-destructive-tool-misuse-248',
  'How do you prevent destructive tool misuse?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Separate read tools from write tools.',
  'Separate read tools from write tools.
Add authorization, confirmation gates, and parameter validation before side effects.
I never rely on the model alone to decide whether a risky action is safe.',
  NULL,
  'Separate read tools from write tools.
Add authorization, confirmation gates, and parameter validation before side effects.
I never rely on the model alone to decide whether a risky action is safe.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is idempotency critical in agent systems?...
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
) VALUES (
  'notion_q_249',
  'why-is-idempotency-critical-in-agent-systems-249',
  'Why is idempotency critical in agent systems?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Retries, duplicate tool calls, and loop bugs happen.',
  'Retries, duplicate tool calls, and loop bugs happen.
If "create ticket" or "refund order" is not idempotent, one model mistake becomes a business incident.
Tool design has to assume imperfect orchestration.',
  NULL,
  'Retries, duplicate tool calls, and loop bugs happen.
If "create ticket" or "refund order" is not idempotent, one model mistake becomes a business incident.
Tool design has to assume imperfect orchestration.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does memory mean in an agent system?...
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
) VALUES (
  'notion_q_250',
  'what-does-memory-mean-in-an-agent-system-250',
  'What does memory mean in an agent system?',
  'cat_ai',
  'Medium',
  ARRAY['memory']::TEXT[],
  'Short-term memory is the working context for the current task.',
  'Short-term memory is the working context for the current task.
Long-term memory is stored user or workflow state reused later.
Many teams call everything "memory," but the real question is what should persist, for how long, and under what trust level.',
  NULL,
  'Short-term memory is the working context for the current task.
Long-term memory is stored user or workflow state reused later.
Many teams call everything "memory," but the real question is what should persist, for how long, and under what trust level.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you debug an agent failure?...
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
) VALUES (
  'notion_q_251',
  'how-do-you-debug-an-agent-failure-251',
  'How do you debug an agent failure?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Reconstruct the trace: prompt, retrieved context, tool calls, tool outputs, and final decision.',
  'Reconstruct the trace: prompt, retrieved context, tool calls, tool outputs, and final decision.
Split the failure into planning, tool selection, parameter extraction, tool correctness, and answer synthesis.
If you cannot replay the exact path, you are still debugging blind.',
  NULL,
  'Reconstruct the trace: prompt, retrieved context, tool calls, tool outputs, and final decision.
Split the failure into planning, tool selection, parameter extraction, tool correctness, and answer synthesis.
If you cannot replay the exact path, you are still debugging blind.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do structured outputs matter?...
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
) VALUES (
  'notion_q_252',
  'why-do-structured-outputs-matter-252',
  'Why do structured outputs matter?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Free text is easy for demos and painful for systems.',
  'Free text is easy for demos and painful for systems.
Structured outputs make downstream validation, storage, UI rendering, and fallback logic much safer.
I prefer constraining the output contract early rather than fixing parsing with regex later.',
  NULL,
  'Free text is easy for demos and painful for systems.
Structured outputs make downstream validation, storage, UI rendering, and fallback logic much safer.
I prefer constraining the output contract early rather than fixing parsing with regex later.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is MCP, and where is it useful?...
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
) VALUES (
  'notion_q_253',
  'what-is-mcp-and-where-is-it-useful-253',
  'What is MCP, and where is it useful?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'It standardizes how tools and context providers are exposed to AI applications.',
  'It standardizes how tools and context providers are exposed to AI applications.
It is useful when you want a cleaner boundary between models, clients, and external systems such as docs, tickets, files, or internal services.
The real benefit is interoperability and less one-off glue code.',
  NULL,
  'It standardizes how tools and context providers are exposed to AI applications.
It is useful when you want a cleaner boundary between models, clients, and external systems such as docs, tickets, files, or internal services.
The real benefit is interoperability and less one-off glue code.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When do you put a human in the loop?...
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
) VALUES (
  'notion_q_254',
  'when-do-you-put-a-human-in-the-loop-254',
  'When do you put a human in the loop?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'High-risk actions',
  'High-risk actions
Low-confidence outputs
Expensive mistakes
Ambiguous policy decisions
Novel cases that your evals do not cover well',
  NULL,
  'High-risk actions
Low-confidence outputs
Expensive mistakes
Ambiguous policy decisions
Novel cases that your evals do not cover well',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What metrics matter for agent systems besides model accuracy?...
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
) VALUES (
  'notion_q_255',
  'what-metrics-matter-for-agent-systems-besides-model-accuracy-255',
  'What metrics matter for agent systems besides model accuracy?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Task completion rate',
  'Task completion rate
Tool success rate
Step count
Retry rate
Human takeover rate
Latency and cost per successful task
Safety violations and bad side effects',
  NULL,
  'Task completion rate
Tool success rate
Step count
Retry rate
Human takeover rate
Latency and cost per successful task
Safety violations and bad side effects',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is fine-tuning actually the right move?...
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
) VALUES (
  'notion_q_256',
  'when-is-fine-tuning-actually-the-right-move-256',
  'When is fine-tuning actually the right move?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'When prompting and retrieval hit a plateau and the task pattern is repetitive enough to justify specialized model behavior.',
  'When prompting and retrieval hit a plateau and the task pattern is repetitive enough to justify specialized model behavior.
Good reasons include format reliability, domain tone, extraction consistency, or reducing long prompt overhead.
It is a bad escape hatch for messy labels and poor system design.',
  NULL,
  'When prompting and retrieval hit a plateau and the task pattern is repetitive enough to justify specialized model behavior.
Good reasons include format reliability, domain tone, extraction consistency, or reducing long prompt overhead.
It is a bad escape hatch for messy labels and poor system design.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the real difference between prompt engineering and supervised fine-tunin...
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
) VALUES (
  'notion_q_257',
  'what-is-the-real-difference-between-prompt-engineering-and-supervised-fine-tunin-257',
  'What is the real difference between prompt engineering and supervised fine-tuning?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'Prompting changes the instructions at inference time.',
  'Prompting changes the instructions at inference time.
Fine-tuning changes the model behavior itself through examples.
If you need the behavior on every call and the prompt keeps becoming huge, tuning becomes more attractive.',
  NULL,
  'Prompting changes the instructions at inference time.
Fine-tuning changes the model behavior itself through examples.
If you need the behavior on every call and the prompt keeps becoming huge, tuning becomes more attractive.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain LoRA or PEFT in a practical way?...
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
) VALUES (
  'notion_q_258',
  'how-do-you-explain-lora-or-peft-in-a-practical-way-258',
  'How do you explain LoRA or PEFT in a practical way?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'They adapt part of the model behavior with far fewer trainable parameters than full fine-tuning.',
  'They adapt part of the model behavior with far fewer trainable parameters than full fine-tuning.
That reduces training cost and makes experimentation faster.
They are not magic. Data quality and eval discipline still dominate.',
  NULL,
  'They adapt part of the model behavior with far fewer trainable parameters than full fine-tuning.
That reduces training cost and makes experimentation faster.
They are not magic. Data quality and eval discipline still dominate.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What training data do you need before you fine-tune?...
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
) VALUES (
  'notion_q_259',
  'what-training-data-do-you-need-before-you-fine-tune-259',
  'What training data do you need before you fine-tune?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'A clear task definition',
  'A clear task definition
Consistent high-quality target outputs
Coverage of normal cases and ugly edge cases
Enough hard examples to prevent shallow pattern matching
A held-out set you did not handcraft to flatter the model',
  NULL,
  'A clear task definition
Consistent high-quality target outputs
Coverage of normal cases and ugly edge cases
Enough hard examples to prevent shallow pattern matching
A held-out set you did not handcraft to flatter the model',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is synthetic data helpful, and when is it dangerous?...
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
) VALUES (
  'notion_q_260',
  'when-is-synthetic-data-helpful-and-when-is-it-dangerous-260',
  'When is synthetic data helpful, and when is it dangerous?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Helpful when you need coverage, variation, or bootstrapping for narrow tasks.',
  'Helpful when you need coverage, variation, or bootstrapping for narrow tasks.
Dangerous when the teacher model injects bias, boring patterns, or confident errors that the student then imitates.
I treat synthetic data as leverage, not as ground truth.',
  NULL,
  'Helpful when you need coverage, variation, or bootstrapping for narrow tasks.
Dangerous when the teacher model injects bias, boring patterns, or confident errors that the student then imitates.
I treat synthetic data as leverage, not as ground truth.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you explain RLHF versus DPO?...
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
) VALUES (
  'notion_q_261',
  'how-do-you-explain-rlhf-versus-dpo-261',
  'How do you explain RLHF versus DPO?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Both aim to align model behavior with human preferences.',
  'Both aim to align model behavior with human preferences.
RLHF is a heavier pipeline with a reward-modeling step and reinforcement optimization.
DPO is a simpler preference-optimization approach that is easier to operationalize in many cases.
The interview answer should focus on trade-offs, not just acronyms.',
  NULL,
  'Both aim to align model behavior with human preferences.
RLHF is a heavier pipeline with a reward-modeling step and reinforcement optimization.
DPO is a simpler preference-optimization approach that is easier to operationalize in many cases.
The interview answer should focus on trade-offs, not just acronyms.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is catastrophic forgetting, and how do you reduce it?...
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
) VALUES (
  'notion_q_262',
  'what-is-catastrophic-forgetting-and-how-do-you-reduce-it-262',
  'What is catastrophic forgetting, and how do you reduce it?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'The model gets better at the fine-tuned task but worse at general capabilities or earlier skills.',
  'The model gets better at the fine-tuned task but worse at general capabilities or earlier skills.
I reduce it with careful data mixture, eval coverage across old and new tasks, and not over-tuning for one narrow benchmark.
If you do not measure regression, you will not notice it until users do.',
  NULL,
  'The model gets better at the fine-tuned task but worse at general capabilities or earlier skills.
I reduce it with careful data mixture, eval coverage across old and new tasks, and not over-tuning for one narrow benchmark.
If you do not measure regression, you will not notice it until users do.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When does distillation make sense?...
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
) VALUES (
  'notion_q_263',
  'when-does-distillation-make-sense-263',
  'When does distillation make sense?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'When you have a strong but slow or expensive teacher and a cheaper student can learn enough of the behavior for production.',
  'When you have a strong but slow or expensive teacher and a cheaper student can learn enough of the behavior for production.
It is useful for classification, ranking, extraction, and repetitive enterprise tasks.
I do not assume the student will keep the teacher''s long-tail reasoning quality.',
  NULL,
  'When you have a strong but slow or expensive teacher and a cheaper student can learn enough of the behavior for production.
It is useful for classification, ranking, extraction, and repetitive enterprise tasks.
I do not assume the student will keep the teacher''s long-tail reasoning quality.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When should you route to different models instead of building one heavily tuned ...
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
) VALUES (
  'notion_q_264',
  'when-should-you-route-to-different-models-instead-of-building-one-heavily-tuned--264',
  'When should you route to different models instead of building one heavily tuned model?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'When task types are clearly different, latency budgets differ, or the expensive model is only needed for a subset of traffic.',
  'When task types are clearly different, latency budgets differ, or the expensive model is only needed for a subset of traffic.
Routing is often more flexible than forcing one model to do everything.
But routing adds complexity, so the gain has to justify the orchestration cost.',
  NULL,
  'When task types are clearly different, latency budgets differ, or the expensive model is only needed for a subset of traffic.
Routing is often more flexible than forcing one model to do everything.
But routing adds complexity, so the gain has to justify the orchestration cost.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you evaluate whether fine-tuning was worth it?...
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
) VALUES (
  'notion_q_265',
  'how-do-you-evaluate-whether-fine-tuning-was-worth-it-265',
  'How do you evaluate whether fine-tuning was worth it?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Compare against the best prompt-only and RAG baselines, not against a weak baseline.',
  'Compare against the best prompt-only and RAG baselines, not against a weak baseline.
Measure format accuracy, task success, latency, prompt length reduction, and cost per successful outcome.
If the only gain is benchmark vanity, it is probably not worth carrying operationally.',
  NULL,
  'Compare against the best prompt-only and RAG baselines, not against a weak baseline.
Measure format accuracy, task success, latency, prompt length reduction, and cost per successful outcome.
If the only gain is benchmark vanity, it is probably not worth carrying operationally.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you break down LLM latency in production?...
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
) VALUES (
  'notion_q_266',
  'how-do-you-break-down-llm-latency-in-production-266',
  'How do you break down LLM latency in production?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'Network and queueing',
  'Network and queueing
Prompt construction and retrieval
Prefill time
Decode time
Tool round trips
Post-processing and validation
If you only measure end-to-end latency, you will optimize the wrong layer.',
  NULL,
  'Network and queueing
Prompt construction and retrieval
Prefill time
Decode time
Tool round trips
Post-processing and validation
If you only measure end-to-end latency, you will optimize the wrong layer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is the difference between static batching and continuous batching?...
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
) VALUES (
  'notion_q_267',
  'what-is-the-difference-between-static-batching-and-continuous-batching-267',
  'What is the difference between static batching and continuous batching?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'Static batching groups requests together at fixed boundaries.',
  'Static batching groups requests together at fixed boundaries.
Continuous batching keeps filling the GPU as requests enter and finish.
In high-volume serving, continuous batching often gives better throughput, but it complicates scheduling and tail latency behavior.',
  NULL,
  'Static batching groups requests together at fixed boundaries.
Continuous batching keeps filling the GPU as requests enter and finish.
In high-volume serving, continuous batching often gives better throughput, but it complicates scheduling and tail latency behavior.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What are the real trade-offs of quantization?...
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
) VALUES (
  'notion_q_268',
  'what-are-the-real-trade-offs-of-quantization-268',
  'What are the real trade-offs of quantization?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Lower memory use and cheaper serving',
  'Lower memory use and cheaper serving
Often better throughput
Possible quality loss, especially on sensitive reasoning or generation tasks
I evaluate quantization by task, not as a universal good or bad.',
  NULL,
  'Lower memory use and cheaper serving
Often better throughput
Possible quality loss, especially on sensitive reasoning or generation tasks
I evaluate quantization by task, not as a universal good or bad.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is speculative decoding, and when is it useful?...
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
) VALUES (
  'notion_q_269',
  'what-is-speculative-decoding-and-when-is-it-useful-269',
  'What is speculative decoding, and when is it useful?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'A smaller draft model proposes tokens and a larger target model verifies them.',
  'A smaller draft model proposes tokens and a larger target model verifies them.
It can reduce decode latency when the acceptance rate is good.
The value depends on the serving stack and workload mix, not just on the idea sounding clever.',
  NULL,
  'A smaller draft model proposes tokens and a larger target model verifies them.
It can reduce decode latency when the acceptance rate is good.
The value depends on the serving stack and workload mix, not just on the idea sounding clever.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is prefix or prompt caching, and where does it help?...
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
) VALUES (
  'notion_q_270',
  'what-is-prefix-or-prompt-caching-and-where-does-it-help-270',
  'What is prefix or prompt caching, and where does it help?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'If many requests share the same long prefix, the system can reuse work instead of recomputing from scratch.',
  'If many requests share the same long prefix, the system can reuse work instead of recomputing from scratch.
It helps with repeated system prompts, standard policies, templates, or shared document context.
It does not help much when every request is truly unique.',
  NULL,
  'If many requests share the same long prefix, the system can reuse work instead of recomputing from scratch.
It helps with repeated system prompts, standard policies, templates, or shared document context.
It does not help much when every request is truly unique.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can GPU utilization stay mediocre even when traffic is high?...
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
) VALUES (
  'notion_q_271',
  'why-can-gpu-utilization-stay-mediocre-even-when-traffic-is-high-271',
  'Why can GPU utilization stay mediocre even when traffic is high?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Workload fragmentation, short requests, memory pressure, poor batching, slow retrieval, or tool waits can all starve the model server.',
  'Workload fragmentation, short requests, memory pressure, poor batching, slow retrieval, or tool waits can all starve the model server.
The bottleneck may be outside the GPU.
I look at tokens per second, queueing, batch size distribution, and request mix before buying more hardware.',
  NULL,
  'Workload fragmentation, short requests, memory pressure, poor batching, slow retrieval, or tool waits can all starve the model server.
The bottleneck may be outside the GPU.
I look at tokens per second, queueing, batch size distribution, and request mix before buying more hardware.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you design model routing and fallback?...
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
) VALUES (
  'notion_q_272',
  'how-do-you-design-model-routing-and-fallback-272',
  'How do you design model routing and fallback?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'Start with task classification and clear failure criteria.',
  'Start with task classification and clear failure criteria.
Use cheaper models for easy traffic and escalate only when confidence or complexity requires it.
Fallbacks should degrade gracefully, not silently change behavior in dangerous ways.',
  NULL,
  'Start with task classification and clear failure criteria.
Use cheaper models for easy traffic and escalate only when confidence or complexity requires it.
Fallbacks should degrade gracefully, not silently change behavior in dangerous ways.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What are the trade-offs of streaming responses?...
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
) VALUES (
  'notion_q_273',
  'what-are-the-trade-offs-of-streaming-responses-273',
  'What are the trade-offs of streaming responses?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Better perceived latency and UX',
  'Better perceived latency and UX
Harder moderation, citation control, and structured output validation
More complicated retry and cancellation handling
I stream when the UX gain is real, not by default.',
  NULL,
  'Better perceived latency and UX
Harder moderation, citation control, and structured output validation
More complicated retry and cancellation handling
I stream when the UX gain is real, not by default.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you decide between hosted APIs and self-hosted models?...
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
) VALUES (
  'notion_q_274',
  'how-do-you-decide-between-hosted-apis-and-self-hosted-models-274',
  'How do you decide between hosted APIs and self-hosted models?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Hosted APIs win on speed of adoption and lower ops burden.',
  'Hosted APIs win on speed of adoption and lower ops burden.
Self-hosting wins when data locality, predictable cost at scale, custom serving, or model control matter.
The wrong answer is choosing based on ideology instead of workload and constraints.',
  NULL,
  'Hosted APIs win on speed of adoption and lower ops burden.
Self-hosting wins when data locality, predictable cost at scale, custom serving, or model control matter.
The wrong answer is choosing based on ideology instead of workload and constraints.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you cut AI cost without wrecking quality?...
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
) VALUES (
  'notion_q_275',
  'how-do-you-cut-ai-cost-without-wrecking-quality-275',
  'How do you cut AI cost without wrecking quality?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Reduce unnecessary tokens before changing models.',
  'Reduce unnecessary tokens before changing models.
Cache repeated work.
Route simple tasks to cheaper models.
Use smaller models for subtasks like classification or reranking.
Remove tool calls or retrieval steps that do not move evals.',
  NULL,
  'Reduce unnecessary tokens before changing models.
Cache repeated work.
Route simple tasks to cheaper models.
Use smaller models for subtasks like classification or reranking.
Remove tool calls or retrieval steps that do not move evals.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does a serious eval strategy look like for an AI product?...
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
) VALUES (
  'notion_q_276',
  'what-does-a-serious-eval-strategy-look-like-for-an-ai-product-276',
  'What does a serious eval strategy look like for an AI product?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'A fixed regression suite for core tasks',
  'A fixed regression suite for core tasks
A changing challenge set for new failure modes
Separate evals for retrieval, tool use, generation, and safety
Online monitoring because offline evals never see everything',
  NULL,
  'A fixed regression suite for core tasks
A changing challenge set for new failure modes
Separate evals for retrieval, tool use, generation, and safety
Online monitoring because offline evals never see everything',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you build a good test set for LLM systems?...
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
) VALUES (
  'notion_q_277',
  'how-do-you-build-a-good-test-set-for-llm-systems-277',
  'How do you build a good test set for LLM systems?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'Include normal traffic, hard cases, ambiguous cases, adversarial cases, and recent incidents.',
  'Include normal traffic, hard cases, ambiguous cases, adversarial cases, and recent incidents.
Use real distributions when possible, not only handpicked textbook prompts.
I prefer smaller honest evals over big flattering evals.',
  NULL,
  'Include normal traffic, hard cases, ambiguous cases, adversarial cases, and recent incidents.
Use real distributions when possible, not only handpicked textbook prompts.
I prefer smaller honest evals over big flattering evals.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When are model-graded evals useful, and when are they risky?...
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
) VALUES (
  'notion_q_278',
  'when-are-model-graded-evals-useful-and-when-are-they-risky-278',
  'When are model-graded evals useful, and when are they risky?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Useful for subjective criteria like tone, helpfulness, or partial completeness when exact matching is too brittle.',
  'Useful for subjective criteria like tone, helpfulness, or partial completeness when exact matching is too brittle.
Risky when the judge model shares the same blind spots or preferences as the model under test.
I trust judge models more when I calibrate them against human-reviewed samples.',
  NULL,
  'Useful for subjective criteria like tone, helpfulness, or partial completeness when exact matching is too brittle.
Risky when the judge model shares the same blind spots or preferences as the model under test.
I trust judge models more when I calibrate them against human-reviewed samples.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you connect offline evals to online experiments?...
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
) VALUES (
  'notion_q_279',
  'how-do-you-connect-offline-evals-to-online-experiments-279',
  'How do you connect offline evals to online experiments?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I use offline evals to block bad changes and online tests to measure user impact.',
  'I use offline evals to block bad changes and online tests to measure user impact.
The key is aligning the offline suite with real product outcomes like resolution rate, edit rate, escalation rate, or conversion.
If offline and online disagree often, the eval set is probably not representative.',
  NULL,
  'I use offline evals to block bad changes and online tests to measure user impact.
The key is aligning the offline suite with real product outcomes like resolution rate, edit rate, escalation rate, or conversion.
If offline and online disagree often, the eval set is probably not representative.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is prompt injection, and why is it not just a prompt problem?...
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
) VALUES (
  'notion_q_280',
  'what-is-prompt-injection-and-why-is-it-not-just-a-prompt-problem-280',
  'What is prompt injection, and why is it not just a prompt problem?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'Untrusted content tries to change model behavior or override instructions.',
  'Untrusted content tries to change model behavior or override instructions.
In RAG or browsing systems, the attack can come from retrieved text, docs, emails, or web pages.
The defense is system design: trust boundaries, tool restrictions, sanitization, and output validation.',
  NULL,
  'Untrusted content tries to change model behavior or override instructions.
In RAG or browsing systems, the attack can come from retrieved text, docs, emails, or web pages.
The defense is system design: trust boundaries, tool restrictions, sanitization, and output validation.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is tool injection or data exfiltration risk?...
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
) VALUES (
  'notion_q_281',
  'what-is-tool-injection-or-data-exfiltration-risk-281',
  'What is tool injection or data exfiltration risk?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'The model can be manipulated into calling tools with unsafe parameters or leaking sensitive data across boundaries.',
  'The model can be manipulated into calling tools with unsafe parameters or leaking sensitive data across boundaries.
This becomes serious when the agent can access files, tickets, code, or customer data.
I treat tool outputs as untrusted input and keep permissions tight.',
  NULL,
  'The model can be manipulated into calling tools with unsafe parameters or leaking sensitive data across boundaries.
This becomes serious when the agent can access files, tickets, code, or customer data.
I treat tool outputs as untrusted input and keep permissions tight.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you handle PII and secrets in AI pipelines?...
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
) VALUES (
  'notion_q_282',
  'how-do-you-handle-pii-and-secrets-in-ai-pipelines-282',
  'How do you handle PII and secrets in AI pipelines?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Minimize what enters the prompt in the first place.',
  'Minimize what enters the prompt in the first place.
Redact or tokenize sensitive fields when possible.
Control logging and tracing carefully, because debugging pipelines are a common place where secrets leak.',
  NULL,
  'Minimize what enters the prompt in the first place.
Redact or tokenize sensitive fields when possible.
Control logging and tracing carefully, because debugging pipelines are a common place where secrets leak.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you roll out a new model version safely?...
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
) VALUES (
  'notion_q_283',
  'how-do-you-roll-out-a-new-model-version-safely-283',
  'How do you roll out a new model version safely?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Shadow evaluation on stored traffic or replay traffic',
  'Shadow evaluation on stored traffic or replay traffic
Side-by-side comparisons on a fixed suite
Gradual traffic ramp with rollback triggers
Monitoring of quality, latency, cost, and safety together
No one metric should decide rollout alone',
  NULL,
  'Shadow evaluation on stored traffic or replay traffic
Side-by-side comparisons on a fixed suite
Gradual traffic ramp with rollback triggers
Monitoring of quality, latency, cost, and safety together
No one metric should decide rollout alone',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you know your refusal policy is too strict or too weak?...
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
) VALUES (
  'notion_q_284',
  'how-do-you-know-your-refusal-policy-is-too-strict-or-too-weak-284',
  'How do you know your refusal policy is too strict or too weak?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Too strict means useful legitimate requests are blocked and users learn to bypass the system.',
  'Too strict means useful legitimate requests are blocked and users learn to bypass the system.
Too weak means harmful or high-risk outputs slip through.
I tune policy on real examples and business risk, not on abstract purity.',
  NULL,
  'Too strict means useful legitimate requests are blocked and users learn to bypass the system.
Too weak means harmful or high-risk outputs slip through.
I tune policy on real examples and business risk, not on abstract purity.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What does governance mean in an AI system beyond legal checkboxes?...
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
) VALUES (
  'notion_q_285',
  'what-does-governance-mean-in-an-ai-system-beyond-legal-checkboxes-285',
  'What does governance mean in an AI system beyond legal checkboxes?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Clear ownership of models, prompts, tools, data, and evals',
  'Clear ownership of models, prompts, tools, data, and evals
Versioning and auditability
Human review paths for sensitive cases
A repeatable process for incidents, regressions, and policy updates',
  NULL,
  'Clear ownership of models, prompts, tools, data, and evals
Versioning and auditability
Human review paths for sensitive cases
A repeatable process for incidents, regressions, and policy updates',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When would you use OCR plus LLM versus a native multimodal model?...
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
) VALUES (
  'notion_q_286',
  'when-would-you-use-ocr-plus-llm-versus-a-native-multimodal-model-286',
  'When would you use OCR plus LLM versus a native multimodal model?',
  'cat_system',
  'Medium',
  ARRAY['design', 'llm']::TEXT[],
  'OCR plus LLM is strong when the document is text-heavy and you need explicit extracted text for search or audit.',
  'OCR plus LLM is strong when the document is text-heavy and you need explicit extracted text for search or audit.
Native multimodal models help more when layout, diagrams, screenshots, or visual grounding matter.
I choose based on failure modes, not on novelty.',
  NULL,
  'OCR plus LLM is strong when the document is text-heavy and you need explicit extracted text for search or audit.
Native multimodal models help more when layout, diagrams, screenshots, or visual grounding matter.
I choose based on failure modes, not on novelty.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a document Q&A system for PDFs, tables, and screenshots?...
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
) VALUES (
  'notion_q_287',
  'how-would-you-design-a-document-qa-system-for-pdfs-tables-and-screenshots-287',
  'How would you design a document Q&A system for PDFs, tables, and screenshots?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'Separate ingestion paths for text extraction, layout metadata, and image regions.',
  'Separate ingestion paths for text extraction, layout metadata, and image regions.
Use document-aware chunking and preserve section structure.
Route to OCR, table parsing, or multimodal reasoning depending on the asset type.
Log which evidence source actually supported the answer.',
  NULL,
  'Separate ingestion paths for text extraction, layout metadata, and image regions.
Use document-aware chunking and preserve section structure.
Route to OCR, table parsing, or multimodal reasoning depending on the asset type.
Log which evidence source actually supported the answer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is hard about building a speech assistant beyond speech-to-text?...
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
) VALUES (
  'notion_q_288',
  'what-is-hard-about-building-a-speech-assistant-beyond-speech-to-text-288',
  'What is hard about building a speech assistant beyond speech-to-text?',
  'cat_system',
  'Easy',
  ARRAY['design']::TEXT[],
  'Turn-taking, interruption handling, and strict latency budgets.',
  'Turn-taking, interruption handling, and strict latency budgets.
Spoken conversations also need shorter answers and stronger repair strategies after ASR mistakes.
Voice systems fail on UX details, not only on raw transcription quality.',
  NULL,
  'Turn-taking, interruption handling, and strict latency budgets.
Spoken conversations also need shorter answers and stronger repair strategies after ASR mistakes.
Voice systems fail on UX details, not only on raw transcription quality.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is a common multimodal failure mode in enterprise use?...
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
) VALUES (
  'notion_q_289',
  'what-is-a-common-multimodal-failure-mode-in-enterprise-use-289',
  'What is a common multimodal failure mode in enterprise use?',
  'cat_system',
  'Easy',
  ARRAY['design']::TEXT[],
  'The system recognizes the text but misses the relationship between text, layout, and image regions.',
  'The system recognizes the text but misses the relationship between text, layout, and image regions.
For example it reads a table cell correctly but associates it with the wrong column or time period.
That is why visual grounding and traceability matter.',
  NULL,
  'The system recognizes the text but misses the relationship between text, layout, and image regions.
For example it reads a table cell correctly but associates it with the wrong column or time period.
That is why visual grounding and traceability matter.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you judge whether an AI feature is actually worth shipping?...
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
) VALUES (
  'notion_q_290',
  'how-do-you-judge-whether-an-ai-feature-is-actually-worth-shipping-290',
  'How do you judge whether an AI feature is actually worth shipping?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I want a concrete job to be done, a measurable success metric, and a clear fallback when the model is wrong.',
  'I want a concrete job to be done, a measurable success metric, and a clear fallback when the model is wrong.
If the feature saves time only in ideal cases but creates review burden in messy cases, the ROI may be fake.
I care about net workflow improvement, not demo beauty.',
  NULL,
  'I want a concrete job to be done, a measurable success metric, and a clear fallback when the model is wrong.
If the feature saves time only in ideal cases but creates review burden in messy cases, the ROI may be fake.
I care about net workflow improvement, not demo beauty.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you think about build versus buy for AI systems?...
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
) VALUES (
  'notion_q_291',
  'how-do-you-think-about-build-versus-buy-for-ai-systems-291',
  'How do you think about build versus buy for AI systems?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Buy when the problem is commodity and speed matters.',
  'Buy when the problem is commodity and speed matters.
Build when workflow, data, latency, compliance, or integration needs are a real differentiator.
Many teams should buy more of the stack than they admit, but not the parts that define their advantage.',
  NULL,
  'Buy when the problem is commodity and speed matters.
Build when workflow, data, latency, compliance, or integration needs are a real differentiator.
Many teams should buy more of the stack than they admit, but not the parts that define their advantage.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you decide which model goes on which workflow step?...
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
) VALUES (
  'notion_q_292',
  'how-do-you-decide-which-model-goes-on-which-workflow-step-292',
  'How do you decide which model goes on which workflow step?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Routing and cheap classification can use smaller fast models.',
  'Routing and cheap classification can use smaller fast models.
High-stakes reasoning or complex tool selection may need a stronger model.
I decompose the workflow so each step gets the least expensive model that still clears the bar.',
  NULL,
  'Routing and cheap classification can use smaller fast models.
High-stakes reasoning or complex tool selection may need a stronger model.
I decompose the workflow so each step gets the least expensive model that still clears the bar.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is context engineering, and why is it more important than prompt wording al...
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
) VALUES (
  'notion_q_293',
  'what-is-context-engineering-and-why-is-it-more-important-than-prompt-wording-alo-293',
  'What is context engineering, and why is it more important than prompt wording alone?',
  'cat_system',
  'Easy',
  ARRAY['design']::TEXT[],
  'It is the full job of deciding what information enters the model, in what order, with what structure, and under what trust rules.',
  'It is the full job of deciding what information enters the model, in what order, with what structure, and under what trust rules.
Many teams over-focus on wording and under-focus on context assembly.
In production, better context usually beats cleverer adjectives.',
  NULL,
  'It is the full job of deciding what information enters the model, in what order, with what structure, and under what trust rules.
Many teams over-focus on wording and under-focus on context assembly.
In production, better context usually beats cleverer adjectives.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What do you log in an AI system without creating a privacy mess?...
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
) VALUES (
  'notion_q_294',
  'what-do-you-log-in-an-ai-system-without-creating-a-privacy-mess-294',
  'What do you log in an AI system without creating a privacy mess?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'Request metadata',
  'Request metadata
Model and prompt-template version
Retrieval IDs or tool traces
Latency and cost
Validation errors and user outcomes
I do not log raw sensitive content unless there is a clear approved reason.',
  NULL,
  'Request metadata
Model and prompt-template version
Retrieval IDs or tool traces
Latency and cost
Validation errors and user outcomes
I do not log raw sensitive content unless there is a clear approved reason.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a high-volume AI customer support assistant?...
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
) VALUES (
  'notion_q_295',
  'how-would-you-design-a-high-volume-ai-customer-support-assistant-295',
  'How would you design a high-volume AI customer support assistant?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'A layered system: intent routing, retrieval, answer generation, policy checks, and human escalation.',
  'A layered system: intent routing, retrieval, answer generation, policy checks, and human escalation.
Strong caching and repeated-issue handling for common cases.
Clear source visibility for agents and customers.
Tight monitoring of resolution rate, bad automation rate, and escalation quality.',
  NULL,
  'A layered system: intent routing, retrieval, answer generation, policy checks, and human escalation.
Strong caching and repeated-issue handling for common cases.
Clear source visibility for agents and customers.
Tight monitoring of resolution rate, bad automation rate, and escalation quality.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can "just add more context" make answer quality worse?...
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
) VALUES (
  'notion_q_296',
  'why-can-just-add-more-context-make-answer-quality-worse-296',
  'Why can "just add more context" make answer quality worse?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'The model has to separate signal from noise, and irrelevant context can dominate attention.',
  'The model has to separate signal from noise, and irrelevant context can dominate attention.
Longer prompts also increase cost and latency and can reduce retrieval precision if the wrong chunks get included.
Strong candidates say "better context," not "more context."',
  NULL,
  'The model has to separate signal from noise, and irrelevant context can dominate attention.
Longer prompts also increase cost and latency and can reduce retrieval precision if the wrong chunks get included.
Strong candidates say "better context," not "more context."',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can retries make an AI workflow worse instead of better?...
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
) VALUES (
  'notion_q_297',
  'why-can-retries-make-an-ai-workflow-worse-instead-of-better-297',
  'Why can retries make an AI workflow worse instead of better?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Retries can duplicate side effects, amplify cost, and create inconsistent outputs.',
  'Retries can duplicate side effects, amplify cost, and create inconsistent outputs.
If the root cause is bad prompt state, stale retrieval, or a broken tool, blind retries only multiply failure.
Retries need idempotency, backoff, and a reasoned trigger.',
  NULL,
  'Retries can duplicate side effects, amplify cost, and create inconsistent outputs.
If the root cause is bad prompt state, stale retrieval, or a broken tool, blind retries only multiply failure.
Retries need idempotency, backoff, and a reasoned trigger.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can JSON mode or schema-constrained output still fail in real systems?...
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
) VALUES (
  'notion_q_298',
  'why-can-json-mode-or-schema-constrained-output-still-fail-in-real-systems-298',
  'Why can JSON mode or schema-constrained output still fail in real systems?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'The syntax may be valid while the semantics are wrong, missing, or inconsistent with business rules.',
  'The syntax may be valid while the semantics are wrong, missing, or inconsistent with business rules.
Tool arguments can be structurally valid but operationally unsafe.
Output contracts still need validation beyond parsing.',
  NULL,
  'The syntax may be valid while the semantics are wrong, missing, or inconsistent with business rules.
Tool arguments can be structurally valid but operationally unsafe.
Output contracts still need validation beyond parsing.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can a reranker upgrade beat a generator model upgrade?...
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
) VALUES (
  'notion_q_299',
  'why-can-a-reranker-upgrade-beat-a-generator-model-upgrade-299',
  'Why can a reranker upgrade beat a generator model upgrade?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'If the wrong evidence enters the prompt, a smarter generator still starts from the wrong facts.',
  'If the wrong evidence enters the prompt, a smarter generator still starts from the wrong facts.
Better retrieval ordering can improve grounded answers more cheaply than moving to a much larger model.
Fix the information path before paying for more model power.',
  NULL,
  'If the wrong evidence enters the prompt, a smarter generator still starts from the wrong facts.
Better retrieval ordering can improve grounded answers more cheaply than moving to a much larger model.
Fix the information path before paying for more model power.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is answer rate a misleading metric?...
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
) VALUES (
  'notion_q_300',
  'why-is-answer-rate-a-misleading-metric-300',
  'Why is answer rate a misleading metric?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'A system can answer more often by becoming more confidently wrong.',
  'A system can answer more often by becoming more confidently wrong.
High answer rate without groundedness, accuracy, or safe abstention behavior is dangerous.
I pair answer rate with correctness and escalation quality.',
  NULL,
  'A system can answer more often by becoming more confidently wrong.
High answer rate without groundedness, accuracy, or safe abstention behavior is dangerous.
I pair answer rate with correctness and escalation quality.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why do agent loops happen even when each individual tool works?...
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
) VALUES (
  'notion_q_301',
  'why-do-agent-loops-happen-even-when-each-individual-tool-works-301',
  'Why do agent loops happen even when each individual tool works?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'The planning policy is weak, the stop condition is unclear, or the model is implicitly rewarded for taking more steps.',
  'The planning policy is weak, the stop condition is unclear, or the model is implicitly rewarded for taking more steps.
Tool descriptions may also overlap and cause indecisive bouncing.
The fix is often better orchestration and termination rules, not just a bigger model.',
  NULL,
  'The planning policy is weak, the stop condition is unclear, or the model is implicitly rewarded for taking more steps.
Tool descriptions may also overlap and cause indecisive bouncing.
The fix is often better orchestration and termination rules, not just a bigger model.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can changing the embedding model break search quality even if benchmarks loo...
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
) VALUES (
  'notion_q_302',
  'why-can-changing-the-embedding-model-break-search-quality-even-if-benchmarks-loo-302',
  'Why can changing the embedding model break search quality even if benchmarks looked good?',
  'cat_system',
  'Medium',
  ARRAY['embeddings']::TEXT[],
  'The new embedding space changes similarity behavior, chunk interactions, and score distributions.',
  'The new embedding space changes similarity behavior, chunk interactions, and score distributions.
Existing thresholds, filters, and rerankers may no longer be calibrated.
Embedding changes are system changes, not drop-in swaps.',
  NULL,
  'The new embedding space changes similarity behavior, chunk interactions, and score distributions.
Existing thresholds, filters, and rerankers may no longer be calibrated.
Embedding changes are system changes, not drop-in swaps.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why can conversation summarization degrade assistant quality?...
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
) VALUES (
  'notion_q_303',
  'why-can-conversation-summarization-degrade-assistant-quality-303',
  'Why can conversation summarization degrade assistant quality?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Summaries compress away nuance, uncertainty, and exact user constraints.',
  'Summaries compress away nuance, uncertainty, and exact user constraints.
Errors in one summary can propagate across many later turns.
I only summarize what needs persistence and keep critical facts separately structured.',
  NULL,
  'Summaries compress away nuance, uncertainty, and exact user constraints.
Errors in one summary can propagate across many later turns.
I only summarize what needs persistence and keep critical facts separately structured.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Why is tool success rate not the same as task success rate?...
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
) VALUES (
  'notion_q_304',
  'why-is-tool-success-rate-not-the-same-as-task-success-rate-304',
  'Why is tool success rate not the same as task success rate?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'Every tool call can succeed technically while the overall plan is wrong.',
  'Every tool call can succeed technically while the overall plan is wrong.
The model may retrieve data correctly and still answer the wrong question or take the wrong action.
This is why system-level evals matter more than isolated component vanity metrics.',
  NULL,
  'Every tool call can succeed technically while the overall plan is wrong.
The model may retrieve data correctly and still answer the wrong question or take the wrong action.
This is why system-level evals matter more than isolated component vanity metrics.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What do strong AI interview answers sound like?...
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
) VALUES (
  'notion_q_305',
  'what-do-strong-ai-interview-answers-sound-like-305',
  'What do strong AI interview answers sound like?',
  'cat_system',
  'Medium',
  ARRAY['general']::TEXT[],
  'They separate model problems, data problems, retrieval problems, orchestration problems, and product problems.',
  'This page is intentionally broad, deep, and current. Use it for mock interviews, answer drilling, and English speaking practice.
Q19. You integrated Claude Bedrock into a CI/CD pipeline. Walk through the architecture.
Follow-up: Why Bedrock instead of calling the Claude API directly? Because Bedrock runs inside the Rakuten AWS account — data stays in-network, IAM handles auth, and we avoid storing API keys in Kubernetes secrets.
Q20. What happens when the Claude API is down inside a CI/CD pipeline?
Follow-up: Is SKIPPED the same as PASS? No. We distinguish three states: PASS (AI confirmed correct), FAIL (AI found a regression), SKIPPED (AI was unreachable). Only PASS allows auto-promote. SKIPPED requires manual confirmation.
Q21. How do you measure the quality of AI-generated test output in a CI/CD context?
Q22. What cost and latency tradeoffs did you make for LLM calls inside CI/CD?
Q23. How did you handle cases where Claude returned unparseable or schema-invalid output?
Q24. How do you version and deploy changes to an AI-driven component without breaking the pipeline?',
  NULL,
  'They separate model problems, data problems, retrieval problems, orchestration problems, and product problems.
They talk about trade-offs, failure modes, metrics, and rollback plans.
They sound like someone who has operated the system after launch, not just built the demo.
Not every failure is a model failure.
Retrieval, tool design, evals, and cost control are first-class engineering concerns.
Current interviews increasingly go beyond prompt engineering into RAG, agents, structured outputs, safety, and serving fundamentals.
--- Part 3: LLM Integration in Production — From Real Engineering (MALLKVS-7540) ---
The system is mallkvs-smoke-test-agent: a Spring Boot service running in Kubernetes that receives a smoke-test request (endpoint list + environment), calls Claude Sonnet via AWS Bedrock, and returns a structured test plan with pass/fail assertions.
The Jenkins pipeline POSTs to the agent endpoint, waits for a 200 response with the AI-generated verdict, and marks the stage PASS or FAIL.
Key design choices: the LLM is called with structured JSON input (endpoint metadata, sample response), asked to return structured JSON output (assertions, verdict, confidence), and the agent validates the schema before forwarding to Jenkins.
We separated the AI call timeout (30s) from the overall pipeline timeout (10m) so a slow Bedrock response did not cascade into a hung pipeline.
We treat AI-driven smoke tests as a best-effort enhancement, not a gate. If Bedrock returns 5xx or times out, the agent returns a structured SKIPPED verdict rather than an error.
The pipeline has a SKIP_SMOKE_TEST_AI boolean param so teams can bypass AI tests independently of the rest of the pipeline without code changes.
We log every Bedrock call with request_id, model version, input token count, latency, and final verdict. If the failure rate exceeds 10% over 10 minutes, an alert fires.
The fallback is: mark the AI stage as SKIPPED, continue to the next pipeline stage, and send a Slack notification that AI validation was unavailable.
Offline: we maintain a golden set of 50 smoke-test scenarios (endpoint + expected response + correct verdict). Every model version change runs the golden set and we require 90%+ agreement before deploying the new model version.
Online: we track false positive rate (AI said FAIL, human confirmed PASS) and false negative rate (AI said PASS, human found regression). False negatives are the expensive metric.
We log cases where AI confidence was low (< 0.7) and route them to human review rather than auto-verdict.
One concrete finding: the model performed poorly on endpoints that returned deeply nested JSON with nullable arrays. We added a pre-processing step that flattens nullable arrays to empty lists before sending to Claude, and accuracy went from 72% to 94% on that subset.
We use Claude Sonnet (not Opus) for routine smoke tests. Opus would be 5x the cost with less than 5% better accuracy on well-structured JSON comparison tasks.
We cache the system prompt and the endpoint schema for 24 hours using Bedrock prompt caching (approximately 80% token cost reduction for repeated pipelines).
Latency target: the AI stage must complete within 60 seconds for developer experience. We achieved P95 = 18s, P99 = 34s by batching all endpoints into one Claude call rather than one call per endpoint.
We explicitly rejected streaming responses in this context. Streaming saves time-to-first-token but the pipeline needed the complete structured verdict, not incremental text.
We use Bedrock''s structured output / response_format feature to constrain Claude to a JSON schema. This eliminates most freeform text wrapping.
For the rare cases where the schema is violated, we have one automatic retry with a corrective instruction in the prompt: ''Your previous response was not valid JSON matching the schema. Respond only with the JSON object.''
If the retry also fails, we return SKIPPED with a parse_error reason code. We log the raw model output for debugging.
Parse failures occurred in approximately 0.3% of requests in the first month and dropped to near zero after adding the structured output constraint. This is a concrete example of using model capabilities to fix system reliability.
We treat the AI agent as a versioned microservice. The Jenkins pipeline calls /v1/smoke-test; a breaking change to the response schema requires a new /v2 endpoint rather than modifying the existing contract.
Model version upgrades (e.g., Sonnet 3 to Sonnet 3.5) go through the golden-set regression before reaching production. We shadow-test the new model for one week before cutting over.
Prompt changes are treated like code: they go through PR review, include a before/after comparison on the golden set, and need explicit sign-off from the owning team.
We learned the hard way that updating a prompt and updating the model version in the same deployment makes it impossible to diagnose which change caused a quality regression.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you implement an O(1) LRU cache?...
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
) VALUES (
  'notion_q_306',
  'how-would-you-implement-an-o1-lru-cache-306',
  'How would you implement an O(1) LRU cache?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'The standard design is a HashMap plus a doubly linked list. The map gives O(1) key lookup, and the list keeps items ordered by recency so that move-to-front and tail eviction are both O(1).',
  'The standard design is a HashMap plus a doubly linked list. The map gives O(1) key lookup, and the list keeps items ordered by recency so that move-to-front and tail eviction are both O(1).
On every get, I look up the node in the map and move it to the head. On put, I either update the existing node and move it to the head, or insert a new node. If capacity is exceeded, I evict tail.prev and remove its key from the map.
In Java, I would mention that LinkedHashMap with accessOrder=true is the quickest correct implementation when requirements are simple. If I need custom metrics, weighted eviction, TTL, or special hooks, I would implement the list and map directly.
If the cache is shared across threads, ConcurrentHashMap alone is not enough because recency order is shared mutable state. I would protect the list and map consistently with one lock or use segmented caches when high concurrency matters.',
  NULL,
  'The standard design is a HashMap plus a doubly linked list. The map gives O(1) key lookup, and the list keeps items ordered by recency so that move-to-front and tail eviction are both O(1).
On every get, I look up the node in the map and move it to the head. On put, I either update the existing node and move it to the head, or insert a new node. If capacity is exceeded, I evict tail.prev and remove its key from the map.
In Java, I would mention that LinkedHashMap with accessOrder=true is the quickest correct implementation when requirements are simple. If I need custom metrics, weighted eviction, TTL, or special hooks, I would implement the list and map directly.
If the cache is shared across threads, ConcurrentHashMap alone is not enough because recency order is shared mutable state. I would protect the list and map consistently with one lock or use segmented caches when high concurrency matters.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you implement a rate limiter such as a token bucket or leaky bucket?...
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
) VALUES (
  'notion_q_307',
  'how-would-you-implement-a-rate-limiter-such-as-a-token-bucket-or-leaky-bucket-307',
  'How would you implement a rate limiter such as a token bucket or leaky bucket?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I usually start with token bucket because it is simple and supports bursts. The bucket has a refill rate and a maximum capacity. Every request consumes one or more tokens, and requests are rejected or',
  'I usually start with token bucket because it is simple and supports bursts. The bucket has a refill rate and a maximum capacity. Every request consumes one or more tokens, and requests are rejected or queued if there are not enough tokens available.
Leaky bucket is better when I want a smoother outbound rate to protect a downstream service. Instead of allowing bursts, it drains at a fixed rate, so latency may increase but traffic becomes more predictable.
For a single-node service, I can implement this with atomic counters and a monotonic clock. For distributed enforcement, I prefer Redis plus Lua so that token calculation and decrement happen atomically across instances.
A production answer should also mention key dimensions such as user, tenant, API, and global limits, as well as Retry-After headers, observability, and the difference between rejecting, delaying, and degrading requests.',
  NULL,
  'I usually start with token bucket because it is simple and supports bursts. The bucket has a refill rate and a maximum capacity. Every request consumes one or more tokens, and requests are rejected or queued if there are not enough tokens available.
Leaky bucket is better when I want a smoother outbound rate to protect a downstream service. Instead of allowing bursts, it drains at a fixed rate, so latency may increase but traffic becomes more predictable.
For a single-node service, I can implement this with atomic counters and a monotonic clock. For distributed enforcement, I prefer Redis plus Lua so that token calculation and decrement happen atomically across instances.
A production answer should also mention key dimensions such as user, tenant, API, and global limits, as well as Retry-After headers, observability, and the difference between rejecting, delaying, and degrading requests.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a concurrency-safe delayed task scheduler?...
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
) VALUES (
  'notion_q_308',
  'how-would-you-design-a-concurrency-safe-delayed-task-scheduler-308',
  'How would you design a concurrency-safe delayed task scheduler?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'The core structure is a priority queue or DelayQueue ordered by executeAt. A scheduler thread waits for the earliest due task, then hands the work to a worker pool so that long-running tasks never blo',
  'The core structure is a priority queue or DelayQueue ordered by executeAt. A scheduler thread waits for the earliest due task, then hands the work to a worker pool so that long-running tasks never block scheduling itself.
To make it concurrency-safe, I want clear ownership of the queue, cancellation support, task IDs for deduplication, and a state machine such as pending, running, succeeded, failed, and cancelled. Shared mutable structures must be protected with a lock, condition variable, or a concurrency-safe queue implementation.
If tasks must survive restarts, I would persist them in a database or durable queue and use leader election so that only one node acts as the active scheduler for a shard. The executor should also assume handlers are idempotent because retries and failover can happen.
In Java, I would say ScheduledThreadPoolExecutor is fine for simple in-memory workloads, but for production scheduling with recovery, retry, and visibility, I would separate scheduling metadata, durable storage, and workers.',
  NULL,
  'The core structure is a priority queue or DelayQueue ordered by executeAt. A scheduler thread waits for the earliest due task, then hands the work to a worker pool so that long-running tasks never block scheduling itself.
To make it concurrency-safe, I want clear ownership of the queue, cancellation support, task IDs for deduplication, and a state machine such as pending, running, succeeded, failed, and cancelled. Shared mutable structures must be protected with a lock, condition variable, or a concurrency-safe queue implementation.
If tasks must survive restarts, I would persist them in a database or durable queue and use leader election so that only one node acts as the active scheduler for a shard. The executor should also assume handlers are idempotent because retries and failover can happen.
In Java, I would say ScheduledThreadPoolExecutor is fine for simple in-memory workloads, but for production scheduling with recovery, retry, and visibility, I would separate scheduling metadata, durable storage, and workers.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you implement Top K frequency statistics, and what are the time and sp...
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
) VALUES (
  'notion_q_309',
  'how-would-you-implement-top-k-frequency-statistics-and-what-are-the-time-and-spa-309',
  'How would you implement Top K frequency statistics, and what are the time and space complexities?',
  'cat_ai',
  'Hard',
  ARRAY['general']::TEXT[],
  'The most common exact solution is HashMap for counts plus a min-heap of size K. I count every element in O(n), then push counts into the heap, evicting the smallest when the heap grows past K. That gi',
  'The most common exact solution is HashMap for counts plus a min-heap of size K. I count every element in O(n), then push counts into the heap, evicting the smallest when the heap grows past K. That gives O(n log K) time after counting and O(n) space for the map.
If the data is offline and I want pure linear time, bucket sort is also valid because frequencies range from 1 to n. I can build buckets by frequency and scan from high to low, which is O(n) time and O(n) space.
If the stream is extremely large and approximate answers are acceptable, I would mention heavy-hitter methods such as Count-Min Sketch plus a candidate heap, because exact counting may be too expensive.
A strong interview answer also covers ties, how to handle very large cardinality, and why the right choice depends on whether the workload is batch, streaming, exact, or approximate.',
  NULL,
  'The most common exact solution is HashMap for counts plus a min-heap of size K. I count every element in O(n), then push counts into the heap, evicting the smallest when the heap grows past K. That gives O(n log K) time after counting and O(n) space for the map.
If the data is offline and I want pure linear time, bucket sort is also valid because frequencies range from 1 to n. I can build buckets by frequency and scan from high to low, which is O(n) time and O(n) space.
If the stream is extremely large and approximate answers are acceptable, I would mention heavy-hitter methods such as Count-Min Sketch plus a candidate heap, because exact counting may be too expensive.
A strong interview answer also covers ties, how to handle very large cardinality, and why the right choice depends on whether the workload is batch, streaming, exact, or approximate.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Given a log stream, how would you count error codes per minute and output the To...
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
) VALUES (
  'notion_q_310',
  'given-a-log-stream-how-would-you-count-error-codes-per-minute-and-output-the-top-310',
  'Given a log stream, how would you count error codes per minute and output the Top N?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I would model this as a windowed aggregation problem. For each event, I extract the event minute and error code, then update a counter keyed by minute plus error code. When a window closes, I compute ',
  'I would model this as a windowed aggregation problem. For each event, I extract the event minute and error code, then update a counter keyed by minute plus error code. When a window closes, I compute Top N for that minute with a min-heap over the aggregated counts.
If logs can arrive late, I would use event time plus a watermark and allow a small lateness window. That way the result is stable but still tolerates reordering. In a distributed setting, Kafka plus Flink or Spark Structured Streaming would be a natural fit.
To scale, I would partition by time bucket and possibly by error code, perform local aggregation, then merge partial counts before computing the final Top N. That reduces the amount of data shuffled across nodes.
The main complexity is O(events) for counting plus O(m log N) per minute where m is the number of distinct error codes in that window. I would also define retention, output format, and what happens when a minute has too many unique codes.',
  NULL,
  'I would model this as a windowed aggregation problem. For each event, I extract the event minute and error code, then update a counter keyed by minute plus error code. When a window closes, I compute Top N for that minute with a min-heap over the aggregated counts.
If logs can arrive late, I would use event time plus a watermark and allow a small lateness window. That way the result is stable but still tolerates reordering. In a distributed setting, Kafka plus Flink or Spark Structured Streaming would be a natural fit.
To scale, I would partition by time bucket and possibly by error code, perform local aggregation, then merge partial counts before computing the final Top N. That reduces the amount of data shuffled across nodes.
The main complexity is O(events) for counting plus O(m log N) per minute where m is the number of distinct error codes in that window. I would also define retention, output format, and what happens when a minute has too many unique codes.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design an idempotent write API?...
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
) VALUES (
  'notion_q_311',
  'how-would-you-design-an-idempotent-write-api-311',
  'How would you design an idempotent write API?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'I would require the client to send an idempotency key and store that key together with request hash, status, response payload, and timestamps in a durable store. The first successful request performs ',
  'I would require the client to send an idempotency key and store that key together with request hash, status, response payload, and timestamps in a durable store. The first successful request performs the business write and persists the final response atomically.
If the same key arrives again with the same payload, I return the stored result instead of executing the write twice. If the same key arrives with a different payload, I reject it because that is usually a client bug or replay with inconsistent intent.
To make this robust, I would use a unique constraint on the idempotency key, a clear in-progress state to handle retries during partial failure, and a TTL policy if keys should expire after some business-defined window.
For asynchronous workflows, I would combine this with an outbox pattern and downstream consumer deduplication. Idempotency is rarely only an API concern; it usually needs end-to-end thinking across queues, databases, and retries.',
  NULL,
  'I would require the client to send an idempotency key and store that key together with request hash, status, response payload, and timestamps in a durable store. The first successful request performs the business write and persists the final response atomically.
If the same key arrives again with the same payload, I return the stored result instead of executing the write twice. If the same key arrives with a different payload, I reject it because that is usually a client bug or replay with inconsistent intent.
To make this robust, I would use a unique constraint on the idempotency key, a clear in-progress state to handle retries during partial failure, and a TTL policy if keys should expire after some business-defined window.
For asynchronous workflows, I would combine this with an outbox pattern and downstream consumer deduplication. Idempotency is rarely only an API concern; it usually needs end-to-end thinking across queues, databases, and retries.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design an end-to-end RAG service, including chunking, retrieval, r...
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
) VALUES (
  'notion_q_312',
  'how-would-you-design-an-end-to-end-rag-service-including-chunking-retrieval-rera-312',
  'How would you design an end-to-end RAG service, including chunking, retrieval, reranking, answer generation, and citations?',
  'cat_ai',
  'Hard',
  ARRAY['design', 'rag', 'llm']::TEXT[],
  'I split the design into an offline ingestion path and an online serving path. Offline, I clean documents, preserve structure such as headings and tables, chunk them into semantically coherent spans, g',
  'I split the design into an offline ingestion path and an online serving path. Offline, I clean documents, preserve structure such as headings and tables, chunk them into semantically coherent spans, generate embeddings, attach metadata and ACL tags, and index them in both vector and keyword stores.
For chunking, I avoid cutting purely by fixed size if it destroys meaning. A practical default is structure-aware chunks of roughly 300 to 500 tokens with overlap, but I adjust this by document type. Legal contracts, tickets, and code need different chunking strategies.
At query time, I normalize the question, run hybrid retrieval such as BM25 plus vector search, apply permission filters, and then rerank the top candidates with a stronger model. Only the highest-confidence evidence goes into the final prompt so that the generator sees concise, grounded context instead of noisy context stuffing.
The answer generation step should require citations, support abstention when evidence is weak, and log the retrieved chunk IDs, model version, latency, and answer quality signals. In production, I care as much about citation precision, freshness, and failure behavior as about raw answer fluency.',
  NULL,
  'I split the design into an offline ingestion path and an online serving path. Offline, I clean documents, preserve structure such as headings and tables, chunk them into semantically coherent spans, generate embeddings, attach metadata and ACL tags, and index them in both vector and keyword stores.
For chunking, I avoid cutting purely by fixed size if it destroys meaning. A practical default is structure-aware chunks of roughly 300 to 500 tokens with overlap, but I adjust this by document type. Legal contracts, tickets, and code need different chunking strategies.
At query time, I normalize the question, run hybrid retrieval such as BM25 plus vector search, apply permission filters, and then rerank the top candidates with a stronger model. Only the highest-confidence evidence goes into the final prompt so that the generator sees concise, grounded context instead of noisy context stuffing.
The answer generation step should require citations, support abstention when evidence is weak, and log the retrieved chunk IDs, model version, latency, and answer quality signals. In production, I care as much about citation precision, freshness, and failure behavior as about raw answer fluency.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you make LLM output stable and safely consumable by downstream systems, i...
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
) VALUES (
  'notion_q_313',
  'how-do-you-make-llm-output-stable-and-safely-consumable-by-downstream-systems-in-313',
  'How do you make LLM output stable and safely consumable by downstream systems, including strict JSON, validation, and retry strategy?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'I never rely on free-form text when the output is intended for another system. I define an explicit schema, prefer structured output or function-calling features when available, and make field require',
  'I never rely on free-form text when the output is intended for another system. I define an explicit schema, prefer structured output or function-calling features when available, and make field requirements, enums, nullability, and forbidden fields clear in the prompt contract.
On the application side, I parse and validate strictly. In Java, that usually means parsing into typed objects, validating against a JSON Schema or custom validator, and refusing to continue if required fields are missing, types are wrong, or values fall outside allowed ranges.
If validation fails, I retry with a repair prompt or a lower-temperature request that includes the validation error and asks the model to emit only corrected JSON. Retries must be bounded and observable, because infinite repair loops make reliability worse.
If the model still fails, I degrade safely by returning a structured error, a fallback template, or a smaller scoped result. The key idea is that the system, not the model, owns correctness and schema compatibility.',
  NULL,
  'I never rely on free-form text when the output is intended for another system. I define an explicit schema, prefer structured output or function-calling features when available, and make field requirements, enums, nullability, and forbidden fields clear in the prompt contract.
On the application side, I parse and validate strictly. In Java, that usually means parsing into typed objects, validating against a JSON Schema or custom validator, and refusing to continue if required fields are missing, types are wrong, or values fall outside allowed ranges.
If validation fails, I retry with a repair prompt or a lower-temperature request that includes the validation error and asks the model to emit only corrected JSON. Retries must be bounded and observable, because infinite repair loops make reliability worse.
If the model still fails, I degrade safely by returning a structured error, a fallback template, or a smaller scoped result. The key idea is that the system, not the model, owns correctness and schema compatibility.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What engineering safeguards would you use when the model hallucinates?...
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
) VALUES (
  'notion_q_314',
  'what-engineering-safeguards-would-you-use-when-the-model-hallucinates-314',
  'What engineering safeguards would you use when the model hallucinates?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'I think about hallucination in three layers: prevention, detection, and fallback. Prevention means narrowing the task, retrieving grounded evidence, requiring citations, and telling the model to absta',
  'I think about hallucination in three layers: prevention, detection, and fallback. Prevention means narrowing the task, retrieving grounded evidence, requiring citations, and telling the model to abstain when the evidence is weak or missing.
Detection means scoring whether the answer is actually supported by the retrieved material. That can be done with citation coverage checks, rule-based consistency checks, or a verifier model that judges groundedness before the answer is shown to the user.
Fallback means the system should not force a confident answer when confidence is low. Depending on the product, I may fall back to search results, a safe template, a smaller rule-based workflow, or human escalation.
In high-risk domains, the most important design choice is to make refusal or uncertainty look intentional and useful. A system that says “I cannot confirm this from the available sources” is often better than one that answers smoothly but incorrectly.',
  NULL,
  'I think about hallucination in three layers: prevention, detection, and fallback. Prevention means narrowing the task, retrieving grounded evidence, requiring citations, and telling the model to abstain when the evidence is weak or missing.
Detection means scoring whether the answer is actually supported by the retrieved material. That can be done with citation coverage checks, rule-based consistency checks, or a verifier model that judges groundedness before the answer is shown to the user.
Fallback means the system should not force a confident answer when confidence is low. Depending on the product, I may fall back to search results, a safe template, a smaller rule-based workflow, or human escalation.
In high-risk domains, the most important design choice is to make refusal or uncertainty look intentional and useful. A system that says “I cannot confirm this from the available sources” is often better than one that answers smoothly but incorrectly.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design offline and online evaluation for answer quality and busine...
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
) VALUES (
  'notion_q_315',
  'how-would-you-design-offline-and-online-evaluation-for-answer-quality-and-busine-315',
  'How would you design offline and online evaluation for answer quality and business impact?',
  'cat_ai',
  'Hard',
  ARRAY['design', 'llm']::TEXT[],
  'Offline evaluation starts with a representative dataset: real user questions, expected answers, retrieved evidence, and edge cases such as ambiguity, outdated docs, and missing permissions. I would me',
  'Offline evaluation starts with a representative dataset: real user questions, expected answers, retrieved evidence, and edge cases such as ambiguity, outdated docs, and missing permissions. I would measure groundedness, citation precision, answer correctness, latency, and cost, and I would slice results by query type instead of looking only at one global score.
Online evaluation should connect product quality to business outcomes. Depending on the use case, that can include answer acceptance rate, human override rate, escalation rate, first-contact resolution, CSAT, conversion, or time saved. Good offline scores do not matter if the system hurts real workflows.
I also care about guardrail metrics such as refusal rate, unsupported-claim rate, PII leakage, tool failure rate, and fallback frequency. These often reveal production problems earlier than headline metrics do.
The strongest setup links offline and online data by logging prompt version, model version, retrieved evidence, and experiment assignment for each request. That makes regression analysis, rollback, and root-cause debugging much easier.',
  NULL,
  'Offline evaluation starts with a representative dataset: real user questions, expected answers, retrieved evidence, and edge cases such as ambiguity, outdated docs, and missing permissions. I would measure groundedness, citation precision, answer correctness, latency, and cost, and I would slice results by query type instead of looking only at one global score.
Online evaluation should connect product quality to business outcomes. Depending on the use case, that can include answer acceptance rate, human override rate, escalation rate, first-contact resolution, CSAT, conversion, or time saved. Good offline scores do not matter if the system hurts real workflows.
I also care about guardrail metrics such as refusal rate, unsupported-claim rate, PII leakage, tool failure rate, and fallback frequency. These often reveal production problems earlier than headline metrics do.
The strongest setup links offline and online data by logging prompt version, model version, retrieved evidence, and experiment assignment for each request. That makes regression analysis, rollback, and root-cause debugging much easier.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you handle sensitive data and permissions so that model calls and retr...
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
) VALUES (
  'notion_q_316',
  'how-would-you-handle-sensitive-data-and-permissions-so-that-model-calls-and-retr-316',
  'How would you handle sensitive data and permissions so that model calls and retrieval stay compliant?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'I would propagate user identity and tenant context from the start and enforce authorization before retrieval, not after generation. Documents and chunks should carry ACL metadata so that the retriever',
  'I would propagate user identity and tenant context from the start and enforce authorization before retrieval, not after generation. Documents and chunks should carry ACL metadata so that the retriever only sees what the caller is allowed to access.
Before sending content to a model, I would apply data minimization, redaction, or tokenization where possible. Sensitive fields such as PII, secrets, or regulated data should be masked or excluded unless there is an explicit approved reason to include them.
From an infrastructure perspective, I want encryption in transit and at rest, clear data residency controls, secret management, and provider-level guarantees about retention and training usage. In some cases, the right answer is to keep inference inside a private network or self-host a model.
Finally, compliance requires auditability: who asked what, what data was retrieved, which model was called, what policy was applied, and how long logs are retained. Security is not just blocking access; it is also proving the system behaved correctly.',
  NULL,
  'I would propagate user identity and tenant context from the start and enforce authorization before retrieval, not after generation. Documents and chunks should carry ACL metadata so that the retriever only sees what the caller is allowed to access.
Before sending content to a model, I would apply data minimization, redaction, or tokenization where possible. Sensitive fields such as PII, secrets, or regulated data should be masked or excluded unless there is an explicit approved reason to include them.
From an infrastructure perspective, I want encryption in transit and at rest, clear data residency controls, secret management, and provider-level guarantees about retention and training usage. In some cases, the right answer is to keep inference inside a private network or self-host a model.
Finally, compliance requires auditability: who asked what, what data was retrieved, which model was called, what policy was applied, and how long logs are retained. Security is not just blocking access; it is also proving the system behaved correctly.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you wrap an LLM client inside a Java service, including timeout, rate ...
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
) VALUES (
  'notion_q_317',
  'how-would-you-wrap-an-llm-client-inside-a-java-service-including-timeout-rate-li-317',
  'How would you wrap an LLM client inside a Java service, including timeout, rate limiting, circuit breaking, and degradation?',
  'cat_ai',
  'Medium',
  ARRAY['llm']::TEXT[],
  'I would hide provider differences behind a small interface so the rest of the application can call a stable internal client. The wrapper should standardize request building, prompt and tool metadata, ',
  'I would hide provider differences behind a small interface so the rest of the application can call a stable internal client. The wrapper should standardize request building, prompt and tool metadata, model selection, retries, parsing, and telemetry.
Operationally, I want strict connect and read timeouts, bounded retries with exponential backoff, and idempotent retry semantics. I also separate thread pools or async executors so that slow model calls cannot starve unrelated traffic.
To protect the service, I would add rate limiting, bulkheads, and a circuit breaker. When the provider is slow or failing, I can degrade to a smaller model, cached answer, narrower retrieval-only mode, or a user-facing “please try again” path depending on the product.
A strong Java answer should also mention structured logging, tracing IDs, token and cost accounting, prompt version tags, and a clean place to inject provider-specific adapters without leaking them through the whole codebase.',
  NULL,
  'I would hide provider differences behind a small interface so the rest of the application can call a stable internal client. The wrapper should standardize request building, prompt and tool metadata, model selection, retries, parsing, and telemetry.
Operationally, I want strict connect and read timeouts, bounded retries with exponential backoff, and idempotent retry semantics. I also separate thread pools or async executors so that slow model calls cannot starve unrelated traffic.
To protect the service, I would add rate limiting, bulkheads, and a circuit breaker. When the provider is slow or failing, I can degrade to a smaller model, cached answer, narrower retrieval-only mode, or a user-facing “please try again” path depending on the product.
A strong Java answer should also mention structured logging, tracing IDs, token and cost accounting, prompt version tags, and a clean place to inject provider-specific adapters without leaking them through the whole codebase.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a pipeline from an operational database to a data lake or w...
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
) VALUES (
  'notion_q_318',
  'how-would-you-design-a-pipeline-from-an-operational-database-to-a-data-lake-or-w-318',
  'How would you design a pipeline from an operational database to a data lake or warehouse, and how would you guarantee data quality?',
  'cat_ai',
  'Hard',
  ARRAY['database', 'design']::TEXT[],
  'I usually start with an initial snapshot plus CDC for incremental changes. Raw data lands in a bronze layer, cleaned and standardized data moves to silver, and business-ready modeled data goes to gold',
  'I usually start with an initial snapshot plus CDC for incremental changes. Raw data lands in a bronze layer, cleaned and standardized data moves to silver, and business-ready modeled data goes to gold. This keeps the raw source available for replay while giving analysts and models a stable curated layer.
Data quality needs to be explicit. I would define checks for freshness, completeness, uniqueness, referential integrity, schema drift, and business invariants such as revenue never being negative. Failed records go to a dead-letter path rather than silently contaminating downstream tables.
I also want lineage from source tables to derived models, plus job version, schema version, and ownership metadata. Without that, incidents turn into guesswork because nobody knows which transformation changed what.
A good answer should mention reconciliation against the source system, clear SLAs, and how to do backfills safely when logic or schemas change.',
  NULL,
  'I usually start with an initial snapshot plus CDC for incremental changes. Raw data lands in a bronze layer, cleaned and standardized data moves to silver, and business-ready modeled data goes to gold. This keeps the raw source available for replay while giving analysts and models a stable curated layer.
Data quality needs to be explicit. I would define checks for freshness, completeness, uniqueness, referential integrity, schema drift, and business invariants such as revenue never being negative. Failed records go to a dead-letter path rather than silently contaminating downstream tables.
I also want lineage from source tables to derived models, plus job version, schema version, and ownership metadata. Without that, incidents turn into guesswork because nobody knows which transformation changed what.
A good answer should mention reconciliation against the source system, clear SLAs, and how to do backfills safely when logic or schemas change.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- When is batch processing better than stream processing, and how would you explai...
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
) VALUES (
  'notion_q_319',
  'when-is-batch-processing-better-than-stream-processing-and-how-would-you-explain-319',
  'When is batch processing better than stream processing, and how would you explain the trade-offs?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Batch is usually better when latency requirements are loose, data volume is high, and simplicity matters more than freshness. It is cheaper to operate, easier to backfill, and often easier to reason a',
  'Batch is usually better when latency requirements are loose, data volume is high, and simplicity matters more than freshness. It is cheaper to operate, easier to backfill, and often easier to reason about for reporting, training data generation, and periodic feature computation.
Streaming is justified when the business value of freshness is high, such as fraud detection, real-time alerting, online features, or customer-facing dashboards that need near-real-time data. The main cost is operational complexity: state management, out-of-order events, exactly-once semantics, replay, and more difficult debugging.
In practice, many teams use a hybrid model. They stream the small set of flows that truly need low latency and keep the rest in batch. Doing everything as a stream is often unnecessary and expensive.
The answer I want to give in an interview is not “streaming is modern.” It is “I choose the simplest architecture that still meets the freshness SLA and replay requirements.”',
  NULL,
  'Batch is usually better when latency requirements are loose, data volume is high, and simplicity matters more than freshness. It is cheaper to operate, easier to backfill, and often easier to reason about for reporting, training data generation, and periodic feature computation.
Streaming is justified when the business value of freshness is high, such as fraud detection, real-time alerting, online features, or customer-facing dashboards that need near-real-time data. The main cost is operational complexity: state management, out-of-order events, exactly-once semantics, replay, and more difficult debugging.
In practice, many teams use a hybrid model. They stream the small set of flows that truly need low latency and keep the rest in batch. Doing everything as a stream is often unnecessary and expensive.
The answer I want to give in an interview is not “streaming is modern.” It is “I choose the simplest architecture that still meets the freshness SLA and replay requirements.”',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What are common optimization strategies for large joins and slow queries?...
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
) VALUES (
  'notion_q_320',
  'what-are-common-optimization-strategies-for-large-joins-and-slow-queries-320',
  'What are common optimization strategies for large joins and slow queries?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I start with the execution plan, because tuning without the plan is guesswork. I look for full scans, bad join order, missing partition pruning, data skew, spilling to disk, and filters that are appli',
  'I start with the execution plan, because tuning without the plan is guesswork. I look for full scans, bad join order, missing partition pruning, data skew, spilling to disk, and filters that are applied too late.
Common fixes include adding or correcting indexes, pruning columns early, filtering before joining, repartitioning data, using broadcast joins for small dimension tables, and pre-aggregating or materializing results that are repeatedly computed.
For very large tables, data layout matters as much as SQL wording. Partitioning by time, clustering on common predicates, and keeping table statistics fresh can have a much bigger impact than micro-optimizing syntax.
I would also mention anti-patterns such as functions on join keys, N plus one queries in application code, and blindly increasing compute when the real issue is a poor access path or a skewed key distribution.',
  NULL,
  'I start with the execution plan, because tuning without the plan is guesswork. I look for full scans, bad join order, missing partition pruning, data skew, spilling to disk, and filters that are applied too late.
Common fixes include adding or correcting indexes, pruning columns early, filtering before joining, repartitioning data, using broadcast joins for small dimension tables, and pre-aggregating or materializing results that are repeatedly computed.
For very large tables, data layout matters as much as SQL wording. Partitioning by time, clustering on common predicates, and keeping table statistics fresh can have a much bigger impact than micro-optimizing syntax.
I would also mention anti-patterns such as functions on join keys, N plus one queries in application code, and blindly increasing compute when the real issue is a poor access path or a skewed key distribution.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a feature store that keeps offline and online features cons...
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
) VALUES (
  'notion_q_321',
  'how-would-you-design-a-feature-store-that-keeps-offline-and-online-features-cons-321',
  'How would you design a feature store that keeps offline and online features consistent?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'The key principle is “define once, serve twice.” Feature definitions should come from the same transformation logic or at least the same semantic specification, so the offline training feature and the',
  'The key principle is “define once, serve twice.” Feature definitions should come from the same transformation logic or at least the same semantic specification, so the offline training feature and the online serving feature are not reimplemented separately and allowed to drift.
Offline, I want point-in-time correct historical features for training and validation. Online, I want a low-latency store keyed by entity and feature name. The tricky part is not storage itself but ensuring that time semantics, joins, and freshness rules match between the two paths.
I would version features, track lineage to raw sources, and measure training-serving skew continuously. If online values consistently differ from offline values for the same entity and time, the feature store is failing its main job.
A strong answer should also mention backfills, TTLs, online freshness guarantees, and what happens when a feature computation is delayed or partially missing.',
  NULL,
  'The key principle is “define once, serve twice.” Feature definitions should come from the same transformation logic or at least the same semantic specification, so the offline training feature and the online serving feature are not reimplemented separately and allowed to drift.
Offline, I want point-in-time correct historical features for training and validation. Online, I want a low-latency store keyed by entity and feature name. The tricky part is not storage itself but ensuring that time semantics, joins, and freshness rules match between the two paths.
I would version features, track lineage to raw sources, and measure training-serving skew continuously. If online values consistently differ from offline values for the same entity and time, the feature store is failing its main job.
A strong answer should also mention backfills, TTLs, online freshness guarantees, and what happens when a feature computation is delayed or partially missing.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you handle data version management and traceability?...
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
) VALUES (
  'notion_q_322',
  'how-would-you-handle-data-version-management-and-traceability-322',
  'How would you handle data version management and traceability?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I want every meaningful artifact to be versioned: raw inputs, derived datasets, schemas, transformation code, features, and models. That does not always mean copying all data, but it does mean having ',
  'I want every meaningful artifact to be versioned: raw inputs, derived datasets, schemas, transformation code, features, and models. That does not always mean copying all data, but it does mean having immutable identifiers and a manifest that says exactly which inputs produced which outputs.
Traceability requires lineage metadata: source tables, job version, config version, execution time, and owner. When a metric breaks or a model degrades, I should be able to answer which upstream change introduced the issue and which downstream artifacts are affected.
For reproducibility, I prefer immutable storage patterns and explicit snapshots or partition versions rather than “latest” references. Latest is convenient in dashboards and dangerous in debugging.
This is also important for compliance. If somebody asks how a prediction or report was produced, versioning and lineage are what let you answer confidently instead of reconstructing history by hand.',
  NULL,
  'I want every meaningful artifact to be versioned: raw inputs, derived datasets, schemas, transformation code, features, and models. That does not always mean copying all data, but it does mean having immutable identifiers and a manifest that says exactly which inputs produced which outputs.
Traceability requires lineage metadata: source tables, job version, config version, execution time, and owner. When a metric breaks or a model degrades, I should be able to answer which upstream change introduced the issue and which downstream artifacts are affected.
For reproducibility, I prefer immutable storage patterns and explicit snapshots or partition versions rather than “latest” references. Latest is convenient in dashboards and dangerous in debugging.
This is also important for compliance. If somebody asks how a prediction or report was produced, versioning and lineage are what let you answer confidently instead of reconstructing history by hand.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you handle backfills, replay, and reprocessing?...
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
) VALUES (
  'notion_q_323',
  'how-would-you-handle-backfills-replay-and-reprocessing-323',
  'How would you handle backfills, replay, and reprocessing?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I design for replay from day one by keeping an immutable raw layer or event log. If the transformation logic changes, I can recompute from raw inputs instead of trying to patch already-aggregated outp',
  'I design for replay from day one by keeping an immutable raw layer or event log. If the transformation logic changes, I can recompute from raw inputs instead of trying to patch already-aggregated outputs in place.
The jobs themselves should be idempotent and partition-aware so that I can rerun a specific time range or entity set without corrupting current data. That usually means writing to a new version or staging location first and then publishing the result atomically.
For streaming systems, I need clear event-time semantics, duplicate handling, and a policy for late data. Reprocessing without understanding watermarks and state cleanup often creates subtle correctness bugs.
Operationally, I like shadow backfills and validation checks before publish. If the new output differs sharply from the old output, I want to understand why before downstream dashboards, features, or models pick it up.',
  NULL,
  'I design for replay from day one by keeping an immutable raw layer or event log. If the transformation logic changes, I can recompute from raw inputs instead of trying to patch already-aggregated outputs in place.
The jobs themselves should be idempotent and partition-aware so that I can rerun a specific time range or entity set without corrupting current data. That usually means writing to a new version or staging location first and then publishing the result atomically.
For streaming systems, I need clear event-time semantics, duplicate handling, and a policy for late data. Reprocessing without understanding watermarks and state cleanup often creates subtle correctness bugs.
Operationally, I like shadow backfills and validation checks before publish. If the new output differs sharply from the old output, I want to understand why before downstream dashboards, features, or models pick it up.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What are the pros, cons, and best-fit scenarios for real-time, asynchronous, and...
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
) VALUES (
  'notion_q_324',
  'what-are-the-pros-cons-and-best-fit-scenarios-for-real-time-asynchronous-and-bat-324',
  'What are the pros, cons, and best-fit scenarios for real-time, asynchronous, and batch inference?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'Real-time inference is best when the user is actively waiting for a result, such as chat, fraud checks, or ranking. The advantage is low latency and direct UX impact, but the downside is higher infras',
  'Real-time inference is best when the user is actively waiting for a result, such as chat, fraud checks, or ranking. The advantage is low latency and direct UX impact, but the downside is higher infrastructure cost and tighter reliability requirements.
Asynchronous inference fits long-running tasks such as document analysis, report generation, or large multi-step workflows. It improves resilience because requests can be queued and retried, but users must accept eventual completion instead of an immediate answer.
Batch inference is the cheapest and easiest to optimize at scale. It works well for nightly scoring, recommendation refreshes, and large offline enrichment jobs, but it is the wrong fit when the business needs instant personalized decisions.
A good production design often uses all three: real-time for the critical path, async for heavy jobs, and batch for background refresh. The choice should be driven by user SLA, queue tolerance, and cost profile.',
  NULL,
  'Real-time inference is best when the user is actively waiting for a result, such as chat, fraud checks, or ranking. The advantage is low latency and direct UX impact, but the downside is higher infrastructure cost and tighter reliability requirements.
Asynchronous inference fits long-running tasks such as document analysis, report generation, or large multi-step workflows. It improves resilience because requests can be queued and retried, but users must accept eventual completion instead of an immediate answer.
Batch inference is the cheapest and easiest to optimize at scale. It works well for nightly scoring, recommendation refreshes, and large offline enrichment jobs, but it is the wrong fit when the business needs instant personalized decisions.
A good production design often uses all three: real-time for the critical path, async for heavy jobs, and batch for background refresh. The choice should be driven by user SLA, queue tolerance, and cost profile.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Which metrics would you monitor to judge model quality and drift?...
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
) VALUES (
  'notion_q_325',
  'which-metrics-would-you-monitor-to-judge-model-quality-and-drift-325',
  'Which metrics would you monitor to judge model quality and drift?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I separate system health metrics from model quality metrics. System metrics include latency, throughput, timeout rate, error rate, queue depth, token usage, and cost. These tell me whether the service',
  'I separate system health metrics from model quality metrics. System metrics include latency, throughput, timeout rate, error rate, queue depth, token usage, and cost. These tell me whether the service is alive and affordable.
Quality metrics depend on the task. For an LLM system, I might track groundedness, citation coverage, tool success rate, human rating, answer acceptance, escalation rate, and business outcomes such as resolution or conversion. A model can be technically healthy and still business-bad.
For drift, I watch changes in input distribution, embedding distribution, topic mix, output distribution, and eventually label-based metrics when delayed ground truth is available. Proxy signals such as increased refusal rate or higher fallback rate are often the first warning signs.
The important point is that one metric is never enough. I want a dashboard that links input shift, output quality, and business impact so I can see whether a drift event actually matters.',
  NULL,
  'I separate system health metrics from model quality metrics. System metrics include latency, throughput, timeout rate, error rate, queue depth, token usage, and cost. These tell me whether the service is alive and affordable.
Quality metrics depend on the task. For an LLM system, I might track groundedness, citation coverage, tool success rate, human rating, answer acceptance, escalation rate, and business outcomes such as resolution or conversion. A model can be technically healthy and still business-bad.
For drift, I watch changes in input distribution, embedding distribution, topic mix, output distribution, and eventually label-based metrics when delayed ground truth is available. Proxy signals such as increased refusal rate or higher fallback rate are often the first warning signs.
The important point is that one metric is never enough. I want a dashboard that links input shift, output quality, and business impact so I can see whether a drift event actually matters.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a canary release and rollback mechanism for model systems?...
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
) VALUES (
  'notion_q_326',
  'how-would-you-design-a-canary-release-and-rollback-mechanism-for-model-systems-326',
  'How would you design a canary release and rollback mechanism for model systems?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'I would release new models, prompts, or retrieval logic behind explicit versioning and traffic routing. First I run shadow traffic or offline replay, then a small canary percentage, and only then broa',
  'I would release new models, prompts, or retrieval logic behind explicit versioning and traffic routing. First I run shadow traffic or offline replay, then a small canary percentage, and only then broader rollout if guardrail metrics stay healthy.
The canary decision cannot rely on one KPI alone. I want latency, error rate, hallucination or unsupported-claim rate, cost per request, and user outcome metrics. Sometimes a new model improves answer quality but blows up latency or cost enough to be a bad launch.
Rollback must be fast and operationally simple. That means version-pinned artifacts, feature flags, and routing rules that can move traffic back without redeploying the whole stack. If the schema of outputs changes, backward compatibility matters even more.
I also like having a clear manual override path. Automated rules are helpful, but when a safety or compliance issue appears, humans should be able to freeze or reverse the rollout immediately.',
  NULL,
  'I would release new models, prompts, or retrieval logic behind explicit versioning and traffic routing. First I run shadow traffic or offline replay, then a small canary percentage, and only then broader rollout if guardrail metrics stay healthy.
The canary decision cannot rely on one KPI alone. I want latency, error rate, hallucination or unsupported-claim rate, cost per request, and user outcome metrics. Sometimes a new model improves answer quality but blows up latency or cost enough to be a bad launch.
Rollback must be fast and operationally simple. That means version-pinned artifacts, feature flags, and routing rules that can move traffic back without redeploying the whole stack. If the schema of outputs changes, backward compatibility matters even more.
I also like having a clear manual override path. Automated rules are helpful, but when a safety or compliance issue appears, humans should be able to freeze or reverse the rollout immediately.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What cost optimization methods would you use, and how would you keep spending un...
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
) VALUES (
  'notion_q_327',
  'what-cost-optimization-methods-would-you-use-and-how-would-you-keep-spending-und-327',
  'What cost optimization methods would you use, and how would you keep spending under control?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I start with model routing. Not every request needs the largest model. I route simple tasks to smaller or cheaper models, reserve premium models for hard cases, and use retrieval, reranking, caching, ',
  'I start with model routing. Not every request needs the largest model. I route simple tasks to smaller or cheaper models, reserve premium models for hard cases, and use retrieval, reranking, caching, or templates to reduce expensive generation where possible.
Prompt and context management also matter. Shorter prompts, fewer irrelevant documents, structured outputs, and aggressive cache reuse can cut token costs significantly without hurting answer quality.
From an infrastructure perspective, I use batching where latency allows, autoscaling with sensible minimums, and clear quotas per tenant or workflow. Without tenant-level cost attribution, budget conversations stay vague and unhelpful.
The strongest answer is that cost is a product decision as much as an engineering one. I want budgets, alerts, and per-feature unit economics so the team knows which workflows create value and which ones just consume tokens.',
  NULL,
  'I start with model routing. Not every request needs the largest model. I route simple tasks to smaller or cheaper models, reserve premium models for hard cases, and use retrieval, reranking, caching, or templates to reduce expensive generation where possible.
Prompt and context management also matter. Shorter prompts, fewer irrelevant documents, structured outputs, and aggressive cache reuse can cut token costs significantly without hurting answer quality.
From an infrastructure perspective, I use batching where latency allows, autoscaling with sensible minimums, and clear quotas per tenant or workflow. Without tenant-level cost attribution, budget conversations stay vague and unhelpful.
The strongest answer is that cost is a product decision as much as an engineering one. I want budgets, alerts, and per-feature unit economics so the team knows which workflows create value and which ones just consume tokens.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is your emergency strategy when a model service fails or starts producing a...
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
) VALUES (
  'notion_q_328',
  'what-is-your-emergency-strategy-when-a-model-service-fails-or-starts-producing-a-328',
  'What is your emergency strategy when a model service fails or starts producing abnormal outputs?',
  'cat_ai',
  'Easy',
  ARRAY['general']::TEXT[],
  'The first step is fast detection with useful signals, not just generic 500 alerts. I want alerts for provider timeout spikes, malformed outputs, unsupported-claim spikes, refusal anomalies, and sudden',
  'The first step is fast detection with useful signals, not just generic 500 alerts. I want alerts for provider timeout spikes, malformed outputs, unsupported-claim spikes, refusal anomalies, and sudden jumps in fallback or human-escalation rate.
Operationally, I would trip a circuit breaker and degrade gracefully. Depending on the product, that may mean switching to a smaller model, disabling a tool path, returning retrieval-only results, serving cached responses, or escalating directly to humans.
At the same time, I would isolate the suspected bad version of model, prompt, or retrieval logic and stop further rollout. Strong traceability is what makes this possible quickly, because I can correlate the incident with a specific change set.
After stabilization, I would replay affected traffic in a safe environment, confirm the root cause, and add regression checks so the same failure mode is less likely to recur.',
  NULL,
  'The first step is fast detection with useful signals, not just generic 500 alerts. I want alerts for provider timeout spikes, malformed outputs, unsupported-claim spikes, refusal anomalies, and sudden jumps in fallback or human-escalation rate.
Operationally, I would trip a circuit breaker and degrade gracefully. Depending on the product, that may mean switching to a smaller model, disabling a tool path, returning retrieval-only results, serving cached responses, or escalating directly to humans.
At the same time, I would isolate the suspected bad version of model, prompt, or retrieval logic and stop further rollout. Strong traceability is what makes this possible quickly, because I can correlate the incident with a specific change set.
After stabilization, I would replay affected traffic in a safe environment, confirm the root cause, and add regression checks so the same failure mode is less likely to recur.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you integrate model services into CI/CD and automated testing?...
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
) VALUES (
  'notion_q_329',
  'how-would-you-integrate-model-services-into-cicd-and-automated-testing-329',
  'How would you integrate model services into CI/CD and automated testing?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I treat prompts, schemas, retrieval configs, and model routing rules as versioned artifacts, not as hidden application constants. CI should run unit tests for prompt builders, parsers, tool adapters, ',
  'I treat prompts, schemas, retrieval configs, and model routing rules as versioned artifacts, not as hidden application constants. CI should run unit tests for prompt builders, parsers, tool adapters, and policy logic, plus contract tests for every structured output consumed downstream.
For AI-specific regression testing, I would maintain a curated evaluation set and run it in CI or a pre-release gate. The goal is not to expect deterministic text, but to detect changes in correctness, groundedness, latency, and policy compliance before traffic shifts.
CD should support staged rollout, canaries, and automated rollback conditions. Infrastructure as code, model registry integration, and environment-specific secrets are part of the same deployment story.
I also like post-deploy smoke tests and replay tests against sampled production traffic. Traditional unit tests are necessary, but they are not enough for probabilistic systems.',
  NULL,
  'I treat prompts, schemas, retrieval configs, and model routing rules as versioned artifacts, not as hidden application constants. CI should run unit tests for prompt builders, parsers, tool adapters, and policy logic, plus contract tests for every structured output consumed downstream.
For AI-specific regression testing, I would maintain a curated evaluation set and run it in CI or a pre-release gate. The goal is not to expect deterministic text, but to detect changes in correctness, groundedness, latency, and policy compliance before traffic shifts.
CD should support staged rollout, canaries, and automated rollback conditions. Infrastructure as code, model registry integration, and environment-specific secrets are part of the same deployment story.
I also like post-deploy smoke tests and replay tests against sampled production traffic. Traditional unit tests are necessary, but they are not enough for probabilistic systems.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design an AI customer support system for millions of users while k...
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
) VALUES (
  'notion_q_330',
  'how-would-you-design-an-ai-customer-support-system-for-millions-of-users-while-k-330',
  'How would you design an AI customer support system for millions of users while keeping it stable and cost-controlled?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'I would break the system into layers: request intake, intent and risk classification, retrieval and customer context assembly, response generation, and escalation to human agents. Not every ticket sho',
  'I would break the system into layers: request intake, intent and risk classification, retrieval and customer context assembly, response generation, and escalation to human agents. Not every ticket should go through the full expensive LLM path; many can be resolved by routing, templates, or FAQ retrieval first.
To control cost, I would route by complexity and business value. High-volume simple cases use cheaper paths, while only complex unresolved cases use larger models or richer context. Caching previous solutions and reusing ticket summaries can cut cost significantly.
For stability, I want queues for spikes, strong timeout and fallback logic, tenant and channel isolation, and a clear “human handoff” path when confidence is low or the case is high risk. The model should be a component in the workflow, not the entire workflow.
Success metrics would include resolution rate, repeat contact rate, escalation rate, latency, cost per resolved case, and unsupported-claim rate. The right design is the one that balances user trust, agent productivity, and unit economics.',
  NULL,
  'I would break the system into layers: request intake, intent and risk classification, retrieval and customer context assembly, response generation, and escalation to human agents. Not every ticket should go through the full expensive LLM path; many can be resolved by routing, templates, or FAQ retrieval first.
To control cost, I would route by complexity and business value. High-volume simple cases use cheaper paths, while only complex unresolved cases use larger models or richer context. Caching previous solutions and reusing ticket summaries can cut cost significantly.
For stability, I want queues for spikes, strong timeout and fallback logic, tenant and channel isolation, and a clear “human handoff” path when confidence is low or the case is high risk. The model should be a component in the workflow, not the entire workflow.
Success metrics would include resolution rate, repeat contact rate, escalation rate, latency, cost per resolved case, and unsupported-claim rate. The right design is the one that balances user trust, agent productivity, and unit economics.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design an auditable LLM system, and what logs and traces are requi...
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
) VALUES (
  'notion_q_331',
  'how-would-you-design-an-auditable-llm-system-and-what-logs-and-traces-are-requir-331',
  'How would you design an auditable LLM system, and what logs and traces are required?',
  'cat_system',
  'Hard',
  ARRAY['design', 'llm']::TEXT[],
  'I want every request to carry a correlation ID and to log the user or service identity, tenant, prompt version, model version, retrieval results, tool calls, output schema version, safety decisions, a',
  'I want every request to carry a correlation ID and to log the user or service identity, tenant, prompt version, model version, retrieval results, tool calls, output schema version, safety decisions, and final user-visible response. Auditability starts with being able to reconstruct what happened end to end.
Tracing is especially important in multi-step workflows. If the system rewrites the query, calls a retriever, reranks documents, invokes a tool, and then generates an answer, I need span-level visibility to see where latency, quality, or policy failures were introduced.
Because audit logs can themselves become sensitive, I would redact or tokenize secrets and PII, apply access control to logs, and set clear retention rules. Observability without privacy discipline just creates a second compliance problem.
A strong answer should also mention replayability. The best audit setup is not only a log archive; it is a way to rerun a request with the same versions and inspect why the system behaved as it did.',
  NULL,
  'I want every request to carry a correlation ID and to log the user or service identity, tenant, prompt version, model version, retrieval results, tool calls, output schema version, safety decisions, and final user-visible response. Auditability starts with being able to reconstruct what happened end to end.
Tracing is especially important in multi-step workflows. If the system rewrites the query, calls a retriever, reranks documents, invokes a tool, and then generates an answer, I need span-level visibility to see where latency, quality, or policy failures were introduced.
Because audit logs can themselves become sensitive, I would redact or tokenize secrets and PII, apply access control to logs, and set clear retention rules. Observability without privacy discipline just creates a second compliance problem.
A strong answer should also mention replayability. The best audit setup is not only a log archive; it is a way to rerun a request with the same versions and inspect why the system behaved as it did.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you isolate data and resources in a multi-tenant AI platform?...
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
) VALUES (
  'notion_q_332',
  'how-would-you-isolate-data-and-resources-in-a-multi-tenant-ai-platform-332',
  'How would you isolate data and resources in a multi-tenant AI platform?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I would isolate tenants at multiple layers: authentication and authorization, storage namespace, retrieval filters, rate limits, and compute quotas. Data isolation is not enough if one tenant can stil',
  'I would isolate tenants at multiple layers: authentication and authorization, storage namespace, retrieval filters, rate limits, and compute quotas. Data isolation is not enough if one tenant can still starve another tenant’s inference or embedding capacity.
For sensitive environments, I would use separate encryption keys, tenant-scoped indexes or namespaces, and strict metadata tagging so that retrieval and caching never mix documents across tenants. Cross-tenant cache leaks are a real risk if the design is careless.
On the compute side, I want quotas, admission control, and bulkheads so that one noisy tenant cannot take down the shared platform. Depending on compliance needs, some tenants may need dedicated workers, networks, or even dedicated model endpoints.
The best answer also includes governance: tenant ownership, audit logs, usage reporting, and clear guarantees about retention, deletion, and how training or evaluation data is handled.',
  NULL,
  'I would isolate tenants at multiple layers: authentication and authorization, storage namespace, retrieval filters, rate limits, and compute quotas. Data isolation is not enough if one tenant can still starve another tenant’s inference or embedding capacity.
For sensitive environments, I would use separate encryption keys, tenant-scoped indexes or namespaces, and strict metadata tagging so that retrieval and caching never mix documents across tenants. Cross-tenant cache leaks are a real risk if the design is careless.
On the compute side, I want quotas, admission control, and bulkheads so that one noisy tenant cannot take down the shared platform. Depending on compliance needs, some tenants may need dedicated workers, networks, or even dedicated model endpoints.
The best answer also includes governance: tenant ownership, audit logs, usage reporting, and clear guarantees about retention, deletion, and how training or evaluation data is handled.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- Under high concurrency, how would you use caching and degradation so that the mo...
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
) VALUES (
  'notion_q_333',
  'under-high-concurrency-how-would-you-use-caching-and-degradation-so-that-the-mod-333',
  'Under high concurrency, how would you use caching and degradation so that the model does not become the bottleneck?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I would cache at multiple levels: raw retrieval results, embeddings, semantic response cache for repeated questions, and sometimes intermediate workflow outputs such as summaries. Caching only the fin',
  'I would cache at multiple levels: raw retrieval results, embeddings, semantic response cache for repeated questions, and sometimes intermediate workflow outputs such as summaries. Caching only the final answer misses many opportunities to cut load.
When concurrency spikes, I want admission control, rate limiting, and priority lanes so that critical traffic is protected first. The worst design is a flat queue where premium and low-value traffic all compete for the same expensive model pool.
Graceful degradation can include smaller models, shorter contexts, retrieval-only mode, template responses, asynchronous completion, or direct escalation. The product should keep functioning at lower quality rather than failing completely.
I would also watch cache hit rate, degraded-request percentage, queue depth, and user satisfaction. Degradation is successful only if it protects the service without silently destroying the user experience.',
  NULL,
  'I would cache at multiple levels: raw retrieval results, embeddings, semantic response cache for repeated questions, and sometimes intermediate workflow outputs such as summaries. Caching only the final answer misses many opportunities to cut load.
When concurrency spikes, I want admission control, rate limiting, and priority lanes so that critical traffic is protected first. The worst design is a flat queue where premium and low-value traffic all compete for the same expensive model pool.
Graceful degradation can include smaller models, shorter contexts, retrieval-only mode, template responses, asynchronous completion, or direct escalation. The product should keep functioning at lower quality rather than failing completely.
I would also watch cache hit rate, degraded-request percentage, queue depth, and user satisfaction. Degradation is successful only if it protects the service without silently destroying the user experience.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you handle prompt version management and A/B testing?...
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
) VALUES (
  'notion_q_334',
  'how-would-you-handle-prompt-version-management-and-ab-testing-334',
  'How would you handle prompt version management and A/B testing?',
  'cat_system',
  'Medium',
  ARRAY['design']::TEXT[],
  'I would treat prompts like code. Each prompt version should have an owner, changelog, associated model and tool configuration, schema expectations, and a stable identifier that is logged on every requ',
  'I would treat prompts like code. Each prompt version should have an owner, changelog, associated model and tool configuration, schema expectations, and a stable identifier that is logged on every request.
For experimentation, I would use feature flags or experiment assignment to send a controlled percentage of traffic to a candidate prompt version. The evaluation should include not only response quality but also latency, cost, fallback rate, and downstream business metrics.
The system must make rollback easy. If a prompt change increases hallucination or token usage, I want to route traffic back immediately without waiting for a code redeploy.
A mature answer also mentions offline evaluation before A/B, segment-level analysis after launch, and avoiding hidden prompt drift from ad hoc edits in application code.',
  NULL,
  'I would treat prompts like code. Each prompt version should have an owner, changelog, associated model and tool configuration, schema expectations, and a stable identifier that is logged on every request.
For experimentation, I would use feature flags or experiment assignment to send a controlled percentage of traffic to a candidate prompt version. The evaluation should include not only response quality but also latency, cost, fallback rate, and downstream business metrics.
The system must make rollback easy. If a prompt change increases hallucination or token usage, I want to route traffic back immediately without waiting for a code redeploy.
A mature answer also mentions offline evaluation before A/B, segment-level analysis after launch, and avoiding hidden prompt drift from ad hoc edits in application code.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design a permission system that limits which data can be retrieved...
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
) VALUES (
  'notion_q_335',
  'how-would-you-design-a-permission-system-that-limits-which-data-can-be-retrieved-335',
  'How would you design a permission system that limits which data can be retrieved?',
  'cat_system',
  'Hard',
  ARRAY['design']::TEXT[],
  'The safest design is permission-aware retrieval from the start. Every document or chunk should carry ACL metadata such as tenant, user groups, document owner, sensitivity label, and resource scope, an',
  'The safest design is permission-aware retrieval from the start. Every document or chunk should carry ACL metadata such as tenant, user groups, document owner, sensitivity label, and resource scope, and the retriever should filter on those attributes before candidate selection or reranking.
I prefer deny-by-default behavior. If the system cannot prove the caller is allowed to see a document, that document must not enter the context window. Filtering after generation is too late because the model may already have seen restricted information.
I would also protect related surfaces such as caches, summaries, embeddings, and audit logs. It is common to secure raw documents and forget that a cached answer or summary can leak the same restricted information.
Finally, I would test cross-tenant and cross-role boundary cases explicitly. Authorization bugs in AI retrieval are often silent until they become a serious incident.',
  NULL,
  'The safest design is permission-aware retrieval from the start. Every document or chunk should carry ACL metadata such as tenant, user groups, document owner, sensitivity label, and resource scope, and the retriever should filter on those attributes before candidate selection or reranking.
I prefer deny-by-default behavior. If the system cannot prove the caller is allowed to see a document, that document must not enter the context window. Filtering after generation is too late because the model may already have seen restricted information.
I would also protect related surfaces such as caches, summaries, embeddings, and audit logs. It is common to secure raw documents and forget that a cached answer or summary can leak the same restricted information.
Finally, I would test cross-tenant and cross-role boundary cases explicitly. Authorization bugs in AI retrieval are often silent until they become a serious incident.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you choose a thread pool strategy, and how do you avoid thread leaks and ...
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
) VALUES (
  'notion_q_336',
  'how-do-you-choose-a-thread-pool-strategy-and-how-do-you-avoid-thread-leaks-and-d-336',
  'How do you choose a thread pool strategy, and how do you avoid thread leaks and deadlocks?',
  'cat_ai',
  'Medium',
  ARRAY['concurrency']::TEXT[],
  'I choose thread pools by workload type. CPU-bound work usually needs a small pool near the number of cores, while IO-bound work can tolerate more concurrency because threads spend time waiting. Schedu',
  'I choose thread pools by workload type. CPU-bound work usually needs a small pool near the number of cores, while IO-bound work can tolerate more concurrency because threads spend time waiting. Scheduled work, blocking RPC calls, and background maintenance should not all share the same pool.
I avoid unbounded queues and unbounded thread creation because they hide overload until latency explodes or memory is exhausted. I prefer bounded queues, explicit rejection policies, and clear thread naming so that overload becomes visible and debuggable.
Thread leaks usually come from tasks that never finish, futures that are never cancelled, missing shutdown logic, or executors created per request. Deadlocks often come from blocking on tasks submitted to the same saturated pool or from inconsistent lock ordering.
In an interview, I would also mention timeouts, cancellation, graceful shutdown, and observability such as active thread count, queue depth, and task wait time. Pool strategy is part capacity planning, not just API usage.',
  NULL,
  'I choose thread pools by workload type. CPU-bound work usually needs a small pool near the number of cores, while IO-bound work can tolerate more concurrency because threads spend time waiting. Scheduled work, blocking RPC calls, and background maintenance should not all share the same pool.
I avoid unbounded queues and unbounded thread creation because they hide overload until latency explodes or memory is exhausted. I prefer bounded queues, explicit rejection policies, and clear thread naming so that overload becomes visible and debuggable.
Thread leaks usually come from tasks that never finish, futures that are never cancelled, missing shutdown logic, or executors created per request. Deadlocks often come from blocking on tasks submitted to the same saturated pool or from inconsistent lock ordering.
In an interview, I would also mention timeouts, cancellation, graceful shutdown, and observability such as active thread count, queue depth, and task wait time. Pool strategy is part capacity planning, not just API usage.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- What is your approach to GC tuning, and which metrics do you watch?...
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
) VALUES (
  'notion_q_337',
  'what-is-your-approach-to-gc-tuning-and-which-metrics-do-you-watch-337',
  'What is your approach to GC tuning, and which metrics do you watch?',
  'cat_ai',
  'Easy',
  ARRAY['gc']::TEXT[],
  'I do not start with JVM flags. I start with symptoms and data: pause times, throughput loss, allocation rate, heap occupancy, old-generation pressure, promotion failures, and GC logs. Without that, tu',
  'I do not start with JVM flags. I start with symptoms and data: pause times, throughput loss, allocation rate, heap occupancy, old-generation pressure, promotion failures, and GC logs. Without that, tuning is mostly superstition.
I want to understand whether the real problem is too much object churn, a memory leak, oversized caches, humongous allocations, or the wrong collector for the latency target. Often the fastest fix is reducing allocation pressure in the application rather than changing GC settings.
For metrics, I look at p95 and p99 pause time, frequency of young and old collections, allocation rate, live set size after GC, old-gen occupancy trend, and CPU consumed by GC. These tell me whether the collector is stable or just fighting the workload.
A good answer also maps collector choice to SLA. G1 is a practical default for many services, while lower-latency collectors such as ZGC make sense when pause sensitivity is high and the operational cost is justified.',
  NULL,
  'I do not start with JVM flags. I start with symptoms and data: pause times, throughput loss, allocation rate, heap occupancy, old-generation pressure, promotion failures, and GC logs. Without that, tuning is mostly superstition.
I want to understand whether the real problem is too much object churn, a memory leak, oversized caches, humongous allocations, or the wrong collector for the latency target. Often the fastest fix is reducing allocation pressure in the application rather than changing GC settings.
For metrics, I look at p95 and p99 pause time, frequency of young and old collections, allocation rate, live set size after GC, old-gen occupancy trend, and CPU consumed by GC. These tell me whether the collector is stable or just fighting the workload.
A good answer also maps collector choice to SLA. G1 is a practical default for many services, while lower-latency collectors such as ZGC make sense when pause sensitivity is high and the operational cost is justified.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- In Spring Boot, how do you think about transaction propagation and consistency t...
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
) VALUES (
  'notion_q_338',
  'in-spring-boot-how-do-you-think-about-transaction-propagation-and-consistency-tr-338',
  'In Spring Boot, how do you think about transaction propagation and consistency trade-offs?',
  'cat_ai',
  'Medium',
  ARRAY['spring', 'transactions']::TEXT[],
  'I use transaction propagation to express intent, not as a magic fix. REQUIRED is the normal default, REQUIRES_NEW is useful when I need an independent unit such as audit or outbox persistence, and NES',
  'I use transaction propagation to express intent, not as a magic fix. REQUIRED is the normal default, REQUIRES_NEW is useful when I need an independent unit such as audit or outbox persistence, and NESTED only makes sense when the database supports savepoints and the semantics are truly local.
I avoid holding database transactions open across remote calls because that increases lock time, hurts throughput, and still does not give me distributed consistency. Once a workflow spans services, I usually move toward eventual consistency patterns such as outbox, retries, and saga-style coordination.
The trade-off is simple: stronger immediate consistency usually increases coupling, latency, and failure sensitivity. Eventual consistency requires compensation, observability, and careful contract design, but it scales better across services.
In interviews, I like to say that transaction boundaries should align with what the local database can guarantee. Everything beyond that is a workflow design problem, not just a Spring annotation problem.',
  NULL,
  'I use transaction propagation to express intent, not as a magic fix. REQUIRED is the normal default, REQUIRES_NEW is useful when I need an independent unit such as audit or outbox persistence, and NESTED only makes sense when the database supports savepoints and the semantics are truly local.
I avoid holding database transactions open across remote calls because that increases lock time, hurts throughput, and still does not give me distributed consistency. Once a workflow spans services, I usually move toward eventual consistency patterns such as outbox, retries, and saga-style coordination.
The trade-off is simple: stronger immediate consistency usually increases coupling, latency, and failure sensitivity. Eventual consistency requires compensation, observability, and careful contract design, but it scales better across services.
In interviews, I like to say that transaction boundaries should align with what the local database can guarantee. Everything beyond that is a workflow design problem, not just a Spring annotation problem.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design rate limiting and circuit breaking for a high-concurrency A...
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
) VALUES (
  'notion_q_339',
  'how-would-you-design-rate-limiting-and-circuit-breaking-for-a-high-concurrency-a-339',
  'How would you design rate limiting and circuit breaking for a high-concurrency API?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'I would layer protections. At the edge, I want coarse global and tenant-level rate limits. Inside the service, I want finer limits for expensive endpoints or downstream dependencies such as databases,',
  'I would layer protections. At the edge, I want coarse global and tenant-level rate limits. Inside the service, I want finer limits for expensive endpoints or downstream dependencies such as databases, search clusters, or model providers.
Circuit breakers, bulkheads, and timeouts work together. If a dependency starts timing out, the breaker should open, concurrency to that dependency should be capped, and the API should fall back to a degraded but controlled response rather than letting request threads pile up.
The right policy depends on the business surface. Some requests should fail fast, some should queue briefly, and some should use stale cache or partial results. Good degradation is product-aware, not just technical.
I would also mention monitoring thresholds, dynamic tuning, and the need to test these protections under load. A rate limiter or breaker that has never been exercised in staging is only a theory.',
  NULL,
  'I would layer protections. At the edge, I want coarse global and tenant-level rate limits. Inside the service, I want finer limits for expensive endpoints or downstream dependencies such as databases, search clusters, or model providers.
Circuit breakers, bulkheads, and timeouts work together. If a dependency starts timing out, the breaker should open, concurrency to that dependency should be capped, and the API should fall back to a degraded but controlled response rather than letting request threads pile up.
The right policy depends on the business surface. Some requests should fail fast, some should queue briefly, and some should use stale cache or partial results. Good degradation is product-aware, not just technical.
I would also mention monitoring thresholds, dynamic tuning, and the need to test these protections under load. A rate limiter or breaker that has never been exercised in staging is only a theory.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you diagnose an online performance problem, from metrics to root cause?...
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
) VALUES (
  'notion_q_340',
  'how-do-you-diagnose-an-online-performance-problem-from-metrics-to-root-cause-340',
  'How do you diagnose an online performance problem, from metrics to root cause?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I start broad and narrow down. First I look at service-level metrics such as latency, error rate, throughput, saturation, and recent changes. That tells me whether the issue is local, downstream, infr',
  'I start broad and narrow down. First I look at service-level metrics such as latency, error rate, throughput, saturation, and recent changes. That tells me whether the issue is local, downstream, infrastructure-related, or tied to a deployment or traffic pattern.
Next I use tracing and breakdown metrics to isolate the slow path. I want to know whether time is being lost in application logic, database queries, external RPC calls, queueing, thread contention, or garbage collection. Slow requests should be decomposed, not treated as one blob.
If needed, I move to process-level evidence such as thread dumps, heap profiles, GC logs, database execution plans, and system metrics like CPU steal, disk IO, and network retransmits. The point is to move from symptom to bottleneck to causal change.
A strong answer ends with validation. After fixing the suspected root cause, I verify that the target metric recovers and add dashboards or alerts so the same class of issue becomes easier to catch next time.',
  NULL,
  'I start broad and narrow down. First I look at service-level metrics such as latency, error rate, throughput, saturation, and recent changes. That tells me whether the issue is local, downstream, infrastructure-related, or tied to a deployment or traffic pattern.
Next I use tracing and breakdown metrics to isolate the slow path. I want to know whether time is being lost in application logic, database queries, external RPC calls, queueing, thread contention, or garbage collection. Slow requests should be decomposed, not treated as one blob.
If needed, I move to process-level evidence such as thread dumps, heap profiles, GC logs, database execution plans, and system metrics like CPU steal, disk IO, and network retransmits. The point is to move from symptom to bottleneck to causal change.
A strong answer ends with validation. After fixing the suspected root cause, I verify that the target metric recovers and add dashboards or alerts so the same class of issue becomes easier to catch next time.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you approach service decomposition and API contract management?...
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
) VALUES (
  'notion_q_341',
  'how-would-you-approach-service-decomposition-and-api-contract-management-341',
  'How would you approach service decomposition and API contract management?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I decompose services around business capabilities and team ownership, not just by technical layer. If the boundaries do not match real ownership and change patterns, the architecture may look clean on',
  'I decompose services around business capabilities and team ownership, not just by technical layer. If the boundaries do not match real ownership and change patterns, the architecture may look clean on paper but create constant cross-team friction.
For contracts, I want explicit schemas such as OpenAPI, Protobuf, or event schemas, plus backward-compatibility rules and semantic versioning where needed. Hidden JSON fields and undocumented assumptions are one of the fastest ways to accumulate system debt.
Contract management should include consumer-driven tests, schema validation in CI, and rollout strategies that allow producers and consumers to upgrade safely at different times. Contract discipline matters even more in event-driven systems because failures are delayed and harder to trace.
My mental model is that service decomposition creates independence only when contracts are stable, observable, and owned. Otherwise I just move complexity from code into coordination overhead.',
  NULL,
  'I decompose services around business capabilities and team ownership, not just by technical layer. If the boundaries do not match real ownership and change patterns, the architecture may look clean on paper but create constant cross-team friction.
For contracts, I want explicit schemas such as OpenAPI, Protobuf, or event schemas, plus backward-compatibility rules and semantic versioning where needed. Hidden JSON fields and undocumented assumptions are one of the fastest ways to accumulate system debt.
Contract management should include consumer-driven tests, schema validation in CI, and rollout strategies that allow producers and consumers to upgrade safely at different times. Contract discipline matters even more in event-driven systems because failures are delayed and harder to trace.
My mental model is that service decomposition creates independence only when contracts are stable, observable, and owned. Otherwise I just move complexity from code into coordination overhead.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design tool calling and agent orchestration safely?...
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
) VALUES (
  'notion_q_342',
  'how-would-you-design-tool-calling-and-agent-orchestration-safely-342',
  'How would you design tool calling and agent orchestration safely?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'I separate planning from execution and keep every tool schema explicit so the model cannot improvise undocumented actions.',
  'I separate planning from execution and keep every tool schema explicit so the model cannot improvise undocumented actions.
Each tool call should be permission-checked, time-bounded, traced, and safe to retry or reject when the output is invalid.
In production I prefer narrow orchestrated workflows over fully open-ended agents because control, observability, and failure handling stay much clearer.',
  NULL,
  'I separate planning from execution and keep every tool schema explicit so the model cannot improvise undocumented actions.
Each tool call should be permission-checked, time-bounded, traced, and safe to retry or reject when the output is invalid.
In production I prefer narrow orchestrated workflows over fully open-ended agents because control, observability, and failure handling stay much clearer.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you defend against prompt injection and jailbreak attempts?...
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
) VALUES (
  'notion_q_343',
  'how-do-you-defend-against-prompt-injection-and-jailbreak-attempts-343',
  'How do you defend against prompt injection and jailbreak attempts?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I treat retrieved documents, web content, and user-provided text as untrusted data rather than trusted instructions.',
  'I treat retrieved documents, web content, and user-provided text as untrusted data rather than trusted instructions.
System policy must stay outside retrieved context, tool access must be constrained, and outputs must be validated before they trigger real actions.
For high-risk workflows I also add allowlists, safety filters, and step-up review paths instead of trusting one model response.',
  NULL,
  'I treat retrieved documents, web content, and user-provided text as untrusted data rather than trusted instructions.
System policy must stay outside retrieved context, tool access must be constrained, and outputs must be validated before they trigger real actions.
For high-risk workflows I also add allowlists, safety filters, and step-up review paths instead of trusting one model response.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How would you design model routing and provider fallback?...
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
) VALUES (
  'notion_q_344',
  'how-would-you-design-model-routing-and-provider-fallback-344',
  'How would you design model routing and provider fallback?',
  'cat_ai',
  'Hard',
  ARRAY['design']::TEXT[],
  'I route simpler work to smaller or cheaper models and reserve premium models for tasks that need stronger reasoning, tools, or higher answer quality.',
  'I route simpler work to smaller or cheaper models and reserve premium models for tasks that need stronger reasoning, tools, or higher answer quality.
Provider fallback must preserve schema compatibility, timeout discipline, and safe degradation instead of silently changing behavior in unpredictable ways.
I log model choice, routing reason, latency, token cost, and business outcome so routing policy can be improved with evidence.',
  NULL,
  'I route simpler work to smaller or cheaper models and reserve premium models for tasks that need stronger reasoning, tools, or higher answer quality.
Provider fallback must preserve schema compatibility, timeout discipline, and safe degradation instead of silently changing behavior in unpredictable ways.
I log model choice, routing reason, latency, token cost, and business outcome so routing policy can be improved with evidence.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you manage conversation memory and session state?...
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
) VALUES (
  'notion_q_345',
  'how-do-you-manage-conversation-memory-and-session-state-345',
  'How do you manage conversation memory and session state?',
  'cat_ai',
  'Medium',
  ARRAY['memory']::TEXT[],
  'I separate short-term working context, durable user state, and retrieval context instead of mixing them into one giant prompt history.',
  'I separate short-term working context, durable user state, and retrieval context instead of mixing them into one giant prompt history.
Long conversations should be summarized deliberately, low-value context should expire, and sensitive state should be permission-scoped.
Bad memory policy damages cost, privacy, and answer quality at the same time, so memory design is an application concern, not only a prompt concern.',
  NULL,
  'I separate short-term working context, durable user state, and retrieval context instead of mixing them into one giant prompt history.
Long conversations should be summarized deliberately, low-value context should expire, and sensitive state should be permission-scoped.
Bad memory policy damages cost, privacy, and answer quality at the same time, so memory design is an application concern, not only a prompt concern.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you handle embedding refresh and re-indexing when documents or chunking r...
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
) VALUES (
  'notion_q_346',
  'how-do-you-handle-embedding-refresh-and-re-indexing-when-documents-or-chunking-r-346',
  'How do you handle embedding refresh and re-indexing when documents or chunking rules change?',
  'cat_ai',
  'Medium',
  ARRAY['indexing', 'embeddings']::TEXT[],
  'I version chunking logic, embedding models, and indexes so old and new retrieval artifacts can coexist safely during rollout.',
  'I version chunking logic, embedding models, and indexes so old and new retrieval artifacts can coexist safely during rollout.
If only a subset of documents changed, I re-index incrementally. If chunking semantics changed, I plan a broader rebuild with version-aware cutover.
Lineage from answer to index version matters because retrieval regressions are otherwise very hard to debug.',
  NULL,
  'I version chunking logic, embedding models, and indexes so old and new retrieval artifacts can coexist safely during rollout.
If only a subset of documents changed, I re-index incrementally. If chunking semantics changed, I plan a broader rebuild with version-aware cutover.
Lineage from answer to index version matters because retrieval regressions are otherwise very hard to debug.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;

-- How do you keep retrieval fresh and invalidate stale knowledge?...
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
) VALUES (
  'notion_q_347',
  'how-do-you-keep-retrieval-fresh-and-invalidate-stale-knowledge-347',
  'How do you keep retrieval fresh and invalidate stale knowledge?',
  'cat_ai',
  'Medium',
  ARRAY['general']::TEXT[],
  'I use document versioning, delete signals, and freshness metadata so stale chunks can be invalidated or down-ranked when source data changes.',
  'I use document versioning, delete signals, and freshness metadata so stale chunks can be invalidated or down-ranked when source data changes.
Caches, summaries, and derived retrieval artifacts must also be invalidated because stale knowledge leaks through more than raw documents.
For high-risk domains, uncertain freshness should push the system toward abstention or escalation rather than confident guessing.',
  NULL,
  'I use document versioning, delete signals, and freshness metadata so stale chunks can be invalidated or down-ranked when source data changes.
Caches, summaries, and derived retrieval artifacts must also be invalidated because stale knowledge leaks through more than raw documents.
For high-risk domains, uncertain freshness should push the system toward abstention or escalation rather than confident guessing.',
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;
