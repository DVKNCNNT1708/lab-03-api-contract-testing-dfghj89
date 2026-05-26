# FIT4110 Lab 03 - Danh Sách Thuật Ngữ

---

## A. API & Contract

### **API (Application Programming Interface)**
- Giao diện cho phép các ứng dụng giao tiếp với nhau
- Trong lab: RESTful API qua HTTP

### **OpenAPI / OpenAPI Specification**
- Tiêu chuẩn mô tả API theo định dạng chuẩn (YAML/JSON)
- Phiên bản: 3.1.0 (mới nhất)
- Tệp: `contracts/iot-ingestion.openapi.yaml`
- Gồm: paths, parameters, responses, schemas

### **Contract (Hợp đồng API)**
- Định nghĩa rõ interface của API: endpoint, request, response
- Binding giữa Provider (bên cung cấp) và Consumer (bên sử dụng)
- Giúp phát triển song song: Consumer code dùng mock, Provider code tự phát triển

### **Provider**
- Service/nhóm cung cấp API
- Trong lab: team-iot (cung cấp IoT Ingestion API)

### **Consumer**
- Service/nhóm sử dụng API của provider khác
- Ví dụ: team-camera gọi API của team-iot

### **Endpoint**
- URL + HTTP method của một operation
- Ví dụ: `POST /readings`, `GET /readings/latest`

### **Request / Response**
- **Request**: dữ liệu gửi từ client tới server (body, headers, parameters)
- **Response**: dữ liệu trả về từ server (status code, body)

### **Status Code**
- HTTP response code (200, 201, 400, 401, 404, 500, ...)
- `2xx`: Success (200 OK, 201 Created)
- `4xx`: Client error (400 Bad Request, 401 Unauthorized, 422 Unprocessable Entity)
- `5xx`: Server error (500 Internal Server Error)

### **Schema**
- Định nghĩa cấu trúc dữ liệu (fields, types, constraints)
- Sử dụng JSON Schema trong OpenAPI

### **ProblemDetails (RFC 7807)**
- Chuẩn định dạng error response
- Fields: `type`, `title`, `status`, `detail`
- Giúp client xử lý lỗi consistently

### **Enum**
- Tập hợp giá trị hợp lệ cho một field
- Ví dụ: `metric: [temperature, humidity, motion, smoke]`

### **Boundary / Edge Case**
- Giá trị ở cạnh giới hạn của một constraint
- Ví dụ: temperature max 80°C, limit max 100

---

## B. Testing & Mock

### **Mock Server**
- Server giả lập API, trả response theo contract
- Không có business logic thực, chỉ return examples
- Cho phép consumer test sớm khi provider chưa code xong
- Trong lab: dùng Prism

### **Prism**
- Tool sinh mock server từ OpenAPI specification
- `npm run mock:iot` → mock tại port 4010
- `npm run mock:vision` → mock tại port 4011

### **Health Check**
- Endpoint để kiểm tra service đang chạy hay không
- Thường: `GET /health` → `{"status": "ok"}`
- Dùng để verify mock server ready

### **Unit Test / Integration Test**
- **Unit test**: test một function/method riêng lẻ
- **Integration test**: test interaction giữa nhiều components
- Trong lab: integration test (Postman test gọi API)

### **Test Case**
- Một kịch bản test: input, expected output
- Trong lab: 13 test cases (TC01-TC13)

### **Test Scenario**
- Miêu tả kịch bản: "Create reading with valid data", "Missing required field", ...

### **Happy Path**
- Kịch bản test với input hợp lệ, expected flow normal
- Ví dụ: POST /readings với đúng format → 201 created

### **Negative Test**
- Test với input không hợp lệ: thiếu field, sai kiểu, ...
- Expected: error response (400/422)

### **Consumer-side Smoke Test**
- Test nhẹ của consumer gọi provider mock để verify basic integration
- Smoke test = test nhanh để phát hiện obvious bugs

### **Assertion**
- Khẳng định trong test: "response code should be 201"
- Dùng `pm.test()` hoặc `pm.expect()` trong Postman

---

## C. Tools & Frameworks

### **Postman**
- Tool API testing & collection management (GUI)
- Import OpenAPI → sinh collection
- Chạy request, viết test script, tạo environment

