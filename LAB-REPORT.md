# FIT4110 Lab 03 - Báo Cáo Hoàn Thành

**Ngày hoàn thành:** 26/05/2026  
**Service:** IoT Ingestion API (team-iot)  
**Repository:** https://github.com/DVKNCNNT1708/lab-03-api-contract-testing-Potatoaim19

---

## 1. Tổng Quan Dự Án

**Mục tiêu:** Triển khai API contract testing với Postman, Mock Server (Prism), và Newman, đảm bảo API tuân thủ OpenAPI specification trước khi triển khai service thực.

**Tại sao cần:** Trong hệ thống nhiều service, các nhóm khác nhau không hoàn thiện đồng thời. Mock server cho phép consumer test sớm mà không chờ provider hoàn tất.

---

## 2. Các Thành Phần Chính

### A. OpenAPI Contract (contracts/)

```
contracts/
├── iot-ingestion.openapi.yaml      ✓ Lint pass
└── ai-vision.openapi.yaml          ✓ Lint pass (for consumer mock)
```

**Nội dung:**
- 2 endpoints chính: POST `/readings`, GET `/readings/latest`
- Response schema chuẩn `ProblemDetails` (RFC 7807)
- Error handling: 400/422 cho validation, 401/403 cho auth
- Constraints: temperature range (-40 to 80°C), limit max 100

**Linting:** Spectral lint pass - contact object đã thêm

---

### B. Postman Collection (postman/)

```
FIT4110_lab03_iot_ingestion.postman_collection.json
```

**6 Folders (cấu trúc yêu cầu):**

1. **00_Health** (1 test)
   - GET /health → status = 200

2. **01_Functional** (2 tests)
   - POST /readings → 201 + response fields
   - GET /readings/latest → 200 + items array

3. **02_Auth** (3 tests)
   - Valid token → accepted
   - Missing token → skip on mock, 401/403 on local
   - Invalid token → skip on mock, 401/403 on local

4. **03_Negative** (2 tests)
   - Missing required field → 400/422
   - Wrong enum value → 400/422

5. **04_Boundary_Reliability** (3 tests)
   - Temperature at 80°C (max) → accepted
   - Temperature at 81°C (exceed) → rejected
   - Limit above 100 → rejected

6. **05_Consumer_side_Smoke** (1 test)
   - POST /detect → call AI Vision mock (port 4011)

7. **06_Local_only_NonFunctional** (1 test)
   - Response time < 1000ms (skip on mock)

**Total: 13 tests**

**Đặc điểm:**
- ✅ Không hardcode `baseUrl`, `authToken`
- ✅ Dùng variables từ Postman Environment
- ✅ Tests có logic conditional (skip trên mock)

---

### C. Environments (postman/environments/)

**Mock Environment:** `FIT4110_lab03_mock.postman_environment.json`
```json
{
  "baseUrl": "http://localhost:4010",
  "authToken": "lab-token",
  "aiVisionMockUrl": "http://localhost:4011"
}
```

**Local Environment:** `FIT4110_lab03_local.postman_environment.json`
```json
{
  "baseUrl": "http://localhost:8000",
  "authToken": "local-dev-token",
  "aiVisionMockUrl": "http://localhost:4011"
}
```

---

### D. Mock Servers

**IoT Ingestion Mock (Port 4010)**
```bash
npm run mock:iot
# → Prism mock server tại http://localhost:4010
# → Response theo OpenAPI examples
```

**AI Vision Mock (Port 4011)** - cho consumer-side test
```bash
npm run mock:vision
# → Prism mock server tại http://localhost:4011
```

**Tính chất mock:**
- ✓ Trả response theo contract
- ✓ Mô phỏng status code
- ✗ Không validate auth thực (skip test trên mock)
- ✗ Không xử lý logic business

---

### E. Newman Tests & Reports

**Chạy tests:**
```bash
npm run test:mock   # → newman-report-mock.xml
npm run test:html   # → newman-report.html
```

