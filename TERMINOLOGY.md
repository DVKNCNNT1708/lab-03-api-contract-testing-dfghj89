# TERMINOLOGY - Danh Sách Thuật Ngữ Lab 03 (Hoàn Chỉnh)

## A. Thuật Ngữ API & OpenAPI

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **OpenAPI** | Specification mô tả REST API một cách chuẩn hóa | OpenAPI 3.1.0 |
| **Contract** | Hợp đồng API định nghĩa interface giữa provider & consumer | `iot-ingestion.openapi.yaml` |
| **Endpoint** | Một đường dẫn API cụ thể | `/readings`, `/health` |
| **Request** | Dữ liệu gửi từ client đến server | POST body với `device_id`, `metric` |
| **Response** | Dữ liệu server trả về cho client | JSON với `reading_id`, `accepted` |
| **Schema** | Định nghĩa cấu trúc dữ liệu (kiểu, field, constraints) | `HealthResponse`, `ReadingData` |
| **Parameter** | Giá trị truyền vào endpoint (query, path, header) | `limit=5`, `device_id=ESP32` |
| **Enum** | Tập hợp giá trị được phép | `metric: [temperature, humidity, motion]` |
| **Constraint** | Ràng buộc trên giá trị (min, max, pattern) | `minimum: -40, maximum: 80` |
| **ProblemDetails** | Standard format cho error response (RFC 7807) | `{status: 400, title: "Validation failed"}` |
| **Bearer Token** | Cách xác thực dùng token JWT | `Authorization: Bearer <token>` |
| **Status Code** | HTTP response code (2xx, 4xx, 5xx) | 200, 201, 400, 401, 500 |

---

## B. Thuật Ngữ Testing

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Test Case** | Một tình huống kiểm thử cụ thể | TC01: Health check, TC02: Create reading |
| **Happy Path** | Kịch bản thành công, đường đi chính | POST /readings với data hợp lệ → 201 |
| **Negative Test** | Kịch bản thất bại, input không hợp lệ | POST /readings thiếu `device_id` → 400 |
| **Boundary Test** | Kịch bản test giá trị biên | temperature = 80 (max) vs 81 (exceed) |
| **Auth Test** | Kịch bản kiểm thử xác thực | Missing token, invalid token |
| **Functional Test** | Kiểm thử chức năng chính | CRUD operations, business logic |
| **Consumer-side Test** | Test từ góc nhìn consumer sử dụng API | Camera Stream gọi AI Vision mock |
| **Smoke Test** | Test cơ bản để xác minh hệ thống hoạt động | Health check, basic CRUD |
| **Regression Test** | Test để đảm bảo thay đổi không làm hỏng cũ | Re-run all tests after update |
| **Assertion** | Kiểm tra xác thực kết quả | `pm.expect(status).to.equal(200)` |

---

## C. Thuật Ngữ Mock & Prism

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Mock Server** | Server giả lập API service theo OpenAPI contract | Prism running on port 4010 |
| **Prism** | Tool sinh mock server từ OpenAPI spec | `npm run mock:iot` |
| **Health Check** | Endpoint kiểm tra service sẵn sàng | GET /health → 200 |
| **Response Example** | Mẫu response định nghĩa trong contract | `status: ok, service: iot-ingestion` |
| **Mocking** | Quá trình tạo giả API service | Mock servers cho parallel development |
| **Provider** | Nhóm/service cung cấp API | IoT Ingestion (team-iot) |
| **Consumer** | Nhóm/service sử dụng API | Camera Stream, Analytics (team-camera, team-analytics) |

---

## D. Thuật Ngữ Newman & Postman

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Collection** | Tập hợp requests Postman được tổ chức theo folder | `FIT4110_lab03_iot_ingestion.postman_collection.json` |
| **Environment** | File chứa biến môi trường (baseUrl, token, etc.) | `FIT4110_lab03_mock.postman_environment.json` |
| **Request** | Một HTTP request (GET, POST, PUT, DELETE) | `POST /readings` |
| **Test Script** | Script JavaScript kiểm tra response | `pm.test("Status is 201", ...)` |
| **Pre-request Script** | Script chạy trước khi gửi request | Thiết lập trace ID |
| **Newman** | CLI tool chạy Postman collection | `npm run test:mock` |
| **Report** | Kết quả test được export | XML (JUnit), HTML, JSON |
| **Variable** | Giá trị động trong collection | `{{baseUrl}}`, `{{authToken}}` |
| **Hardcode** | Giá trị cứng trong code (không tốt) | URL cứng trong request thay vì dùng variable |

