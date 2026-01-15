@echo off
setlocal

echo ==============================
echo UEIntro - Sync and Push
echo ==============================

REM --- Current folder is the repo root ---
set PROJECT_DIR=%cd%

REM --- Ask user for commit message ---
set /p COMMIT_MSG=Enter commit message for your changes: 

REM --- Make sure .uproject exists ---
set FOUND_UPROJECT=
for %%f in (*.uproject) do set FOUND_UPROJECT=%%f

if "%FOUND_UPROJECT%"=="" (
    echo ERROR: No .uproject file found in current folder.
    pause
    exit /b 1
)

echo Found .uproject: %FOUND_UPROJECT%

REM --- Pull latest commits ---
echo Pulling latest changes from GitHub...
git pull origin main

REM --- Pull Git LFS assets ---
echo Pulling Git LFS assets...
git lfs pull

REM --- Add all changes (new/modified/deleted assets) ---
echo Adding local changes...
git add -A

REM --- Commit changes ---
echo Committing changes...
git commit -m "%COMMIT_MSG%"

REM --- Push to GitHub ---
echo Pushing to GitHub...
git push origin main

echo ==============================
echo Push Complete!
echo ==============================
echo Your UE changes are now on GitHub.
pause
