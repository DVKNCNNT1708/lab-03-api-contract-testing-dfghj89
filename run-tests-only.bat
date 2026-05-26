@echo off
setlocal enabledelayedexpansion

cd /d c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19

echo.
echo ========================================
echo Contract Linting
echo ========================================
npm run lint:contracts
if %ERRORLEVEL% neq 0 (
  echo Lint failed!
  exit /b 1
)

echo.
echo ========================================
echo Running Newman Tests (Mock Environment)
echo ========================================
echo Make sure mock server is running!
echo   npm run mock:iot
echo.
npm run test:mock

echo.
echo ========================================
echo Generating HTML Report
echo ========================================
npm run test:html

echo.
echo ========================================
echo Done!
echo Reports: reports/newman-report*.xml, reports/newman-report.html
echo ========================================

