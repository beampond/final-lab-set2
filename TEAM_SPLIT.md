# TEAM_SPLIT.md

## Team Members

| Student ID    | ชื่อ-นามสกุล         |
| ------------- | -------------------- |
| 67543210031-0 | ธนภัทร นุกูล         |
| 66543210011-3 | นายณัฏธพงษ์ เรือนเทศ |

---

## Work Allocation

### Student 1: ธนภัทร นุกูล — Backend

- Auth Service (login, JWT, logEvent)
- Task Service (CRUD, authMiddleware, logEvent)
- Log Service (internal endpoint, GET logs, stats)
- Database Schema (init.sql, bcrypt hash)
- Nginx (nginx.conf, HTTPS, rate limit, gen-certs.sh)
- Docker Compose (docker-compose.yml, .env.example, Dockerfiles)

### Student 2: นายณัฏธพงษ์ เรือนเทศ — Frontend

- Task Board UI (frontend/index.html)
- Log Dashboard (frontend/logs.html)
- Frontend Dockerfile
- README.md (ร่วมกัน)
- Screenshots (ร่วมกัน)

---

## Shared Responsibilities

- ออกแบบ Architecture diagram ร่วมกัน
- ทดสอบ end-to-end ร่วมกัน
- จัดทำ README.md และ screenshots ร่วมกัน
- เขียน TEAM_SPLIT.md และ INDIVIDUAL_REPORT ร่วมกัน

---

## Reason for Work Split

แบ่งงานตาม Backend/Frontend boundary เพื่อให้แต่ละคนรับผิดชอบส่วนที่ชัดเจน และสามารถพัฒนาพร้อมกันได้โดยไม่ติดขัด โดยตกลง API contract (path, request/response format) และ JWT_SECRET ร่วมกันก่อนเริ่มพัฒนา

---

## Integration Notes

- Frontend เรียก API ผ่าน relative URL (`/api/auth/`, `/api/tasks/`, `/api/logs/`) โดย Nginx เป็นตัวกลาง
- JWT_SECRET ใช้ค่าเดียวกันทั้ง Auth Service, Task Service และ Log Service
- Frontend เก็บ JWT ใน `localStorage` key `jwt_token` แล้วส่งผ่าน `Authorization: Bearer <token>` ทุก request
- Log Service รับ log จาก Auth Service และ Task Service ผ่าน `POST /api/logs/internal` ภายใน Docker network เท่านั้น
