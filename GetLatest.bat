@echo off
setlocal

echo ==============================
echo UEIntro - Update to Latest
echo ==============================

REM --- Current folder is the repo root ---
set PROJECT_DIR=%cd%

REM --- Ask user for Unreal Engine path ---
set /p UE_PATH=Enter Unreal Engine path (Epic Launcher install, e.g., C:\Program Files\Epic Games\UE_5.3): 

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

REM --- Detect if C++ project ---
if exist "Source\" (
    echo Detected C++ project. Regenerating project files...
    if not exist "%UE_PATH%\Binaries\DotNET\UnrealBuildTool.exe" (
        echo WARNING: Could not find UnrealBuildTool at "%UE_PATH%"
        echo Make sure Epic Launcher UE version is installed correctly.
    ) else (
        "%UE_PATH%\Binaries\DotNET\UnrealBuildTool.exe" -projectfiles -project="%PROJECT_DIR%\%FOUND_UPROJECT%" -game -rocket -progress
        echo Project files regenerated.
    )
) else (
    echo Blueprint-only project detected. No project file regeneration needed.
)

echo ==============================
echo Update Complete!
echo ==============================
echo Next steps:
echo 1. Open "%PROJECT_DIR%\%FOUND_UPROJECT%" in Unreal Engine to see the latest changes
echo.
pause
