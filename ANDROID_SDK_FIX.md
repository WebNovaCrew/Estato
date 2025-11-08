# Android SDK Path Fix - Spaces in Path Issue

## Problem
Your Android SDK is located at `C:\Users\Web Nova Crew\AppData\Local\Android\sdk` which contains spaces in the path. This causes issues with the Android NDK tools and can lead to app crashes.

## Solution Options

### Option 1: Move Android SDK (Recommended)

1. **Create a new directory without spaces:**
   ```
   C:\AndroidSDK
   ```

2. **Move the entire SDK:**
   - Copy everything from `C:\Users\Web Nova Crew\AppData\Local\Android\sdk`
   - To `C:\AndroidSDK`

3. **Update Android Studio:**
   - Open Android Studio
   - Go to File → Settings → Appearance & Behavior → System Settings → Android SDK
   - Change SDK Location to `C:\AndroidSDK`

4. **Update Environment Variables:**
   - Add `ANDROID_HOME=C:\AndroidSDK` to your system environment variables
   - Add `C:\AndroidSDK\platform-tools` to your PATH

### Option 2: Use Junction Link (Windows)

1. **Open Command Prompt as Administrator**

2. **Create a junction link:**
   ```cmd
   mklink /J C:\AndroidSDK "C:\Users\Web Nova Crew\AppData\Local\Android\sdk"
   ```

3. **Update Android Studio SDK path to:**
   ```
   C:\AndroidSDK
   ```

### Option 3: Use SUBST Command (Temporary)

1. **Open Command Prompt as Administrator**

2. **Create a virtual drive:**
   ```cmd
   subst A: "C:\Users\Web Nova Crew\AppData\Local\Android\sdk"
   ```

3. **Update Android Studio SDK path to:**
   ```
   A:\
   ```

## Verification

After applying any solution, run:
```bash
flutter doctor -v
```

You should see:
```
[√] Android toolchain - develop for Android devices
```

## Additional Steps

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Test the app:**
   ```bash
   flutter run
   ```

## Why This Fixes Crashes

The spaces in the Android SDK path cause:
- NDK build failures
- ProGuard processing errors
- Native library loading issues
- Gradle build problems

These issues often manifest as app crashes on startup or when accessing certain features.
