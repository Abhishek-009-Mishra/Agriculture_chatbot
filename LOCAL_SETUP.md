# 🖥️ Running Agriculture Bot Locally

## Prerequisites Check

✅ **Python 3.11.9** detected  
✅ **pip 26.1.2** detected  
✅ **Virtual environment** exists  
✅ **.env file** exists with Groq API key configured  

---

## Quick Start (If Virtual Environment Already Set Up)

If you've already installed dependencies before, simply:

```powershell
# 1. Navigate to project
cd "E:\Project 2\Agriculture_Bot"

# 2. Activate virtual environment
.\venv\Scripts\Activate.ps1

# 3. Run the application
python run.py
```

Then open your browser to: **http://localhost:5000**

---

## Fresh Setup (First Time or Clean Install)

### Step 1: Navigate to Project Directory

```powershell
cd "E:\Project 2\Agriculture_Bot"
```

### Step 2: Create and Activate Virtual Environment

```powershell
# Create virtual environment (if needed)
python -m venv venv

# Activate it
.\venv\Scripts\Activate.ps1
```

**Note:** If you get an execution policy error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Step 3: Install Dependencies

```powershell
pip install -r requirements.txt
```

Expected output:
```
Successfully installed flask-3.1.3 groq-0.30.0 redis-5.2.0 ...
```

### Step 4: Verify Configuration

Your `.env` file is already configured with:
- ✅ GROQ_API_KEY (set)
- ✅ FLASK_SECRET_KEY (set)
- ✅ Redis credentials (set)

If you want to change any settings, edit the `.env` file.

### Step 5: Run the Application

```powershell
python run.py
```

Expected output:
```
WARNING in __init__: GROQ_API_KEY not set. LLM unavailable.
INFO in __init__: All services initialized successfully.
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://0.0.0.0:5000
```

### Step 6: Open in Browser

Visit: **http://localhost:5000**

You should see the Agriculture Bot chat interface!

---

## Testing the Application

### 1. Test the Health Endpoint

Open a new PowerShell window:

```powershell
curl http://localhost:5000/health
```

Expected response:
```json
{
  "status": "healthy",
  "redis": "connected",
  "timestamp": "2026-07-07T..."
}
```

### 2. Test Text Chat

```powershell
curl -X POST http://localhost:5000/chat -F "text=What crops are good for summer?"
```

Expected response:
```json
{
  "text": "For summer farming, consider crops like...",
  "voice": "/static/audio/ABC12345.wav",
  "cache": {
    "prompt_tokens": 150,
    "cached_tokens": 120,
    "hit_rate": 80.0,
    "completion_tokens": 200
  }
}
```

### 3. Test Web Interface

1. Open browser: **http://localhost:5000**
2. Type a question: "What is crop rotation?"
3. Click send or press Enter
4. You should get:
   - Text response from the AI
   - Voice audio playback
   - Cache metrics displayed

---

## Optional: Running Redis Locally

Your `.env` is configured to connect to Redis. You have two options:

### Option A: Use Your Existing Redis Server

If your Redis credentials are correct, the app will connect automatically.

Check Redis connection:
```powershell
# Test health endpoint
curl http://localhost:5000/health
```

Look for: `"redis": "connected"`

### Option B: Disable Redis (Use In-Memory Storage)

Edit `.env` and comment out Redis settings:

```bash
# REDIS_HOST=localhost
# REDIS_PORT=6379
# REDIS_USERNAME=Abhishek
# REDIS_PASSWORD=23022007@Ak
```

The app will automatically fall back to in-memory conversation storage.

### Option C: Install Redis Locally (Windows)

```powershell
# Using Chocolatey
choco install redis-64

# Or download from:
# https://github.com/microsoftarchive/redis/releases
```

Then run:
```powershell
redis-server
```

---

## Common Issues and Solutions

### Issue 1: "Cannot be loaded because running scripts is disabled"

**Error:**
```
.\venv\Scripts\Activate.ps1 cannot be loaded because running scripts is disabled
```

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue 2: "ModuleNotFoundError: No module named 'flask'"

**Solution:** Virtual environment not activated or dependencies not installed:
```powershell
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### Issue 3: "Address already in use" (Port 5000 conflict)

**Solution 1 - Kill the process:**
```powershell
# Find process on port 5000
netstat -ano | findstr :5000

# Kill it (replace PID with actual process ID)
taskkill /PID <PID> /F
```

**Solution 2 - Use a different port:**

Edit `run.py` and change:
```python
app.run(host='0.0.0.0', port=5001, debug=True)  # Changed to 5001
```

### Issue 4: "Redis connection failed"

**Symptoms:**
```
WARNING: Redis unavailable, using in-memory fallback
```

**Solution:**
- This is OK! The app will work fine with in-memory storage
- Conversations will be lost when you restart the server
- To use Redis, ensure Redis server is running and credentials are correct

### Issue 5: "GROQ_API_KEY not set"

**Solution:** Your API key is already set in `.env`, but make sure:
1. `.env` file is in the project root
2. The key is valid (test at https://console.groq.com/keys)

### Issue 6: Static files (CSS/JS) not loading

**Solution:**
```powershell
# Check if static directories exist
Test-Path "E:\Project 2\Agriculture_Bot\app\static\css"
Test-Path "E:\Project 2\Agriculture_Bot\app\static\js"
Test-Path "E:\Project 2\Agriculture_Bot\app\static\images"
```

If missing, check your project structure.

---

## Development Tips

### Hot Reload

Flask debug mode is enabled, so the server automatically restarts when you edit Python files.

### View Logs

All logs appear in the terminal where you ran `python run.py`:

```
INFO in llm_service: LLM response [session: abc123] — prompt: 150 tokens, cached: 120 (80% hit)
```

### Clear Conversations

```powershell
curl -X POST http://localhost:5000/chat/clear
```

### Stop the Server

Press **Ctrl+C** in the terminal where Flask is running.

### Deactivate Virtual Environment

```powershell
deactivate
```

---

## Project Structure Quick Reference

```
E:\Project 2\Agriculture_Bot\
├── app/
│   ├── __init__.py          # Flask app factory
│   ├── config.py            # Configuration
│   ├── routes/
│   │   ├── chat.py          # Chat endpoints
│   │   └── main.py          # Main routes
│   ├── services/
│   │   ├── llm_service.py   # Groq LLM
│   │   ├── memory_service.py # Redis/memory
│   │   ├── stt_service.py   # Speech-to-text
│   │   └── tts_service.py   # Text-to-speech
│   ├── static/              # CSS, JS, images
│   │   └── audio/           # Generated TTS audio
│   └── templates/
│       └── index.html       # Chat interface
├── venv/                    # Virtual environment
├── .env                     # Your configuration (DO NOT COMMIT)
├── run.py                   # Application entry point ← RUN THIS
└── requirements.txt         # Dependencies
```

---

## Next Steps After Local Testing

Once everything works locally:

1. ✅ Test all features (text chat, voice, image upload)
2. ✅ Verify Redis connection (if using Redis)
3. ✅ Check audio generation works
4. ✅ Test conversation memory persistence
5. 🚀 Deploy to Vercel (see `VERCEL_QUICKSTART.md`)

---

## Quick Command Reference

```powershell
# Activate environment
.\venv\Scripts\Activate.ps1

# Run app
python run.py

# Test health
curl http://localhost:5000/health

# Test chat
curl -X POST http://localhost:5000/chat -F "text=Hello"

# Deactivate
deactivate
```

---

**Ready to run! Open PowerShell and execute the Quick Start commands above.** 🚀
