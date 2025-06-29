@echo off
chcp 65001
echo ============================================
echo Calculator Application Test Runner
echo ============================================

set TEST_EXE=Win32\Debug\CalculatorTests.exe

echo Building tests...

rem Try common Delphi installation paths
if exist "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\dcc32.exe" (
    set COMPILER="C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\dcc32.exe"
    goto compile
)

if exist "C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\dcc32.exe" (
    set COMPILER="C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\dcc32.exe"
    goto compile
)

if exist "C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\dcc32.exe" (
    set COMPILER="C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\dcc32.exe"
    goto compile
)

if defined BDS (
    if exist "%BDS%\bin\dcc32.exe" (
        set COMPILER="%BDS%\bin\dcc32.exe"
        goto compile
    )
)

echo Error: Delphi compiler not found.
echo Please ensure RAD Studio is installed or set BDS environment variable.
echo Trying to find dcc32.exe in PATH...
where dcc32.exe >nul 2>&1
if %errorlevel% equ 0 (
    set COMPILER=dcc32.exe
    goto compile
) else (
    echo dcc32.exe not found in PATH either.
    pause
    exit /b 1
)

:compile
echo Using compiler: %COMPILER%
%COMPILER% CalculatorTests.dpr
if %errorlevel% neq 0 (
    echo Error: Failed to build test program.
    pause
    exit /b 1
)

if not exist "%TEST_EXE%" (
    echo Error: Test executable was not created.
    pause
    exit /b 1
)

echo Running tests...
"%TEST_EXE%" --format=console

echo.
echo ============================================
echo Tests completed
echo ============================================
pause