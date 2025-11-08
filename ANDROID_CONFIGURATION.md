# Android Configuration for Estato App

## Overview
Complete Android configuration for the Estato real estate application including permissions, build configuration, and ProGuard rules.

---

## 📱 Android Manifest Configuration

### File Location
`android/app/src/main/AndroidManifest.xml`

### Key Configurations

#### 1. App Label
```xml
android:label="Estato"
```
The app will appear as "Estato" on the device.

#### 2. Application ID
```
com.estatoprop.lucknow
```

#### 3. Permissions Configured

| Permission | Type | Purpose | Required |
|------------|------|---------|----------|
| INTERNET | Install-time | Load property data and images | ✅ Yes |
| ACCESS_NETWORK_STATE | Install-time | Check connectivity | ✅ Yes |
| CALL_PHONE | Runtime | Call property owners | ⚠️ Optional |
| CAMERA | Runtime | Take property photos | ⚠️ Optional |
| READ_EXTERNAL_STORAGE | Runtime | Select photos from gallery | ⚠️ Optional |
| READ_MEDIA_IMAGES | Runtime | Select photos (Android 13+) | ⚠️ Optional |
| ACCESS_FINE_LOCATION | Runtime | Show nearby properties | ⚠️ Optional |
| ACCESS_COARSE_LOCATION | Runtime | Approximate location | ⚠️ Optional |

#### 4. Intent Queries Configured
- ✅ Phone/Dial intents
- ✅ Web browser intents (HTTP/HTTPS)
- ✅ Email intents
- ✅ Text processing intents

---

## 🔧 Build Configuration

### File Location
`android/app/build.gradle.kts`

### Build Details

#### SDK Versions
```kotlin
minSdk = 21        // Android 5.0 (Lollipop) - 95%+ device coverage
targetSdk = 34     // Android 14 (Latest)
compileSdk = 34    // Android 14 (Latest)
```

#### App Version
```kotlin
versionCode = 1
versionName = "1.0.0"
```

#### Features Enabled
- ✅ MultiDex support for large apps
- ✅ ProGuard code optimization for release builds
- ✅ Resource shrinking for smaller APK size
- ✅ Build config generation

#### Build Types

**Debug Build:**
- No code obfuscation
- Debuggable
- Larger APK size
- Faster build time

**Release Build:**
- Code minification enabled
- Resource shrinking enabled
- ProGuard optimization
- Smaller APK size
- Better performance

---

## 🛡️ ProGuard Rules

### File Location
`android/app/proguard-rules.pro`

### Protection Rules Included

1. **Flutter Framework**
   - Keeps all Flutter classes intact
   - Prevents Flutter plugin issues

2. **Model Classes**
   - Preserves data models for JSON serialization
   - Keeps Gson annotations

3. **Image Libraries**
   - Cached Network Image rules
   - Glide image loading library

4. **Kotlin Coroutines**
   - Prevents coroutine-related crashes

5. **Native Methods**
   - Keeps JNI method signatures

6. **Logging Removal**
   - Removes debug logs in release builds
   - Reduces APK size

---

## 🏗️ Build Commands

### Development Build
```bash
cd estato_prop
flutter build apk --debug
```

### Release Build (Unsigned)
```bash
flutter build apk --release
```

### Release Build (Signed)
```bash
flutter build apk --release --split-per-abi
```

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Install on Device
```bash
flutter install
```

---

## 📦 APK Output Locations

After building:

**Debug APK:**
```
build/app/outputs/flutter-apk/app-debug.apk
```

**Release APK:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**Split APKs (smaller size):**
```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk  (32-bit ARM)
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk    (64-bit ARM)
build/app/outputs/flutter-apk/app-x86_64-release.apk       (x86 64-bit)
```

**App Bundle:**
```
build/app/outputs/bundle/release/app-release.aab
```

---

## 🔐 App Signing (for Production)

### Generate Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Create key.properties
Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

### Update build.gradle.kts
Add signing configuration for release builds.

---

## 📱 Minimum Device Requirements

