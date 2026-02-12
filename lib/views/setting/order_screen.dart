import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isPendingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Orders',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            /// Toggle Buttons
            Row(
              children: [
                _tabButton(
                  title: 'Pending',
                  isSelected: isPendingSelected,
                  onTap: () {
                    setState(() {
                      isPendingSelected = true;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _tabButton(
                  title: 'Delivered',
                  isSelected: !isPendingSelected,
                  onTap: () {
                    setState(() {
                      isPendingSelected = false;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Orders List
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return _orderCard(
                    image: index.isEven
                        ? 'assets/images/women_tshirt.png'
                        : 'assets/images/men_shirt.png',
                    title: 'Delivery expected on Tuesday',
                    subtitle: index.isEven
                        ? 'Women White Tshirt'
                        : "Men's Checked shirt",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tab Button Widget
  Widget _tabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade300,
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.rideDetailScreen);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Divider(height: 0.5, color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      Assets.imagesCoachDummy,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
