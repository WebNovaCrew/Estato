# 🚀 Complete Authentication Guide - From Onboarding to Backend

## 📋 Table of Contents

1. [Overview](#overview)
2. [App Flow](#app-flow)
3. [Step 1: Set Up Supabase](#step-1-set-up-supabase)
4. [Step 2: Set Up Backend](#step-2-set-up-backend)
5. [Step 3: Configure Flutter App](#step-3-configure-flutter-app)
6. [Step 4: Update Authentication](#step-4-update-authentication)
7. [Step 5: Test Complete Flow](#step-5-test-complete-flow)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This guide will walk you through setting up complete authentication from the onboarding screen to backend integration using Supabase.

**Complete Flow:**
1. Splash Screen → Shows app logo
2. Onboarding Screen → Shows app features (first time only)
3. Login/Register Screen → User authentication
4. Home Screen → Main app (after authentication)

---

## 📱 App Flow

### Current Flow (Demo Mode)
```
Splash Screen (3 seconds)
    ↓
Onboarding Screen (4 slides)
    ↓
Login Screen
    ↓
Home Screen (after login)
```

### Backend Integrated Flow
```
Splash Screen (3 seconds)
    ↓
Check: Has seen onboarding? (from SharedPreferences)
    ├─ No → Onboarding Screen
    └─ Yes → Check: Is logged in? (from backend)
        ├─ Yes → Home Screen
        └─ No → Login Screen
```

---

## 🔧 Step 1: Set Up Supabase

### 1.1 Create Supabase Project

1. **Go to Supabase**
   - Visit [supabase.com](https://supabase.com)
   - Sign up or login
   - Click "New Project"

2. **Configure Project**
   - **Name:** `estato-app`
   - **Database Password:** (save this securely)
   - **Region:** Choose closest to you
   - Click "Create new project"

3. **Wait for Setup** (2-3 minutes)
   - Wait for project to be fully created

### 1.2 Get API Keys

1. **Go to Project Settings**
   - Click on your project
   - Go to Settings → API

2. **Copy Keys**
   - **Project URL:** `https://xxxxx.supabase.co`
   - **anon public key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - **service_role key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (keep secret!)

### 1.3 Set Up Database

1. **Go to SQL Editor**
   - Click "SQL Editor" in left sidebar
   - Click "New Query"

2. **Run Schema SQL**
   - Copy contents of `backend/database/schema.sql`
   - Paste into SQL Editor
   - Click "Run" (or press Ctrl+Enter)
   - Wait for success message

3. **Verify Tables Created**
   - Go to "Table Editor"
   - You should see these tables:
     - `users`
     - `properties`
     - `favorites`
     - `chats`
     - `messages`
     - `bookings`
     - `payments`
     - `reports`
     - `notifications`

### 1.4 Set Up Storage

1. **Create Storage Buckets**
   - Go to "Storage" in left sidebar
   - Click "Create a new bucket"
   - **Name:** `property-images`
   - **Public bucket:** ✅ Yes
   - Click "Create bucket"
   - Repeat for `avatars` bucket

2. **Set Storage Policies**
   - Go to SQL Editor
   - Run SQL from `backend/database/storage-setup.md`
   - Or manually set policies in Storage → Policies

---

## 🖥️ Step 2: Set Up Backend

### 2.1 Install Node.js

1. **Download Node.js**
   - Visit [nodejs.org](https://nodejs.org)
   - Download LTS version (18+)
   - Install it

2. **Verify Installation**
   ```bash
   node --version
   npm --version
   ```

### 2.2 Configure Backend

1. **Navigate to Backend**
   ```bash
   cd backend
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Create Environment File**
   ```bash
   # Windows
   copy .env.example .env
   
   # Mac/Linux
   cp .env.example .env
   ```

4. **Edit .env File**
   Open `backend/.env` and add:
   ```env
   # Server
   PORT=3000
   NODE_ENV=development

   # Supabase (from Step 1.2)
   SUPABASE_URL=https://xxxxx.supabase.co
   SUPABASE_ANON_KEY=your_anon_key_here
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

   # JWT
   JWT_SECRET=your_random_secret_key_here

   # CORS
   ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

   # OTP (Optional - for SMS)
   TWILIO_ACCOUNT_SID=your_twilio_sid
   TWILIO_AUTH_TOKEN=your_twilio_token
   TWILIO_PHONE_NUMBER=+1234567890

   # Payments (Optional - for Razorpay)
   RAZORPAY_KEY_ID=your_razorpay_key
   RAZORPAY_KEY_SECRET=your_razorpay_secret
   ```

### 2.3 Start Backend Server

1. **Start Server**
   ```bash
   npm run dev
   ```

2. **Verify Server Running**
   - You should see: `🚀 Estato API Server running on port 3000`
   - Open browser: `http://localhost:3000/health`
   - You should see: `{"success":true,"message":"Estato API is running"}`

3. **Test Registration Endpoint**
   ```bash
   # Using curl (or Postman)
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

   Expected response:
   ```json
   {
     "success": true,
     "message": "User registered successfully. Please verify your email.",
     "data": {
       "user": {...},
       "session": {...}
     }
   }
   ```

---

## 📱 Step 3: Configure Flutter App

### 3.1 Update API Base URL

1. **Open Config Service**
   - File: `lib/services/config_service.dart`

2. **Update API URL**
   ```dart
   // For Android Emulator
   static const String apiBaseUrl = 'http://10.0.2.2:3000/api';
   
   // For iOS Simulator
   static const String apiBaseUrl = 'http://localhost:3000/api';
   
   // For Physical Device (use your computer's IP)
   static const String apiBaseUrl = 'http://192.168.1.100:3000/api';
   ```

   **How to find your IP:**
   - Windows: `ipconfig` → Look for "IPv4 Address"
   - Mac/Linux: `ifconfig` → Look for "inet"

### 3.2 Update Splash Screen

1. **Open Splash Screen**
   - File: `lib/screens/splash_screen.dart`

2. **Update Navigation Logic**
   ```dart
   Timer(const Duration(seconds: 3), () async {
     final prefs = await SharedPreferences.getInstance();
     final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
     
     if (!hasSeenOnboarding) {
       // First time - show onboarding
       Navigator.of(context).pushReplacementNamed('/onboarding');
     } else {
       // Check if user is logged in
       final authProvider = Provider.of<AuthProvider>(context, listen: false);
       await authProvider.checkLoginStatus();
       
       if (authProvider.isLoggedIn) {
         Navigator.of(context).pushReplacementNamed('/home');
       } else {
         Navigator.of(context).pushReplacementNamed('/login');
       }
     }
   });
   ```

### 3.3 Update Onboarding Screen

1. **Open Onboarding Screen**
   - File: `lib/screens/onboarding/onboarding_screen.dart`

2. **Update Navigation to Save Flag**
   ```dart
   void _goToLogin() async {
     // Save that user has seen onboarding
     final prefs = await SharedPreferences.getInstance();
     await prefs.setBool('has_seen_onboarding', true);
     
     Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (context) => const LoginScreen()),
     );
   }
   ```

---

## 🔐 Step 4: Update Authentication

### 4.1 Option A: Use Backend Auth Provider (Recommended)

1. **Backup Demo Provider**
   ```bash
   # Rename demo provider
   mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
   ```

2. **Use Backend Provider**
   ```bash
   # Rename backend provider
   mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
   ```

3. **Update Main.dart**
   - File: `lib/main.dart`
   - No changes needed - it already uses `AuthProvider`

### 4.2 Option B: Update Existing Auth Provider

1. **Open Auth Provider**
   - File: `lib/providers/auth_provider.dart`

2. **Replace Login Method**
   ```dart
   Future<void> login(String email, String password) async {
     _isLoading = true;
     notifyListeners();

     try {
       final response = await ApiClient.login(email: email, password: password);

       if (response['success'] == true && response['data'] != null) {
         final userData = response['data']['user'];
         final profile = userData['profile'] ?? userData;

         _currentUser = User(
           id: userData['id'] ?? profile['id'],
           name: profile['name'] ?? userData['email']?.split('@')[0] ?? 'User',
           email: userData['email'] ?? profile['email'],
           phone: profile['phone'] ?? '+91 9876543210',
           userType: _parseUserType(profile['user_type'] ?? 'both'),
           profileImage: profile['avatar_url'],
           createdAt: profile['created_at'] != null
               ? DateTime.parse(profile['created_at'])
               : DateTime.now(),
         );

         _isLoggedIn = true;

         // Save to local storage
         final prefs = await SharedPreferences.getInstance();
         await prefs.setBool('isLoggedIn', true);
         await prefs.setString('userId', _currentUser!.id);
         await prefs.setString('userName', _currentUser!.name);
         await prefs.setString('userEmail', _currentUser!.email);
         await prefs.setString('userPhone', _currentUser!.phone);
         await prefs.setString('userType', _currentUser!.userType.toString());

         _isLoading = false;
         notifyListeners();
       } else {
         _isLoading = false;
         notifyListeners();
         throw Exception(response['error'] ?? 'Login failed');
       }
     } catch (e) {
       _isLoading = false;
       notifyListeners();
       throw Exception('Login error: ${e.toString()}');
     }
   }
   ```

3. **Replace Register Method**
   ```dart
   Future<void> register(String name, String email, String phone, String password, UserType userType) async {
     _isLoading = true;
     notifyListeners();

     try {
       final response = await ApiClient.register(
         email: email,
         password: password,
         name: name,
         phone: phone,
         userType: _userTypeToString(userType),
       );

       if (response['success'] == true && response['data'] != null) {
         final userData = response['data']['user'];
         final profile = userData['profile'] ?? userData;

         _currentUser = User(
           id: userData['id'] ?? profile['id'],
           name: name,
           email: email,
           phone: phone,
           userType: userType,
           profileImage: profile['avatar_url'],
           createdAt: DateTime.now(),
         );

         _isLoggedIn = true;

         // Save to local storage
         final prefs = await SharedPreferences.getInstance();
         await prefs.setBool('isLoggedIn', true);
         await prefs.setString('userId', _currentUser!.id);
         await prefs.setString('userName', _currentUser!.name);
         await prefs.setString('userEmail', _currentUser!.email);
         await prefs.setString('userPhone', _currentUser!.phone);
         await prefs.setString('userType', _currentUser!.userType.toString());

         _isLoading = false;
         notifyListeners();
       } else {
         _isLoading = false;
         notifyListeners();
         throw Exception(response['error'] ?? 'Registration failed');
       }
     } catch (e) {
       _isLoading = false;
       notifyListeners();
       throw Exception('Registration error: ${e.toString()}');
     }
   }
   ```

4. **Add Helper Methods**
   ```dart
   UserType _parseUserType(String type) {
     switch (type.toLowerCase()) {
       case 'buyer': return UserType.buyer;
       case 'seller': return UserType.seller;
       case 'agent': return UserType.agent;
       case 'landlord': return UserType.landlord;
       case 'owner': return UserType.owner;
       case 'both': return UserType.both;
       default: return UserType.both;
     }
   }

   String _userTypeToString(UserType type) {
     switch (type) {
       case UserType.buyer: return 'buyer';
       case UserType.seller: return 'seller';
       case UserType.agent: return 'agent';
       case UserType.landlord: return 'landlord';
       case UserType.owner: return 'owner';
       case UserType.both: return 'both';
     }
   }
   ```

### 4.3 Update Login Screen

1. **Open Login Screen**
   - File: `lib/screens/auth/login_screen.dart`

2. **Update Error Handling**
   ```dart
   Future<void> _handleLogin() async {
     if (_formKey.currentState!.validate()) {
       setState(() {
         _isLoading = true;
       });

       try {
         final authProvider = Provider.of<AuthProvider>(context, listen: false);
         final result = await authProvider.login(
           _emailController.text,
           _passwordController.text,
         );

         if (mounted) {
           if (result['success'] == true) {
             Navigator.of(context).pushReplacementNamed('/home');
           } else {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text(
                   result['error'] ?? 'Login failed',
                   style: GoogleFonts.poppins(),
                 ),
                 backgroundColor: AppColors.error,
               ),
             );
           }
         }
       } catch (e) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text(
                 'Login failed: ${e.toString()}',
                 style: GoogleFonts.poppins(),
               ),
               backgroundColor: AppColors.error,
             ),
           );
         }
       } finally {
         if (mounted) {
           setState(() {
             _isLoading = false;
           });
         }
       }
     }
   }
   ```

### 4.4 Update Register Screen

1. **Open Register Screen**
   - File: `lib/screens/auth/register_screen.dart`

2. **Update Error Handling** (similar to login screen)

---

## 🧪 Step 5: Test Complete Flow

### 5.1 Test Backend

1. **Start Backend Server**
   ```bash
   cd backend
   npm run dev
   ```

2. **Test Registration**
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

3. **Test Login**
   ```bash
   curl -X POST http://localhost:3000/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "test123"
     }'
   ```

### 5.2 Test Flutter App

1. **Run Flutter App**
   ```bash
   flutter run
   ```

2. **Test Flow**
   - ✅ Splash screen appears (3 seconds)
   - ✅ Onboarding screen appears (first time)
   - ✅ Click "Get Started" → Login screen
   - ✅ Click "Register" → Register screen
   - ✅ Fill registration form → Submit
   - ✅ Should navigate to Home screen
   - ✅ Close app and reopen → Should go directly to Home (if logged in)

### 5.3 Test Login

1. **Logout** (if logged in)
   - Go to Profile → Logout

2. **Login**
   - Enter email: `test@example.com`
   - Enter password: `test123`
   - Click "Login"
   - Should navigate to Home screen

---

## 🔧 Troubleshooting

### Issue: Cannot connect to backend

**Solutions:**
1. **Check Backend is Running**
   ```bash
   curl http://localhost:3000/health
   ```

2. **Check API URL in Flutter**
   - Android Emulator: Use `http://10.0.2.2:3000/api`
   - iOS Simulator: Use `http://localhost:3000/api`
   - Physical Device: Use your computer's IP address

