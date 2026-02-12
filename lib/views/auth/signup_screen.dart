import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/textform_field.dart';
import '../../controller/signup_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupController controller = Get.put(SignupController());

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
          'Complete your Profile',
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
                  const SizedBox(height: 24),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(() {
                          final path = controller.profileImage.value;
                          return Container(
                            width: 124,
                            height: 124,
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
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : path.startsWith('http')
                                  ? Image.network(
                                      path,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              Assets.imagesImagePlaceholder,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    )
                                  : Image.file(
                                      File(path),
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              Assets.imagesImagePlaceholder,
                                              width: 120,
                                              height: 120,
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

                  const SizedBox(height: 40),

                  CommonTextField(
                    title: 'Full Name',
                    controller: controller.nameController,
                    hintText: 'Enter Full Name',
                    titleFontWeight: FontWeight.w500,
                    borderSide: true,
                    titleSize: 14,
                    borderRadius: 28,
                    elevation: 1,
                    maxLength: 30,
                    maxLines: 1,
                    counterText: '',
                    titleColor: Colors.black,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.name,
                    borderColor: AppColor.borderColor,
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    title: 'Email',
                    controller: controller.emailController,
                    hintText: 'Enter Email',
                    titleFontWeight: FontWeight.w500,
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
                  CommonTextField(
                    title: 'Phone Number',
                    titleFontWeight: FontWeight.w500,
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
                  const SizedBox(height: 20),
                  CommonTextField(
                    title: 'City',
                    controller: controller.cityController,
                    hintText: 'Enter City',
                    titleFontWeight: FontWeight.w500,
                    borderSide: true,
                    titleSize: 14,
                    borderRadius: 28,
                    elevation: 1,
                    maxLength: 50,
                    maxLines: 1,
                    counterText: '',
                    titleColor: Colors.black,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.text,
                    borderColor: AppColor.borderColor,
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    title: 'Country',
                    controller: controller.countryController,
                    hintText: 'Enter Country',
                    titleFontWeight: FontWeight.w500,
                    borderSide: true,
                    titleSize: 14,
                    borderRadius: 28,
                    elevation: 1,
                    maxLength: 50,
                    maxLines: 1,
                    counterText: '',
                    titleColor: Colors.black,
                    focusBorderColor: Colors.black,
                    keyboardType: TextInputType.text,
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Obx(() {
                        return Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            value: controller.isSwitchActive.value,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(color: Colors.grey),
                            onChanged: (value) {
                              controller.isSwitchActive.value = value ?? false;
                            },
                          ),
                        );
                      }),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'I agree to the ',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            value: controller.isPrivacySwitchActive.value,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(color: Colors.grey),
                            onChanged: (value) {
                              controller.isPrivacySwitchActive.value = value ?? false;
                            },
                          ),
                        );
                      }),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'I agree to the ',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.validationSignup();
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
                          'Sign Up',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Already have an account?',
                        textSize: 14,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 5),

                      AppText(
                        text: 'Log in',
                        textSize: 14,
                        color: AppColor.yellowColor,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontWeight: FontWeight.w600,
                        onPressed: () async {
                          Get.back();
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
