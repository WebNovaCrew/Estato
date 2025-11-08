# 🔗 Supabase Integration - Step by Step Guide

## 📋 Prerequisites
- ✅ Supabase account created
- ✅ Node.js installed (for backend)
- ✅ Flutter app ready

---

## 🎯 Step 1: Get Supabase API Keys (5 minutes)

### 1.1 Access Your Supabase Project

1. **Login to Supabase**
   - Go to [supabase.com](https://supabase.com)
   - Login with your account

2. **Select Your Project**
   - Click on your project (or create a new one if needed)
   - Wait for project to be fully loaded

### 1.2 Get API Keys

1. **Go to Project Settings**
   - Click on the **⚙️ Settings** icon (bottom left)
   - Click on **API** in the sidebar

2. **Copy Required Keys**
   You'll need these 3 values:
   
   ```
   Project URL: https://xxxxx.supabase.co
   anon public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

3. **Save These Keys Securely**
   - Create a text file to store them temporarily
   - You'll need them in the next steps

---

## 🗄️ Step 2: Set Up Database Schema (10 minutes)

### 2.1 Open SQL Editor

1. **Navigate to SQL Editor**
   - Click on **SQL Editor** in the left sidebar
   - Click on **New Query**

### 2.2 Run Database Schema

1. **Open Schema File**
   - Open `backend/database/schema.sql` in your code editor
   - Copy ALL the contents (Ctrl+A, Ctrl+C)

2. **Paste and Run**
   - Paste the SQL code into Supabase SQL Editor
   - Click **Run** button (or press Ctrl+Enter)
   - Wait for success message: ✅ "Success. No rows returned"

3. **Verify Tables Created**
   - Click on **Table Editor** in the left sidebar
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

### 2.3 Set Up Storage Buckets (5 minutes)

1. **Navigate to Storage**
   - Click on **Storage** in the left sidebar

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

4. **Set Storage Policies**
   - Go back to **SQL Editor**
   - Open `backend/database/storage-setup.md`
   - Copy the SQL code from that file
   - Paste and run in SQL Editor

---

## ⚙️ Step 3: Configure Backend (10 minutes)

### 3.1 Navigate to Backend Folder

```bash
cd backend
```

### 3.2 Install Dependencies

```bash
npm install
```

Wait for installation to complete (this may take 2-3 minutes)

### 3.3 Create Environment File

**Windows:**
```bash
copy .env.example .env
```

**Mac/Linux:**
```bash
cp .env.example .env
```

### 3.4 Edit .env File

1. **Open `.env` file** in your code editor
2. **Replace these values** with your Supabase keys:

```env
# Server Configuration
PORT=3000
NODE_ENV=development

# Supabase Configuration (REPLACE WITH YOUR KEYS)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# JWT Configuration
JWT_SECRET=your_random_secret_key_here_make_it_long_and_random

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

# OTP Configuration (Optional - leave as is for now)
OTP_EXPIRE_MINUTES=10
OTP_LENGTH=6

# App Configuration
APP_NAME=Estato
APP_URL=http://localhost:3000
```

**Important:**
- Replace `https://xxxxx.supabase.co` with your **Project URL**
- Replace `your_anon_key_here` with your **anon public key**
- Replace `your_service_role_key_here` with your **service_role key**
- Replace `your_random_secret_key_here...` with a random string (you can use: `openssl rand -base64 32`)

### 3.5 Start Backend Server

```bash
npm run dev
```

You should see:
```
🚀 Estato API Server running on port 3000
📝 Environment: development
🔗 Health check: http://localhost:3000/health
```

**Keep this terminal window open!** The server needs to keep running.

### 3.6 Test Backend Connection

1. **Open Browser**
   - Go to: `http://localhost:3000/health`
   - You should see: `{"success":true,"message":"Estato API is running"}`

2. **Test Registration Endpoint** (Optional)
   - You can test with Postman or curl:
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

---

## 📱 Step 4: Configure Flutter App (5 minutes)

### 4.1 Update API Base URL

1. **Open Config Service**
   - File: `lib/services/config_service.dart`

2. **Update API URL**

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
   - Replace `192.168.1.100` with your IP:
   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:3000/api';
   ```

### 4.2 Switch to Backend Authentication

1. **Backup Demo Provider** (Optional - for safety)
   ```bash
   # In project root
   mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
   ```

2. **Use Backend Provider**
   ```bash
   mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
   ```

**OR** manually rename the files in your IDE:
- Rename `auth_provider.dart` → `auth_provider_demo.dart`
- Rename `auth_provider_backend.dart` → `auth_provider.dart`

### 4.3 Verify App is Ready

1. **Check Files Exist**
   - ✅ `lib/services/api_client.dart` exists
   - ✅ `lib/services/config_service.dart` exists
   - ✅ `lib/providers/auth_provider.dart` exists (backend version)

---

## 🧪 Step 5: Test Integration (10 minutes)

### 5.1 Start Backend Server

Make sure backend is running:
```bash
cd backend
npm run dev
```

### 5.2 Run Flutter App

```bash
# In project root
flutter run
```

### 5.3 Test Registration Flow

1. **Open App**
   - Splash screen appears
   - Onboarding screen appears (first time)
   - Click "Get Started" or "Skip"

2. **Register New User**
   - Click "Register" on login screen
   - Fill in the form:
     - **Name:** Your Name
     - **Email:** your.email@example.com
     - **Phone:** +91 9876543210
     - **User Type:** Select one (e.g., Buyer)
     - **Password:** test123
     - **Confirm Password:** test123
   - Click "Create Account"

3. **Check for Success**
   - Should navigate to Home screen
   - If error appears, check backend terminal for details

### 5.4 Test Login Flow

1. **Logout** (if logged in)
   - Go to Profile → Logout

2. **Login**
   - Enter email: `your.email@example.com`
   - Enter password: `test123`
   - Click "Login"

3. **Check for Success**
   - Should navigate to Home screen
   - User should be logged in

### 5.5 Verify in Supabase

1. **Check User Created**
   - Go to Supabase Dashboard
   - Click on **Authentication** → **Users**
   - You should see your registered user

2. **Check Database**
   - Go to **Table Editor** → **users**
   - You should see your user profile

---

## 🔧 Step 6: Troubleshooting

### Issue: Backend won't start

**Error:** `Missing Supabase configuration`

**Solution:**
- Check `.env` file exists
- Verify all Supabase keys are correct
- Make sure no extra spaces in `.env` file

### Issue: Cannot connect to backend from Flutter

**Error:** `Network error` or `Connection refused`

**Solutions:**
1. **Check Backend is Running**
   ```bash
   curl http://localhost:3000/health
   ```

2. **Check API URL**
   - Android Emulator: Use `http://10.0.2.2:3000/api`
   - iOS Simulator: Use `http://localhost:3000/api`
   - Physical Device: Use your computer's IP address

3. **Check Firewall**
   - Allow Node.js through firewall
   - Allow port 3000

### Issue: 401 Unauthorized

**Error:** `Invalid or expired token`

**Solutions:**
1. **Check Supabase Keys**
   - Verify keys in `.env` are correct
   - Make sure you're using the right keys (anon vs service_role)

2. **Check Database Schema**
   - Verify all tables are created
   - Check RLS policies are set

### Issue: Registration fails

**Error:** `User already exists` or `Validation failed`

**Solutions:**
1. **Check Email**
   - Use a unique email address
   - Verify email format is correct

2. **Check Password**
   - Minimum 6 characters
   - Check password meets requirements

3. **Check Backend Logs**
   - Look at backend terminal for error details

### Issue: CORS Error

**Error:** `CORS policy: No 'Access-Control-Allow-Origin'`

**Solutions:**
1. **Update ALLOWED_ORIGINS**
   - Add your Flutter app URL to `.env`:
   ```
   ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://10.0.2.2:3000
   ```

2. **Restart Backend**
   ```bash
   # Stop server (Ctrl+C)
   npm run dev
   ```

---

## ✅ Verification Checklist

Before considering integration complete, verify:

- [ ] Supabase project created and active
- [ ] Database schema executed successfully
- [ ] Storage buckets created (property-images, avatars)
- [ ] Backend `.env` file configured with Supabase keys
- [ ] Backend server running on port 3000
- [ ] Health check endpoint working
- [ ] Flutter app API URL configured correctly
- [ ] Backend auth provider being used
- [ ] Registration working
- [ ] Login working
- [ ] User appears in Supabase Authentication
- [ ] User profile created in database

---

## 🎉 Success!

If all steps are completed and tests pass, your Supabase integration is complete!

**What's Working:**
- ✅ User registration with Supabase
- ✅ User login with Supabase
- ✅ User data stored in database
- ✅ Authentication tokens managed
- ✅ Backend API connected to Supabase

**Next Steps:**
1. Test all authentication flows
2. Add more features (properties, favorites, etc.)
3. Deploy backend to production
4. Deploy Flutter app

---

## 📞 Need Help?

If you encounter issues:
1. Check backend terminal for error messages
2. Check Supabase Dashboard for database issues
3. Verify all API keys are correct
4. Check network connectivity
5. Review error messages in Flutter app

---

**Last Updated:** November 4, 2025

