# Hướng dẫn Chạy Lab 03

## Yêu cầu tối thiểu

- ✅ OpenAPI contract (lint pass)
- ✅ Postman Collection (6 folders, không hardcode)
- ✅ Mock environment (`FIT4110_lab03_mock.postman_environment.json`)
- ✅ Local environment (`FIT4110_lab03_local.postman_environment.json`)
- ✅ Test cases: Functional, Auth, Negative, Boundary, Consumer-side
- ⏳ Newman reports (XML + HTML)

## Chạy Tests - Hướng dẫn từng bước

### Terminal 1: Chạy Mock Servers

```bash
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19

# Lint contracts trước
npm run lint:contracts

# Chạy mock IoT (giữ terminal này)
npm run mock:iot
```

Đợi cho đến khi thấy:
```
[PORT] Prism is listening on http://0.0.0.0:4010
```

### Terminal 2: Chạy Mock AI Vision (tuỳ chọn)

```bash
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run mock:vision
```

### Terminal 3: Chạy Newman Tests

```bash
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19

# Chạy tests
npm run test:mock

# Sinh HTML report
npm run test:html

# Kiểm tra reports
dir reports\
```

## Kết quả mong muốn

✓ Lint: `No results with a severity of 'error' found!`

✓ Newman: `Tests 13/13 passed (100%)`

✓ Reports: 
- `reports/newman-report-mock.xml`
- `reports/newman-report.html`

## Chạy trên Local Environment (sau)

Khi service local sẵn sàng, chạy:

```bash
npm run test:local
```

Hiện tại local service chưa sẵn, nên skip bước này.

## Troubleshooting

### Mock server không chạy
- Port 4010 có bị chiếm: `netstat -ano | findstr :4010`
- Kill process: `taskkill /PID <PID> /F`

### Newman tests fail
- Kiểm tra mock server chạy chưa
- Kiểm tra baseUrl = `http://localhost:4010` trong environment

### Cần chạy lại
```bash
# Kill all node processes
taskkill /F /IM node.exe

# Chạy lại từ đầu
npm run mock:iot
```

## Files

- Contract: `contracts/iot-ingestion.openapi.yaml`
- Collection: `postman/collections/FIT4110_lab03_iot_ingestion.postman_collection.json`
- Mock env: `postman/environments/FIT4110_lab03_mock.postman_environment.json`
- Local env: `postman/environments/FIT4110_lab03_local.postman_environment.json`
- Reports: `reports/`

## Checklist hoàn thành

- [x] Contract lint pass
- [x] Collection có 6 folders (Functional, Auth, Negative, Boundary, Consumer-side, Local-only)
- [x] No hardcode baseUrl/authToken
- [x] Mock environment setup
- [x] Local environment setup
- [x] Test cases: ≥13 tests
- [ ] Newman report XML/HTML
- [x] Test-case matrix
- [x] Reliability checklist
- [x] Consumer-provider handshake

