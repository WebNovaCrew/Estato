import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class ManageAgentsScreen extends StatelessWidget {
  const ManageAgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch agents from API
    final pendingAgents = [
      {'id': '1', 'name': 'Amit Singh', 'email': 'amit@example.com', 'phone': '+91 9876543210'},
      {'id': '2', 'name': 'Priya Sharma', 'email': 'priya@example.com', 'phone': '+91 9876543211'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Agents',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: pendingAgents.isEmpty
          ? Center(
              child: Text(
                'No pending agents',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingAgents.length,
              itemBuilder: (context, index) {
                final agent = pendingAgents[index];
                return _buildAgentCard(context, agent);
              },
            ),
    );
  }

  Widget _buildAgentCard(BuildContext context, Map<String, String> agent) {
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
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: Text(
                  agent['name']![0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent['name']!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agent['email']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      agent['phone']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _rejectAgent(context, agent['id']!),
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
                  onPressed: () => _approveAgent(context, agent['id']!),
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

  void _approveAgent(BuildContext context, String agentId) {
    // TODO: Implement API call to approve agent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Agent approved successfully',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rejectAgent(BuildContext context, String agentId) {
    // TODO: Implement API call to reject agent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Agent rejected',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

