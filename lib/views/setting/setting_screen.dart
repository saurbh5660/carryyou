import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F6F8),
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          _section("Preferences", [
            _buildNotificationTile(),
          ]),
          const SizedBox(height: 22),

          _section("Security & Account", [
            _buildTile(
              icon: Icons.lock_outline_rounded,
              color: const Color(0xFF3B82F6),
              title: 'Change Password',
              onTap: () => Get.toNamed(AppRoutes.changePasswordScreen),
            ),
            _buildTile(
              icon: Icons.person_remove_alt_1_outlined,
              color: const Color(0xFFF97316),
              title: 'Delete Account',
              onTap: () => showDelete(context),
            ),
          ]),
          const SizedBox(height: 22),

          _section("Support & Legal", [
            _buildTile(
              icon: Icons.headset_mic_outlined,
              color: const Color(0xFF10B981),
              title: 'Support and Helpdesk',
              onTap: () => Get.toNamed(AppRoutes.contactScreen),
            ),
            _buildTile(
              icon: Icons.privacy_tip_outlined,
              color: const Color(0xFF8B5CF6),
              title: 'Privacy Policy',
              onTap: () =>
                  Get.toNamed(AppRoutes.cmsScreen, arguments: {'from': 'privacy'}),
            ),
            _buildTile(
              icon: Icons.description_outlined,
              color: const Color(0xFF64748B),
              title: 'Terms and Conditions',
              onTap: () =>
                  Get.toNamed(AppRoutes.cmsScreen, arguments: {'from': 'terms'}),
            ),
          ]),
          const SizedBox(height: 22),

          _section("Session", [
            _buildTile(
              icon: Icons.logout_rounded,
              color: const Color(0xFFEF4444),
              title: 'Logout',
              titleColor: const Color(0xFFEF4444),
              showChevron: false,
              onTap: () => showLogout(context),
            ),
          ]),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _section(String label, List<Widget> tiles) {
    final List<Widget> children = [];
    for (int i = 0; i < tiles.length; i++) {
      children.add(tiles[i]);
      if (i != tiles.length - 1) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: 66),
            child: Divider(height: 1, thickness: 0.6, color: Colors.grey.shade200),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNotificationTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          _softIcon(Icons.notifications_rounded, const Color(0xFFF2B705)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Obx(
            () => Switch(
              value: controller.isNotificationEnabled.value,
              onChanged: controller.toggleNotification,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFFF2B705),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    bool showChevron = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              _softIcon(icon, color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? Colors.black,
                  ),
                ),
              ),
              if (showChevron)
                Icon(Icons.chevron_right_rounded,
                    size: 22, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _softIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  // --- Dialogs ---

  void showLogout(BuildContext context) {
    _showActionSheet(
      context: context,
      title: "Log Out",
      message: "Are you sure you want to logout?",
      iconPath: Assets.icons.logoutIcon.path,
      onConfirm: () {
        controller.logout();
      },
    );
  }

  void showDelete(BuildContext context) {
    _showActionSheet(
      context: context,
      title: "Delete Account",
      message: "Are you sure you want to delete this account?",
      iconPath: Assets.icons.deleteAccount.path,
      onConfirm: () {
        controller.deleteAccount();
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
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(iconPath,
                      width: 60, height: 60, color: Colors.black),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: onConfirm,
                        child: Text("Yes",
                            style:
                                GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("No",
                            style:
                                GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
