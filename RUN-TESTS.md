# FIT4110 Lab 03 - Chạy Các Test

## 3 bước dễ nhất

### Terminal 1: Chạy Mock Servers

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run mock:iot
```

Đợi cho đến khi thấy: `Prism is listening on http://0.0.0.0:4010`

### Terminal 2: Chạy Tests

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run lint:contracts
npm run test:mock
npm run test:html
```

### Terminal 3 (tuỳ chọn): Mock AI Vision

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run mock:vision
```

---

## Hoặc chạy tự động (Node.js script)

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run run:lab03
```

Điều này sẽ:
1. Lint contracts
2. Start mock servers
3. Run tests
4. Generate HTML report
5. Clean up

---

## Kiểm tra kết quả

```cmd
dir reports\
```

Kết quả:
- `newman-report-mock.xml` - JUnit report
- `newman-report.html` - HTML report

Mở `reports/newman-report.html` trong browser để xem chi tiết.

---

## Nếu cần test trên Local Environment

Khi service local (localhost:8000) sẵn sàng:

```cmd
npm run test:local
```

Hiện tại: service local chưa sẵn, skip bước này.

