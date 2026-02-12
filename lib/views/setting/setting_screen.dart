import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../controller/setting_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildNotificationTile(Icons.notifications_sharp),
          const Divider(height: 1, thickness: 0.5),

          _buildListTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              Get.toNamed(AppRoutes.changePasswordScreen);
            },
          ),
          const Divider(height: 1, thickness: 0.5),

         /* _buildListTile(
            icon: Icons.assignment_outlined,
            title: 'Support and Helpdesk',
            onTap: () {
              Get.toNamed(AppRoutes.contactScreen);
            },
          ),
          const Divider(height: 1, thickness: 0.5),
*/
          _buildListTile(
            icon: Icons.help_outline,
            title: 'Privacy Policy',
            onTap: () {
              Get.toNamed(AppRoutes.cmsScreen, arguments: {'from': 'privacy'});
            },
          ),
          const Divider(height: 1, thickness: 0.5),

          // _buildListTile(
          //   icon: Icons.language,
          //   title: 'Language',
          //   trailingText: "English",
          //   onTap: () {},
          // ),
          // const Divider(height: 1, thickness: 0.5),

          _buildListTile(
            icon: Icons.description_outlined,
            title: 'Terms and Conditions',
            onTap: () {
              Get.toNamed(AppRoutes.cmsScreen, arguments: {'from': 'terms'});
            },
          ),
          const Divider(height: 1, thickness: 0.5),

          // Restore Delete Account Tile
          _buildListTile(
            icon: Icons.person_remove_outlined,
            title: 'Delete Account',
            showTrailing: true,
            onTap: () => showDelete(context),
          ),
          const Divider(height: 1, thickness: 0.5),

          _buildListTile(
            icon: Icons.logout,
            title: 'Logout',
            showTrailing: false,
            onTap: () => showLogout(context),
          ),
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildNotificationTile(IconData icon) {
    return Obx(() {
      return ListTile(
        leading: _buildIcon(icon),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        trailing: Switch(
          value: controller.isNotificationEnabled.value,
          onChanged: controller.toggleNotification,
          activeColor: Colors.black,
          activeTrackColor: Colors.grey.shade300,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      );
    });
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    bool showTrailing = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: _buildIcon(icon),
      splashColor: Colors.transparent,
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                trailingText,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              ),
            ),
          if (showTrailing)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // --- Dialogs ---

  void showLogout(BuildContext context) {
    _showActionSheet(
      context: context,
      title: "Log Out",
      message: "Are you sure you want to logout?",
      iconPath: Assets.iconsLogoutIcon,
      onConfirm: () {
        Get.back();
        // controller.logout();
      },
    );
  }

  void showDelete(BuildContext context) {
    _showActionSheet(
      context: context,
      title: "Delete Account",
      message: "Are you sure you want to delete this account?",
      iconPath: Assets.iconsDeleteAccount,
      onConfirm: () {
        Get.back();
        // controller.deleteAccount();
      },
    );
  }

  // Generic helper for both Bottom Sheets
  void _showActionSheet({
    required BuildContext context,
    required String title,
    required String message,
    required String iconPath,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(iconPath, width: 60, height: 60, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: onConfirm,
                        child: Text("Yes", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("No", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}