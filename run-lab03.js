#!/usr/bin/env node

/**
 * FIT4110 Lab 03 - Complete Pipeline Runner
 * Usage: node run-lab03.js
 * 
 * Chạy tất cả bước: lint → mock servers → newman tests → html report
 */

const { spawn, spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const projectRoot = __dirname;
const reportsDir = path.join(projectRoot, 'reports');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  blue: '\x1b[34m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m',
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function header(title) {
  log('\n========================================', 'blue');
  log(title, 'blue');
  log('========================================\n', 'blue');
}

function error(message) {
  log(`✗ ${message}`, 'red');
  process.exit(1);
}

function success(message) {
  log(`✓ ${message}`, 'green');
}

// Step 1: Lint contracts
header('STEP 1: Linting OpenAPI Contracts');
log('Running spectral lint...', 'yellow');

const lintResult = spawnSync('npm', ['run', 'lint:contracts'], {
  cwd: projectRoot,
  stdio: 'inherit',
});

if (lintResult.status !== 0) {
  error('Contract lint failed!');
}
success('Contract lint passed!');

// Step 2: Start mock servers
header('STEP 2: Starting Mock Servers');

log('Starting IoT Ingestion mock (port 4010)...', 'cyan');
const mockIot = spawn('npm', ['run', 'mock:iot'], {
  cwd: projectRoot,
  stdio: 'inherit',
});

log('Starting AI Vision mock (port 4011)...', 'cyan');
const mockVision = spawn('npm', ['run', 'mock:vision'], {
  cwd: projectRoot,
  stdio: 'inherit',
});

log('Waiting 8 seconds for servers to start...', 'cyan');
// Wait for servers to start
setTimeout(runTests, 8000);

// Step 3: Run Newman tests
function runTests() {
  header('STEP 3: Running Newman Tests on Mock');
  
  log('Executing tests...', 'yellow');
  const testResult = spawnSync('npm', ['run', 'test:mock'], {
    cwd: projectRoot,
    stdio: 'inherit',
  });

  if (testResult.status !== 0) {
    mockIot.kill();
    mockVision.kill();
    error('Newman tests failed!');
  }
  success('Newman tests passed!');

  // Step 4: Generate HTML report
  header('STEP 4: Generating HTML Report');
  
  log('Generating htmlextra report...', 'yellow');
  const htmlResult = spawnSync('npm', ['run', 'test:html'], {
    cwd: projectRoot,
    stdio: 'inherit',
  });

  if (htmlResult.status !== 0) {
    mockIot.kill();
    mockVision.kill();
    error('HTML report generation failed!');
  }
  success('HTML report generated!');

  // Step 5: Cleanup
  header('STEP 5: Cleanup');
  log('Stopping mock servers...', 'yellow');
  mockIot.kill();
  mockVision.kill();
  success('Mock servers stopped!');

  // Summary
  header('✓ Pipeline completed successfully!');
  
  log('Reports generated:', 'cyan');
  if (fs.existsSync(reportsDir)) {
    const files = fs.readdirSync(reportsDir)
      .filter(f => f.includes('report'))
      .sort();
    files.forEach(file => {
      log(`  - ${file}`, 'white');
    });
  }

  log('\nView HTML report:', 'cyan');
  log('  reports/newman-report.html\n', 'white');
}

// Handle signals
process.on('SIGINT', () => {
  log('\n\nCaught interrupt signal. Cleaning up...', 'yellow');
  mockIot.kill();
  mockVision.kill();
  process.exit(1);
});
