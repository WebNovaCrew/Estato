import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/demo_credentials.dart';

/// Authentication Provider - DEMO MODE
/// 
/// This is a DEMO implementation for testing purposes only.
/// In production, replace with actual API authentication.
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  /// Demo Login - No actual authentication
  /// 
  /// Accepts either:
  /// 1. Predefined demo credentials (see DemoCredentials class)
  /// 2. Any email/password combination (creates demo user on the fly)
  Future<void> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Try to find demo user first
    final demoUser = DemoCredentials.validateLogin(email, password);
    
    if (demoUser != null) {
      // Login with predefined demo account
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: demoUser['name']!,
        email: demoUser['email']!,
        phone: demoUser['phone']!,
        userType: _getUserType(demoUser['type']!),
        createdAt: DateTime.now(),
      );
    } else {
      // Create demo user on the fly (any credentials work)
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Demo User',
        email: email,
        phone: '+91 9876543210',
        userType: UserType.both,
        createdAt: DateTime.now(),
      );
    }
    
    _isLoggedIn = true;
    
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', _currentUser!.id);
    await prefs.setString('userName', _currentUser!.name);
    await prefs.setString('userEmail', _currentUser!.email);
    await prefs.setString('userPhone', _currentUser!.phone);
    await prefs.setString('userType', _currentUser!.userType.toString());
    
    notifyListeners();
  }
  
  UserType _getUserType(String type) {
    switch (type.toLowerCase()) {
      case 'buyer':
        return UserType.buyer;
      case 'seller':
        return UserType.seller;
      case 'both':
        return UserType.both;
      default:
        return UserType.both;
    }
  }

  /// Demo Registration - No actual user creation
  /// 
  /// In production, this would call an API to create a new user account.
  /// For demo purposes, it just creates a local user object.
  Future<void> register(String name, String email, String phone, String password, UserType userType) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Create demo user
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      userType: userType,
      createdAt: DateTime.now(),
    );
    _isLoggedIn = true;
    
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', _currentUser!.id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPhone', phone);
    await prefs.setString('userType', userType.toString());
    
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  /// Check if user is already logged in (from previous session)
  /// 
  /// Retrieves user data from local storage.
  /// In production, validate session with server.
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (_isLoggedIn) {
      // Restore user from local storage
      final userId = prefs.getString('userId') ?? '';
      final userName = prefs.getString('userName') ?? 'Demo User';
      final userEmail = prefs.getString('userEmail') ?? 'demo@estato.com';
      final userPhone = prefs.getString('userPhone') ?? '+91 9876543210';
      final userTypeStr = prefs.getString('userType') ?? 'UserType.both';
      
      _currentUser = User(
        id: userId,
        name: userName,
        email: userEmail,
        phone: userPhone,
        userType: _parseUserType(userTypeStr),
        createdAt: DateTime.now(),
      );
    }
    
    notifyListeners();
  }
  
  UserType _parseUserType(String typeStr) {
    if (typeStr.contains('buyer')) return UserType.buyer;
    if (typeStr.contains('seller')) return UserType.seller;
    return UserType.both;
  }

  void toggleFavorite(String propertyId) {
    if (_currentUser != null) {
      final favorites = List<String>.from(_currentUser!.favoriteProperties);
      if (favorites.contains(propertyId)) {
        favorites.remove(propertyId);
      } else {
        favorites.add(propertyId);
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
    }
  }

  bool isFavorite(String propertyId) {
    return _currentUser?.favoriteProperties.contains(propertyId) ?? false;
  }
}

