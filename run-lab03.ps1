# Lab 03 Pipeline Runner
# Chạy từ cmd: powershell -NoProfile -ExecutionPolicy Bypass -File run-lab03.ps1

$projectPath = "c:\Users\lengo\lab-03-api-contract-testing-Potatoaim19"
Set-Location $projectPath

Write-Host "========================================" -ForegroundColor Blue
Write-Host "FIT4110 Lab 03 - Contract Testing Pipeline" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Step 1: Lint Contracts
Write-Host "STEP 1: Linting OpenAPI Contracts..." -ForegroundColor Yellow
npm run lint:contracts
if ($LASTEXITCODE -ne 0) {
    Write-Host "Lint failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Lint passed!" -ForegroundColor Green
Write-Host ""

# Step 2: Start Mock Servers
Write-Host "STEP 2: Starting Mock Servers..." -ForegroundColor Yellow
Write-Host "Starting IoT Ingestion mock (port 4010)..." -ForegroundColor Cyan
$iotJob = Start-Job -ScriptBlock { cd $using:projectPath; npm run mock:iot }

Write-Host "Starting AI Vision mock (port 4011)..." -ForegroundColor Cyan
$visionJob = Start-Job -ScriptBlock { cd $using:projectPath; npm run mock:vision }

Write-Host "Waiting 5 seconds for servers to start..." -ForegroundColor Cyan
Start-Sleep -Seconds 5
Write-Host ""

# Step 3: Run Newman Tests
Write-Host "STEP 3: Running Newman Tests on Mock..." -ForegroundColor Yellow
npm run test:mock
if ($LASTEXITCODE -ne 0) {
    Write-Host "Newman tests failed!" -ForegroundColor Red
    Stop-Job -Job $iotJob, $visionJob
    exit 1
}
Write-Host "✓ Tests passed!" -ForegroundColor Green
Write-Host ""

# Step 4: Generate HTML Report
Write-Host "STEP 4: Generating HTML Report..." -ForegroundColor Yellow
npm run test:html
if ($LASTEXITCODE -ne 0) {
    Write-Host "HTML report generation failed!" -ForegroundColor Red
    Stop-Job -Job $iotJob, $visionJob
    exit 1
}
Write-Host "✓ HTML report generated!" -ForegroundColor Green
Write-Host ""

# Step 5: Cleanup
Write-Host "STEP 5: Cleaning up..." -ForegroundColor Yellow
Stop-Job -Job $iotJob, $visionJob
Write-Host "✓ Mock servers stopped!" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Pipeline completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Reports generated:" -ForegroundColor Cyan
Get-ChildItem -Path "$projectPath\reports\*report*" | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor White
}
Write-Host ""
Write-Host "View HTML report:" -ForegroundColor Cyan
Write-Host "  reports\newman-report.html" -ForegroundColor White
Write-Host ""
