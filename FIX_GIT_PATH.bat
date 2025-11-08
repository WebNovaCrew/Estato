@echo off
REM Fix Git PATH Issue
REM This script helps add Git to PATH if it's installed but not accessible

echo ========================================
echo Git PATH Fix Script
echo ========================================
echo.

REM Check if Git exists at common location
if exist "C:\Program Files\Git\bin\git.exe" (
    echo [FOUND] Git installed at: C:\Program Files\Git\bin\git.exe
    echo.
    echo Git is installed but not in PATH.
    echo.
    echo Options:
    echo 1. Restart terminal (EASIEST - Recommended)
    echo 2. Add Git to PATH manually
    echo.
    echo For Option 1:
    echo - Close this terminal
    echo - Open a NEW terminal
    echo - Run: git --version
    echo.
    echo For Option 2:
    echo - Press Win + R
    echo - Type: sysdm.cpl
    echo - Advanced ^> Environment Variables
    echo - Edit Path variable
    echo - Add: C:\Program Files\Git\bin
    echo - Restart terminal
    echo.
    
    REM Try to test Git with full path
    echo Testing Git with full path...
    "C:\Program Files\Git\bin\git.exe" --version
    if %errorlevel% equ 0 (
        echo.
        echo [SUCCESS] Git works with full path!
        echo.
        echo You can use Git with full path, but it's better to:
        echo 1. Restart terminal, OR
        echo 2. Add Git to PATH
        echo.
    )
    
) else (
    echo [NOT FOUND] Git is not installed at standard location
    echo.
    echo Please install Git:
    echo 1. Download from: https://git-scm.com/download/win
    echo 2. Install Git
    echo 3. Restart terminal
    echo.
)

echo ========================================
echo Recommendation: RESTART TERMINAL
echo ========================================
echo.
echo After restarting terminal, Git should work automatically.
echo.
pause

