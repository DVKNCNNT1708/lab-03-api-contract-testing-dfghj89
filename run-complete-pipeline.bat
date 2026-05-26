@echo off
setlocal enabledelayedexpansion

cd /d c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19

echo.
echo ========================================
echo STEP 1: Lint OpenAPI Contracts
echo ========================================
call npm run lint:contracts
if %ERRORLEVEL% neq 0 (
  echo Lint failed!
  exit /b 1
)
echo Lint passed!

echo.
echo ========================================
echo STEP 2: Start Mock Servers
echo ========================================
echo Starting IoT Ingestion mock (port 4010)...
start "Mock IoT" cmd /k npm run mock:iot

echo Starting AI Vision mock (port 4011)...
start "Mock Vision" cmd /k npm run mock:vision

echo Waiting for servers to start...
timeout /t 5 /nobreak

echo.
echo ========================================
echo STEP 3: Run Newman Tests on Mock
echo ========================================
call npm run test:mock
if %ERRORLEVEL% neq 0 (
  echo Newman tests failed!
  exit /b 1
)

echo.
echo ========================================
echo STEP 4: Generate HTML Report
echo ========================================
call npm run test:html
if %ERRORLEVEL% neq 0 (
  echo HTML report generation failed!
  exit /b 1
)

echo.
echo ========================================
echo ✓ All tests completed successfully!
echo ========================================
echo.
echo Reports generated:
dir reports\*.xml
dir reports\*.html
echo.
echo Open this file to view report:
echo   reports\newman-report.html
echo.
echo To test on LOCAL environment, update FIT4110_lab03_local.postman_environment.json
echo and run: npm run test:local
echo.
pause
