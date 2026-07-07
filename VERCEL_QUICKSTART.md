# 🚀 Vercel Deployment - Quick Start

## What Was Configured

Your Agriculture Bot is now ready for **Vercel serverless deployment**!

### New Files Created:
```
✅ vercel.json           - Vercel platform config
✅ api/index.py          - Serverless function handler
✅ .vercelignore         - Excludes unnecessary files
✅ VERCEL_DEPLOYMENT.md  - Complete deployment guide
```

### Files Modified:
```
✅ requirements.txt      - Removed gunicorn, added werkzeug
✅ app/config.py         - Uses /tmp for serverless file storage
```

---

## Deploy in 3 Steps

### Option A: Vercel CLI (Fast)

```bash
# 1. Install CLI
npm install -g vercel

# 2. Login
vercel login

# 3. Deploy
cd "E:\Project 2\Agriculture_Bot"
vercel
```

### Option B: Vercel Dashboard (Git)

```bash
# 1. Push to GitHub
git add .
git commit -m "Add Vercel config"
git push origin main

# 2. Visit https://vercel.com/dashboard
# 3. Click "Import Project"
# 4. Select your repo
# 5. Click "Deploy"
```

---

## Required Environment Variables

Add these in Vercel Dashboard → Settings → Environment Variables:

```bash
GROQ_API_KEY=your_groq_api_key        # Required
FLASK_SECRET_KEY=random_secret_here   # Required
```

**Get Groq API Key:** https://console.groq.com/keys

**Generate Secret Key:**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

---

## Optional: Add Redis (Recommended)

For persistent conversations across requests:

**Upstash Redis (Free - Best for Vercel):**
1. Go to your Vercel project → Storage tab
2. Click "Create Database" → "KV (Redis)"
3. Environment variables auto-added ✅

**Or use any Redis provider:**
```bash
REDIS_HOST=your-redis-host.com
REDIS_PORT=6379
REDIS_PASSWORD=your_password
REDIS_SSL=true
```

---

## Key Differences: Vercel vs Render

| Feature | Vercel | Render (Docker) |
|---------|--------|-----------------|
| **Architecture** | Serverless Functions | Container |
| **Deployment** | Git push or CLI | Dockerfile |
| **File Storage** | `/tmp` (ephemeral) | Persistent disk |
| **Scaling** | Automatic, instant | Manual configuration |
| **Cold Start** | 3-5 seconds | Always warm |
| **Timeout** | 10s (free), 60s (pro) | Unlimited |
| **Best For** | Low/medium traffic | High traffic, stateful apps |

---

## Important Notes

⚠️ **File Storage:** Files in `/tmp` are cleared between requests. Audio files are regenerated per session.

💡 **Solution:** For persistent files, use:
- Vercel Blob Storage
- AWS S3
- Cloudinary

✅ **Redis Highly Recommended:** Without Redis, conversations reset between requests.

---

## Test After Deployment

```bash
# Health check
curl https://your-app.vercel.app/health

# Chat test
curl -X POST https://your-app.vercel.app/chat \
  -F "text=What are good crops for summer?"
```

---

## See Full Guide

📖 Read `VERCEL_DEPLOYMENT.md` for:
- Detailed troubleshooting
- Performance optimization
- Cost estimation
- Monitoring setup
- Advanced configuration

---

**Ready to deploy! 🎉**

Choose your deployment method above and follow the steps in `VERCEL_DEPLOYMENT.md`.
