// ════════════════════════════════════════════════════════════
//  config.js — ENGSE207 Sec2 Set 2
//  แก้ URL ตาม Railway deployment ของกลุ่มคุณ
// ════════════════════════════════════════════════════════════

window.APP_CONFIG = {
  // ── Local (Docker Compose) ──────────────────────────────
  // AUTH_URL:     'http://localhost:3001',
  // TASK_URL:     'http://localhost:3002',
  // ACTIVITY_URL: 'http://localhost:3003',

  // ── Railway Cloud ───────────────────────────────────────
  // แก้ URL ด้านล่างให้ตรงกับ Railway project ของกลุ่มคุณ
  AUTH_URL:     'https://auth-service-xxxx.up.railway.app',
  TASK_URL:     'https://task-service-xxxx.up.railway.app',
  ACTIVITY_URL: 'https://activity-service-xxxx.up.railway.app',
};