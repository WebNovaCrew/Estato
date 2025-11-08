import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/demo_credentials.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Fade animation controller
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Slide animation controller
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    // Start animations
    _logoAnimationController.forward();
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // Call login method (works with both demo and backend providers)
        await authProvider.login(
          _emailController.text,
          _passwordController.text,
        );
        
        // Check if login was successful
        if (mounted) {
          if (authProvider.isLoggedIn) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Login failed. Please check your credentials.',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login failed: ${e.toString()}',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Animated Logo with gradient
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: RotationTransition(
                          turns: _logoRotationAnimation,
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: AppColors.primaryGradient,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.home_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Animated Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Welcome Back!',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: AppColors.primaryGradient,
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Login to continue to Estato',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  
                    // Animated Form Fields
                    _buildAnimatedField(
                      index: 0,
                      child: _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildAnimatedField(
                      index: 1,
                      child: _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Forgot Password
                    _buildAnimatedField(
                      index: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: AppColors.primaryGradient,
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 150, 70),
                                ),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  
                    // Animated Login Button
                    _buildAnimatedField(
                      index: 3,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _handleLogin,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  
                    // Divider
                    _buildAnimatedField(
                      index: 4,
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.divider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.divider)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Demo Credentials Info
                    _buildAnimatedField(
                      index: 5,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryUltraLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Demo Mode',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use any email/password or try these:',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...DemoLoginInfo.credentials.take(2).map((cred) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                child: Text(
                                  '${cred['role']}:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${cred['email']} / ${cred['password']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  DemoLoginInfo.title,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DemoLoginInfo.description,
                                        style: GoogleFonts.poppins(fontSize: 13),
                                      ),
                                      const SizedBox(height: 16),
                                      ...DemoLoginInfo.credentials.map((cred) => Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cred['role']!,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text('Email: ${cred['email']}', 
                                              style: GoogleFonts.poppins(fontSize: 12)),
                                            Text('Password: ${cred['password']}',
                                              style: GoogleFonts.poppins(fontSize: 12)),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            'View all demo accounts →',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: AppColors.primaryGradient,
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 70),
                                ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                      ),
                    ),
                  
                    // Register Link
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/register');
                            },
                            child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: AppColors.primaryGradient,
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 100, 70),
                                  ),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({required int index, required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.3 + (index * 0.05)),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _slideAnimationController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            (0.5 + (index * 0.1)).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeAnimationController,
            curve: Interval(
              (index * 0.1).clamp(0.0, 1.0),
              (0.8 + (index * 0.1)).clamp(0.0, 1.0),
              curve: Curves.easeIn,
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryUltraLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.border.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

