@echo off
echo ============================================
echo Opening Calculator Test Project in Delphi
echo ============================================

rem Try to find RAD Studio executable
set RAD_STUDIO_EXE=

if exist "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\bds.exe" (
    set RAD_STUDIO_EXE="C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\bds.exe"
    goto open
)

if exist "C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\bds.exe" (
    set RAD_STUDIO_EXE="C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\bds.exe"
    goto open
)

if exist "C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\bds.exe" (
    set RAD_STUDIO_EXE="C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\bds.exe"
    goto open
)

if defined BDS (
    if exist "%BDS%\bin\bds.exe" (
        set RAD_STUDIO_EXE="%BDS%\bin\bds.exe"
        goto open
    )
)

echo RAD Studio not found. Please open CalculatorTests.dproj manually.
echo Location: %CD%\CalculatorTests.dproj
pause
exit /b 1

:open
echo Opening test project with RAD Studio...
%RAD_STUDIO_EXE% CalculatorTests.dproj

echo.
echo Instructions:
echo 1. Build the project (Ctrl+F9)
echo 2. Run tests (F9)
echo 3. Check results in console window
echo.
echo Alternative: Use View -> Test Explorer for GUI test runner
pause