### **Postman Collection**
- File JSON chứa organized requests & tests
- Cấu trúc: folders, requests, scripts
- File: `FIT4110_lab03_iot_ingestion.postman_collection.json`

### **Postman Environment**
- File JSON chứa variables (baseUrl, authToken, ...)
- Dùng `{{variable}}` trong collection để reuse
- 2 environments: mock, local

### **Newman**
- CLI tool chạy Postman collection
- `npm run test:mock` → chạy collection với mock environment
- Output: XML (JUnit), HTML, CLI log

### **Spectral**
- Linting tool kiểm tra OpenAPI compliance
- `npm run lint:contracts` → verify contract
- Warnings: info-contact, schema-properties, ...

### **GitHub Actions**
- CI/CD automation trên GitHub
- File: `.github/workflows/newman.yml`
- Auto-run: mỗi push hoặc pull request

### **Git / GitHub**
- Version control & repository hosting
- Commit: lưu changes với message
- Push: đẩy commits lên remote repository

---

## D. Architecture & Patterns

### **REST / RESTful API**
- Representational State Transfer
- Resource-based architecture: `/readings` (resource), `/health` (resource)
- HTTP methods: GET (read), POST (create), PUT (update), DELETE (delete)

### **Bearer Token / Authentication**
- Token-based auth: `Authorization: Bearer <token>`
- Trong lab: mock skip auth, local validate auth

### **Request Body / Payload**
- JSON data gửi trong request body
- Ví dụ: `{ "device_id": "ESP32", "metric": "temperature", ... }`

### **Query Parameter / URL Parameter**
- Parameter trong URL: `GET /readings/latest?device_id=ESP32&limit=5`
- `?` = start query params, `&` = separator

### **Response Code / HTTP Status**
- Xem mục Status Code ở trên

### **Latency / Response Time**
- Thời gian từ gửi request đến nhận response
- Ví dụ: "Response time < 1000ms"

### **Rate Limiting**
- Giới hạn số request per minute/hour
- Response `429 Too Many Requests` khi exceed

### **Idempotency**
- Operation an toàn chạy nhiều lần, kết quả như nhau
- Ví dụ: POST reading hai lần → có 2 records (không idempotent)

---

## E. Data Types & Validation

### **String / Number / Boolean**
- Basic data types trong JSON

### **Array / Object**
- **Array**: `[1, 2, 3]` hoặc `[{...}, {...}]`
- **Object**: `{"key": "value", ...}`

### **Minimum / Maximum**
- Constraint trên số: `minimum: 0`, `maximum: 100`
- Ví dụ: limit parameter (min 1, max 100)

### **Required Field**
- Field bắt buộc có trong request
- Ví dụ: `device_id` là required

### **Optional Field**
- Field không bắt buộc, có thể omit
- Ví dụ: `description` có thể không có

### **Pattern / Regular Expression**
- Constraint trên string format
- Ví dụ: email, UUID, date-time format

### **Validation Error**
- Lỗi khi dữ liệu không match schema
- HTTP 400 (Bad Request) hoặc 422 (Unprocessable Entity)

---

## F. Testing Categories (6 Folders)

### **Functional**
- Test happy path: input valid → expected success response
- Folder: `01_Functional`

### **Auth / Authorization**
- Test authentication & authorization
- Folder: `02_Auth`
- Valid token, missing token, invalid token

### **Negative / Validation**
- Test input không hợp lệ: missing field, wrong type, enum violation
- Folder: `03_Negative`
- Expected: error response

### **Boundary / Reliability**
- Test edge cases & limits: min/max values, boundary conditions
- Folder: `04_Boundary_Reliability`
- Ví dụ: max temperature, max limit

### **Consumer-side Smoke**
- Consumer verify có thể call provider mock
- Folder: `05_Consumer_side_Smoke`
- Nhẹ, nhanh, không chi tiết

### **Non-functional**
- Performance, latency, SLA
- Folder: `06_Local_only_NonFunctional`
- Chỉ chạy trên local service (mock không đủ proof)

---

## G. Reports & Artifacts

### **JUnit Report (XML)**
- Standard format: `reports/newman-report-mock.xml`
- Dùng cho CI/CD integration
- Fields: testsuites, testcase, failures, skipped

