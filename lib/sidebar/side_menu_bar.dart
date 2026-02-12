import 'package:cached_network_image/cached_network_image.dart';
import 'package:carry_you_user/common/db_helper.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../common/apputills.dart';
import '../generated/assets.dart';
import '../network/api_constants.dart';
import '../network/api_provider.dart';

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({super.key});

  Future<void> _handleLogout() async {
    try {
      var response = await ApiProvider().logout();
      if (response.success == true) {
        DbHelper().clearAll();
        Get.offAllNamed(AppRoutes.loginView);
      } else {
        Utils.showErrorToast(message: response.message ?? "Logout failed");
      }
    } catch (e) {
      Utils.showErrorToast(message: "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Profile Header
          ClipOval(
            child: CachedNetworkImage(
              imageUrl:
              ApiConstants.userImageUrl +(DbHelper().getUserModel()?.profilePicture ?? ""),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, error, stackTrace) {
                return Image.asset(
                  Assets.imagesImagePlaceholder,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            DbHelper().getUserModel()?.fullName ?? "",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 40),

          // Navigation Items
          _buildDrawerItem(Icons.home_outlined, "Home",1, isSelected: false),
          _buildDrawerItem(Icons.access_time, "Job History",2),
          // _buildDrawerItem(Icons.account_balance_wallet_outlined, "Payment Status",3),
          _buildDrawerItem(Icons.notifications_none, "Notifications",4),
          _buildDrawerItem(Icons.person_outline, "My Profile",5),
          _buildDrawerItem(Icons.settings_outlined, "Account",6),

          const Spacer(),

          _buildDrawerItem(Icons.logout, "Logout",7),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int type, {bool isSelected = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: () {
        Get.back();
        switch(type){
          case 1:{

          }
          case 2:{
            Get.toNamed(AppRoutes.activityScreen);
          }
          case 3:{
            Get.toNamed(AppRoutes.walletScreen);

          }
          case 4:{
            Get.toNamed(AppRoutes.notificationScreen);

          }
          case 5:{
            Get.toNamed(AppRoutes.profileScreen);
          }
          case 6:{
            Get.toNamed(AppRoutes.accountScreen);

          }
          case 7:{
            _handleLogout();
          }
        }
      },
    );
  }
}