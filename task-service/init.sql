CREATE TABLE IF NOT EXISTS tasks (
  id          SERIAL PRIMARY KEY,
  user_id     INTEGER      NOT NULL,
  title       VARCHAR(200) NOT NULL,
  description TEXT,
  status      VARCHAR(20)  DEFAULT 'TODO' CHECK (status IN ('TODO','IN_PROGRESS','DONE')),
  priority    VARCHAR(10)  DEFAULT 'medium' CHECK (priority IN ('low','medium','high')),
  created_at  TIMESTAMP    DEFAULT NOW(),
  updated_at  TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS logs (
  id         SERIAL       PRIMARY KEY,
  level      VARCHAR(10)  NOT NULL CHECK (level IN ('INFO','WARN','ERROR')),
  event      VARCHAR(100) NOT NULL,
  user_id    INTEGER,
  message    TEXT,
  meta       JSONB,
  created_at TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS activities (
  id          SERIAL       PRIMARY KEY,
  user_id     INTEGER      NOT NULL,
  username    VARCHAR(50),             -- ← denormalized: เก็บจาก JWT ณ เวลาที่เกิด event
  event_type  VARCHAR(50)  NOT NULL,   -- 'USER_LOGIN', 'TASK_CREATED', ...
  entity_type VARCHAR(20),             -- 'user', 'task'
  entity_id   INTEGER,                 -- id ของสิ่งที่ถูก act on
  summary     TEXT,                    -- 'alice created task "Deploy to Railway"'
  meta        JSONB,                   -- { old_status: 'TODO', new_status: 'DONE' }
  created_at  TIMESTAMP    DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_activities_user_id   ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_event_type ON activities(event_type);
CREATE INDEX IF NOT EXISTS idx_activities_created_at ON activities(created_at DESC);