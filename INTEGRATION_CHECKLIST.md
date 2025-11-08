# ✅ Supabase Integration Checklist

Use this checklist to ensure everything is set up correctly.

## 📋 Pre-Integration Checklist

- [ ] Supabase account created
- [ ] Supabase project created
- [ ] Node.js installed (version 18+)
- [ ] Flutter app ready
- [ ] Code editor ready

---

## 🔑 Step 1: Get Supabase Keys

- [ ] Logged into Supabase Dashboard
- [ ] Opened Project Settings → API
- [ ] Copied Project URL
- [ ] Copied anon public key
- [ ] Copied service_role key
- [ ] Saved keys securely (temporarily)

---

## 🗄️ Step 2: Database Setup

- [ ] Opened SQL Editor in Supabase
- [ ] Copied contents of `backend/database/schema.sql`
- [ ] Pasted and ran SQL in Supabase
- [ ] Saw success message
- [ ] Verified tables created (users, properties, etc.)
- [ ] Created `property-images` storage bucket
- [ ] Created `avatars` storage bucket
- [ ] Set storage buckets to public
- [ ] Ran storage policies SQL

---

## ⚙️ Step 3: Backend Configuration

- [ ] Navigated to `backend` folder
- [ ] Ran `npm install`
- [ ] Created `.env` file from `.env.example`
- [ ] Added SUPABASE_URL to `.env`
- [ ] Added SUPABASE_ANON_KEY to `.env`
- [ ] Added SUPABASE_SERVICE_ROLE_KEY to `.env`
- [ ] Added JWT_SECRET to `.env`
- [ ] Saved `.env` file
- [ ] Started backend server (`npm run dev`)
- [ ] Saw "Server running on port 3000" message
- [ ] Tested health endpoint (`http://localhost:3000/health`)
- [ ] Got success response

---

## 📱 Step 4: Flutter App Configuration

- [ ] Opened `lib/services/config_service.dart`
- [ ] Updated `apiBaseUrl` for your platform:
  - [ ] Android Emulator: `http://10.0.2.2:3000/api`
  - [ ] iOS Simulator: `http://localhost:3000/api`
  - [ ] Physical Device: `http://YOUR_IP:3000/api`
- [ ] Saved config_service.dart
- [ ] Backed up demo auth provider (optional)
- [ ] Switched to backend auth provider
- [ ] Verified `lib/services/api_client.dart` exists

---

## 🧪 Step 5: Testing

### Backend Tests
- [ ] Backend server running
- [ ] Health check working
- [ ] Tested registration endpoint (optional)
- [ ] Tested login endpoint (optional)

### Flutter App Tests
- [ ] App runs without errors
- [ ] Splash screen appears
- [ ] Onboarding screen appears (first time)
- [ ] Can navigate to login screen
- [ ] Can navigate to register screen
- [ ] Registration form works
- [ ] Can register new user
- [ ] Registration successful
- [ ] Navigates to home after registration
- [ ] Can logout
- [ ] Can login with registered credentials
- [ ] Login successful
- [ ] Navigates to home after login

### Supabase Verification
- [ ] User appears in Supabase Authentication → Users
- [ ] User profile created in database (Table Editor → users)
- [ ] Can see user data in Supabase

---

## 🔧 Step 6: Troubleshooting

If something doesn't work:

- [ ] Checked backend terminal for errors
- [ ] Checked Supabase Dashboard
- [ ] Verified API keys are correct
- [ ] Verified database schema is created
- [ ] Verified storage buckets exist
- [ ] Checked network connectivity
- [ ] Verified API URL in Flutter app
- [ ] Restarted backend server
- [ ] Restarted Flutter app

---

## ✅ Final Verification

### Backend
- [ ] Backend server running smoothly
- [ ] No errors in backend terminal
- [ ] All API endpoints accessible
- [ ] Supabase connection working

### Flutter App
- [ ] App runs without crashes
- [ ] Registration works
- [ ] Login works
- [ ] User data persists
- [ ] Navigation works correctly

### Supabase
- [ ] Database tables created
- [ ] Storage buckets created
- [ ] Users can be created
- [ ] Data can be read/written

---

## 🎉 Success Criteria

Your integration is complete when:

1. ✅ Backend server runs without errors
2. ✅ Can register new users from Flutter app
3. ✅ Can login with registered credentials
4. ✅ Users appear in Supabase Authentication
5. ✅ User profiles created in database
6. ✅ No connection errors
7. ✅ All navigation works correctly

---

## 📝 Notes

**Date Completed:** _______________

**Supabase Project URL:** _______________

**Backend URL:** _______________

**Issues Encountered:**
- 

**Solutions Found:**
- 

---

## 🚀 Next Steps

After integration is complete:

1. [ ] Test all authentication flows
2. [ ] Add property features
3. [ ] Add favorites functionality
4. [ ] Add chat functionality
5. [ ] Test on physical device
6. [ ] Deploy backend to production
7. [ ] Deploy Flutter app

---

**Last Updated:** November 4, 2025

