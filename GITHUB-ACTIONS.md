# GitHub Actions CI/CD Evidence

## Workflow Status

Workflow file: [.github/workflows/newman.yml](.github/workflows/newman.yml)

### How to Check Workflow Results

1. **Go to GitHub Repository**
   - https://github.com/DVKNCNNT1708/lab-03-api-contract-testing-Potatoaim19

2. **Navigate to Actions Tab**
   - Click "Actions" in the navigation bar
   - Look for "Newman Contract Tests" workflow

3. **View Latest Run**
   - Click on the latest run (should be at top)
   - Check job status for "newman"

4. **Download Artifacts**
   - Click on the workflow run
   - Scroll down to "Artifacts" section
   - Download "newman-reports" (contains XML + HTML)

---

## Workflow Steps

The workflow runs automatically on every push to `main` branch:

```
1. Checkout code
2. Setup Node.js 20 + npm cache
3. Install dependencies (npm ci)
4. Lint OpenAPI contracts
5. Start Prism mock servers (IoT + Vision)
6. Wait for health checks
7. Verify test files
8. Run Newman tests
9. Upload reports (if always)
```

---

## Expected Output

**Success:**
```
✓ Lint: No results with a severity of 'error' found!
✓ Mock servers: Started and healthy
✓ Newman: Tests passed
✓ Artifacts: Uploaded
```

**Failure Debugging:**
- Check "Show Prism logs on failure" step
- Review process list to see if mock servers are running
- Check network connections on ports 4010/4011

---

## Key Features

- ✅ Contract lint (Spectral)
- ✅ Prism mock servers auto-start
- ✅ Health check retry (no flaky failures)
- ✅ File verification before tests
- ✅ Detailed logging for debugging
- ✅ Report artifacts upload
- ✅ npm cache for faster builds

---

## Triggering Workflow

Workflow triggers automatically on:
- ✓ Push to `main` branch
- ✓ Pull request to `main` branch

Manual run (if needed):
- Go to "Actions" tab → "Newman Contract Tests" → "Run workflow"

---

## Generated Reports

After successful workflow run:

1. **JUnit XML Report**
   - Path: `reports/newman-report-mock.xml`
   - Format: Standard JUnit format for CI/CD integration

2. **HTML Report**
   - Path: `reports/newman-report.html`
   - Format: Interactive HTML with test details

3. **Lint Report**
   - Path: `reports/contract-lint-report.txt`
   - Format: Human-readable lint results

---

## Common Issues

| Issue | Fix |
|-------|-----|
| Mock server not starting | Check logs in workflow output |
| Health check timeout | Increase wait time in workflow |
| Newman tests fail | Check collection file path |
| Artifacts not uploaded | Ensure reports/ directory exists |

