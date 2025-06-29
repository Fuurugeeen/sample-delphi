#!/usr/bin/env pwsh
# Calculator Application Test Runner (PowerShell)

Write-Host "============================================" -ForegroundColor Green
Write-Host "Calculator Application Test Runner" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green

$TestExe = "Win32\Debug\CalculatorTests.exe"

Write-Host "Building tests..." -ForegroundColor Yellow

# Try to find Delphi compiler
$CompilerPaths = @(
    "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\dcc32.exe",
    "C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\dcc32.exe", 
    "C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\dcc32.exe",
    "C:\Program Files (x86)\Embarcadero\Studio\19.0\bin\dcc32.exe"
)

$Compiler = $null

# Check BDS environment variable first
if ($env:BDS) {
    $BdsCompiler = Join-Path $env:BDS "bin\dcc32.exe"
    if (Test-Path $BdsCompiler) {
        $Compiler = $BdsCompiler
    }
}

# If not found, try common paths
if (-not $Compiler) {
    foreach ($Path in $CompilerPaths) {
        if (Test-Path $Path) {
            $Compiler = $Path
            break
        }
    }
}

# Try PATH as last resort
if (-not $Compiler) {
    try {
        $null = Get-Command dcc32.exe -ErrorAction Stop
        $Compiler = "dcc32.exe"
    }
    catch {
        Write-Host "Error: Delphi compiler not found." -ForegroundColor Red
        Write-Host "Please ensure RAD Studio is installed or dcc32.exe is in PATH." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "Using compiler: $Compiler" -ForegroundColor Cyan

# Build the test project
try {
    & $Compiler "CalculatorTests.dpr"
    if ($LASTEXITCODE -ne 0) {
        throw "Compilation failed with exit code $LASTEXITCODE"
    }
}
catch {
    Write-Host "Error: Failed to build test program." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

if (-not (Test-Path $TestExe)) {
    Write-Host "Error: Test executable was not created." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Running tests..." -ForegroundColor Yellow
try {
    & ".\$TestExe" --format=console
}
catch {
    Write-Host "Error running tests: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "Tests completed" -ForegroundColor Green  
Write-Host "============================================" -ForegroundColor Green
Read-Host "Press Enter to exit"