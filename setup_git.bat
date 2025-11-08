@echo off
REM Git Setup Script for Estato Project
REM This script helps initialize git repository and push to GitHub

echo ========================================
echo Estato - Git Repository Setup
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed or not in PATH!
    echo.
    echo Please do one of the following:
    echo 1. Install Git from: https://git-scm.com/download/win
    echo 2. Restart your terminal/IDE after installing Git
    echo 3. Add Git to your PATH manually
    echo.
    echo If you just installed Git, please:
    echo - Close this terminal
    echo - Open a NEW terminal
    echo - Run this script again
    echo.
    pause
    exit /b 1
)

echo [1/7] Git is installed
echo.

REM Check if already a git repository
if exist .git (
    echo WARNING: Already a git repository!
    echo.
    set /p continue="Do you want to continue? (y/n): "
    if /i not "%continue%"=="y" exit /b 0
    echo.
)

REM Initialize git repository
echo [2/7] Initializing git repository...
git init
if %errorlevel% neq 0 (
    echo ERROR: Failed to initialize git repository
    pause
    exit /b 1
)
echo.

REM Check README exists
if not exist README.md (
    echo [3/7] Creating README.md...
    echo # Estato >> README.md
) else (
    echo [3/7] README.md already exists
)
echo.

REM Add all files
echo [4/7] Adding files to git...
git add .
if %errorlevel% neq 0 (
    echo ERROR: Failed to add files
    pause
    exit /b 1
)
echo.

REM Make initial commit
echo [5/7] Making initial commit...
git commit -m "Initial commit: Estato Real Estate App with Supabase backend"
if %errorlevel% neq 0 (
    echo ERROR: Failed to commit
    pause
    exit /b 1
)
echo.

REM Rename branch to main
echo [6/7] Setting branch to main...
git branch -M main
echo.

REM Add remote
echo [7/7] Adding remote repository...
git remote add origin https://github.com/WebNovaCrew/Estato.git
if %errorlevel% neq 0 (
    echo WARNING: Remote already exists or failed to add
    echo You may need to remove existing remote first:
    echo   git remote remove origin
    echo   git remote add origin https://github.com/WebNovaCrew/Estato.git
)
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Verify .env files are NOT in the repository:
echo    git status
echo.
echo 2. Push to GitHub:
echo    git push -u origin main
echo.
echo 3. If you get authentication errors:
echo    - Use GitHub Personal Access Token instead of password
echo    - Or set up SSH keys
echo.
echo For detailed instructions, see: GIT_SETUP.md
echo.
pause

