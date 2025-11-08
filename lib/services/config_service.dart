/// Configuration Service
/// 
/// Centralized configuration for API keys and app settings

class ConfigService {
  // Google Maps API Key
  // TODO: Replace with your actual Google Maps API key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  
  // Payment Gateway Keys
  // TODO: Replace with your actual payment gateway keys
  static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_ID';
  static const String razorpayKeySecret = 'YOUR_RAZORPAY_KEY_SECRET';
  
  // Firebase Configuration
  // TODO: Add Firebase configuration
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
  
  // SMS Service Configuration
  // TODO: Replace with your SMS service credentials
  static const String twilioAccountSid = 'YOUR_TWILIO_ACCOUNT_SID';
  static const String twilioAuthToken = 'YOUR_TWILIO_AUTH_TOKEN';
  static const String twilioPhoneNumber = 'YOUR_TWILIO_PHONE_NUMBER';
  
  // Email Service Configuration
  // TODO: Replace with your email service credentials
  static const String sendGridApiKey = 'YOUR_SENDGRID_API_KEY';
  static const String sendGridFromEmail = 'noreply@estato.com';
  
  // App Configuration
  static const String appName = 'Estato';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@estato.com';
  static const String supportPhone = '+91 9876543210';
  
  // Backend API Configuration
  // TODO: Update with your backend URL
  // Development: http://localhost:3000/api
  // Android Emulator: http://10.0.2.2:3000/api
  // iOS Simulator: http://localhost:3000/api
  // Production: https://api.estato.com/api
  static const String apiBaseUrl = 'http://localhost:3000/api';
  
  // Feature Flags
  static const bool enablePayments = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableChat = true;
  static const bool enableMaps = true;
  
  // API Configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  
  // Image Configuration
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}

