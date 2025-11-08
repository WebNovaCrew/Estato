import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'User not logged in',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final myProperties = propertyProvider.properties
        .where((p) => p.ownerId == user.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Settings screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.phone,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.userType.toString().split('.').last.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'My Listings',
                  myProperties.length.toString(),
                  Icons.home_work,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Favorites',
                  user.favoriteProperties.length.toString(),
                  Icons.favorite,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Menu Items
          Text(
            'Account',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),

          _buildMenuItem(
            context,
            Icons.person_outline,
            'Edit Profile',
            () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
          _buildMenuItem(
            context,
            Icons.home_work_outlined,
            'My Properties',
            () {
              // TODO: Navigate to my properties screen
            },
          ),
          _buildMenuItem(
            context,
            Icons.favorite_outline,
            'Saved Properties',
            () {
              Navigator.pushNamed(context, '/saved-properties');
            },
          ),
          _buildMenuItem(
            context,
            Icons.history,
            'Search History',
            () {
              // Show search history
            },
          ),
          const SizedBox(height: 24),

          Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),

          _buildMenuItem(
            context,
            Icons.notifications,
            'Notifications',
            () {
              Navigator.pushNamed(context, '/notification-settings');
            },
          ),
          _buildMenuItem(
            context,
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            () {
              Navigator.pushNamed(context, '/privacy');
            },
          ),
          _buildMenuItem(
            context,
            Icons.help_outline,
            'Help & Support',
            () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          _buildMenuItem(
            context,
            Icons.info_outline,
            'About',
            () {
              _showAboutDialog(context);
            },
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    content: Text(
                      'Are you sure you want to logout?',
                      style: GoogleFonts.poppins(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await authProvider.logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Estato',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Home, Our Priority',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Estato is Lucknow\'s premier real estate platform for buying, selling, and renting properties.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

