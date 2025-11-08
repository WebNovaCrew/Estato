/// API Service for backend integration
/// 
/// This service handles all API calls to the backend server.
/// Replace the base URL with your actual backend URL.

class ApiService {
  // TODO: Replace with your backend API URL
  static const String baseUrl = 'https://api.estato.com/v1';
  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';
  
  // User endpoints
  static const String getUserProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String uploadAvatar = '/users/avatar';
  
  // Property endpoints
  static const String getProperties = '/properties';
  static const String getProperty = '/properties';
  static const String createProperty = '/properties';
  static const String updateProperty = '/properties';
  static const String deleteProperty = '/properties';
  static const String getSimilarProperties = '/properties/similar';
  static const String searchProperties = '/properties/search';
  
  // Favorite endpoints
  static const String getFavorites = '/favorites';
  static const String addFavorite = '/favorites';
  static const String removeFavorite = '/favorites';
  
  // Chat endpoints
  static const String getChats = '/chats';
  static const String getChatMessages = '/chats';
  static const String sendMessage = '/chats/messages';
  static const String createChat = '/chats';
  
  // Booking endpoints
  static const String getBookings = '/bookings';
  static const String createBooking = '/bookings';
  static const String updateBooking = '/bookings';
  static const String cancelBooking = '/bookings';
  
  // Payment endpoints
  static const String createPayment = '/payments/create';
  static const String verifyPayment = '/payments/verify';
  static const String getSubscriptions = '/subscriptions';
  static const String subscribe = '/subscriptions/subscribe';
  static const String getPaymentHistory = '/payments/history';
  
  // Admin endpoints
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminProperties = '/admin/properties';
  static const String adminApproveProperty = '/admin/properties/approve';
  static const String adminRejectProperty = '/admin/properties/reject';
  static const String adminReports = '/admin/reports';
  
  // Notification endpoints
  static const String getNotifications = '/notifications';
  static const String markNotificationRead = '/notifications/read';
  static const String updateNotificationSettings = '/notifications/settings';
  
  // Analytics endpoints
  static const String getAnalytics = '/analytics';
  static const String getPropertyAnalytics = '/analytics/property';
}

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;
  
  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });
  
  factory ApiResponse.success(T data, [int? statusCode]) {
    return ApiResponse(
      success: true,
      data: data,
      statusCode: statusCode ?? 200,
    );
  }
  
  factory ApiResponse.error(String error, [int? statusCode]) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode ?? 500,
    );
  }
}

