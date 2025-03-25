@echo off
echo Starting Disaster Relief Platform...
echo.

REM Check if Python is installed
python --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Python is not installed!
    echo Please install Python from https://www.python.org/
    pause
    exit /b 1
)

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Node.js is not installed!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check if MySQL is running
mysql --version >nul 2>&1
if errorlevel 1 (
    echo Warning: MySQL might not be installed!
    echo Please ensure MySQL is installed and running.
)

REM Check if virtual environment exists, if not create it
if not exist "backend\venv" (
    echo Creating Python virtual environment...
    cd backend
    python -m venv venv
    call venv\Scripts\activate
    pip install -r requirements.txt
    cd ..
) else (
    cd backend
    call venv\Scripts\activate
    cd ..
)

REM Start Backend Server
echo Starting Backend Server...
start cmd /k "cd backend && .\venv\Scripts\activate && python app.py"

REM Start Frontend Server
echo Starting Frontend Server...
start cmd /k "cd frontend && npm run dev"

echo.
echo Servers are starting...
echo.
echo Backend will be available at: http://localhost:5000
echo Frontend will be available at: http://localhost:3000
echo.
echo Press any key to close this window. The servers will continue running in their own windows.
pause >nul 