3. **Check Firewall**
   - Allow Node.js through firewall
   - Allow port 3000

### Issue: 401 Unauthorized

**Solutions:**
1. **Check Token Storage**
   - Verify token is saved in SharedPreferences
   - Check token is sent in Authorization header

2. **Check Token Expiration**
   - Tokens expire after 1 hour (default)
   - Implement token refresh

### Issue: Database Errors

**Solutions:**
1. **Check Supabase Connection**
   - Verify SUPABASE_URL and keys in `.env`
   - Check Supabase project is active

2. **Check Database Schema**
   - Verify all tables are created
   - Check RLS policies are set

### Issue: CORS Errors

**Solutions:**
1. **Update ALLOWED_ORIGINS**
   - Add Flutter app URL to `ALLOWED_ORIGINS` in `.env`
   - Restart backend server

---

## ✅ Checklist

- [ ] Supabase project created
- [ ] Database schema executed
- [ ] Storage buckets created
- [ ] Backend server running
- [ ] API URL configured in Flutter
- [ ] Authentication provider updated
- [ ] Splash screen updated
- [ ] Onboarding screen updated
- [ ] Login screen working
- [ ] Register screen working
- [ ] Complete flow tested

---

## 🎉 Success!

You've successfully set up complete authentication from onboarding to backend integration!

**Next Steps:**
1. Test all authentication flows
2. Implement token refresh
3. Add error handling
4. Add loading states
5. Deploy backend to production

---

**Last Updated:** November 4, 2025

