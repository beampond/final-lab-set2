# ENGSE207 Final Lab Sec2 Set 2

## Microservices + Activity Tracking + Cloud (Railway)

## Team Members

| รหัสนักศึกษา  | ชื่อ-นามสกุล         | บทบาท    |
| ------------- | -------------------- | -------- |
| 67543210031-0 | ธนภัทร นุกูล         | Backend  |
| 66543210011-3 | นายณัฏธพงษ์ เรือนเทศ | Frontend |

---

## 🌐 Railway URLs

| Service          | URL                                               |
| ---------------- | ------------------------------------------------- |
| Auth Service     | `final-lab-set2-production.up.railway.app`        |
| Task Service     | `final-lab-set2-production-cb3b.up.railway.app`   |
| Activity Service | `activity-service-production-c044.up.railway.app` |

---

## 🏗️ Architecture

### Service-to-Service Call

```
Browser / Postman
        │
        ▼ HTTPS
┌─────────────────────────────────────────────────────┐
│                  Railway Project                     │
│                                                     │
│  Auth Service          Task Service                 │
│  /api/auth/*           /api/tasks/*                 │
│       │                     │                       │
│       │  POST /api/activity/internal (fire-and-forget)
│       └─────────────────────┴──────────────────►   │
│                                          Activity   │
│                                          Service    │
│                                          /api/activity/*
│       │                     │                │      │
│       ▼                     ▼                ▼      │
│   auth-db              task-db          activity-db │
│  [PostgreSQL]          [PostgreSQL]     [PostgreSQL] │
└─────────────────────────────────────────────────────┘
```

### Activity Events

| event_type            | ส่งมาจาก     | เกิดขึ้นเมื่อ                 |
| --------------------- | ------------ | ----------------------------- |
| `USER_REGISTERED`     | auth-service | POST /register สำเร็จ         |
| `USER_LOGIN`          | auth-service | POST /login สำเร็จ            |
| `TASK_CREATED`        | task-service | POST /tasks สำเร็จ            |
| `TASK_STATUS_CHANGED` | task-service | PUT /tasks/:id เปลี่ยน status |
| `TASK_DELETED`        | task-service | DELETE /tasks/:id             |

---

## 📖 Key Concepts

### Denormalization — ทำไม Activity Service ถึงเก็บ `username` ไว้

ใน Database-per-Service Pattern แต่ละ service มี database เป็นของตัวเอง  
`activity-db` ไม่มี `users` table — ข้อมูล username อยู่ใน `auth-db` เท่านั้น  
ถ้าไม่เก็บ `username` ไว้ใน `activities` table จะต้อง query ข้าม 2 databases  
ซึ่งทำไม่ได้ใน Microservices architecture

**วิธีแก้:** เก็บ `username` ไว้ใน `activities` table ณ เวลาที่ event เกิดขึ้น  
แม้จะซ้ำซ้อนกับ `auth-db` แต่ทำให้ query ได้โดยไม่ต้อง JOIN ข้าม database

### Fire-and-Forget Pattern — ใช้ที่ไหนในระบบ (Bonus B1)

`logActivity()` ใน auth-service และ task-service ใช้ pattern นี้:

```javascript
fetch(`${ACTIVITY_URL}/api/activity/internal`, { ... })
  .catch(() => {
    console.warn('activity-service unreachable — skipping');
  });
```

**ความหมาย:** ส่ง HTTP request ไปหา Activity Service แล้วไม่รอผล  
ถ้า Activity Service ล่ม — auth-service และ task-service **ยังทำงานได้ปกติ**  
เพียงแต่ activity จะไม่ถูกบันทึกชั่วคราว

**ใช้ที่:** POST /register, POST /login, POST /tasks, PUT /tasks/:id, DELETE /tasks/:id

### Gateway Strategy — Option A (Direct Call)

Frontend เรียก URL ของแต่ละ service โดยตรงผ่าน `config.js`:

```javascript
window.APP_CONFIG = {
  AUTH_URL: "https://final-lab-set2-production.up.railway.app",
  TASK_URL: "https://final-lab-set2-production-cb3b.up.railway.app",
  ACTIVITY_URL: "https://activity-service-production-c044.up.railway.app",
};
```

**เหตุผลที่เลือก:**

- ไม่ต้องสร้าง API Gateway เพิ่ม ลด complexity
- Railway จัดการ HTTPS ให้อัตโนมัติทุก service
- เหมาะกับระบบขนาดเล็กที่มี 3 services

---

## 🚀 วิธีรัน Local

### Prerequisites

- Docker Desktop
- Node.js 20+

### Steps

