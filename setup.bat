@echo off
echo Initializing Disaster Relief Platform...
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

REM Check if PostgreSQL is installed
pg_isready >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: PostgreSQL is not running or not installed!
    echo Please install PostgreSQL and ensure it's running.
    pause
    exit /b 1
)

REM Create necessary directories if they don't exist
if not exist "backend" mkdir backend
if not exist "frontend" mkdir frontend
if not exist "contracts" mkdir contracts

REM Setup Backend
echo Setting up Backend...
cd backend

REM Create virtual environment
python -m venv venv
call venv\Scripts\activate

REM Install Python dependencies
pip install -r requirements.txt

REM Create .env file if it doesn't exist
if not exist ".env" (
    echo Creating .env file...
    (
        echo FLASK_APP=app.py
        echo FLASK_ENV=development
        echo DATABASE_URL=postgresql://postgres:postgres@localhost/disaster_relief
        echo JWT_SECRET=your-secret-key
        echo FRONTEND_URL=http://localhost:3000
        echo AWS_ACCESS_KEY_ID=your_aws_access_key
        echo AWS_SECRET_ACCESS_KEY=your_aws_secret_key
        echo AWS_REGION=your_aws_region
        echo AWS_BUCKET_NAME=your_bucket_name
        echo IPFS_PROJECT_ID=your_ipfs_project_id
        echo IPFS_PROJECT_SECRET=your_ipfs_project_secret
        echo WEB3_PROVIDER_URL=https://sepolia.infura.io/v3/your_infura_project_id
    ) > .env
    echo Created .env file. Please update it with your configuration.
)

REM Initialize database
flask db init
flask db migrate -m "Initial migration"
flask db upgrade

call deactivate
cd ..

REM Setup Frontend
echo.
echo Setting up Frontend...
cd frontend
call npm install
if not exist ".env.local" (
    echo Creating .env.local file...
    (
        echo NEXT_PUBLIC_API_URL=http://localhost:5000
        echo NEXT_PUBLIC_MAPBOX_TOKEN=your_mapbox_token
        echo NEXT_PUBLIC_WEB3_PROVIDER_URL=https://sepolia.infura.io/v3/your_infura_project_id
    ) > .env.local
    echo Created .env.local file. Please update it with your configuration.
)
cd ..

REM Setup Smart Contracts
echo.
echo Setting up Smart Contracts...
cd contracts
call npm install
if not exist ".env" (
    echo Creating .env file...
    (
        echo WEB3_PROVIDER_URL=https://sepolia.infura.io/v3/your_infura_project_id
        echo PRIVATE_KEY=your_private_key
        echo ETHERSCAN_API_KEY=your_etherscan_api_key
    ) > .env
    echo Created .env file. Please update it with your configuration.
)
cd ..

echo.
echo Setup completed!
echo.
echo Before starting the application, please ensure you have:
echo 1. Updated the environment variables in:
echo    - backend/.env
echo    - frontend/.env.local
echo    - contracts/.env
echo.
echo 2. Started your PostgreSQL database
echo.
echo Then you can run 'start.bat' to launch the application.
echo.
pause 