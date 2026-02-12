import 'dart:io';

import 'package:carry_you_user/controller/edit_profile_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../common/app_colors.dart';
import '../../common/textform_field.dart';
import '../../controller/signup_controller.dart';
import '../../generated/assets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileController controller = Get.put(EditProfileController());

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
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: AsymmetricHeaderClipper(),
                  child: Container(
                    height: 320,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:   Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(() {
                          final path = controller.profileImage.value;
                          Logger().d("ddds----------- "+path!);
                          return Container(
                            width: 164,
                            height: 164,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: path == null || path.isEmpty
                                  ? Image.asset(
                                Assets.imagesImagePlaceholder,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                                  : path.startsWith('http')
                                  ? Image.network(
                                path,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    Assets.imagesImagePlaceholder,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  );
                                },

                              )
                                  : Image.file(
                                File(path),
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    Assets.imagesImagePlaceholder,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller.cameraHelper.openImagePicker(0);
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Full Name"),
                  CommonTextField(
                    controller: controller.nameController,
                    hintText: 'Enter First Name',
                    borderSide: true,
                    titleSize: 14,
                    borderRadius: 28,
                    elevation: 1,
                    maxLength: 50,
                    maxLines: 1,
                    counterText: '',
                    titleColor: Colors.black,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    borderColor: AppColor.borderColor,
                  ),

                  const SizedBox(height: 20),

                  _buildLabel("Email", isOptional: true),
                  CommonTextField(
                    controller: controller.emailController,
                    hintText: 'Enter Email',
                    borderSide: true,
                    titleSize: 14,
                    borderRadius: 28,
                    elevation: 1,
                    maxLength: 50,
                    maxLines: 1,
                    counterText: '',
                    titleColor: Colors.black,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    borderColor: AppColor.borderColor,
                  ),

                  const SizedBox(height: 20),
                  _buildLabel("Phone Number", isOptional: false),
                  CommonTextField(
                    controller: controller.phoneController,
                    borderSide: true,
                    maxLength: 14,
                    borderRadius: 28,
                    counterText: '',
                    elevation: 1,
                    maxLines: 1,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    borderColor: AppColor.borderColor,
                    hintText: 'Enter',
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            controller.selectedDialCode.value =
                            "+${country.phoneCode}";
                            controller.selectedFlag.value = country.flagEmoji;
                          },
                        );
                      },
                      child: Obx(() {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.selectedFlag.value,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                controller.selectedDialCode.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 60),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.updateApi();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Update",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isOptional = false, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
          children: [
            if (isOptional)
              const TextSpan(
                text: " (optional)",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
              ),
            if (isRequired)
              const TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isPhone) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade400, width: 0.8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
            width: 24,
            errorBuilder: (c, e, s) => const Icon(Icons.flag),
          ),
          const SizedBox(width: 8),
          const Text("+1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class AsymmetricHeaderClipper extends CustomClipper<Path> {
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