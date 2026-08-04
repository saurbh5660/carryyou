import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_colors.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  // Stream to trigger the spin
  final StreamController<int> selected = StreamController<int>();

  // Data for the wheel
  final List<int> items = [500, 10, 20, 80, 0, 100, 250, 50];

  // Colors matching the segments in your image
  final List<Color> colors = [
    const Color(0xFF9C27B0), // Purple (500)
    const Color(0xFF4CAF50), // Green (10)
    const Color(0xFF8BC34A), // Light Green (20)
    const Color(0xFF1E88E5), // Blue (80)
    const Color(0xFFFFA000), // Orange (0)
    const Color(0xFFD32F2F), // Red (100)
    const Color(0xFFFFC107), // Amber (250)
    const Color(0xFF37474F), // Dark Grey/Blue (50)
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- Your Custom AppBar ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Rewards',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // --- Fortune Wheel ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 300,
                child: FortuneWheel(
                  selected: selected.stream,
                  animateFirst: false,
                  indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: TriangleIndicator(color: Colors.amber),
                    ),
                  ],
                  items: [
                    for (int i = 0; i < items.length; i++)
                      FortuneItem(
                        child: Text(
                          items[i].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        style: FortuneItemStyle(
                          color: colors[i],
                          borderColor: const Color(0xFFFFD700), // Golden border
                          borderWidth: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- Spin Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selected.add(Fortune.randomInt(0, items.length));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Spin Now',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Rewards",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _rewardRow("10% Discount", "24 Feb, 2025"),
                    _rewardRow("30% Discount", "24 Feb, 2025"),
                    _rewardRow("7 Days of Free Videos", "24 Feb, 2025"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardRow(String title, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