### **HTML Report**
- Interactive report: `reports/newman-report.html`
- Dễ đọc, hiển thị test details, timing
- Newman reporter: `htmlextra`

### **Lint Report**
- Text report từ Spectral: `reports/contract-lint-report.txt`
- List errors, warnings, checks passed

### **Artifact**
- Output file từ GitHub Actions
- Dùng để download reports sau workflow run

---

## H. Deployment & Environment

### **Mock Environment**
- Postman env cho mock server (port 4010)
- `baseUrl: http://localhost:4010`

### **Local Environment**
- Postman env cho local service (port 8000)
- `baseUrl: http://localhost:8000`
- Chạy sau khi service local sẵn sàng

### **Production Environment**
- Real service deployment (không trong lab này)
- `baseUrl: https://api.example.com`

### **Port**
- Network endpoint: 4010 (mock IoT), 4011 (mock Vision), 8000 (local)

### **localhost / 127.0.0.1**
- Local machine (development)
- `http://localhost:4010` = `http://127.0.0.1:4010`

---

## I. Documentation

### **Test-case Matrix**
- CSV file: `templates/test-case-matrix.csv`
- Danh sách: ID, endpoint, method, scenario, input, expected, type

### **Reliability Checklist**
- Markdown: `templates/reliability_checklist.md`
- Checklist: Functional, Auth, Negative, Boundary, Reliability, Evidence

### **Consumer-Provider Handshake**
- Markdown: `templates/consumer-provider-handshake.md`
- Biên bản: khi consumer integrate với provider mock
- Info: contract, smoke test, kết quả, change log

---

## J. CI/CD & Version Control

### **CI (Continuous Integration)**
- Tự động chạy tests mỗi commit
- Detect bugs early

### **CD (Continuous Deployment)**
- Tự động deploy khi tests pass
- Trong lab: chỉ có CI (chưa deploy)

### **GitHub Actions**
- GitHub's CI/CD automation
- Trigger: push, pull request
- Steps: checkout, install, lint, test, upload artifacts

### **Workflow**
- Tệp config CI/CD: `.github/workflows/newman.yml`
- Define jobs, steps, actions

### **Commit**
- Lưu changes lại git với message
- `git commit -m "message"`

### **Push**
- Đẩy commits lên remote repository (GitHub)
- `git push`

### **Branch**
- Version của code: main, develop, feature-x
- Trong lab: main branch

---

## K. Khác

### **Service / Microservice**
- Ứng dụng độc lập: team-iot, team-camera, team-analytics, ...
- Giao tiếp qua API

### **Telemetry / Sensor Reading**
- Dữ liệu từ sensor: temperature, humidity, motion, ...
- `POST /readings` → gửi telemetry

### **Device ID**
- Identifier của thiết bị: "ESP32-LAB-A01"
- Dùng để track sensor nào gửi data

### **Metric**
- Loại đo: temperature, humidity, motion, smoke, light
- Enum: `[temperature, humidity, motion, smoke]`

### **Timestamp**
- Thời gian event xảy ra: "2026-05-13T08:30:00+07:00" (ISO 8601)

### **Trace ID / Correlation ID**
- Unique ID để track request flow qua các service
- Giúp debugging, logging

---

## Tóm Tắt Bảng Chữ Cái

| Mục | Thuật ngữ |
|-----|-----------|
| A | API, OpenAPI, Contract, Provider, Consumer, ... |
| B | Mock, Prism, Health Check, Test Case, ... |
| C | Postman, Newman, Spectral, GitHub Actions, ... |
| D | REST, Bearer Token, Query Parameter, ... |
| E | String, Array, Required, Validation, ... |
| F | Functional, Auth, Negative, Boundary, ... |
| G | JUnit, HTML Report, Artifact, ... |
| H | Mock Env, Local Env, Port, localhost, ... |
| I | Test-case Matrix, Checklist, Handshake, ... |
| J | CI, CD, GitHub Actions, Commit, Push, ... |
| K | Service, Telemetry, Device ID, Metric, ... |

---

**Tổng cộng: 100+ thuật ngữ kỹ thuật được giải thích**

Sử dụng danh sách này để:
- 📖 Tham khảo khi đọc báo cáo
- 📝 Học các concept kỹ thuật
- 🎓 Chuẩn bị cho thuyết trình/phòng vấn

