# ✅ Supabase Keys Configured - Next Steps

## 🎉 Great! Your Supabase keys are now configured.

I've created your `.env` file with your Supabase credentials:
- ✅ Project URL: `https://yapmbzqzahsyuxxdejpq.supabase.co`
- ✅ Anon Key: Configured
- ✅ Service Role Key: Configured

---

## 📋 Next Steps to Complete Integration

### Step 1: Set Up Database Schema (5 minutes)

1. **Go to Supabase Dashboard**
   - Visit [supabase.com](https://supabase.com)
   - Login and select your project

2. **Open SQL Editor**
   - Click **SQL Editor** in left sidebar
   - Click **New Query**

3. **Run Database Schema**
   - Open file: `backend/database/schema.sql`
   - Copy ALL contents (Ctrl+A, Ctrl+C)
   - Paste into Supabase SQL Editor
   - Click **Run** button
   - Wait for ✅ "Success" message

4. **Verify Tables Created**
   - Click **Table Editor** in left sidebar
   - You should see these tables:
     - ✅ users
     - ✅ properties
     - ✅ favorites
     - ✅ chats
     - ✅ messages
     - ✅ bookings
     - ✅ payments
     - ✅ reports
     - ✅ notifications

### Step 2: Create Storage Buckets (3 minutes)

1. **Go to Storage**
   - Click **Storage** in left sidebar

2. **Create Property Images Bucket**
   - Click **Create a new bucket**
   - **Name:** `property-images`
   - **Public bucket:** ✅ **YES** (toggle ON)
   - Click **Create bucket**

3. **Create Avatars Bucket**
   - Click **Create a new bucket** again
   - **Name:** `avatars`
   - **Public bucket:** ✅ **YES** (toggle ON)
   - Click **Create bucket**

4. **Set Storage Policies** (Optional but Recommended)
   - Go to **SQL Editor**
   - Open `backend/database/storage-setup.md`
   - Copy the SQL code
   - Paste and run in SQL Editor

### Step 3: Install Backend Dependencies (2 minutes)

1. **Open Terminal in Backend Folder**
   ```bash
   cd backend
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```
   Wait for installation to complete (2-3 minutes)

### Step 4: Start Backend Server (1 minute)

1. **Start Server**
   ```bash
   npm run dev
   ```

2. **Verify Server Running**
   You should see:
   ```
   🚀 Estato API Server running on port 3000
   📝 Environment: development
   🔗 Health check: http://localhost:3000/health
   ```

3. **Test Backend**
   - Open browser: `http://localhost:3000/health`
   - Should see: `{"success":true,"message":"Estato API is running"}`

   **Keep this terminal open!** Server needs to keep running.

### Step 5: Configure Flutter App (2 minutes)

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
   - Find your computer's IP address:
     - **Windows:** Open CMD → `ipconfig` → Look for "IPv4 Address"
     - **Mac/Linux:** Open Terminal → `ifconfig` → Look for "inet"
   - Use your IP:
   ```dart
   static const String apiBaseUrl = 'http://YOUR_IP:3000/api';
   ```

2. **Switch to Backend Auth** (Optional but Recommended)

   **Option A: Using Terminal**
   ```bash
   # Backup demo provider
   mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
   
   # Use backend provider
   mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
   ```

   **Option B: Manual (in your IDE)**
   - Rename `auth_provider.dart` → `auth_provider_demo.dart`
   - Rename `auth_provider_backend.dart` → `auth_provider.dart`

### Step 6: Test Integration (5 minutes)

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
   - Click **Table Editor** → **users**
   - You should see user profile ✅

---

## ✅ Verification Checklist

Use this checklist to verify everything is set up:

- [ ] Database schema executed in Supabase
- [ ] Storage buckets created (property-images, avatars)
- [ ] Backend dependencies installed (`npm install`)
- [ ] Backend server running (`npm run dev`)
- [ ] Health check working (`http://localhost:3000/health`)
- [ ] Flutter app API URL configured
- [ ] Backend auth provider enabled (optional)
- [ ] Registration working
- [ ] Login working
- [ ] User appears in Supabase Authentication
- [ ] User profile created in database

---

## 🐛 Troubleshooting

### Backend won't start

**Error:** `Missing Supabase configuration`

**Solution:**
- ✅ Your `.env` file is already created with correct keys
- Check if file is in `backend` folder
- Verify no extra spaces in keys
- Try: `cd backend && npm run dev`

### Cannot connect from Flutter

**Error:** `Network error` or `Connection refused`

**Solutions:**
1. **Check Backend is Running**
   ```bash
   curl http://localhost:3000/health
   ```

2. **Check API URL in Flutter**
   - Android Emulator: `http://10.0.2.2:3000/api`
   - iOS Simulator: `http://localhost:3000/api`
   - Physical Device: Your computer's IP

3. **Check Firewall**
   - Allow Node.js through firewall
   - Allow port 3000

### 401 Unauthorized

**Error:** `Invalid or expired token`

**Solutions:**
1. ✅ Your Supabase keys are correct (already configured)
2. Verify database schema is created
3. Check RLS policies are set
4. Restart backend server

### Registration fails

**Error:** `User already exists` or `Validation failed`

**Solutions:**
1. Use a unique email address
2. Check password is at least 6 characters
3. Check backend terminal for error details

---

## 🎉 Success!

Once all steps are complete and tests pass, your Supabase integration is complete!

**What's Working:**
- ✅ Supabase keys configured
- ✅ Backend connected to Supabase
- ✅ User registration
- ✅ User login
- ✅ User data stored in database

---

## 📞 Need Help?

If you encounter issues:

1. **Check Backend Terminal** for error messages
2. **Check Supabase Dashboard** for database issues
3. **Verify Database Schema** is created
4. **Check Storage Buckets** are created
5. **Verify API URL** in Flutter app

---

## 🚀 Next Steps After Integration

1. Test all authentication flows
2. Add property features
3. Add favorites functionality
4. Add chat functionality
5. Test on physical device
6. Deploy backend to production
7. Deploy Flutter app

---

**Your Supabase Project URL:** `https://yapmbzqzahsyuxxdejpq.supabase.co`

**Backend .env file:** ✅ Created and configured

**Next:** Follow the steps above to complete the integration!

---

**Last Updated:** November 4, 2025

