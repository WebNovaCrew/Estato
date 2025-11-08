# ⚡ Render Deployment - Quick Start

## 🚀 Deploy Your Backend to Render in 10 Minutes

---

## 📋 Step 1: Push Backend to GitHub (2 min)

```bash
# Make sure backend is committed
git add backend/
git commit -m "Prepare backend for Render deployment"
git push origin main
```

---

## 🔐 Step 2: Get Your Supabase Keys (1 min)

You already have these:
- **Supabase URL:** `https://yapmbzqzahsyuxxdejpq.supabase.co`
- **Anon Key:** (from earlier)
- **Service Role Key:** (from earlier)

---

## 🌐 Step 3: Create Render Service (5 min)

1. **Go to Render**
   - Visit: [https://render.com](https://render.com)
   - Sign up/Login
   - Click "New +" → "Web Service"

2. **Connect Repository**
   - Select your GitHub repository: `WebNovaCrew/Estato`
   - Click "Connect"

3. **Configure Service**
   - **Name:** `estato-backend`
   - **Environment:** `Node`
   - **Region:** `Oregon (US West)` (or closest to you)
   - **Branch:** `main`
   - **Root Directory:** `backend` ⚠️ **Important!**
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`

4. **Add Environment Variables**
   - Scroll to "Environment Variables"
   - Add these (see `backend/ENV_VARIABLES_FOR_RENDER.md` for full list):
     
     ```
     PORT=10000
     NODE_ENV=production
     SUPABASE_URL=https://yapmbzqzahsyuxxdejpq.supabase.co
     SUPABASE_ANON_KEY=your_anon_key
     SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
     JWT_SECRET=your_random_secret
     ALLOWED_ORIGINS=https://estato-backend.onrender.com,http://localhost:3000
     ```

5. **Create Service**
   - Click "Create Web Service"
   - Wait for deployment (5-10 minutes)

---

## ✅ Step 4: Verify Deployment (2 min)

1. **Check Status**
   - Wait for "Live" status
   - Your URL: `https://estato-backend.onrender.com`

2. **Test Health Endpoint**
   - Open: `https://estato-backend.onrender.com/health`
   - Should see: `{"success":true,"message":"Estato API is running"}`

---

## 📱 Step 5: Update Flutter App (1 min)

1. **Update API URL**
   - File: `lib/services/config_service.dart`
   - Change to:
     ```dart
     static const String apiBaseUrl = 'https://estato-backend.onrender.com/api';
     ```

2. **Test App**
   - Run Flutter app
   - Test registration/login
   - Should connect to Render backend!

---

## 🎉 Done!

Your backend is now live on Render! 🚀

**Backend URL:** `https://estato-backend.onrender.com`

**Next Steps:**
- Update ALLOWED_ORIGINS with your Flutter app URL
- Test all API endpoints
- Set up custom domain (optional)
- Monitor performance

---

## 🐛 Quick Troubleshooting

### Service won't start
- Check logs in Render Dashboard
- Verify environment variables are set
- Check PORT is set to 10000

### CORS errors
- Update ALLOWED_ORIGINS in Render
- Add your app's URL
- Redeploy service

### 401 Unauthorized
- Verify Supabase keys in Render
- Check database connection
- Verify JWT_SECRET is set

---

## 📚 Detailed Guides

- **Complete Guide:** `backend/DEPLOY_TO_RENDER.md`
- **Environment Variables:** `backend/ENV_VARIABLES_FOR_RENDER.md`
- **Checklist:** `backend/RENDER_SETUP_CHECKLIST.md`

---

**Last Updated:** November 4, 2025

