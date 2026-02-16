import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "CarryU Money", // Matching the UI Title
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Large Balance Section (Uber Style)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CarryU Cash",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    "\$${controller.balance.value.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
                  const SizedBox(height: 15),
                  // Add Funds Button
                  GestureDetector(
                    onTap: () => debugPrint("Add Funds Tapped"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "Add funds",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 8, color: Color(0xFFF6F6F6)),

            // 2. Gift Cards / Promotions Section
            _buildSectionTile(Icons.card_giftcard, "Gift cards"),
            const Divider(height: 1, indent: 60),
            _buildSectionTile(Icons.local_offer_outlined, "Promotions"),

            const Divider(thickness: 8, color: Color(0xFFF6F6F6)),

            // 3. Activity / Transaction History
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Activity",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.transactions.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 20),
              itemBuilder: (context, index) {
                final tx = controller.transactions[index];
                return ListTile(
                  onTap: () {},
                  title: Text(
                    tx['title'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  subtitle: Text(
                    tx['date'],
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
                  ),
                  trailing: Text(
                    "${tx['amount'] > 0 ? '' : ''}\$${tx['amount'].toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  // Helper for Gift Card / Promo items
  Widget _buildSectionTile(IconData icon, String title) {
    return ListTile(
      onTap: () {},
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
    );
  }
}