# 🚀 Vercel Deployment Guide - Agriculture Bot

## ✅ Vercel Configuration Complete

Your Agriculture Bot project has been configured for Vercel serverless deployment with the following setup:

### Files Created/Modified:
- ✅ `vercel.json` - Vercel platform configuration
- ✅ `api/index.py` - Serverless function entry point
- ✅ `.vercelignore` - Excludes unnecessary files
- ✅ `requirements.txt` - Updated for serverless compatibility
- ✅ `app/config.py` - Updated to use `/tmp` for file storage on Vercel

---

## 📋 Pre-Deployment Checklist

### 1. Configure Environment Variables

You'll need to set these in Vercel dashboard after connecting your project:

**Required:**
```bash
GROQ_API_KEY=your_groq_api_key_from_console.groq.com
FLASK_SECRET_KEY=generate_a_long_random_secret
```

**Optional (Redis for persistent conversations):**
```bash
REDIS_HOST=your-redis-host.com
REDIS_PORT=6379
REDIS_USERNAME=your_redis_username
REDIS_PASSWORD=your_redis_password
REDIS_SSL=true
REDIS_SESSION_TTL=3600
```

**Optional (Customization):**
```bash
LLM_MODEL=openai/gpt-oss-120b
LLM_VISION_MODEL=meta-llama/llama-4-scout-17b-16e-instruct
LLM_TEMPERATURE=0.3
LLM_MAX_TOKENS=2048
STT_MODEL=whisper-large-v3-turbo
TTS_MODEL=canopylabs/orpheus-v1-english
VOICE=autumn
LOG_LEVEL=INFO
```

### 2. Generate a Secure Secret Key

```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

Copy the output and use it as your `FLASK_SECRET_KEY`.

---

## 🌐 Deploy to Vercel

### Method 1: Deploy via Vercel CLI (Recommended)

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

2. **Navigate to your project:**
   ```bash
   cd "E:\Project 2\Agriculture_Bot"
   ```

3. **Login to Vercel:**
   ```bash
   vercel login
   ```

4. **Deploy:**
   ```bash
   vercel
   ```
   
   Follow the prompts:
   - Set up and deploy? **Yes**
   - Which scope? Select your account
   - Link to existing project? **No**
   - What's your project name? `agriculture-bot` (or your choice)
   - In which directory is your code located? `./`
   - Want to override settings? **No**

5. **Set environment variables:**
   ```bash
   vercel env add GROQ_API_KEY
   # Paste your Groq API key
   
   vercel env add FLASK_SECRET_KEY
   # Paste your generated secret key
   ```

6. **Deploy to production:**
   ```bash
   vercel --prod
   ```

### Method 2: Deploy via Vercel Dashboard (Git Integration)

1. **Push to Git:**
   ```bash
   git add .
   git commit -m "Configure for Vercel deployment"
   git push origin main
   ```

2. **Go to Vercel Dashboard:**
   - Visit: https://vercel.com/dashboard
   - Click "Add New..." → "Project"

3. **Import Git Repository:**
   - Select your Git provider (GitHub, GitLab, Bitbucket)
   - Authorize Vercel if needed
   - Select your `Agriculture_Bot` repository
   - Click "Import"

4. **Configure Project:**
   - **Framework Preset:** Other
   - **Root Directory:** `./` (leave as default)
   - **Build Command:** (leave empty)
   - **Output Directory:** (leave empty)
   - **Install Command:** `pip install -r requirements.txt`

5. **Add Environment Variables:**
   Click "Environment Variables" and add:
   ```
   GROQ_API_KEY = your_groq_api_key_here
   FLASK_SECRET_KEY = your_generated_secret_key
   ```
   
   Add any optional variables you need (Redis, model settings, etc.)

6. **Deploy:**
   - Click "Deploy"
   - Wait for build to complete (2-3 minutes)
   - Your app will be live at: `https://agriculture-bot-xxxx.vercel.app`

---

## 🔍 Testing Your Deployment

### 1. Check Health Endpoint
```bash
curl https://your-app.vercel.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "redis": "connected",
  "timestamp": "2026-07-07T..."
}
```

### 2. Test Chat Endpoint
```bash
curl -X POST https://your-app.vercel.app/chat \
  -F "text=What crops are good for summer farming?"
```

Expected response:
```json
{
  "text": "For summer farming, consider crops like...",
  "voice": "/static/audio/response_xxxxx.wav",
  "cache": {
    "prompt_tokens": 150,
    "cached_tokens": 120,
    "hit_rate": 80.0,
    "completion_tokens": 200
  }
}
```

### 3. Visit Web Interface
Open your browser and go to:
```
https://your-app.vercel.app/
```

You should see the chat interface with voice and image upload capabilities.

---

## ⚙️ Vercel-Specific Considerations

### File Storage Limitations

**Important:** Vercel serverless functions have a **read-only filesystem** except for `/tmp`.

- ✅ **Configured:** The app automatically uses `/tmp` for uploads and audio files when running on Vercel
- ⚠️ **Note:** Files in `/tmp` are ephemeral and cleared between invocations
- 💡 **Solution:** For persistent file storage, consider:
  - **Vercel Blob Storage** (recommended)
  - **AWS S3**
  - **Cloudinary**