---

## E. Thuật Ngữ CI/CD & GitHub Actions

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **CI/CD** | Continuous Integration / Continuous Deployment | GitHub Actions workflow |
| **Workflow** | File định nghĩa automation trên GitHub Actions | `.github/workflows/newman.yml` |
| **Trigger** | Sự kiện khích hoạt workflow | Push, Pull Request, Manual |
| **Step** | Một công việc trong workflow | Install, Lint, Test, Upload |
| **Job** | Tập hợp steps thực thi tuần tự | "newman" job |
| **Artifact** | File được lưu từ workflow | Reports (XML, HTML) |
| **Action** | Reusable task trong GitHub Actions | `actions/checkout@v4`, `actions/upload-artifact@v4` |
| **Log** | Output từ workflow execution | Lint output, mock server logs, test results |

---

## F. Thuật Ngữ Linting & Validation

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Lint** | Kiểm tra code/config theo quy chuẩn | Spectral lint OpenAPI contracts |
| **Spectral** | Tool lint OpenAPI/Swagger specs | `npm run lint:contracts` |
| **Error** | Lỗi blocking (phải fix) | Missing required response |
| **Warning** | Cảnh báo (nên fix) | Missing contact in info object |
| **Rule** | Quy tắc lint | `info-contact`, `operation-success-response` |
| **Severity** | Mức độ của lỗi (error, warning, info, hint) | `--fail-severity error` |

---

## G. Thuật Ngữ JSON & Data Format

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **JSON** | JavaScript Object Notation - định dạng dữ liệu | `{"reading_id": "read-123", "value": 31.5}` |
| **JSON Schema** | Mô tả cấu trúc JSON file | Schema định nghĩa trong OpenAPI |
| **Payload** | Dữ liệu trong request/response body | POST body là payload |
| **Field** | Một thuộc tính trong JSON object | `device_id`, `metric`, `value` |
| **Type** | Kiểu dữ liệu (string, number, integer, boolean, array, object) | `type: string`, `type: integer` |
| **Format** | Định dạng cụ thể của type | `format: date-time`, `format: uuid` |
| **Required** | Field bắt buộc phải có | `required: ["device_id", "metric"]` |
| **Optional** | Field không bắt buộc | `timestamp` có thể bị bỏ qua |

---

## H. Thuật Ngữ Version Control & Git

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Repository** | Kho lưu trữ code trên GitHub | `lab-03-api-contract-testing-Potatoaim19` |
| **Commit** | Lưu thay đổi vào git với message | `git commit -m "Lab 03: Complete"` |
| **Push** | Đẩy commits lên remote repository | `git push` → GitHub |
| **Branch** | Nhánh phát triển | `main` branch |
| **Merge** | Kết hợp code từ branch khác | Pull Request merge |
| **Pull Request** | Đề xuất thay đổi trước khi merge | PR từ feature branch → main |

---

## I. Thuật Ngữ Service & Architecture

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Microservice** | Service độc lập nhỏ | IoT Ingestion, AI Vision, Core Business |
| **Integration** | Kết nối giữa các service | Camera Stream gọi AI Vision |
| **Synchronous** | Gọi đợi response ngay lập tức | REST API call |
| **Asynchronous** | Gọi không chờ response | Queue, Webhook, Event |
| **Webhook** | Callback khi event xảy ra | AI Vision gửi webhook khi detect xong |
| **Rate Limiting** | Giới hạn số request | Max 100 requests/minute |
| **Idempotency** | Gọi nhiều lần kết quả như nhau | Retry-safe operations |

---

## J. Thuật Ngữ Chất Lượng & SLA

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **SLA** | Service Level Agreement - cam kết về hiệu năng | Response time < 1000ms |
| **Latency** | Thời gian từ request đến response | 150ms, 500ms |
| **Throughput** | Số request xử lý được mỗi giây | 1000 req/sec |
| **Reliability** | Độ tin cậy, uptime | 99.9% availability |
| **Test Coverage** | % code được cover bởi tests | 13/13 tests = 100% |
| **Pass Rate** | % tests pass thành công | 13/13 = 100% pass |

---

