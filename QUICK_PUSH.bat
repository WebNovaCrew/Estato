@echo off
REM Quick Git Push Script for Estato
REM Make sure you've restarted terminal after installing Git!

echo ========================================
echo Estato - Push to GitHub
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not found!
    echo.
    echo Please:
    echo 1. Make sure Git is installed
    echo 2. Restart your terminal/IDE
    echo 3. Run this script again
    echo.
    pause
    exit /b 1
)

echo [OK] Git is installed
echo.

REM Check if already a git repository
if exist .git (
    echo [INFO] Git repository already initialized
) else (
    echo [1/8] Initializing git repository...
    git init
    if %errorlevel% neq 0 (
        echo ERROR: Failed to initialize git
        pause
        exit /b 1
    )
)
echo.

REM Check status
echo [2/8] Checking what will be committed...
git status
echo.
echo [IMPORTANT] Verify that .env files are NOT in the list above!
echo If you see backend/.env, press Ctrl+C to cancel and check .gitignore
echo.
pause
echo.

REM Add all files
echo [3/8] Adding files to git...
git add .
if %errorlevel% neq 0 (
    echo ERROR: Failed to add files
    pause
    exit /b 1
)
echo.

REM Check status again
echo [4/8] Checking status again (verify .env is NOT there)...
git status
echo.
set /p continue="Continue with commit? (y/n): "
if /i not "%continue%"=="y" (
    echo Cancelled.
    pause
    exit /b 0
)
echo.

REM Commit
echo [5/8] Committing changes...
git commit -m "Initial commit: Estato Real Estate App with Supabase backend and Render deployment"
if %errorlevel% neq 0 (
    echo ERROR: Failed to commit
    pause
    exit /b 1
)
echo.

REM Rename branch
echo [6/8] Setting branch to main...
git branch -M main
echo.

REM Add remote
echo [7/8] Adding remote repository...
git remote remove origin >nul 2>&1
git remote add origin https://github.com/WebNovaCrew/Estato.git
if %errorlevel% neq 0 (
    echo WARNING: Failed to add remote (might already exist)
)
echo.

REM Push
echo [8/8] Pushing to GitHub...
echo.
echo You will be prompted for GitHub credentials.
echo Use Personal Access Token as password (not your GitHub password).
echo.
echo To create token:
echo 1. Go to: https://github.com/settings/tokens
echo 2. Generate new token (classic)
echo 3. Select 'repo' scope
echo 4. Copy token and use as password
echo.
pause
echo.

git push -u origin main

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Push failed!
    echo.
    echo Common issues:
    echo - Authentication failed: Use Personal Access Token
    echo - Repository not found: Create repository on GitHub first
    echo - Network error: Check internet connection
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Code pushed to GitHub!
echo ========================================
echo.
echo Next steps:
echo 1. Verify on GitHub: https://github.com/WebNovaCrew/Estato
echo 2. Deploy to Render: Follow RENDER_DEPLOYMENT_QUICK_START.md
echo.
pause

