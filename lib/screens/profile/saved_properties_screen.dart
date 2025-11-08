import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../widgets/property_card.dart';
import '../../utils/app_colors.dart';
import '../property/property_detail_screen.dart';

class SavedPropertiesScreen extends StatelessWidget {
  const SavedPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please login to view saved properties',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final favoriteIds = user.favoriteProperties;
    final savedProperties = propertyProvider.properties
        .where((property) => favoriteIds.contains(property.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Properties',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: savedProperties.isEmpty
          ? _buildEmptyState(context)
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.backgroundGradient,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedProperties.length,
                itemBuilder: (context, index) {
                  final property = savedProperties[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PropertyCard(property: property),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.backgroundGradient,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Properties',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Properties you save will appear here',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.search),
              label: const Text('Browse Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

