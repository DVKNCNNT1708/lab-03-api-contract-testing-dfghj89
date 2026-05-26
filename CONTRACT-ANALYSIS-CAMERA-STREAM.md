# CONTRACT ANALYSIS - Camera Stream ↔ AI Vision

**Vị trí:** A2 (Product A - Camera Stream)  
**Ngày phân tích:** 26/05/2026  
**Contract mới:** Camera Stream ↔ AI Vision (OpenAPI 3.1.0)  
**So sánh với:** Quy trình IoT Ingestion (Team A2 hiện tại)

---

## 1. Tóm Tắt Contract Mới

### Thông Tin Cơ Bản
```
Title: Camera Stream ↔ AI Vision Contract
Version: 1.0.0
OpenAPI: 3.1.0
Port: http://localhost:4010 (mock)
Auth: Bearer JWT
```

### Endpoints
1. **GET /health** - Kiểm tra service sẵn sàng
2. **POST /detect** - Phân tích frame camera (→ 202 Accepted)
3. **GET /detections** - Danh sách detection (cursor pagination)
4. **GET /detections/recent** - Detection gần đây
5. **GET /detections/{detectionId}** - Chi tiết detection
6. **Webhook: detectionCompleted** - Callback khi detect xong

---

## 2. So Sánh với IoT Ingestion (Hiện Tại)

| Khía cạnh | IoT Ingestion | Camera Stream (Mới) |
|-----------|---------------|-------------------|
| **Endpoints** | 2 (POST /readings, GET /latest) | 5 (+ webhook) |
| **HTTP Methods** | POST, GET | POST, GET (+ webhook) |
| **Status Code** | 201 (Created) | **202 (Accepted)** ← Async |
| **Request Type** | Sensor data | **Frame URL** (async) |
| **Response** | Sync result | **Webhook callback** (async) |
| **Pagination** | Query parameter `limit` | **Cursor-based** |
| **Data Type** | Telemetry (số liệu) | **Detection results** (hình ảnh) |
| **Business Logic** | Lưu reading | **Analyze + Track** |

### Key Differences

#### 1. Status Code: 201 → 202
- **IoT (201 Created)**: Sync - server tạo xong trả result ngay
- **Camera (202 Accepted)**: Async - server chấp nhận request, process sau, gửi webhook

```
IoT Ingestion Flow:
POST /readings
  ↓ (wait)
Response 201 {reading_id, accepted}

Camera Stream Flow:
POST /detect
  ↓ (wait)
Response 202 {detectionId, status: PROCESSING}
  ↓ (later, async)
Webhook POST → detectionCompleted {detectionId, status: COMPLETED}
```

#### 2. Pagination: Query → Cursor
- **IoT**: `GET /readings/latest?limit=5&device_id=ESP32`
- **Camera**: `GET /detections?cursor=null&limit=20`

#### 3. Request Body: Telemetry → Detection
```
IoT Ingestion:
{
  device_id: "ESP32-LAB-A01",
  metric: "temperature",
  value: 31.5,
  unit: "celsius"
}

Camera Stream:
{
  cameraId: "CAM-01",
  frameUrl: "https://campus.local/frame.jpg",
  timestamp: "2026-05-10T08:00:00Z",
  requestId: "REQ-001",
  analysisType: "PERSON_DETECTION"
}
```

#### 4. Response: Simple → Complex
```
IoT Response (201):
{
  reading_id: "read-12345",
  device_id: "ESP32-LAB-A01",
  accepted: true
}

Camera Response (202 + Webhook):
Initial Response (202):
{
  detectionId: "uuid-xxx",
  status: "PROCESSING"
}

Later Webhook (200):
{
  detectionId: "uuid-xxx",
  detectionType: "PERSON",
  confidence: 0.98,
  boundingBox: {x, y, width, height},
  trackingId: "TRACK-001",
  status: "COMPLETED"
}
```

#### 5. Detection Tracking
- **IoT**: Không có tracking (mỗi reading độc lập)
- **Camera**: Có `trackingId` (track object qua nhiều frame)

```json
{
  "detectionId": "uuid-123",
  "trackingId": "TRACK-001",  // ← Track across frames
  "detectionType": "PERSON",
  "boundingBox": {
    "x": 150,
    "y": 100,
    "width": 200,
    "height": 300
  }
}
```

---

## 3. Impact Analysis - Áp Dụng cho Team A2 (Camera Stream)

### ✅ Khớp với Quy Trình Hiện Tại

