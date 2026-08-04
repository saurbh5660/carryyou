import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../common/app_colors.dart';
import '../../controller/signup_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Assets.icons.back.path,
              color: Colors.black,
              width: 16,
              height: 16,
            ),
          ),
        ),

        title: Text(
          'Verification Code',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  'Enter confirmation code',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'The 4-digit code sent to you at \n${Get.arguments?["email"] ?? ""}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'OTP',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: MaterialPinField(
                  length: 4,
                  hintCharacter: '-',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.circle,
                    borderWidth: 0.5,
                    cellSize: const Size(60, 60),
                    fillColor: Colors.white,
                    focusedFillColor: Colors.white,
                    filledFillColor: Colors.white,
                    borderColor: Colors.grey.shade200,
                    focusedBorderColor: AppColor.blackColor,
                    filledBorderColor: Colors.grey.shade200,
                    cursorColor: Colors.black,
                    showCursor: true,
                    entryAnimation: MaterialPinAnimation.scale,
                    animationDuration: const Duration(milliseconds: 300),
                  ),
                  onCompleted: (v) {},
                  onChanged: (value) {
                    controller.otpController.text = value;
                  },
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.otpVerify();
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
                      'Confirm',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: AppColor.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  controller.otpResend();
                },
                child: Center(
                  child: Text(
                    'Resend',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      color: AppColor.redColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
