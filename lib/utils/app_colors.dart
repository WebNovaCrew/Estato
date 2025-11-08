/// App Color Theme Constants
/// 
/// Centralized color definitions for the Estato app
/// Change colors here to update the entire app theme
/// Beautiful Violet Theme

import 'package:flutter/material.dart';

class AppColors {
  // Primary Color - Rich Violet/Purple (Premium Real Estate)
  static const Color primary = Color(0xFF6C5CE7); // Rich Violet
  static const Color primaryDark = Color(0xFF5A4FCF); // Darker shade
  static const Color primaryLight = Color(0xFF8B7FE8); // Lighter shade
  static const Color primaryUltraLight = Color(0xFFE8E5FF); // Ultra light for backgrounds
  
  // Secondary Color - Deep Purple/Magenta (Accent)
  static const Color secondary = Color(0xFFA29BFE); // Soft Purple
  static const Color secondaryDark = Color(0xFF8E7EF2); // Darker shade
  static const Color secondaryLight = Color(0xFFC4B5FD); // Lighter shade
  
  // Accent Colors - Complementary Violet Tones
  static const Color accent = Color(0xFF9B59B6); // Purple
  static const Color accentLight = Color(0xFFBB8FCE); // Light Purple
  static const Color accentDark = Color(0xFF7D3C98); // Dark Purple
  
  // Background Colors
  static const Color background = Color(0xFFFAFBFF); // Soft white with violet tint
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure white
  static const Color backgroundDark = Color(0xFFF5F7FA); // Light gray
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436); // Dark gray
  static const Color textSecondary = Color(0xFF636E72); // Medium gray
  static const Color textLight = Color(0xFFB2BEC3); // Light gray
  
  // Status Colors
  static const Color success = Color(0xFF00B894); // Teal green
  static const Color error = Color(0xFFE84393); // Pink
  static const Color warning = Color(0xFFFDCB6E); // Yellow
  static const Color info = Color(0xFF74B9FF); // Light blue
  
  // UI Element Colors
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE8E8E8);
  static const Color border = Color(0xFFE0E0E0);
  
  // Gradient Colors - Beautiful Violet Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF6C5CE7), // Rich Violet
    Color(0xFFA29BFE), // Soft Purple
    Color(0xFF9B59B6), // Purple
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFFA29BFE), // Soft Purple
    Color(0xFFC4B5FD), // Light Purple
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFFFAFBFF), // Soft white
    Color(0xFFF0F2FF), // Light violet tint
    Color(0xFFE8E5FF), // Ultra light violet
  ];
  
  static const List<Color> cardGradient = [
    Colors.white,
    Color(0xFFF8F9FF),
  ];
  
  // Glass morphism effect
  static const Color glassBackground = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
}

