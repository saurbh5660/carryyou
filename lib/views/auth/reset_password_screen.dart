import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/textform_field.dart';
import '../../controller/reset_password_controller.dart';
import '../../generated/assets.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

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
       /* title: Text(
          'Forgot Password',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,*/
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                   /* Center(
                      child: Image.asset(
                        Assets.iconsSplashLogo,
                        height: 120,
                        width: 120,
                      ),
                    ),
                    const SizedBox(height: 16),
*/
                    Center(
                      child: AppText(
                        text:
                        'Forgot Password?',
                        textSize: 18,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: AppText(
                          text:
                              'Please enter your register email id. We will send One Time Password on your email id.',
                          textSize: 14,
                          textAlign: TextAlign.center,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CommonTextField(
                      title: 'Email',
                      controller: controller.emailController,
                      hintText: 'Enter Email',
                      titleFontWeight: FontWeight.w500,
                      borderSide: true,
                      titleSize: 14,
                      borderRadius: 28,
                      maxLines: 1,
                      elevation: 1,
                      titleColor: Colors.black,
                      focusBorderColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      borderColor: AppColor.borderColor,
                    ),
                    const SizedBox(height: 50),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
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
                            'Send',
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
            ],
          ),
        ),
      ),
    );
  }
}
