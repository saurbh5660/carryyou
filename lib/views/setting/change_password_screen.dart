import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/textform_field.dart';
import '../../controller/change_password_controller.dart';
import '../../controller/signup_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              Assets.iconsBack,
              color: Colors.black,
              width: 16,
              height: 16,
            ),
          ),
        ),
        title: Text(
          'Change Password',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Obx(() {
                    return CommonTextField(
                      title: 'Old Password',
                      controller: controller.oldPasswordController,
                      borderSide: true,
                      borderRadius: 28,
                      hintText: 'Enter Old Password',
                      elevation: 1,
                      counterText: '',
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      borderColor: AppColor.borderColor,
                      focusBorderColor: Colors.black,
                      obscureText: controller.oldPasswordVisibility.value,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.oldPasswordVisibility.value =
                              !controller.oldPasswordVisibility.value;
                        },
                        child: !controller.oldPasswordVisibility.value
                            ? Icon(Icons.visibility, color: AppColor.hintColor)
                            : Icon(
                                Icons.visibility_off,
                                color: AppColor.hintColor,
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    return CommonTextField(
                      title: 'New Password',
                      controller: controller.passwordController,
                      borderSide: true,
                      borderRadius: 28,
                      hintText: 'Enter New Password',
                      elevation: 1,
                      counterText: '',
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      borderColor: AppColor.borderColor,
                      focusBorderColor: Colors.black,
                      obscureText: controller.passwordVisibility.value,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.passwordVisibility.value =
                              !controller.passwordVisibility.value;
                        },
                        child: !controller.passwordVisibility.value
                            ? Icon(Icons.visibility, color: AppColor.hintColor)
                            : Icon(
                                Icons.visibility_off,
                                color: AppColor.hintColor,
                              ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  Obx(() {
                    return CommonTextField(
                      title: 'Confirm Password',
                      controller: controller.confirmPasswordController,
                      borderSide: true,
                      borderRadius: 28,
                      hintText: 'Enter Confirm Password',
                      elevation: 1,
                      counterText: '',
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      borderColor: AppColor.borderColor,
                      focusBorderColor: Colors.black,
                      obscureText: controller.confirmPasswordVisibility.value,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.confirmPasswordVisibility.value =
                          !controller.confirmPasswordVisibility.value;
                        },
                        child: !controller.confirmPasswordVisibility.value
                            ? Icon(Icons.visibility, color: AppColor.hintColor)
                            : Icon(
                          Icons.visibility_off,
                          color: AppColor.hintColor,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.verificationScreen);
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
                          'Submit',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: AppColor.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