```bash
# 1. Clone repo
git clone https://github.com/beampond/final-lab-set2.git
cd final-lab-set2

# 2. สร้าง .env
cp .env.example .env

# 3. รัน
docker compose up --build
```

Services จะขึ้นที่:

- Auth Service: `http://localhost:3001`
- Task Service: `http://localhost:3002`
- Activity Service: `http://localhost:3003`

---

## ⚙️ Environment Variables

### Auth Service

| Variable               | Value                                      | หมายเหตุ                 |
| ---------------------- | ------------------------------------------ | ------------------------ |
| `DATABASE_URL`         | `${{auth-db.DATABASE_URL}}`                | Railway inject อัตโนมัติ |
| `JWT_SECRET`           | `engse207-sec2-set2-grpup1`                | ต้องเหมือนกันทุก service |
| `JWT_EXPIRES`          | `1h`                                       |                          |
| `PORT`                 | `3001`                                     |                          |
| `NODE_ENV`             | `production`                               |                          |
| `ACTIVITY_SERVICE_URL` | `final-lab-set2-production.up.railway.app` |                          |

### Task Service

| Variable               | Value                                           | หมายเหตุ                 |
| ---------------------- | ----------------------------------------------- | ------------------------ |
| `DATABASE_URL`         | `${{task-db.DATABASE_URL}}`                     | Railway inject อัตโนมัติ |
| `JWT_SECRET`           | `engse207-sec2-set2-grpup1`                     | ต้องเหมือนกันทุก service |
| `PORT`                 | `3002`                                          |                          |
| `NODE_ENV`             | `production`                                    |                          |
| `ACTIVITY_SERVICE_URL` | `final-lab-set2-production-cb3b.up.railway.app` |                          |

### Activity Service

| Variable       | Value                           | หมายเหตุ                 |
| -------------- | ------------------------------- | ------------------------ |
| `DATABASE_URL` | `${{activity-db.DATABASE_URL}}` | Railway inject อัตโนมัติ |
| `JWT_SECRET`   | `engse207-sec2-set2-grpup1`     | ต้องเหมือนกันทุก service |
| `PORT`         | `3003`                          |                          |
| `NODE_ENV`     | `production`                    |                          |

---

## 🧪 วิธีทดสอบ (Cloud)

```bash
AUTH_URL="https://final-lab-set2-production.up.railway.app"
TASK_URL="https://final-lab-set2-production-cb3b.up.railway.app"
ACTIVITY_URL="https://activity-service-production-c044.up.railway.app"

# T1: Health Check
curl $AUTH_URL/api/auth/health
curl $TASK_URL/api/tasks/health
curl $ACTIVITY_URL/api/activity/health

# T2: Register
curl -X POST $AUTH_URL/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"sec2user","email":"sec2@test.com","password":"123456"}'

# T3: Login → เก็บ token
TOKEN=$(curl -s -X POST $AUTH_URL/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"sec2@test.com","password":"123456"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

# T4: Auth Me
curl $AUTH_URL/api/auth/me -H "Authorization: Bearer $TOKEN"

# T5: ดู USER_REGISTERED + USER_LOGIN
curl $ACTIVITY_URL/api/activity/me -H "Authorization: Bearer $TOKEN"

# T6: Create Task
curl -X POST $TASK_URL/api/tasks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Cloud activity test","priority":"high"}'

# ดู TASK_CREATED
curl $ACTIVITY_URL/api/activity/me -H "Authorization: Bearer $TOKEN"

# T7: Update Task status
curl -X PUT $TASK_URL/api/tasks/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status":"DONE"}'

# T8: Get Tasks
curl $TASK_URL/api/tasks -H "Authorization: Bearer $TOKEN"

# T9: ไม่มี JWT → 401
curl $TASK_URL/api/tasks
curl $ACTIVITY_URL/api/activity/me

# T10: Admin vs Member
ADMIN_TOKEN=$(curl -s -X POST $AUTH_URL/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lab.local","password":"adminpass"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

curl $ACTIVITY_URL/api/activity/all -H "Authorization: Bearer $ADMIN_TOKEN"  # 200
curl $ACTIVITY_URL/api/activity/all -H "Authorization: Bearer $TOKEN"         # 403
```

---

## ⚠️ Known Limitations

- Activity Service ล่มจะทำให้ events หายชั่วคราว (fire-and-forget by design)
- ไม่มี API Gateway — frontend ต้องจัดการ URL หลาย service เอง
- JWT หมดอายุใน 1 ชั่วโมง ต้อง login ใหม่
- seed users (`alice`, `admin`) มีใน auth-db เท่านั้น ไม่มีใน activity-db
- `/api/activity/internal` ไม่มี authentication — ควรเพิ่ม internal secret ในอนาคต
