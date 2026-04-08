CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  display_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('USER', 'ADMIN')),
  preferred_tracks TEXT[] NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE users
ADD COLUMN IF NOT EXISTS password_hash TEXT NOT NULL DEFAULT '';

CREATE TABLE IF NOT EXISTS user_sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS question_categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS questions (
  id TEXT PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  category_id TEXT NOT NULL REFERENCES question_categories (id),
  difficulty TEXT NOT NULL CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
  tags TEXT[] NOT NULL DEFAULT '{}',
  excerpt TEXT NOT NULL,
  body TEXT NOT NULL,
  hint TEXT,
  reference_answer TEXT,
  related_slugs TEXT[] NOT NULL DEFAULT '{}',
  visibility TEXT NOT NULL DEFAULT 'PUBLIC' CHECK (visibility IN ('PUBLIC', 'PRIVATE')),
  content_status TEXT NOT NULL DEFAULT 'PUBLISHED' CHECK (content_status IN ('DRAFT', 'PUBLISHED', 'ARCHIVED')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_question_progress (
  user_id TEXT NOT NULL REFERENCES users (id),
  question_id TEXT NOT NULL REFERENCES questions (id),
  progress_status TEXT NOT NULL CHECK (
    progress_status IN (
      'NOT_STARTED',
      'PLANNED',
      'IN_PROGRESS',
      'REVIEWED',
      'MASTERED'
    )
  ),
  review_count INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, question_id)
);

CREATE TABLE IF NOT EXISTS study_tasks (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users (id),
  plan_date DATE NOT NULL,
  title TEXT NOT NULL,
  task_type TEXT NOT NULL CHECK (
    task_type IN ('QUESTION_LINKED', 'CATEGORY_PRACTICE', 'FREEFORM')
  ),
  status TEXT NOT NULL CHECK (
    status IN ('PENDING', 'COMPLETED', 'SKIPPED', 'CARRIED_OVER')
  ),
  priority INTEGER NOT NULL CHECK (priority BETWEEN 1 AND 5),
  category_id TEXT REFERENCES question_categories (id),
  category_name TEXT,
  linked_question_slug TEXT,
  linked_question_title TEXT,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE study_tasks
ADD COLUMN IF NOT EXISTS category_id TEXT REFERENCES question_categories (id);

UPDATE study_tasks AS task
SET category_id = category.id
FROM question_categories AS category
WHERE task.category_id IS NULL
  AND task.category_name IS NOT NULL
  AND category.name = task.category_name;

CREATE INDEX IF NOT EXISTS idx_questions_category_id ON questions (category_id);
CREATE INDEX IF NOT EXISTS idx_questions_slug ON questions (slug);
CREATE UNIQUE INDEX IF NOT EXISTS idx_question_categories_name_unique
  ON question_categories (name);
CREATE INDEX IF NOT EXISTS idx_user_question_progress_user_id
  ON user_question_progress (user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id
  ON user_sessions (user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_expires_at
  ON user_sessions (expires_at);
CREATE INDEX IF NOT EXISTS idx_study_tasks_user_plan_date
  ON study_tasks (user_id, plan_date);
CREATE INDEX IF NOT EXISTS idx_study_tasks_user_status
  ON study_tasks (user_id, status);
CREATE INDEX IF NOT EXISTS idx_study_tasks_user_category_id
  ON study_tasks (user_id, category_id);
