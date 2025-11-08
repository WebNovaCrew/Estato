import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String planName;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.planName,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'UPI';
  final List<String> _paymentMethods = ['UPI', 'Card', 'Wallet', 'Net Banking'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
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
                    'Order Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.planName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '₹${widget.amount.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '₹${widget.amount.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Payment Methods
            Text(
              'Select Payment Method',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._paymentMethods.map((method) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPaymentMethodCard(method),
                )),
            
            const SizedBox(height: 32),
            
            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Pay ₹${widget.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Security Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Secure payment encrypted',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String method) {
    final isSelected = _selectedPaymentMethod == method;
    final icon = _getPaymentIcon(method);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Radio<String>(
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'UPI':
        return Icons.account_balance_wallet;
      case 'Card':
        return Icons.credit_card;
      case 'Wallet':
        return Icons.wallet;
      case 'Net Banking':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  void _processPayment() {
    // TODO: Integrate with payment gateway (Razorpay, Stripe, etc.)
    // Example:
    // final razorpay = Razorpay();
    // var options = {
    //   'key': ConfigService.razorpayKeyId,
    //   'amount': widget.amount * 100, // in paise
    //   'name': 'Estato',
    //   'description': widget.planName,
    //   'prefill': {'contact': '9876543210', 'email': 'user@example.com'}
    // };
    // razorpay.open(options);

    // Simulate payment success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          amount: widget.amount,
          planName: widget.planName,
        ),
      ),
    );
  }
}