### Redis for Conversation Memory

Since Vercel is stateless, **Redis is highly recommended** for conversation persistence:

**Free Redis Options:**
- **Upstash Redis** (recommended for Vercel): https://upstash.com/
  - Free tier: 10,000 commands/day
  - Built-in Redis integration on Vercel
- **Redis Cloud**: https://redis.com/try-free/
  - Free tier: 30MB storage

**To add Upstash Redis on Vercel:**
1. Go to your Vercel project dashboard
2. Click "Storage" tab
3. Click "Create Database" → "KV (Redis)"
4. Environment variables are automatically added

### Function Timeout

- Default Vercel timeout: **10 seconds** (hobby plan)
- Pro plan: **60 seconds**
- For longer LLM responses, consider upgrading or using streaming

### Cold Starts

First request after inactivity may take 3-5 seconds (cold start). Subsequent requests are fast (~100-500ms).

---

## 🐛 Troubleshooting

### Issue: "Module not found" error
**Solution:** Ensure all dependencies are in `requirements.txt` and no local imports break.

### Issue: "GROQ_API_KEY not set"
**Solution:** 
1. Go to Vercel dashboard → Your project → Settings → Environment Variables
2. Add `GROQ_API_KEY` with your actual key
3. Redeploy: `vercel --prod`

### Issue: "Redis connection failed"
**Solution:** 
- If not using Redis, this is OK (falls back to in-memory storage)
- If using Redis, verify `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD` are correct

### Issue: "Audio files not persisting"
**Solution:** This is expected on Vercel's serverless environment. Audio is regenerated per session. For persistent storage, integrate Vercel Blob or S3.

### Issue: "Function timeout"
**Solution:**
- Reduce `LLM_MAX_TOKENS` (e.g., set to 1024)
- Upgrade to Vercel Pro for 60s timeout
- Use streaming responses (requires code changes)

### Issue: "Static files not loading"
**Solution:** Vercel routes static files automatically. Ensure paths start with `/static/` and match `vercel.json` routing rules.

---

## 📊 Monitoring

### View Logs
```bash
vercel logs your-deployment-url
```

Or in the Vercel dashboard:
- Go to your project
- Click "Deployments"
- Click on a deployment
- View "Functions" logs

### Key Metrics to Monitor
- **Function Duration:** Should be < 10s (hobby) or < 60s (pro)
- **Cache Hit Rate:** Should be > 70% after warmup
- **Error Rate:** Should be < 1%
- **Redis Connection Status:** Check `/health` endpoint

---

## 🔄 Continuous Deployment

Once connected to Git, Vercel automatically:
- ✅ Deploys every push to `main` branch (production)
- ✅ Creates preview deployments for pull requests
- ✅ Runs deployments in parallel
- ✅ Provides instant rollback

### Deploy from Git Branch
```bash
git checkout -b feature/new-model
# Make changes
git add .
git commit -m "Update LLM model"
git push origin feature/new-model
```

Vercel automatically creates a preview deployment at:
```
https://agriculture-bot-git-feature-new-model-username.vercel.app
```

---

## 🎯 Performance Tips

1. **Enable Prompt Caching** (already implemented)
   - System prompt is cached automatically by Groq
   - Reduces costs by 50% and improves latency

2. **Use Edge Network**
   - Vercel automatically uses edge network
   - Your app is served from 100+ locations worldwide

3. **Optimize Redis**
   - Limit conversation history to 10 turns (already configured)
   - Set TTL to 1 hour to reduce memory usage

4. **Monitor Cold Starts**
   - Consider Vercel Pro to reduce cold starts
   - Or use Upstash Redis with edge caching

---

## 💰 Cost Estimation

### Vercel Free (Hobby) Plan:
- 100 GB bandwidth/month
- Unlimited serverless function invocations
- 10 second timeout
- **Perfect for testing and personal projects**

### Vercel Pro Plan ($20/month):
- 1 TB bandwidth/month
- 60 second timeout
- Better performance
- **Recommended for production**

### Groq API (Free Tier):
- 14,400 requests/day
- ~30,000 tokens/request
- **More than enough for small to medium traffic**

### Redis (Upstash Free):
- 10,000 commands/day
- 256 MB storage
- **Good for 100-500 daily users**

---

## 📞 Support Resources

- **Vercel Docs:** https://vercel.com/docs
- **Vercel Python Runtime:** https://vercel.com/docs/functions/runtimes/python
- **Groq API Docs:** https://console.groq.com/docs
- **Upstash Redis:** https://docs.upstash.com/redis

---

## ✨ Next Steps

1. ✅ Deploy using one of the methods above
2. ✅ Add environment variables in Vercel dashboard
3. ✅ Test all endpoints (health, chat, image upload)
4. ✅ Set up Redis for conversation persistence (recommended)
5. ✅ Configure custom domain (optional)
6. ✅ Monitor usage and logs
7. ✅ Set up GitHub integration for auto-deploy

**Your project is now fully configured for Vercel deployment! 🎉**
