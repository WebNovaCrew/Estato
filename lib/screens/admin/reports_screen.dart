import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch reports from API
    final reports = [
      {'id': '1', 'type': 'Property', 'description': 'Inappropriate content', 'status': 'Pending'},
      {'id': '2', 'type': 'User', 'description': 'Spam account', 'status': 'Resolved'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports & Complaints',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: reports.isEmpty
          ? Center(
              child: Text(
                'No reports',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return _buildReportCard(context, report);
              },
            ),
    );
  }

  Widget _buildReportCard(BuildContext context, Map<String, String> report) {
    final isResolved = report['status'] == 'Resolved';
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report['type']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isResolved ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report['status']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isResolved ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            report['description']!,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          if (!isResolved) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _resolveReport(context, report['id']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Mark as Resolved'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _resolveReport(BuildContext context, String reportId) {
    // TODO: Implement API call to resolve report
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Report resolved',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

