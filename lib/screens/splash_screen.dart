import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
      
      if (!hasSeenOnboarding) {
        // First time - show onboarding
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
      } else {
        // Check if user is logged in
        if (mounted) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.checkLoginStatus();
          
          if (authProvider.isLoggedIn) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
              colors: AppColors.backgroundGradient,
          ),
        ),
        child: Stack(
          children: [
            // Decorative elements in corners
            Positioned(
              top: -50,
              left: -50,
              child: _buildDecorativePattern(),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: _buildDecorativeCircle(30, AppColors.secondary.withOpacity(0.3)),
            ),
            Positioned(
              top: 100,
              right: 60,
              child: _buildDecorativeCircle(15, AppColors.primary.withOpacity(0.2)),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: _buildDecorativePattern(),
            ),
            Positioned(
              bottom: 100,
              left: 30,
              child: _buildDecorativeCircle(20, AppColors.secondary.withOpacity(0.3)),
            ),
            Positioned(
              bottom: 150,
              left: 70,
              child: _buildDecorativeCircle(12, AppColors.primary.withOpacity(0.2)),
            ),
            
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // House Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              size: 70,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            Positioned(
                              bottom: 30,
                              child: Text(
                                'E',
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // App Name
                      Text(
                        'Estato',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Tagline
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'Your ',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF62B6CB),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'Home',
                              style: GoogleFonts.poppins(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ', Our ',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF62B6CB),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'Priority',
                              style: GoogleFonts.poppins(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativePattern() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: CustomPaint(
        painter: DiagonalLinesPainter(),
      ),
    );
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withOpacity(0.2)
      ..strokeWidth = 1.5;

    for (double i = -size.width; i < size.width * 2; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

