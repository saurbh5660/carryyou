import 'package:cached_network_image/cached_network_image.dart';
import 'package:carry_you_user/controller/profile_controller.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/assets.dart';
import '../../network/api_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    controller.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Header Section ---
              Stack(
                children: [
                  ClipPath(
                    clipper: ProfileHeaderClipper(),
                    child: Container(height: 320, color: Colors.black),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Obx(() {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  ApiConstants.userImageUrl +
                                  (controller
                                          .profileBody
                                          .value
                                          .profilePicture ??
                                      ""),
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.imagesImagePlaceholder,
                                  fit: BoxFit.cover,
                                  width: 130,
                                  height: 130,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- Info Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Obx(() {
                    return Column(
                      children: [
                        _infoRow("Name", controller.profileBody.value.fullName ?? ""),
                        const Divider(height: 40, thickness: 0.5),
                        _infoRow("Email", controller.profileBody.value.email ?? ""),
                        const Divider(height: 40, thickness: 0.5),
                        _infoRow("Phone Number", "${controller.profileBody.value.countryCode ?? ""} ${controller.profileBody.value.phoneNumber ?? ""}"),
                      ],
                    );
                  }
                ),
              ),

              /* const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _actionTile(Icons.badge_outlined, "Licence Detail", 1),
                    const SizedBox(height: 15),
                    _actionTile(
                      Icons.directions_car_filled_outlined,
                      "Vehicle Information",
                      2,
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
*/
              const SizedBox(height: 120),

              // --- Edit Profile Button ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      final result =await Get.toNamed(AppRoutes.editProfileScreen);
                      controller.getProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _actionTile(IconData icon, String title, int type) {
    return GestureDetector(
      onTap: () {
        if (type == 1) {
          Get.toNamed(AppRoutes.licenseDetail, arguments: {'from': "edit"});
        } else if (type == 2) {
          Get.toNamed(AppRoutes.vehicleDetail, arguments: {'from': "edit"});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black, size: 22),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 2,
          ),
        ),
      ),
    );
  }
}

class ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start at top left
    path.lineTo(0, 0);
    // Draw down the left side to a point
    path.lineTo(0, size.height - 40);
    // Draw to the center point (the 'V' or cross effect)
    // Adjust 'size.height - 110' to make the cross higher or lower
    path.lineTo(size.width / 2, size.height - 110);
    // Draw to the right side
    path.lineTo(size.width, size.height - 40);
    // Draw up to top right
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