## K. Thuật Ngữ Project Management

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **Deliverable** | Sản phẩm phải giao nộp | Reports, Collection, Documents |
| **Milestone** | Mục tiêu chính trong project | Lab 03 completion |
| **Requirement** | Yêu cầu phải thực hiện | 13 test cases, 6 folders |
| **Evidence** | Bằng chứng hoàn thành | Reports, Commits, Workflow logs |
| **Checklist** | Danh sách items kiểm tra | Reliability checklist, submission checklist |
| **Handshake** | Biên bản đồng ý giữa provider & consumer | Consumer-provider handshake |

---

## L. Thuật Ngữ Lỗi & Debugging

| Thuật ngữ | Ý nghĩa | Ví dụ |
|-----------|---------|--------|
| **400 Bad Request** | Request không hợp lệ (client error) | Missing required field |
| **401 Unauthorized** | Thiếu hoặc sai authentication | Missing token |
| **403 Forbidden** | Authenticated nhưng không có quyền | Invalid permissions |
| **404 Not Found** | Resource không tìm thấy | Non-existent reading ID |
| **422 Unprocessable Entity** | Validation failed | Invalid enum value |
| **500 Internal Server Error** | Server error | Exception trong logic |
| **Stacktrace** | Chi tiết error với call stack | Debug khi test fail |
| **Log** | Output để tracking execution | Mock server logs, test logs |

---

## M. Ký Hiệu & Abbreviation

| Ký hiệu | Ý nghĩa | Context |
|--------|--------|---------|
| **HTTP** | HyperText Transfer Protocol | Web communication protocol |
| **REST** | Representational State Transfer | API style |
| **CRUD** | Create, Read, Update, Delete | Basic operations |
| **UUID** | Universally Unique Identifier | ID format (8-4-4-4-12) |
| **JWT** | JSON Web Token | Authentication token |
| **SSL/TLS** | Secure Sockets Layer/Transport Layer Security | HTTPS encryption |
| **QA** | Quality Assurance | Testing & validation |
| **SUT** | System Under Test | IoT Ingestion API |
| **DUT** | Device Under Test | Mock server |
| **TPS** | Transactions Per Second | Throughput metric |

---

## N. Công Cụ & Technology Stack

| Công cụ | Tác dụng | Version |
|--------|---------|---------|
| **Node.js** | JavaScript runtime | 20.x LTS |
| **npm** | Package manager | Latest |
| **OpenAPI** | API specification | 3.1.0 |
| **Prism** | Mock server | 5.x |
| **Postman** | API testing client | Latest |
| **Newman** | CLI test runner | 6.x |
| **Spectral** | Linter for OpenAPI | 6.x |
| **GitHub Actions** | CI/CD platform | - |
| **Git** | Version control | Latest |

---

## O. Quy Ước & Best Practices

| Quy ước | Mô tả | Áp dụng |
|--------|-------|--------|
| **Naming** | Đặt tên rõ ràng, meaningful | `/readings`, `getHealth()` |
| **Versioning** | Version API khi breaking change | `v1`, `v2` |
| **Error Handling** | Response lỗi chuẩn với Problem Details | Consistent error format |
| **Documentation** | Mô tả rõ endpoint, request, response | OpenAPI descriptions |
| **Security** | Bearer token authentication | `Authorization: Bearer <token>` |
| **Pagination** | Cho danh sách lớn | Cursor-based hoặc offset-based |
| **Rate Limiting** | Giới hạn request | Status 429 Too Many Requests |
| **Idempotency** | Retry-safe operations | Same result on retry |

---

## Tham Chiếu Nhanh

### Folder Structure
```
postman/
├── collections/        # Test collection
└── environments/       # Mock + Local env

contracts/
├── iot-ingestion.openapi.yaml
└── ai-vision.openapi.yaml

reports/
├── newman-report-mock.xml    # JUnit
├── newman-report.html         # HTML
└── contract-lint-report.txt   # Lint

templates/
├── test-case-matrix.csv
├── consumer-provider-handshake.md
└── reliability_checklist.md
```

### Common Commands
```bash
npm run lint:contracts      # Lint OpenAPI
npm run mock:iot           # Start mock
npm run test:mock          # Run tests
npm run test:html          # HTML report
git push                   # Push to GitHub
```

### HTTP Methods
- `GET` - Retrieve data (safe, idempotent)
- `POST` - Create data (not idempotent)
- `PUT` - Replace data (idempotent)
- `PATCH` - Partial update
- `DELETE` - Remove data (idempotent)

### Status Code Ranges
- `2xx` - Success (200, 201, 202, 204)
- `4xx` - Client Error (400, 401, 403, 404, 422)
- `5xx` - Server Error (500, 502, 503)

