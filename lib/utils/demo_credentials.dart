/// Demo Login Credentials for Estato App
/// 
/// This file contains demo login credentials for testing purposes.
/// In production, replace this with actual authentication via API.

class DemoCredentials {
  // Demo user accounts
  static const List<Map<String, String>> demoUsers = [
    {
      'email': 'buyer@estato.com',
      'password': 'buyer123',
      'name': 'Raj Kumar',
      'phone': '+91 9876543210',
      'type': 'buyer',
    },
    {
      'email': 'seller@estato.com',
      'password': 'seller123',
      'name': 'Priya Sharma',
      'phone': '+91 9876543211',
      'type': 'seller',
    },
    {
      'email': 'agent@estato.com',
      'password': 'agent123',
      'name': 'Amit Singh',
      'phone': '+91 9876543212',
      'type': 'agent',
    },
    {
      'email': 'landlord@estato.com',
      'password': 'landlord123',
      'name': 'Ramesh Verma',
      'phone': '+91 9876543213',
      'type': 'landlord',
    },
    {
      'email': 'owner@estato.com',
      'password': 'owner123',
      'name': 'Sunita Devi',
      'phone': '+91 9876543214',
      'type': 'owner',
    },
    {
      'email': 'demo@estato.com',
      'password': 'demo123',
      'name': 'Demo User',
      'phone': '+91 9876543215',
      'type': 'both',
    },
  ];

  /// Validate demo login credentials
  /// Returns user data if valid, null otherwise
  static Map<String, String>? validateLogin(String email, String password) {
    try {
      return demoUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if email exists in demo accounts
  static bool emailExists(String email) {
    return demoUsers.any((user) => user['email'] == email);
  }

  /// Get demo user by email
  static Map<String, String>? getUserByEmail(String email) {
    try {
      return demoUsers.firstWhere((user) => user['email'] == email);
    } catch (e) {
      return null;
    }
  }
}

/// Demo Login Instructions
class DemoLoginInfo {
  static const String title = 'Demo Login Credentials';
  
  static const String description = 
    'This is a demo app. You can login with any of the following credentials, '
    'or simply enter any email and password (minimum 6 characters) to create a demo account.';
  
  static const List<Map<String, String>> credentials = [
    {
      'role': 'Buyer',
      'email': 'buyer@estato.com',
      'password': 'buyer123',
    },
    {
      'role': 'Seller',
      'email': 'seller@estato.com',
      'password': 'seller123',
    },
    {
      'role': 'Agent',
      'email': 'agent@estato.com',
      'password': 'agent123',
    },
    {
      'role': 'Demo User',
      'email': 'demo@estato.com',
      'password': 'demo123',
    },
  ];

  static String getFormattedCredentials() {
    String result = '$title\n\n$description\n\n';
    result += 'Demo Accounts:\n';
    result += '-' * 40 + '\n';
    
    for (var cred in credentials) {
      result += '${cred['role']}:\n';
      result += '  Email: ${cred['email']}\n';
      result += '  Password: ${cred['password']}\n\n';
    }
    
    return result;
  }
}

