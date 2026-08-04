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

  static const Color _amber = Color(0xFFFFC107);

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
    final user = DbHelper().getUserModel();
    final String name = user?.fullName ?? "";
    final String subtitle =
        (user?.email != null && user!.email!.isNotEmpty) ? user.email! : "Carry You Member";

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(name, subtitle),
          const SizedBox(height: 18),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _buildDrawerItem(Icons.home_rounded, "Home", 1, isSelected: true),
                _buildDrawerItem(Icons.history_rounded, "Ride History", 2),
                _buildDrawerItem(Icons.notifications_rounded, "Notifications", 4),
                _buildDrawerItem(Icons.person_rounded, "My Profile", 5),
                _buildDrawerItem(Icons.settings_rounded, "Account", 6),
              ],
            ),
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
            child: Material(
              color: const Color(0xFFFDECEC),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _handleLogout,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8D7D7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout_rounded,
                            color: Color(0xFFE53935), size: 20),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 4),
            child: Center(
              child: Text(
                "v1.0.0",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name, String subtitle) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F2A38), Color(0xFF0E1622)],
        ),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(45)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 60, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _amber, width: 2.5),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: ApiConstants.userImageUrl +
                        (DbHelper().getUserModel()?.profilePicture ?? ""),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade500,
                      child: Container(width: 64, height: 64, color: Colors.white),
                    ),
                    errorWidget: (context, error, stackTrace) => Image.asset(
                      Assets.images.imagePlaceholder.path,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF263241),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: _amber, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "MEMBER",
                      style: GoogleFonts.poppins(
                        color: _amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int type,
      {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFCEFC7) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onItemTap(type),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected ? _amber : const Color(0xFFF2F2F4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.black54,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTap(int type) {
    Get.back();
    switch (type) {
      case 1:
        break;
      case 2:
        Get.toNamed(AppRoutes.activityScreen);
        break;
      case 4:
        Get.toNamed(AppRoutes.notificationScreen);
        break;
      case 5:
        Get.toNamed(AppRoutes.profileScreen);
        break;
      case 6:
        Get.toNamed(AppRoutes.accountScreen);
        break;
    }
  }
}
