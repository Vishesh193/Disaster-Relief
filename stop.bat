@echo off
echo Stopping Disaster Relief Platform servers...
echo.

REM Kill Python process running on port 5000
for /f "tokens=5" %%a in ('netstat -aon ^| find ":5000" ^| find "LISTENING"') do (
    echo Stopping backend server...
    taskkill /f /pid %%a >nul 2>nul
)

REM Kill Node.js process running on port 3000
for /f "tokens=5" %%a in ('netstat -aon ^| find ":3000" ^| find "LISTENING"') do (
    echo Stopping frontend server...
    taskkill /f /pid %%a >nul 2>nul
)

REM Deactivate virtual environment if active
if defined VIRTUAL_ENV (
    call deactivate
)

echo All servers have been stopped.
echo.
echo Press any key to exit...
pause >nul 