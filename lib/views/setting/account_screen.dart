import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- Added AppBar with Back Button and Title ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Account',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ramzi Sherif',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '5.0',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFEEEEEE),
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 2. Quick Action Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildQuickAction(Icons.help, "Help", () {
                      Get.toNamed(AppRoutes.contactScreen);
                    }),
                    const SizedBox(width: 12),
                    _buildQuickAction(
                      Icons.account_balance_wallet,
                      "Wallet",
                      () {
                        Get.toNamed(AppRoutes.walletScreen);

                      },
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAction(Icons.history, "Trips", () {
                      Get.toNamed(AppRoutes.activityScreen);

                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(thickness: 1, height: 1),

              // 3. Settings List
              _buildListTile(
                Icons.people,
                "Family and teens",
                () => debugPrint("Family Tapped"),
              ),
              _buildListTile(Icons.settings, "Settings", () {
                Get.toNamed(AppRoutes.settingView);
              }),
              _buildListTile(Icons.chat_bubble, "Messages", () {
                Get.toNamed(AppRoutes.messageScreen);
              }),
              _buildListTile(
                Icons.card_giftcard,
                "Send a gift",
                () => debugPrint("Gift Tapped"),
              ),
              _buildListTile(
                Icons.monetization_on,
                "Earn by driving",
                () => debugPrint("Earn Tapped"),
              ),
              _buildListTile(
                Icons.business_center,
                "Business Hub",
                () => debugPrint("Business Tapped"),
              ),
              _buildListTile(
                Icons.confirmation_number,
                "Vouchers",
                () => debugPrint("Vouchers Tapped"),
              ),
              _buildListTile(
                Icons.emoji_events,
                "Partner Rewards",
                () => debugPrint("Rewards Tapped"),
              ),
              _buildListTile(
                Icons.label,
                "Promotions",
                () => debugPrint("Promos Tapped"),
              ),
              _buildListTile(
                Icons.favorite,
                "Favorites",
                () => debugPrint("Favorites Tapped"),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build the Help/Wallet/Trips squares with onTap functionality
  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.black),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build the list items with onTap functionality
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
