# Consumer–Provider Handshake

## Thông tin chung

- Lab: FIT4110 Lab 03
- Ngày: 2026-05-20
- Provider team: team-iot
- Consumer team: team-camera (hoặc team-core, team-analytics)
- Provider service: IoT Ingestion
- Consumer service: Camera (hoặc Core, Analytics)

## Contract

- Contract file: `contracts/iot-ingestion.openapi.yaml`
- Mock base URL: `http://localhost:4010`
- Auth method: Bearer Token
- Endpoint được test: 
  - POST `/readings` - gửi cảm biến từ IoT
  - GET `/readings/latest` - lấy dữ liệu cảm biến gần đây nhất

## Smoke test

### Request: Create Reading

```http
POST /readings
Authorization: Bearer lab-token
Content-Type: application/json
```

```json
{
  "device_id": "ESP32-LAB-A01",
  "metric": "temperature",
  "value": 31.5,
  "unit": "celsius",
  "timestamp": "2026-05-13T08:30:00+07:00"
}
```

### Expected response

```json
{
  "reading_id": "read-12345",
  "device_id": "ESP32-LAB-A01",
  "metric": "temperature",
  "value": 31.5,
  "unit": "celsius",
  "timestamp": "2026-05-13T08:30:00+07:00",
  "accepted": true
}
```

### Request: Get Latest Readings

```http
GET /readings/latest?device_id=ESP32-LAB-A01&limit=5
Authorization: Bearer lab-token
```

### Expected response

```json
{
  "items": [
    {
      "reading_id": "read-12345",
      "device_id": "ESP32-LAB-A01",
      "metric": "temperature",
      "value": 31.5,
      "unit": "celsius",
      "timestamp": "2026-05-13T08:30:00+07:00"
    }
  ]
}
```

## Kết quả

- [x] Consumer gọi mock thành công.
- [x] Consumer parse được field cần dùng.
- [x] Consumer hiểu lỗi 4xx/5xx provider trả về.
- [ ] Có Newman report hoặc screenshot.

## Ghi chú thay đổi hợp đồng

| Nội dung | Trước | Sau | Người đồng ý |
|---------|-------|-----|--------------|
| Temperature range | -40 to 100 | -40 to 80 | team-iot |
| Rate limit | No limit | 100 req/min | team-iot |
| Retry policy | No retry | 3x exponential | team-camera |

## Notes

- **Metric enum**: temperature, humidity, motion, smoke, light
- **Unit enum**: celsius, percent, boolean, lux, ppm
- **Error format**: ProblemDetails (RFC 7807) với fields: type, title, status, detail
- **Token format**: Bearer token được validate trên local service, mock sẽ skip auth
- **Timeout**: Service nên trả response trong 1000ms
- **Rate limit**: Mock không enforce, nhưng local service sẽ trả 429 nếu exceed
|---|---|---|---|
| | | | |

## Xác nhận

- Provider representative:
- Consumer representative:
