# TEAM_SPLIT.md

## Team Members

| Student ID    | ชื่อ-นามสกุล         |
| ------------- | -------------------- |
| 67543210031-0 | ธนภัทร นุกูล         |
| 66543210011-3 | นายณัฏธพงษ์ เรือนเทศ |

---

## Work Allocation

### Student 1: ธนภัทร นุกูล — Backend

- Auth Service: เพิ่ม Register API + logActivity() + logToDB()
- Task Service: เพิ่ม logActivity() ใน CRUD routes ทุกตัว
- Activity Service: สร้างใหม่ทั้งหมด (POST /internal, GET /me, GET /all)
- แก้ db.js ทุก service ให้ใช้ DATABASE_URL
- docker-compose.yml: ปรับเป็น Database-per-Service (3 DB แยก)
- Deploy auth-service, task-service, activity-service บน Railway
- README.md (ร่วมกัน)
- Screenshots (ร่วมกัน)

### Student 2: นายณัฏธพงษ์ เรือนเทศ — Frontend

- ปรับ index.html: เพิ่ม Register form, ลบ Profile tab, ลบ Log Dashboard
- เพิ่ม config.js สำหรับ Railway Service URLs
- สร้าง activity.html: Activity Timeline page
- ปรับ URL ทุก fetch ให้ใช้ AUTH, TASK, ACTIVITY จาก config.js
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
