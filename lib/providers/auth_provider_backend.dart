import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_client.dart';

/// Authentication Provider with Backend API Integration
/// 
/// This provider uses the Node.js backend with Supabase authentication
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  /// Login with backend API
  Future<Map<String, dynamic>> login(String email, String password) async {
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

        return {'success': true, 'message': 'Login successful'};
      } else {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'error': response['error'] ?? 'Login failed'};
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Register with backend API
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    UserType userType,
  ) async {
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

        return {'success': true, 'message': 'Registration successful'};
      } else {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'error': response['error'] ?? 'Registration failed'};
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await ApiClient.logout();
    } catch (e) {
      print('Logout error: $e');
    }

    _currentUser = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  /// Check login status and restore session
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // Try to get current user from API
        final response = await ApiClient.getCurrentUser();

        if (response['success'] == true && response['data'] != null) {
          final userData = response['data'];
          final profile = userData['profile'] ?? userData;

          _currentUser = User(
            id: userData['id'] ?? profile['id'],
            name: profile['name'] ?? 'User',
            email: userData['email'] ?? profile['email'],
            phone: profile['phone'] ?? '+91 9876543210',
            userType: _parseUserType(profile['user_type'] ?? 'both'),
            profileImage: profile['avatar_url'],
            createdAt: profile['created_at'] != null
                ? DateTime.parse(profile['created_at'])
                : DateTime.now(),
          );

          _isLoggedIn = true;
        } else {
          // Session expired, clear local data
          await prefs.clear();
          _isLoggedIn = false;
        }
      }
    } catch (e) {
      print('Check login status error: $e');
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? bio,
  }) async {
    try {
      final response = await ApiClient.updateUserProfile(
        name: name,
        phone: phone,
        bio: bio,
      );

      if (response['success'] == true && response['data'] != null) {
        final profile = response['data'];

        _currentUser = User(
          id: _currentUser!.id,
          name: profile['name'] ?? _currentUser!.name,
          email: _currentUser!.email,
          phone: profile['phone'] ?? _currentUser!.phone,
          userType: _currentUser!.userType,
          profileImage: profile['avatar_url'] ?? _currentUser!.profileImage,
          createdAt: _currentUser!.createdAt,
          favoriteProperties: _currentUser!.favoriteProperties,
        );

        notifyListeners();
        return {'success': true, 'message': 'Profile updated successfully'};
      } else {
        return {'success': false, 'error': response['error'] ?? 'Update failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Toggle favorite property
  Future<void> toggleFavorite(String propertyId) async {
    if (_currentUser == null) return;

    try {
      final favorites = List<String>.from(_currentUser!.favoriteProperties);
      final isFavorite = favorites.contains(propertyId);

      if (isFavorite) {
        // Remove favorite
        final response = await ApiClient.removeFavorite(propertyId);
        if (response['success'] == true) {
          favorites.remove(propertyId);
        }
      } else {
        // Add favorite
        final response = await ApiClient.addFavorite(propertyId);
        if (response['success'] == true) {
          favorites.add(propertyId);
        }
      }

      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        userType: _currentUser!.userType,
        favoriteProperties: favorites,
        createdAt: _currentUser!.createdAt,
      );

      notifyListeners();
    } catch (e) {
      print('Toggle favorite error: $e');
    }
  }

  bool isFavorite(String propertyId) {
    return _currentUser?.favoriteProperties.contains(propertyId) ?? false;
  }

  UserType _parseUserType(String type) {
    switch (type.toLowerCase()) {
      case 'buyer':
        return UserType.buyer;
      case 'seller':
        return UserType.seller;
      case 'agent':
        return UserType.agent;
      case 'landlord':
        return UserType.landlord;
      case 'owner':
        return UserType.owner;
      case 'both':
        return UserType.both;
      default:
        return UserType.both;
    }
  }

  String _userTypeToString(UserType type) {
    switch (type) {
      case UserType.buyer:
        return 'buyer';
      case UserType.seller:
        return 'seller';
      case UserType.agent:
        return 'agent';
      case UserType.landlord:
        return 'landlord';
      case UserType.owner:
        return 'owner';
      case UserType.both:
        return 'both';
    }
  }
}

