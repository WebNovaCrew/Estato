# 🚀 START HERE - Supabase Integration Guide

## 👋 Welcome!

You've created a Supabase account. Now let's connect it to your Flutter app in **15 minutes**.

---

## 📚 Choose Your Guide

### ⚡ Quick Setup (15 minutes)
**Follow this if you want to get started quickly:**
👉 **`QUICK_SUPABASE_SETUP.md`**

### 📖 Detailed Guide (30 minutes)
**Follow this for step-by-step instructions with explanations:**
👉 **`SUPABASE_INTEGRATION_STEP_BY_STEP.md`**

### 🔑 Keys Setup Help
**If you need help getting Supabase keys:**
👉 **`SUPABASE_KEYS_SETUP.md`**

### ✅ Checklist
**Use this to verify everything is set up correctly:**
👉 **`INTEGRATION_CHECKLIST.md`**

---

## 🎯 What You'll Do

1. **Get Supabase Keys** (2 min)
   - Copy Project URL, anon key, service_role key

2. **Set Up Database** (5 min)
   - Run SQL schema
   - Create storage buckets

3. **Configure Backend** (5 min)
   - Install dependencies
   - Create .env file
   - Add Supabase keys
   - Start server

4. **Configure Flutter App** (3 min)
   - Update API URL
   - Switch to backend auth

5. **Test** (5 min)
   - Register user
   - Login
   - Verify in Supabase

---

## ⚡ Quick Start (Copy-Paste Commands)

### 1. Get Supabase Keys
1. Go to [supabase.com](https://supabase.com) → Your Project
2. Settings → API → Copy keys

### 2. Set Up Database
1. SQL Editor → New Query
2. Copy `backend/database/schema.sql` → Paste → Run
3. Storage → Create buckets: `property-images`, `avatars` (both public)

### 3. Backend Setup
```bash
cd backend
npm install
# Create .env file (copy ENV_TEMPLATE.txt to .env)
# Edit .env with your Supabase keys
npm run dev
```

### 4. Flutter Setup
```bash
# Update lib/services/config_service.dart
# Change apiBaseUrl to: http://10.0.2.2:3000/api (Android) or http://localhost:3000/api (iOS)

# Switch to backend auth (optional)
mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
```

### 5. Test
```bash
flutter run
# Register user → Login → Verify in Supabase
```

---

## 🗂️ File Structure

```
Estato/
├── backend/
│   ├── .env                    # ← Create this with your Supabase keys
│   ├── ENV_TEMPLATE.txt        # ← Template for .env file
│   ├── database/
│   │   └── schema.sql          # ← Run this in Supabase SQL Editor
│   └── server.js
├── lib/
│   ├── services/
│   │   ├── api_client.dart     # ← Already configured
│   │   └── config_service.dart # ← Update API URL here
│   └── providers/
│       ├── auth_provider.dart           # ← Demo version (current)
│       └── auth_provider_backend.dart   # ← Backend version (switch to this)
└── QUICK_SUPABASE_SETUP.md     # ← Start here!
```

---

## 📋 Prerequisites Checklist

Before starting, make sure you have:

- [x] Supabase account created ✅ (You have this!)
- [ ] Node.js installed (download from nodejs.org)
- [ ] Flutter app ready
- [ ] Code editor ready

---

## 🎓 Step-by-Step Flow

```
1. Supabase Dashboard
   └─ Get API Keys (Project URL, anon key, service_role key)

2. Supabase SQL Editor
   └─ Run schema.sql → Create tables

3. Supabase Storage
   └─ Create buckets (property-images, avatars)

4. Backend Folder
   └─ npm install → Create .env → Add keys → npm run dev

5. Flutter App
   └─ Update config_service.dart → Switch auth provider

6. Test
   └─ Run app → Register → Login → Verify
```

---

## 🐛 Common Issues

### "Cannot connect to backend"
- ✅ Check backend is running: `npm run dev`
- ✅ Check API URL in `config_service.dart`
- ✅ For physical device, use your computer's IP

### "401 Unauthorized"
- ✅ Check Supabase keys in `.env` file
- ✅ Verify database schema is created
- ✅ Restart backend server

### "Missing Supabase configuration"
- ✅ Check `.env` file exists
- ✅ Verify keys are correct
- ✅ No extra spaces in keys

---

## 📞 Need Help?

1. **Check the guides:**
   - `QUICK_SUPABASE_SETUP.md` - Quick setup
   - `SUPABASE_INTEGRATION_STEP_BY_STEP.md` - Detailed guide
   - `SUPABASE_KEYS_SETUP.md` - Keys help

2. **Check backend terminal** for error messages

3. **Check Supabase Dashboard** for database issues

4. **Verify all steps** in `INTEGRATION_CHECKLIST.md`

---

## ✅ Success Criteria

You'll know it's working when:

1. ✅ Backend server runs without errors
2. ✅ Can register new users from app
3. ✅ Can login with registered credentials
4. ✅ Users appear in Supabase Authentication
5. ✅ User profiles created in database

---

## 🚀 Ready to Start?

👉 **Open `QUICK_SUPABASE_SETUP.md` and follow the steps!**

---

**Last Updated:** November 4, 2025

