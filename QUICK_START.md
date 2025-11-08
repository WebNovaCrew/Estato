# ⚡ Quick Start Guide - Authentication Setup

## 🚀 5-Minute Setup

### Step 1: Supabase (2 minutes)

1. **Create Account & Project**
   - Go to [supabase.com](https://supabase.com)
   - Sign up → Create Project → Wait 2 minutes

2. **Get API Keys**
   - Settings → API → Copy:
     - Project URL
     - anon key
     - service_role key

3. **Run Database Schema**
   - SQL Editor → New Query
   - Paste `backend/database/schema.sql`
   - Click "Run"

4. **Create Storage Buckets**
   - Storage → Create bucket: `property-images` (public)
   - Storage → Create bucket: `avatars` (public)

### Step 2: Backend (2 minutes)

1. **Install Dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase keys
   ```

3. **Start Server**
   ```bash
   npm run dev
   # Should see: "🚀 Estato API Server running on port 3000"
   ```

### Step 3: Flutter App (1 minute)

1. **Update API URL**
   - Open `lib/services/config_service.dart`
   - Change `apiBaseUrl` to:
     ```dart
     // Android Emulator
     static const String apiBaseUrl = 'http://10.0.2.2:3000/api';
     
     // iOS Simulator
     static const String apiBaseUrl = 'http://localhost:3000/api';
     
     // Physical Device (replace with your IP)
     static const String apiBaseUrl = 'http://192.168.1.100:3000/api';
     ```

2. **Switch to Backend Auth** (Optional)
   ```bash
   # Backup demo provider
   mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
   
   # Use backend provider
   mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
   ```

3. **Run App**
   ```bash
   flutter run
   ```

### Step 4: Test

1. **Test Backend**
   ```bash
   curl http://localhost:3000/health
   ```

2. **Test Registration**
   - Open app → Register
   - Fill form → Submit
   - Should navigate to Home

3. **Test Login**
   - Logout → Login
   - Enter credentials → Submit
   - Should navigate to Home

---

## ✅ Done!

Your authentication is now working with backend!

**Flow:**
- Splash → Onboarding (first time) → Login/Register → Home

**For detailed guide, see:** `COMPLETE_AUTH_GUIDE.md`

---

## 🐛 Common Issues

### Cannot connect to backend
- ✅ Check backend is running: `curl http://localhost:3000/health`
- ✅ Check API URL in Flutter (use correct IP/URL)
- ✅ Check firewall allows port 3000

### 401 Unauthorized
- ✅ Check Supabase keys in `.env`
- ✅ Verify database schema is created
- ✅ Check user is registered

### CORS Error
- ✅ Add Flutter URL to `ALLOWED_ORIGINS` in `.env`
- ✅ Restart backend server

---

**Need Help?** See `COMPLETE_AUTH_GUIDE.md` for detailed instructions.