| Requirement | Specification |
|-------------|---------------|
| **Android Version** | 5.0 (Lollipop) or higher |
| **API Level** | 21+ |
| **RAM** | 2 GB minimum, 4 GB recommended |
| **Storage** | 100 MB free space |
| **Screen Size** | 4.5" or larger recommended |
| **Architecture** | ARM, ARM64, x86, x86_64 |

### Device Coverage
- Android 5.0+: ~95% of devices (as of 2024)
- Android 6.0+: ~93% of devices
- Android 8.0+: ~85% of devices

---

## 🧪 Testing Permissions

### Grant All Permissions (Testing)
```bash
adb shell pm grant com.estatoprop.lucknow android.permission.CAMERA
adb shell pm grant com.estatoprop.lucknow android.permission.CALL_PHONE
adb shell pm grant com.estatoprop.lucknow android.permission.ACCESS_FINE_LOCATION
adb shell pm grant com.estatoprop.lucknow android.permission.ACCESS_COARSE_LOCATION
adb shell pm grant com.estatoprop.lucknow android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.estatoprop.lucknow android.permission.READ_MEDIA_IMAGES
```

### Revoke All Permissions
```bash
adb shell pm reset-permissions com.estatoprop.lucknow
```

### Check Current Permissions
```bash
adb shell dumpsys package com.estatoprop.lucknow | grep permission
```

---

## 📊 APK Size Optimization

Current optimizations applied:

1. ✅ **Code Minification** - ProGuard removes unused code
2. ✅ **Resource Shrinking** - Removes unused resources
3. ✅ **Split APKs** - Separate APKs per CPU architecture
4. ✅ **Optimized Images** - Using cached network images
5. ✅ **Removed Debug Info** - In release builds

Expected APK sizes:
- **Debug APK:** ~45-60 MB
- **Release APK (Universal):** ~25-35 MB
- **Release APK (Split):** ~15-20 MB each

---

## 🚀 Play Store Preparation

### Required Assets

1. **App Icon**
   - 512x512 PNG
   - Location: `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

2. **Feature Graphic**
   - 1024x500 PNG
   - For Play Store listing

3. **Screenshots**
   - At least 2 phone screenshots
   - 1080x1920 or higher
   - Different screens (splash, home, property detail)

4. **Privacy Policy**
   - Required for apps requesting permissions
   - Must be hosted on accessible URL

### Play Store Checklist

- [ ] Signed release AAB generated
- [ ] App tested on multiple devices
- [ ] Screenshots prepared
- [ ] Privacy policy created and hosted
- [ ] App description written
- [ ] Content rating completed
- [ ] Pricing set (Free/Paid)
- [ ] Target countries selected (India - Lucknow focus)

---

## 🔍 Troubleshooting

### Common Issues

**Issue: Permission denied errors**
```bash
Solution: Check AndroidManifest.xml and request runtime permissions
```

**Issue: Build failed - SDK not found**
```bash
Solution: Update android/local.properties with correct SDK path
```

**Issue: MultiDex error**
```bash
Solution: Already enabled in build.gradle.kts
```

**Issue: Image picker not working**
```bash
Solution: Check camera and storage permissions granted
```

**Issue: APK too large**
```bash
Solution: Use split APKs with --split-per-abi flag
```

---

## 📞 Support

For Android configuration issues:
1. Check Flutter doctor: `flutter doctor -v`
2. Clean build: `flutter clean && flutter pub get`
3. Rebuild: `flutter build apk --release`

---

## 📝 Files Summary

### Created/Modified Files

1. ✅ `android/app/src/main/AndroidManifest.xml` - Permissions and app configuration
2. ✅ `android/app/build.gradle.kts` - Build configuration
3. ✅ `android/app/proguard-rules.pro` - Code optimization rules
4. ✅ `android/app/PERMISSIONS.md` - Detailed permissions documentation
5. ✅ `ANDROID_CONFIGURATION.md` - This file

### Backup Files
- `android/app/build.gradle.kts.backup` - Original build file

---

**Last Updated:** November 4, 2025  
**App Version:** 1.0.0  
**Target Platform:** Android 5.0 (API 21) to Android 14 (API 34)  
**Package Name:** com.estatoprop.lucknow

