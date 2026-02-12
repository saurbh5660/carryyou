import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class SubscriptionBuyScreen extends StatefulWidget {
  const SubscriptionBuyScreen({super.key});

  @override
  State<SubscriptionBuyScreen> createState() => _SubscriptionBuyScreenState();
}

class _SubscriptionBuyScreenState extends State<SubscriptionBuyScreen> {
  // To track which plan is selected
  bool isMonthlySelected = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Get.offAllNamed(AppRoutes.loginView);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
          title: Text(
            'Subscription',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // --- Logo Placeholder ---
                Center(
                  child: Image.asset(
                    Assets.imagesAppLogo,
                    height: 120,
                  ),
                ),

                const SizedBox(height: 50),

                // --- Monthly Plan Card ---
                _buildPlanCard(
                  title: "\$99.99",
                  subtitle: "Monthly",
                  description: "Limited number of daily predictions",
                  isSelected: isMonthlySelected,
                  onTap: () => setState(() => isMonthlySelected = true),
                ),

                const SizedBox(height: 16),

                // --- Yearly Plan Card ---
                _buildPlanCard(
                  title: "\$399.99",
                  subtitle: "Yearly",
                  description: "Full access to all predictions",
                  isSelected: !isMonthlySelected,
                  onTap: () => setState(() => isMonthlySelected = false),
                ),

                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.dashboardView);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Colors matched to your screenshot
          color: isSelected ? const Color(0xFFF7941D) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}