**Reports generated:**

1. **XML Report** (JUnit format)
   - `reports/newman-report-mock.xml`
   - 13 tests, 13 passed, 0 failed (100%)

2. **HTML Report** (Interactive)
   - `reports/newman-report.html`
   - Detailed test breakdown, timing, assertions

3. **Lint Report** (Text)
   - `reports/contract-lint-report.txt`
   - Contract compliance checklist

---

### F. Documentation (templates/ + checklists/)

| File | Nội dung |
|------|---------|
| `test-case-matrix.csv` | 13 test cases mapped: endpoint, input, expected, type |
| `reliability_checklist.md` | Checklist 6 categories: Functional, Auth, Negative, Boundary, Reliability, Evidence |
| `consumer-provider-handshake.md` | Biên bản: provider info, smoke test, handshake notes |

---

## 3. Quy Trình Triển Khai

### Bước 1: Linting Contract (5 phút)
```bash
npm run lint:contracts
# Kiểm tra: schema, error responses, enums, contact info
# Result: PASS ✓
```

### Bước 2: Setup Mock Servers (3 phút)
```bash
# Terminal 1
npm run mock:iot

# Terminal 2 (optional)
npm run mock:vision

# Verify: curl http://localhost:4010/health → 200
```

### Bước 3: Import & Verify Collection (10 phút)
- Postman: Import JSON collection
- Kiểm tra: 6 folders, 13 tests, no hardcode variables
- Environment: Load mock environment

### Bước 4: Run Tests Manually (5 phút)
```bash
npm run test:mock
# 13 passing tests
```

### Bước 5: Generate Reports (2 phút)
```bash
npm run test:html
# XML + HTML reports sinh ra
```

### Bước 6: Document & Submit (10 phút)
```bash
git add <files>
git commit -m "Lab 03: Complete submission"
git push
```

**Total time: ~35 phút**

---

## 4. Test Coverage & Results

### Test Breakdown

| Category | Tests | Status |
|----------|-------|--------|
| Functional | 3 | ✓ Pass |
| Auth | 3 | ✓ Pass (skip on mock) |
| Negative | 2 | ✓ Pass |
| Boundary | 3 | ✓ Pass |
| Consumer-side | 1 | ✓ Pass |
| Non-functional | 1 | ✓ Pass (skip on mock) |
| **Total** | **13** | **✓ 100%** |

### Assertions per Test

- Status code verification (2xx, 4xx)
- Response body schema check
- Field presence validation
- Type checking (string, number, array)
- Enum value validation
- Boundary value validation

---

## 5. GitHub Actions CI/CD Pipeline

**Workflow:** `.github/workflows/newman.yml`

**Trigger:** Auto-run on push/PR to main branch

**Steps:**
1. Checkout code
2. Setup Node.js 20 + npm cache
3. npm install
4. **Lint contracts** → Pass/Fail
5. **Start mock servers** → Health check retry
6. **Run Newman tests** → 13 tests
7. **Upload reports** → Artifacts
8. Debugging logs on failure

**Status:** ✅ Configured and working

---

## 6. Yêu Cầu README - Hoàn Thành Checklist

### Mục 2: Mục tiêu sau buổi lab

| Yêu cầu | Hoàn thành |
|---------|-----------|
| Import OpenAPI vào Postman | ✅ |
| Collection cấu trúc rõ (6 folders) | ✅ |
| Mock Server chạy từ contract | ✅ |
| Test script `pm.test` | ✅ (13 tests) |
| Status code, body, schema, auth, negative, boundary | ✅ |
| Environment mock & local | ✅ |
| Không hardcode URL/token | ✅ |
| Newman run & export report | ✅ |
| Consumer-side smoke test | ✅ |
| Contract lint & Newman trong CI | ✅ |

### Mục 15: Sản phẩm cần nộp

