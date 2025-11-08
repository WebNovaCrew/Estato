# ⚡ Quick Supabase Integration - 15 Minutes

## 🎯 Goal
Connect your Flutter app to Supabase for authentication (login/register).

---

## 📋 Step 1: Get Supabase Keys (2 minutes)

1. **Go to Supabase Dashboard**
   - Visit [supabase.com](https://supabase.com)
   - Login to your account
   - Click on your project

2. **Get API Keys**
   - Click **Settings** (⚙️ icon) → **API**
   - Copy these 3 values:
     - **Project URL:** `https://xxxxx.supabase.co`
     - **anon public key:** `eyJhbGciOiJIUzI1NiIs...` (long string)
     - **service_role key:** `eyJhbGciOiJIUzI1NiIs...` (long string)

3. **Save them** - You'll need them in Step 3

---

## 🗄️ Step 2: Set Up Database (5 minutes)

1. **Open SQL Editor**
   - In Supabase Dashboard, click **SQL Editor**
   - Click **New Query**

2. **Run Database Schema**
   - Open file: `backend/database/schema.sql`
   - Copy ALL contents (Ctrl+A, Ctrl+C)
   - Paste into SQL Editor
   - Click **Run** button
   - Wait for ✅ "Success" message

3. **Create Storage Buckets**
   - Click **Storage** in left sidebar
   - Click **Create a new bucket**
   - Name: `property-images`, Public: **YES** ✅
   - Click **Create bucket**
   - Repeat for `avatars` bucket

---

## ⚙️ Step 3: Configure Backend (5 minutes)

1. **Open Terminal in Backend Folder**
   ```bash
   cd backend
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```
   Wait 2-3 minutes for installation.

3. **Create .env File**

   **Windows:**
   ```bash
   copy .env.example .env
   ```

   **Mac/Linux:**
   ```bash
   cp .env.example .env
   ```

4. **Edit .env File**
   - Open `backend/.env` in your code editor
   - Replace these lines with your Supabase keys:

   ```env
   SUPABASE_URL=https://your-actual-project-url.supabase.co
   SUPABASE_ANON_KEY=your_actual_anon_key_here
   SUPABASE_SERVICE_ROLE_KEY=your_actual_service_role_key_here
   JWT_SECRET=any_random_string_here_123456789
   ```

5. **Start Backend Server**
   ```bash
   npm run dev
   ```

   You should see:
   ```
   🚀 Estato API Server running on port 3000
   ```

   **Keep this terminal open!**

6. **Test Backend**
   - Open browser: `http://localhost:3000/health`
   - Should see: `{"success":true,"message":"Estato API is running"}`

---

## 📱 Step 4: Configure Flutter App (3 minutes)

1. **Update API URL**

   Open `lib/services/config_service.dart`

   **For Android Emulator:**
   ```dart
   static const String apiBaseUrl = 'http://10.0.2.2:3000/api';
   ```

   **For iOS Simulator:**
   ```dart
   static const String apiBaseUrl = 'http://localhost:3000/api';
   ```

   **For Physical Device:**
   - Find your computer's IP:
     - Windows: Open CMD → `ipconfig` → Look for "IPv4 Address"
     - Mac: Open Terminal → `ifconfig` → Look for "inet"
   - Use: `http://YOUR_IP:3000/api`

2. **Switch to Backend Auth** (Optional but Recommended)

   **Option A: Rename Files**
   ```bash
   # Backup demo provider
   mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
   
   # Use backend provider
   mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
   ```

   **Option B: Manual** (in your IDE)
   - Rename `auth_provider.dart` → `auth_provider_demo.dart`
   - Rename `auth_provider_backend.dart` → `auth_provider.dart`

---

## 🧪 Step 5: Test Everything (5 minutes)

1. **Make Sure Backend is Running**
   - Check terminal: Should see "Server running on port 3000"
   - If not, run: `cd backend && npm run dev`

2. **Run Flutter App**
   ```bash
   flutter run
   ```

3. **Test Registration**
   - App opens → Splash screen
   - Onboarding screen (first time)
   - Click "Get Started" → Login screen
   - Click "Register"
   - Fill form:
     - Name: Test User
     - Email: test@example.com
     - Phone: +91 9876543210
     - User Type: Buyer
     - Password: test123
     - Confirm Password: test123
   - Click "Create Account"
   - Should navigate to Home screen ✅

4. **Test Login**
   - Go to Profile → Logout
   - Enter email: `test@example.com`
   - Enter password: `test123`
   - Click "Login"
   - Should navigate to Home screen ✅

5. **Verify in Supabase**
   - Go to Supabase Dashboard
   - Click **Authentication** → **Users**
   - You should see your registered user ✅

---

## ✅ Success!

If all steps work, your Supabase integration is complete! 🎉

**What's Working:**
- ✅ User registration with Supabase
- ✅ User login with Supabase  
- ✅ User data stored in database
- ✅ Authentication working

---

## 🐛 Troubleshooting

### Backend won't start
- Check `.env` file exists
- Verify Supabase keys are correct
- Make sure no extra spaces in keys

### Cannot connect from Flutter
- Check backend is running
- Verify API URL is correct
- For physical device, use your computer's IP

### Registration fails
- Check backend terminal for errors
- Verify database schema is created
- Check Supabase Dashboard

### 401 Unauthorized
- Verify Supabase keys in `.env`
- Check keys are correct
- Restart backend server

---

## 📚 Next Steps

1. Test all authentication flows
2. Add more features (properties, favorites, etc.)
3. Deploy backend to production
4. Deploy Flutter app

---

## 📞 Need More Help?

See detailed guides:
- `SUPABASE_INTEGRATION_STEP_BY_STEP.md` - Detailed step-by-step
- `SUPABASE_KEYS_SETUP.md` - How to get and set keys
- `INTEGRATION_CHECKLIST.md` - Checklist for verification

---

**Last Updated:** November 4, 2025

