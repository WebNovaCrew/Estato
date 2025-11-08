import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class ApproveListingsScreen extends StatelessWidget {
  const ApproveListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch pending listings from API
    final pendingListings = [
      {'id': '1', 'title': '3 BHK Apartment', 'location': 'Gomti Nagar', 'price': '₹85 Lac'},
      {'id': '2', 'title': '2 BHK Flat', 'location': 'Hazratganj', 'price': '₹25,000/month'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approve Listings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: pendingListings.isEmpty
          ? Center(
              child: Text(
                'No pending listings',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingListings.length,
              itemBuilder: (context, index) {
                final listing = pendingListings[index];
                return _buildListingCard(context, listing);
              },
            ),
    );
  }

  Widget _buildListingCard(BuildContext context, Map<String, String> listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing['title']!,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                listing['location']!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            listing['price']!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _rejectListing(context, listing['id']!),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _approveListing(context, listing['id']!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _approveListing(BuildContext context, String listingId) {
    // TODO: Implement API call to approve listing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Listing approved successfully',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rejectListing(BuildContext context, String listingId) {
    // TODO: Implement API call to reject listing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Listing rejected',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

