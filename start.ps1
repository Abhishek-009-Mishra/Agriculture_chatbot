# Agriculture Bot - Local Run Script
# Run this script in PowerShell from the project directory

Write-Host "🌾 Agriculture Bot - Local Setup & Run" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

# Step 1: Navigate to project directory
Write-Host "📂 Step 1: Navigating to project directory..." -ForegroundColor Cyan
Set-Location "E:\Project 2\Agriculture_Bot"
Write-Host "   Current directory: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Step 2: Check if virtual environment exists
Write-Host "🔍 Step 2: Checking virtual environment..." -ForegroundColor Cyan
if (Test-Path ".\venv\Scripts\Activate.ps1") {
    Write-Host "   ✅ Virtual environment found!" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Virtual environment not found. Creating..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "   ✅ Virtual environment created!" -ForegroundColor Green
}
Write-Host ""

# Step 3: Activate virtual environment
Write-Host "🔧 Step 3: Activating virtual environment..." -ForegroundColor Cyan
& ".\venv\Scripts\Activate.ps1"
Write-Host "   ✅ Virtual environment activated!" -ForegroundColor Green
Write-Host ""

# Step 4: Install/Update dependencies
Write-Host "📦 Step 4: Installing dependencies..." -ForegroundColor Cyan
Write-Host "   This may take a minute..." -ForegroundColor Gray
pip install -q -r requirements.txt
Write-Host "   ✅ Dependencies installed!" -ForegroundColor Green
Write-Host ""

# Step 5: Verify .env file
Write-Host "🔐 Step 5: Verifying configuration..." -ForegroundColor Cyan
if (Test-Path ".\.env") {
    Write-Host "   ✅ .env file found!" -ForegroundColor Green
    
    # Check for API key (without displaying it)
    $envContent = Get-Content ".\.env" -Raw
    if ($envContent -match "GROQ_API_KEY=.+") {
        Write-Host "   ✅ GROQ_API_KEY is configured!" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  GROQ_API_KEY not set in .env file!" -ForegroundColor Yellow
        Write-Host "   Please edit .env and add your Groq API key." -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️  .env file not found!" -ForegroundColor Yellow
}
Write-Host ""

# Step 6: Run the application
Write-Host "🚀 Step 6: Starting the application..." -ForegroundColor Cyan
Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Application will start on port 5000" -ForegroundColor White
Write-Host "  Open your browser to: http://localhost:5000" -ForegroundColor Yellow
Write-Host "  Press Ctrl+C to stop the server" -ForegroundColor White
Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

python run.py
