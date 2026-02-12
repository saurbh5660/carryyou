import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../controller/setting_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        title: Text(
          'Membership & Subscription System',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            _buildListTile(
              title: 'Subscription Plan',
              onTap: () {
                Get.toNamed(AppRoutes.subscriptionPlanScreen);
              },
            ),
            _buildListTile(
              title: 'Referral',
              onTap: () {
                Get.toNamed(AppRoutes.referralScreen);
              },
            ),
            _buildListTile(
              title: 'Payment History',
              onTap: () {
                Get.toNamed(AppRoutes.paymentHistoryScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(16),
        color: AppColor.white,
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Image.asset(Assets.iconsForwardIcon, width: 20, height: 20),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
    );
  }
}
