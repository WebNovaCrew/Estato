# 🔑 Supabase Keys Setup Guide

## 📍 Where to Find Your Supabase Keys

### Step 1: Login to Supabase
1. Go to [supabase.com](https://supabase.com)
2. Click "Sign In" or "Login"
3. Enter your credentials

### Step 2: Select Your Project
1. After login, you'll see your projects
2. Click on your project name
3. Wait for the project dashboard to load

### Step 3: Get API Keys
1. **Click on Settings** (⚙️ icon at bottom left)
2. **Click on "API"** in the settings menu
3. You'll see a page with your API keys

### Step 4: Copy These 3 Values

#### 1. Project URL
```
Project URL: https://xxxxx.supabase.co
```
- This is your Supabase project URL
- Copy the entire URL starting with `https://`

#### 2. anon public key
```
anon public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eCIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjE2MjM5MDIyfQ.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
- This is your public anonymous key
- Safe to use in frontend
- Copy the entire key

#### 3. service_role key
```
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eCIsInJvbGUiOiJzZXJ2aWNlX3JvbGUiLCJpYXQiOjE2MTYyMzkwMjJ9.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
- ⚠️ **KEEP THIS SECRET!** 
- Only use in backend
- Never expose in frontend
- Copy the entire key

---

## 📝 How to Add Keys to Backend

### Step 1: Open .env File
1. Navigate to `backend` folder
2. Open `.env` file in your code editor
3. If `.env` doesn't exist, copy `.env.example` to `.env`

### Step 2: Replace Values

Replace these lines in `.env`:

```env
# Before (example values)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# After (your actual values)
SUPABASE_URL=https://abcdefghijklmnop.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNjIzOTAyMn0.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNjE2MjM5MDIyfQ.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Step 3: Save File
- Save the `.env` file
- Make sure there are no extra spaces
- Make sure keys are not in quotes

### Step 4: Restart Backend
```bash
# Stop server (Ctrl+C)
# Then start again
npm run dev
```

---

## ✅ Verify Keys are Working

### Test 1: Check Backend Starts
```bash
cd backend
npm run dev
```

Should see:
```
🚀 Estato API Server running on port 3000
```

If you see error about "Missing Supabase configuration", check your `.env` file.

### Test 2: Check Health Endpoint
Open browser: `http://localhost:3000/health`

Should see:
```json
{
  "success": true,
  "message": "Estato API is running",
  "timestamp": "2025-11-04T..."
}
```

### Test 3: Test Registration
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123",
    "name": "Test User",
    "phone": "+91 9876543210",
    "userType": "buyer"
  }'
```

Should see success response with user data.

---

## 🔒 Security Tips

1. **Never commit .env file to Git**
   - `.env` is already in `.gitignore`
   - Never share your keys publicly

2. **Use Different Keys for Production**
   - Create separate Supabase project for production
   - Use production keys in production environment

3. **Rotate Keys if Compromised**
   - Go to Supabase Settings → API
   - Generate new keys
   - Update `.env` file
   - Restart backend

4. **Keep service_role Key Secret**
   - Only use in backend
   - Never expose in frontend code
   - Never commit to Git

---

## 🐛 Common Issues

### Issue: "Missing Supabase configuration"
**Cause:** Keys not set in `.env` file

**Solution:**
1. Check `.env` file exists
2. Verify keys are correct
3. Make sure no quotes around keys
4. Restart backend server

### Issue: "Invalid API key"
**Cause:** Wrong key or key copied incorrectly

**Solution:**
1. Double-check keys in Supabase Dashboard
2. Copy keys again
3. Make sure no extra spaces
4. Verify you're using the right keys (anon vs service_role)

### Issue: "Connection refused"
**Cause:** Supabase URL incorrect or project paused

**Solution:**
1. Check Supabase URL is correct
2. Verify project is active (not paused)
3. Check internet connection
4. Try accessing Supabase Dashboard

---

## 📞 Need Help?

If you're stuck:
1. Check Supabase Dashboard is accessible
2. Verify project is active
3. Check backend terminal for error messages
4. Verify all keys are copied correctly
5. Make sure `.env` file is in `backend` folder

---

**Last Updated:** November 4, 2025

