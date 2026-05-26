# Hướng dẫn Chạy Mock Server và Newman Tests

## Các bước chi tiết

### **Bước 1: Kiểm tra & Lint Contracts**

Mở **Command Prompt (cmd.exe)**:

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run lint:contracts
```

**Kết quả mong muốn:**
```
✓ No results with a severity of 'error' found!
```

---

### **Bước 2: Chạy Mock Server IoT**

Mở **Command Prompt thứ 1** (để terminal này chạy):

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run mock:iot
```

**Chờ cho đến khi thấy:**
```
[4:47:54 PM] Prism is listening on http://0.0.0.0:4010
```

Terminal này **GIỮ NGUYÊN, KHÔNG ĐÓNG**.

---

### **Bước 3: Chạy Mock Server AI Vision (tuỳ chọn)**

Mở **Command Prompt thứ 2** (để terminal này chạy):

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run mock:vision
```

**Chờ cho đến khi thấy:**
```
[4:47:55 PM] Prism is listening on http://0.0.0.0:4011
```

Terminal này **GIỮ NGUYÊN, KHÔNG ĐÓNG**.

---

### **Bước 4: Chạy Newman Tests**

Mở **Command Prompt thứ 3** (terminal mới):

```cmd
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run test:mock
```

**Kết quả mong muốn:**
```
├─ Tests 13/13 passed (100%)
├─ Requests 13/13 passed (100%)
└─ Test Pass Rate 100%
```

Newman sẽ sinh report: `reports/newman-report-mock.xml`

---

### **Bước 5: Sinh HTML Report**

Cùng terminal thứ 3, chạy:

```cmd
npm run test:html
```

Sẽ sinh file: `reports/newman-report.html`

---

### **Bước 6: Kiểm tra Reports**

```cmd
dir reports\
```

**Kết quả mong muốn:**
```
newman-report-mock.xml
newman-report.html
```

---

## Khắc phục sự cố

### Mock server không chạy
- Kiểm tra port 4010 có bị chiếm không: `netstat -ano | findstr :4010`
- Nếu có process, kill nó: `taskkill /PID <PID> /F`
- Sau đó chạy lại `npm run mock:iot`

### Newman tests fail
- Kiểm tra mock server có running không (xem Terminal 1)
- Kiểm tra Postman environment có đúng không: `baseUrl=http://localhost:4010`
- Nếu auth fail, có thể do mock không enforce auth - đây là bình thường trên mock

### HTML report không generate
- Kiểm tra npm reporter plugin đã install: `npm install newman-reporter-htmlextra`
- Kiểm tra folder `reports/` tồn tại

---

## File Batch (tuỳ chọn)

Nếu muốn chạy lint + test (nhưng mock server phải chạy trước):

```cmd
c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19\run-tests-only.bat
```

---

## Tóm tắt lệnh từng bước

```cmd
# Terminal 1 - Mock IoT (GIỮ CHẠY)
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19 && npm run mock:iot

# Terminal 2 - Mock Vision (GIỮ CHẠY) - tuỳ chọn
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19 && npm run mock:vision

# Terminal 3 - Lint + Tests
cd c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19
npm run lint:contracts
npm run test:mock
npm run test:html

# Terminal 3 - Kiểm tra reports
dir reports\
```

