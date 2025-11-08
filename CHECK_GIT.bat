@echo off
REM Git Verification Script
REM This script checks if Git is installed and configured

echo ========================================
echo Git Verification and Setup Check
echo ========================================
echo.

REM Check if git is in PATH
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Git is installed and in PATH
    echo.
    echo Git Version:
    git --version
    echo.
    
    REM Check Git location
    echo Git Location:
    where git
    echo.
    
    REM Check configuration
    echo Git Configuration:
    git config --global --list
    echo.
    
    REM Check if user name is set
    git config --global --get user.name >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Git user.name is configured
        git config --global --get user.name
    ) else (
        echo [WARNING] Git user.name is NOT configured
        echo Run: git config --global user.name "Your Name"
    )
    echo.
    
    REM Check if user email is set
    git config --global --get user.email >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Git user.email is configured
        git config --global --get user.email
    ) else (
        echo [WARNING] Git user.email is NOT configured
        echo Run: git config --global user.email "your.email@example.com"
    )
    echo.
    
    echo ========================================
    echo Git is ready to use!
    echo ========================================
    echo.
    echo Next steps:
    echo 1. Configure Git (if not configured):
    echo    git config --global user.name "Your Name"
    echo    git config --global user.email "your.email@example.com"
    echo.
    echo 2. Push to GitHub:
    echo    Run QUICK_PUSH.bat
    echo    Or follow START_HERE_PUSH_TO_GITHUB.md
    echo.
    
) else (
    echo [ERROR] Git is NOT found in PATH
    echo.
    echo Possible reasons:
    echo 1. Git is not installed
    echo 2. Git is installed but not in PATH
    echo 3. Terminal needs to be restarted after installation
    echo.
    echo Solutions:
    echo.
    echo Option 1: Install Git
    echo 1. Download from: https://git-scm.com/download/win
    echo 2. Install Git
    echo 3. RESTART your terminal/IDE
    echo 4. Run this script again
    echo.
    echo Option 2: Check if Git is installed but not in PATH
    echo 1. Check: C:\Program Files\Git\bin\git.exe
    echo 2. If exists, add to PATH:
    echo    - Win + R, type: sysdm.cpl
    echo    - Advanced ^> Environment Variables
    echo    - Add: C:\Program Files\Git\bin
    echo 3. RESTART terminal
    echo.
    echo Option 3: Restart Terminal
    echo - If you just installed Git, RESTART your terminal
    echo - Close all terminal windows
    echo - Open a NEW terminal
    echo - Run this script again
    echo.
    
    REM Check common installation locations
    echo Checking common Git installation locations...
    echo.
    
    if exist "C:\Program Files\Git\bin\git.exe" (
        echo [FOUND] Git at: C:\Program Files\Git\bin\git.exe
        echo [ACTION] Add this to PATH or restart terminal
    ) else (
        echo [NOT FOUND] C:\Program Files\Git\bin\git.exe
    )
    
    if exist "C:\Program Files (x86)\Git\bin\git.exe" (
        echo [FOUND] Git at: C:\Program Files (x86)\Git\bin\git.exe
        echo [ACTION] Add this to PATH or restart terminal
    ) else (
        echo [NOT FOUND] C:\Program Files (x86)\Git\bin\git.exe
    )
    
    echo.
    echo ========================================
    echo Please install Git or restart terminal
    echo ========================================
    echo.
)

pause

