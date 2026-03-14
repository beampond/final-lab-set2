# INDIVIDUAL_REPORT

## 1. ข้อมูลผู้จัดทำ

|                    |                   |
| ------------------ | ----------------- |
| **Student ID**     | 67543210031-0     |
| **ชื่อ-นามสกุล**   | ธนภัทร นุกูล      |
| **หน้าที่ในกลุ่ม** | Backend Developer |

---

## 2. ส่วนที่รับผิดชอบ

- **Nginx** — ตั้งค่า HTTPS, reverse proxy, rate limiting, gen-certs.sh
- **Auth Service** — login endpoint, JWT generate/verify, logEvent helper
- **Task Service** — CRUD tasks, JWT middleware, logEvent helper
- **Log Service** — รับ log จาก services อื่น, GET logs, stats endpoint
- **Database** — init.sql schema, bcrypt hash สำหรับ seed users
- **Docker Compose** — รวมทุก service, .env.example, Dockerfiles

---

## 3. สิ่งที่ได้ลงมือพัฒนาด้วยตนเอง

- เขียน `nginx.conf` สำหรับ HTTPS และ rate limiting
- สร้าง Self-Signed Certificate ด้วย `gen-certs.sh`
- เขียน `auth-service` ตั้งแต่ต้น รวมถึง timing-safe password comparison เพื่อป้องกัน timing attack
- เขียน `task-service` พร้อม role-based access (admin เห็น tasks ทั้งหมด, member เห็นแค่ของตัวเอง)
- เขียน `log-service` พร้อม dynamic query filter และ admin-only access
- ออกแบบ `db/init.sql` schema ทั้งหมดและสร้าง bcrypt hash จริงสำหรับ seed users
- เขียน `docker-compose.yml` พร้อม healthcheck และ depends_on

---

## 4. ปัญหาที่พบและวิธีการแก้ไข

**ปัญหา 1:** Git ไม่ track โฟลเดอร์เปล่า  
**แก้ไข:** สร้างไฟล์ `.gitkeep` ในแต่ละโฟลเดอร์เพื่อให้ git รู้จักโครงสร้าง

**ปัญหา 2:** `docker compose up` ล้มเหลวเพราะ DB ยังไม่พร้อม  
**แก้ไข:** เพิ่ม healthcheck ใน postgres และ `depends_on: condition: service_healthy` ใน services อื่น และเพิ่ม retry loop ใน log-service

**ปัญหา 3:** Self-Signed Certificate ทำให้ browser แจ้งเตือน  
**แก้ไข:** ใช้ `--insecure` flag กับ curl สำหรับทดสอบ และ proceed ผ่าน browser warning

---

## 5. สิ่งที่ได้เรียนรู้จากงานนี้

- วิธีตั้งค่า HTTPS ด้วย Self-Signed Certificate บน Nginx และความสำคัญของ TLS hardening
- การออกแบบ Microservices ที่แต่ละ service มีหน้าที่ชัดเจนและสื่อสารกันผ่าน REST API
- การใช้ JWT สำหรับ stateless authentication และการส่งต่อ identity ระหว่าง services
- Lightweight Logging โดยใช้ REST API แทน log aggregation tool เช่น Loki/Grafana ช่วยลด complexity ของระบบ
- การใช้ Docker Compose จัดการ multi-service application พร้อม healthcheck

---

## 6. แนวทางที่ต้องการพัฒนาต่อใน Set 2

- แยก Database ของแต่ละ service ออกจากกัน (Database per Service pattern)
- เพิ่ม Refresh Token เพื่อให้ JWT มีความปลอดภัยมากขึ้น
- Deploy บน Railway หรือ cloud platform จริง
- เพิ่ม CI/CD pipeline สำหรับ automated testing