| Yếu tố | Tương Thích |
|--------|-----------|
| 6 Test Folders | ✅ Vẫn áp dụng (Functional, Auth, Negative, Boundary, Consumer, Non-functional) |
| Collection Structure | ✅ Postman Collection vẫn dùng được |
| Mock Server | ✅ Prism từ OpenAPI vẫn work |
| Newman Tests | ✅ pm.test scripts vẫn dùng được |
| Environments | ✅ Mock + Local setup vẫn dùng |
| CI/CD Pipeline | ✅ GitHub Actions vẫn chạy |

### ⚠️ Thay Đổi Cần Lưu Ý

| Thay Đổi | Chi Tiết | Giải Pháp |
|---------|---------|----------|
| **Async Response** | 202 không phải 201, cần webhook | Test cả initial 202 + webhook response |
| **Webhook Testing** | POST /detect trả 202, after test webhook | Thêm webhook handler để nhận callback |
| **Cursor Pagination** | Không phải `limit` query mà `cursor` | Update GET tests để handle cursor |
| **BoundingBox** | Response chứa coordinates | Add assertions cho x, y, width, height |
| **TrackingId** | Track object qua frames | Validate trackingId consistency |
| **Status Enum** | PROCESSING, COMPLETED, FAILED | Test tất cả status transitions |

---

## 4. Test Strategy cho Camera Stream Contract

### Test Case Breakdown

#### 00_Health (1 test)
```
✓ GET /health → 200
```

#### 01_Functional (3 tests)
```
✓ POST /detect valid → 202 PROCESSING
✓ GET /detections → 200 items array
✓ GET /detections/{id} → 200 with boundingBox
```

#### 02_Auth (3 tests)
```
✓ Valid bearer token → accepted
✓ Missing token → 401 (skip on mock)
✓ Invalid token → 401 (skip on mock)
```

#### 03_Negative (2 tests)
```
✓ Missing cameraId → 400/422
✓ Invalid analysisType enum → 400/422
```

#### 04_Boundary_Reliability (3 tests)
```
✓ BoundingBox max values (999, 999) → accepted
✓ Confidence 0.0 and 1.0 (boundaries) → valid
✓ Limit max 100 → accepted, >100 → rejected
```

#### 05_Consumer_side_Smoke (1 test)
```
✓ Webhook callback from AI Vision mock → 200 success response
```

#### 06_Local_only_NonFunctional (1 test)
```
✓ Response time < 2000ms (async processing)
```

**Total: 14 tests** (vs 13 trong IoT)

---

## 5. Implementation Steps

### Step 1: Create New Collection
```bash
# Option A: Start from scratch
Postman → New → API

# Option B: Import OpenAPI
Postman → Import → Camera Stream openapi.yaml
```

### Step 2: Create Test Scripts

#### Functional Test - POST /detect (202 Async)
```javascript
pm.test("POST /detect returns 202 Accepted", function () {
  pm.expect(pm.response.code).to.equal(202);
});

pm.test("Response has detectionId (UUID format)", function () {
  const json = pm.response.json();
  pm.expect(json).to.have.property('detectionId');
  pm.expect(json.detectionId).to.match(/^[a-f0-9-]{36}$/);
});

pm.test("Initial status is PROCESSING", function () {
  const json = pm.response.json();
  pm.expect(json).to.have.property('status', 'PROCESSING');
});
```

#### Pagination Test - Cursor-based
```javascript
pm.test("GET /detections returns cursor pagination", function () {
  const json = pm.response.json();
  pm.expect(json).to.have.property('items');
  pm.expect(json).to.have.property('nextCursor');
  pm.expect(json).to.have.property('hasMore');
});
```

#### BoundingBox Test
```javascript
pm.test("DetectionResult has valid BoundingBox", function () {
  const json = pm.response.json();
  const bbox = json.boundingBox;
  pm.expect(bbox).to.have.all.keys('x', 'y', 'width', 'height');
  pm.expect(bbox.x).to.be.greaterThanOrEqual(0);
  pm.expect(bbox.width).to.be.greaterThanOrEqual(1);
  pm.expect(bbox.height).to.be.greaterThanOrEqual(1);
});
```

#### Webhook Test (Polling or Mock Listener)
```javascript
// Option 1: Polling for webhook callback
pm.test("Webhook callback received with COMPLETED status", function (done) {
  setTimeout(() => {
    pm.sendRequest({
      url: pm.environment.get('baseUrl') + '/detections/' + pm.globals.get('lastDetectionId'),
      method: 'GET',
      header: {
        'Authorization': 'Bearer ' + pm.environment.get('authToken')
      }
    }, function (err, response) {
      if (!err) {
        const json = response.json();
        pm.expect(json.status).to.be.oneOf(['PROCESSING', 'COMPLETED']);
        pm.globals.unset('lastDetectionId');
      }
      done();
    });
  }, 2000); // Wait 2 seconds for async processing
});
```

