import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/property/add_property_screen.dart';
import 'screens/property/property_detail_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/dashboard/agent_dashboard_screen.dart';
import 'screens/dashboard/landlord_dashboard_screen.dart';
import 'screens/dashboard/owner_dashboard_screen.dart';
import 'screens/filters/advanced_filters_screen.dart';
import 'screens/map/property_map_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/booking/bookings_screen.dart';
import 'screens/booking/schedule_visit_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/saved_properties_screen.dart';
import 'screens/legal/terms_screen.dart';
import 'screens/legal/privacy_screen.dart';
import 'screens/legal/help_screen.dart';
import 'screens/property/edit_property_screen.dart';
import 'screens/payment/subscription_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_success_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/manage_agents_screen.dart';
import 'screens/admin/approve_listings_screen.dart';
import 'screens/admin/reports_screen.dart';
import 'screens/admin/analytics_screen.dart';
import 'screens/settings/notification_settings_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/property_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/booking_provider.dart';
import 'models/property.dart';
import 'utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling for crashes
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'Estato',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            tertiary: AppColors.accent,
            brightness: Brightness.light,
            surface: AppColors.backgroundLight,
          ),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.light().textTheme,
          ).apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: AppColors.background,
            iconTheme: const IconThemeData(color: AppColors.primary),
            titleTextStyle: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
            errorStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.error,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.cardBackground,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          dialogTheme: DialogThemeData(
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            contentTextStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const HomeScreen(),
          '/add-property': (context) => const AddPropertyScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/saved-properties': (context) => const SavedPropertiesScreen(),
          '/agent-dashboard': (context) => const AgentDashboardScreen(),
          '/landlord-dashboard': (context) => const LandlordDashboardScreen(),
          '/owner-dashboard': (context) => const OwnerDashboardScreen(),
          '/admin-dashboard': (context) => const AdminDashboardScreen(),
          '/advanced-filters': (context) => const AdvancedFiltersScreen(),
          '/property-map': (context) => const PropertyMapScreen(),
          '/chats': (context) => const ChatListScreen(),
          '/bookings': (context) => const BookingsScreen(),
          '/subscription': (context) => const SubscriptionScreen(),
          '/terms': (context) => const TermsScreen(),
          '/privacy': (context) => const PrivacyScreen(),
          '/help': (context) => const HelpScreen(),
          '/notification-settings': (context) => const NotificationSettingsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/schedule-visit') {
            final property = settings.arguments as Property;
            return MaterialPageRoute(
              builder: (context) => ScheduleVisitScreen(property: property),
            );
          }
          if (settings.name == '/otp-verification') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                phoneNumber: args['phoneNumber'],
                email: args['email'],
                isPhoneVerification: args['isPhoneVerification'] ?? true,
              ),
            );
          }
          if (settings.name == '/edit-property') {
            final property = settings.arguments as Property;
            return MaterialPageRoute(
              builder: (context) => EditPropertyScreen(property: property),
            );
          }
          if (settings.name == '/payment') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentScreen(
                amount: args['amount'],
                planName: args['planName'],
              ),
            );
          }
          if (settings.name == '/payment-success') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(
                amount: args['amount'],
                planName: args['planName'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
