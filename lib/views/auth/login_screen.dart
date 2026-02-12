import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../common/app_string.dart';
import '../../common/app_text.dart';
import '../../common/textform_field.dart';
import '../../controller/common_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends GetView<CommonController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  const SizedBox(height: 50),
                  Center(
                    child: AppText(
                      text: 'Let\'s sign you in.',
                      textSize: 24,
                      textAlign: TextAlign.center,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: AppText(
                      text: 'Create your account now.',
                      textSize: 14,
                      textAlign: TextAlign.center,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CommonTextField(
                    title: 'Email',
                    titleFontWeight: FontWeight.w500,
                    controller: controller.emailController,
                    borderSide: true,
                    hintText: 'Enter Email',
                    borderRadius: 28,
                    elevation: 1,
                    maxLines: 1,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    borderColor: AppColor.borderColor,
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return CommonTextField(
                      title: 'Password',
                      controller: controller.passwordController,
                      borderSide: true,
                      borderRadius: 28,
                      hintText: 'Enter Password',
                      elevation: 1,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    /*  Row(
                        children: [
                          Obx(() {
                            return Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                value: controller.isSwitchActive.value,
                                activeTrackColor: AppColor.yellowColor,
                                thumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                onChanged: controller.onSwitchChanged,
                              ),
                            );
                          }),
                          AppText(
                            text: 'Remember Me',
                            textSize: 14,
                            color: Colors.black,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),*/
                      AppText(
                        text: 'Forgot Password?',
                        textSize: 12,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w400,
                        onPressed: () async {
                          Get.toNamed(AppRoutes.resetScreenView);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child:
                      ElevatedButton(
                        onPressed: () {
                          controller.validationLogin();
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
                          AppString.login,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: AppColor.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: AppText(
                      text: 'Login with Social',
                      textSize: 15,
                      color: Colors.grey.shade700,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 45,
                            height: 45,
                            color: AppColor.transparent,
                            child: Icon(
                              Icons.facebook,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 45,
                            height: 45,
                            color: AppColor.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                Assets.iconsGoogleIcon,
                                color: AppColor.googleColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        if (Platform.isIOS) ...{
                          Card(
                            elevation: 2,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: 45,
                              height: 45,
                              color: AppColor.transparent,
                              child: Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 27,
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Don\'t have an account?',
                        textSize: 14,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 5),
                      AppText(
                        text: 'Sign Up',
                        textSize: 14,
                        underline: true,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w600,
                        onPressed: () async {
                          Get.toNamed(AppRoutes.signupView);
                        },
                      ),
                    ],
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