| File | Trạng thái |
|------|-----------|
| `contracts/iot-ingestion.openapi.yaml` | ✅ Pushed |
| `postman/collections/*.postman_collection.json` | ✅ Pushed |
| `postman/environments/*_mock.postman_environment.json` | ✅ Pushed |
| `postman/environments/*_local.postman_environment.json` | ✅ Pushed |
| `reports/newman-report.xml` | ✅ Pushed |
| `reports/newman-report.html` | ✅ Pushed |
| `reports/contract-lint-report.txt` | ✅ Pushed |
| `checklists/reliability_checklist.md` | ✅ Pushed |
| `templates/test-case-matrix.csv` | ✅ Pushed |
| `templates/consumer-provider-handshake.md` | ✅ Pushed |

### Mục 16: Điều kiện hoàn thành

- [x] Contract lint pass hoặc giải thích warning
- [x] Collection chạy được trên mock
- [x] Collection không hardcode URL/token
- [x] Có test: happy path, auth, negative, boundary
- [x] Consumer-side smoke test ≥1
- [x] Newman report XML/HTML
- [x] Test-case matrix
- [x] Reliability checklist
- [x] Consumer-provider handshake

---

## 7. Commits & Push History

```
3169e94 - Use npm install with legacy-peer-deps flag
24cdde5 - Add package-lock.json for CI/CD consistency
4b92439 - Lab 03: Contract testing complete
4690d1f - Add GitHub Actions CI/CD documentation
78c0173 - Fix GitHub Actions workflow - Add health checks
```

**Total: 5 commits đã push**

---

## 8. Kết Quả & Bằng Chứng

### Evidence 1: Newman Reports
- `reports/newman-report-mock.xml` ← JUnit format, CI/CD ready
- `reports/newman-report.html` ← Interactive HTML report

### Evidence 2: GitHub Actions Log
- Workflow runs automatically on every push
- All steps pass: lint → mock → tests → artifacts

### Evidence 3: Git Commit History
- Organized commits with clear messages
- All submission files tracked in git

---

## 9. Học Được Từ Lab

### Concepts

1. **API Contract-First Development**
   - Contract định nghĩa interface trước code
   - Mock server cho phép parallel development
   - Test chứng minh API tuân thủ contract

2. **Mock Server Strategy**
   - Phân biệt mock vs real service
   - Mock test early, real test late
   - Consumer-side smoke test để xác minh integration

3. **Test Structure (6 folders)**
   - Functional: happy path
   - Auth: security basics
   - Negative: input validation
   - Boundary: edge cases
   - Consumer-side: dependency check
   - Non-functional: performance (local only)

4. **CI/CD Evidence**
   - Automated tests mỗi lần push
   - Reproducible: any developer chạy lại được
   - Artifacts: XML/HTML reports

### Tools & Technologies

- **OpenAPI 3.1.0** - Contract specification
- **Prism** - Mock server from OpenAPI
- **Postman** - API testing & collection management
- **Newman** - CLI test runner
- **Spectral** - Contract linting
- **GitHub Actions** - CI/CD automation

---

## 10. Kế Tiếp (Local Service)

Khi team triển khai service local (localhost:8000):

1. Update `FIT4110_lab03_local.postman_environment.json`
2. Chạy `npm run test:local`
3. Auth tests sẽ unblock (real validation)
4. Performance tests chạy với latency thực
5. Adjust test assertions nếu behavior khác

---

## Tóm Lược

| Yếu tố | Chi tiết |
|--------|----------|
| **Service** | IoT Ingestion API |
| **Contract** | OpenAPI 3.1.0 (2 endpoints) |
| **Tests** | 13 test cases (100% pass) |
| **Mock Servers** | 2 (IoT + Vision) |
| **Documentation** | 3 files (matrix, checklist, handshake) |
| **Reports** | XML + HTML + Lint |
| **CI/CD** | GitHub Actions workflow |
| **Commits** | 5 organized commits |
| **Status** | ✅ Complete & Submitted |

---

**Lab 03 hoàn thành thành công!** 🎉

