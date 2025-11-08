# ✅ Your Supabase Keys - Ready to Use!

## 🎉 Great! I've prepared your configuration file.

Your Supabase keys have been extracted and configured:

- ✅ **Project URL:** `https://yapmbzqzahsyuxxdejpq.supabase.co`
- ✅ **Anon Key:** Configured
- ✅ **Service Role Key:** Configured

---

## 📝 Step 1: Create .env File (2 minutes)

### Option A: Manual Creation (Recommended)

1. **Navigate to Backend Folder**
   - Open `backend` folder in your code editor

2. **Create New File**
   - Create a new file named `.env` (with the dot at the beginning)
   - Make sure it's in the `backend` folder

3. **Copy Contents**
   - Open `backend/YOUR_ENV_FILE.txt`
   - Copy ALL contents
   - Paste into your new `.env` file
   - Save the file

### Option B: Using Terminal

**Windows (PowerShell):**
```powershell
cd backend
Copy-Item YOUR_ENV_FILE.txt .env
```

**Mac/Linux:**
```bash
cd backend
cp YOUR_ENV_FILE.txt .env
```

---

## 🗄️ Step 2: Set Up Database (5 minutes)

### 2.1 Run Database Schema

1. **Go to Supabase Dashboard**
   - Visit: [https://supabase.com/dashboard](https://supabase.com/dashboard)
   - Login and select your project

2. **Open SQL Editor**
   - Click **SQL Editor** in left sidebar
   - Click **New Query**

3. **Run Schema**
   - Open file: `backend/database/schema.sql`
   - Copy ALL contents (Ctrl+A, Ctrl+C)
   - Paste into Supabase SQL Editor
   - Click **Run** button (or press Ctrl+Enter)
   - Wait for ✅ "Success. No rows returned" message

4. **Verify Tables**
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

### 2.2 Create Storage Buckets

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

---

## ⚙️ Step 3: Install and Start Backend (3 minutes)

### 3.1 Install Dependencies

1. **Open Terminal in Backend Folder**
   ```bash
   cd backend
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```
   Wait 2-3 minutes for installation.

### 3.2 Start Backend Server

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

   **✅ Keep this terminal open!** Server needs to keep running.

---

## 📱 Step 4: Configure Flutter App (2 minutes)

### 4.1 Update API URL

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
   - Find your computer's IP:
     - **Windows:** Open CMD → `ipconfig` → Look for "IPv4 Address"
     - **Mac/Linux:** Open Terminal → `ifconfig` → Look for "inet"
   - Use your IP:
   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:3000/api';
   ```
   (Replace `192.168.1.100` with your actual IP)

### 4.2 Switch to Backend Auth (Optional)

**Using Terminal:**
```bash
# Backup demo provider
mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart

# Use backend provider
mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
```

**Or manually in your IDE:**
- Rename `auth_provider.dart` → `auth_provider_demo.dart`
- Rename `auth_provider_backend.dart` → `auth_provider.dart`

---

## 🧪 Step 5: Test Everything (5 minutes)

### 5.1 Make Sure Backend is Running
- Check terminal: Should see "Server running on port 3000"
- If not, run: `cd backend && npm run dev`

### 5.2 Run Flutter App
```bash
flutter run
```

### 5.3 Test Registration
1. App opens → Splash screen
2. Onboarding screen (first time)
3. Click "Get Started" → Login screen
4. Click "Register"
5. Fill form:
   - Name: Test User
   - Email: test@example.com
   - Phone: +91 9876543210
   - User Type: Buyer
   - Password: test123
   - Confirm Password: test123
6. Click "Create Account"
7. Should navigate to Home screen ✅

### 5.4 Test Login
1. Go to Profile → Logout
2. Enter email: `test@example.com`
3. Enter password: `test123`
4. Click "Login"
5. Should navigate to Home screen ✅

### 5.5 Verify in Supabase
1. Go to Supabase Dashboard
2. Click **Authentication** → **Users**
3. You should see your registered user ✅
4. Click **Table Editor** → **users**
5. You should see user profile ✅

---

## ✅ Quick Checklist

- [ ] Created `.env` file in `backend` folder
- [ ] Copied contents from `YOUR_ENV_FILE.txt`
- [ ] Database schema executed in Supabase
- [ ] Storage buckets created (property-images, avatars)
- [ ] Backend dependencies installed (`npm install`)
- [ ] Backend server running (`npm run dev`)
- [ ] Health check working (`http://localhost:3000/health`)
- [ ] Flutter app API URL configured
- [ ] Registration working
- [ ] Login working
- [ ] User appears in Supabase

---

## 🐛 Troubleshooting

### ".env file not found" error
- ✅ Make sure file is named `.env` (with dot at beginning)
- ✅ Make sure it's in `backend` folder
- ✅ Check file is saved

### "Missing Supabase configuration" error
- ✅ Check `.env` file exists
- ✅ Verify keys are correct (no extra spaces)
- ✅ Restart backend server

### Cannot connect from Flutter
- ✅ Check backend is running
- ✅ Verify API URL is correct
- ✅ For physical device, use your computer's IP

### 401 Unauthorized
- ✅ Verify database schema is created
- ✅ Check Supabase keys are correct
- ✅ Restart backend server

---

## 🎉 Success!

Once all steps are complete and tests pass, your Supabase integration is complete!

**Your Configuration:**
- ✅ Supabase Project: `yapmbzqzahsyuxxdejpq`
- ✅ Project URL: `https://yapmbzqzahsyuxxdejpq.supabase.co`
- ✅ Keys configured in `.env` file
- ✅ Ready to connect!

---

## 🚀 Next Steps

1. Follow the steps above
2. Test registration and login
3. Verify in Supabase Dashboard
4. Start building features!

---

**Need Help?** See `SETUP_COMPLETE_NEXT_STEPS.md` for detailed instructions.

---

**Last Updated:** November 4, 2025