### Step 3: Environments
```json
Mock Environment:
{
  "baseUrl": "http://localhost:4010",
  "authToken": "lab-token",
  "analysisType": "PERSON_DETECTION"
}

Local Environment:
{
  "baseUrl": "http://localhost:8000",
  "authToken": "local-dev-token",
  "analysisType": "PERSON_DETECTION"
}
```

### Step 4: Run Tests
```bash
npm run test:mock   # On mock environment
npm run test:local  # On local service (when ready)
npm run test:html   # Generate HTML report
```

---

## 6. Key Assertions for Camera Stream

| Assertion | Why | Example |
|-----------|-----|---------|
| Status 202 on POST | Async pattern | `pm.expect(code).to.equal(202)` |
| UUID format | Valid detection ID | `/^[a-f0-9-]{36}$/` |
| BoundingBox presence | Visual output | `pm.expect(bbox).to.exist` |
| Confidence 0-1 | ML confidence score | `pm.expect(conf).to.be.within(0, 1)` |
| Tracking ID consistency | Frame tracking | `trackingId === prevTrackingId` |
| Status enum validation | Valid state | `['PROCESSING', 'COMPLETED', 'FAILED']` |
| Cursor pagination | Large result sets | `nextCursor !== null` |
| Webhook format | Event format | `{detectionId, status, ...}` |

---

## 7. Dependencies & Integration

### Làm việc với Các Nhóm Khác

**Camera Stream (A2) → AI Vision (A4) Provider**
- Contract: Định nghĩa sẵn trong `ai-vision.openapi.yaml`
- Consumer-side smoke test: Gọi `/detect` endpoint
- Handshake: Biên bản giữa team-camera & team-vision

**Camera Stream (A2) ← Core Business (A6) Consumer**
- Team Core sẽ gọi `/detect` endpoint
- Team Camera cần đảm bảo API chính xác theo contract
- Phối hợp qua consumer-provider handshake

### Mapping với Dependency Map (từ attachment)
```
Camera Stream (A2)
  → Provider: AI Vision (A4)
    → Loại: Lấy kết quả phân tích ảnh

Camera Stream (A2)
  ← Consumer: Core Business (A6)
    → Loại: Core gọi để trigger camera/analyze
```

---

## 8. Differences Summary Table

| Aspect | IoT Ingestion | Camera Stream | Change |
|--------|---------------|---------------|--------|
| Response Model | Sync (201) | Async (202 + Webhook) | **Major** |
| Pagination | Query param | Cursor-based | **Medium** |
| Data Shape | Telemetry | Visual Detection | **Major** |
| Business Flow | Store → Read | Analyze → Track | **Major** |
| Detection Type | None | PERSON/VEHICLE/UNKNOWN | **New** |
| Spatial Data | None | BoundingBox | **New** |
| Tracking | None | TrackingId | **New** |
| Processing | Immediate | Deferred | **Major** |

---

## 9. Checklist - Áp Dụng cho Team A2

- [ ] Cập nhật contract từ IoT → Camera Stream mới
- [ ] Tạo Postman Collection mới cho Camera Stream
- [ ] Update test scripts để handle async (202) pattern
- [ ] Thêm webhook listener/polling tests
- [ ] Update boundary tests cho bounding box
- [ ] Kiểm tra pagination cursor vs limit
- [ ] Tạo mock data cho camera frames
- [ ] Update test-case matrix với 14 tests
- [ ] Update reliability checklist
- [ ] Cập nhật consumer-provider handshake
- [ ] Run full test suite trên mock
- [ ] Push to git với commit message rõ
- [ ] Trigger GitHub Actions CI/CD
- [ ] Kiểm tra reports: XML + HTML

---

## 10. Next Steps

### For Team A2 (Camera Stream)
1. Review contract `ai-vision.openapi.yaml` (hiện tại)
2. Replace với contract mới (Camera Stream version)
3. Re-run toàn bộ quy trình Lab 03
4. Update documentation
5. Commit & push

### Cross-Team Coordination
1. Share contract với team-vision (provider)
2. Share contract với team-core (consumer)
3. Discuss webhook endpoint & data format
4. Agree on error handling & retries
5. Document handshake

---

**Lab 03 Camera Stream Contract - Ready for Implementation** ✓

