@echo off
cd /d c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19

echo ========================================
echo STEP 1: Lint OpenAPI Contracts
echo ========================================
call npm run lint:contracts
if %ERRORLEVEL% neq 0 (
  echo Contract lint failed!
  pause
  exit /b 1
)

echo.
echo ========================================
echo STEP 2: Start Prism Mock Server (IoT)
echo ========================================
start "Mock Server IoT" cmd /k "npm run mock:iot"
timeout /t 5

echo.
echo ========================================
echo STEP 3: Wait for mock server to be ready
echo ========================================
timeout /t 3

echo.
echo ========================================
echo STEP 4: Run Newman Tests on Mock
echo ========================================
call npm run test:mock
if %ERRORLEVEL% neq 0 (
  echo Newman tests failed!
  pause
  exit /b 1
)

echo.
echo ========================================
echo STEP 5: Generate HTML Report
echo ========================================
call npm run test:html
if %ERRORLEVEL% neq 0 (
  echo HTML report generation failed!
  pause
  exit /b 1
)

echo.
echo ========================================
echo All tests completed successfully!
echo ========================================
echo Reports available at: reports/
echo.
pause
