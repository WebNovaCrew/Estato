import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/property.dart';
import '../models/booking.dart';
import '../models/message.dart';
import 'config_service.dart';

/// API Client for backend communication
/// 
/// This service handles all API calls to the Node.js backend with Supabase authentication
class ApiClient {
  // Use config service for base URL
  static String get baseUrl => ConfigService.apiBaseUrl;
  
  // Get stored access token
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Save access token
  static Future<void> _saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Clear access token
  static Future<void> _clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  // Make authenticated request
  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (requireAuth) {
        final token = await _getAccessToken();
        if (token == null) {
          return {
            'success': false,
            'error': 'Not authenticated. Please login.',
          };
        }
        requestHeaders['Authorization'] = 'Bearer $token';
      }

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: requestHeaders);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: requestHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        // Token expired, clear and return error
        await _clearAccessToken();
        return {
          'success': false,
          'error': 'Session expired. Please login again.',
        };
      }

      return responseData;
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  // Authentication Methods
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
  }) async {
    final response = await _makeRequest(
      'POST',
      '/auth/register',
      body: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'userType': userType,
      },
      requireAuth: false,
    );

    if (response['success'] == true && response['data'] != null) {
      final session = response['data']['session'];
      if (session != null && session['access_token'] != null) {
        await _saveAccessToken(session['access_token']);
      }
    }

    return response;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _makeRequest(
      'POST',
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      requireAuth: false,
    );

    if (response['success'] == true && response['data'] != null) {
      final accessToken = response['data']['accessToken'];
      if (accessToken != null) {
        await _saveAccessToken(accessToken);
      }
    }

    return response;
  }

  static Future<Map<String, dynamic>> logout() async {
    final response = await _makeRequest('POST', '/auth/logout');
    await _clearAccessToken();
    return response;
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    return await _makeRequest('GET', '/auth/me');
  }

  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _makeRequest(
      'POST',
      '/auth/refresh',
      body: {'refreshToken': refreshToken},
      requireAuth: false,
    );

    if (response['success'] == true && response['data'] != null) {
      final accessToken = response['data']['accessToken'];
      if (accessToken != null) {
        await _saveAccessToken(accessToken);
      }
    }

    return response;
  }

  // OTP Methods
  static Future<Map<String, dynamic>> sendOTP({
    String? phone,
    String? email,
  }) async {
    return await _makeRequest(
      'POST',
      '/otp/send',
      body: {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
      },
      requireAuth: false,
    );
  }

  static Future<Map<String, dynamic>> verifyOTP({
    String? phone,
    String? email,
    required String otp,
  }) async {
    return await _makeRequest(
      'POST',
      '/otp/verify',
      body: {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        'otp': otp,
      },
      requireAuth: false,
    );
  }

  static Future<Map<String, dynamic>> resendOTP({
    String? phone,
    String? email,
  }) async {
    return await _makeRequest(
      'POST',
      '/otp/resend',
      body: {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
      },
      requireAuth: false,
    );
  }

  // User Methods
  static Future<Map<String, dynamic>> getUserProfile() async {
    return await _makeRequest('GET', '/users/profile');
  }

  static Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
  }) async {
    return await _makeRequest(
      'PUT',
      '/users/profile',
      body: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (bio != null) 'bio': bio,
      },
    );
  }

  static Future<Map<String, dynamic>> uploadAvatar(String imagePath) async {
    // TODO: Implement file upload using multipart request
    // This requires additional implementation
    return {
      'success': false,
      'error': 'Avatar upload not yet implemented',
    };
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _makeRequest(
      'POST',
      '/users/change-password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  // Property Methods
  static Future<Map<String, dynamic>> getProperties({
    String? propertyType,
    String? transactionType,
    double? minPrice,
    double? maxPrice,
    String? area,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (propertyType != null) queryParams['propertyType'] = propertyType;
    if (transactionType != null) queryParams['transactionType'] = transactionType;
    if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
    if (area != null) queryParams['area'] = area;
    if (search != null) queryParams['search'] = search;

    final queryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return await _makeRequest(
      'GET',
      '/properties${queryString.isNotEmpty ? '?$queryString' : ''}',
      requireAuth: false,
    );
  }

  static Future<Map<String, dynamic>> getPropertyById(String id) async {
    return await _makeRequest('GET', '/properties/$id', requireAuth: false);
  }

  static Future<Map<String, dynamic>> createProperty(Map<String, dynamic> propertyData) async {
    // TODO: Implement multipart form data for image upload
    return await _makeRequest('POST', '/properties', body: propertyData);
  }

  static Future<Map<String, dynamic>> updateProperty(String id, Map<String, dynamic> updates) async {
    return await _makeRequest('PUT', '/properties/$id', body: updates);
  }

  static Future<Map<String, dynamic>> deleteProperty(String id) async {
    return await _makeRequest('DELETE', '/properties/$id');
  }

  static Future<Map<String, dynamic>> getSimilarProperties(String propertyId) async {
    return await _makeRequest('GET', '/properties/$propertyId/similar', requireAuth: false);
  }

  // Favorite Methods
  static Future<Map<String, dynamic>> getFavorites() async {
    return await _makeRequest('GET', '/favorites');
  }

  static Future<Map<String, dynamic>> addFavorite(String propertyId) async {
    return await _makeRequest('POST', '/favorites', body: {'propertyId': propertyId});
  }

  static Future<Map<String, dynamic>> removeFavorite(String propertyId) async {
    return await _makeRequest('DELETE', '/favorites/$propertyId');
  }

  // Chat Methods
  static Future<Map<String, dynamic>> getChats() async {
    return await _makeRequest('GET', '/chats');
  }

  static Future<Map<String, dynamic>> createChat({
    required String participant2Id,
    required String propertyId,
  }) async {
    return await _makeRequest('POST', '/chats', body: {
      'participant2Id': participant2Id,
      'propertyId': propertyId,
    });
  }

  static Future<Map<String, dynamic>> getChatMessages(String chatId) async {
    return await _makeRequest('GET', '/chats/$chatId/messages');
  }

  static Future<Map<String, dynamic>> sendMessage(String chatId, String content) async {
    return await _makeRequest('POST', '/chats/$chatId/messages', body: {
      'content': content,
    });
  }

  // Booking Methods
  static Future<Map<String, dynamic>> getBookings({String? status}) async {
    final query = status != null ? '?status=$status' : '';
    return await _makeRequest('GET', '/bookings$query');
  }

  static Future<Map<String, dynamic>> createBooking({
    required String propertyId,
    required String scheduledDate,
    required String scheduledTime,
    String? notes,
  }) async {
    return await _makeRequest('POST', '/bookings', body: {
      'propertyId': propertyId,
      'scheduledDate': scheduledDate,
      'scheduledTime': scheduledTime,
      if (notes != null) 'notes': notes,
    });
  }

  static Future<Map<String, dynamic>> updateBooking(String id, String status) async {
    return await _makeRequest('PUT', '/bookings/$id', body: {'status': status});
  }

  // Payment Methods
  static Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String planName,
  }) async {
    return await _makeRequest('POST', '/payments/create', body: {
      'amount': amount,
      'planName': planName,
    });
  }

  static Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    return await _makeRequest('POST', '/payments/verify', body: {
      'orderId': orderId,
      'paymentId': paymentId,
      'signature': signature,
    });
  }

  static Future<Map<String, dynamic>> getPaymentHistory() async {
    return await _makeRequest('GET', '/payments/history');
  }

  // Admin Methods
  static Future<Map<String, dynamic>> getAdminDashboard() async {
    return await _makeRequest('GET', '/admin/dashboard');
  }

  static Future<Map<String, dynamic>> getAdminUsers() async {
    return await _makeRequest('GET', '/admin/users');
  }

  static Future<Map<String, dynamic>> getAdminProperties({String? status}) async {
    final query = status != null ? '?status=$status' : '';
    return await _makeRequest('GET', '/admin/properties$query');
  }

  static Future<Map<String, dynamic>> approveProperty(String id) async {
    return await _makeRequest('PUT', '/admin/properties/$id/approve');
  }

  static Future<Map<String, dynamic>> rejectProperty(String id) async {
    return await _makeRequest('PUT', '/admin/properties/$id/reject');
  }

  static Future<Map<String, dynamic>> getAdminAgents() async {
    return await _makeRequest('GET', '/admin/agents');
  }

  static Future<Map<String, dynamic>> approveAgent(String id) async {
    return await _makeRequest('PUT', '/admin/agents/$id/approve');
  }

  static Future<Map<String, dynamic>> getAdminReports() async {
    return await _makeRequest('GET', '/admin/reports');
  }

  static Future<Map<String, dynamic>> resolveReport(String id) async {
    return await _makeRequest('PUT', '/admin/reports/$id/resolve');
  }
}

