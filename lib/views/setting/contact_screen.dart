import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../common/textform_field.dart';
import '../../controller/signup_controller.dart';
import '../../generated/assets.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              Assets.iconsBack,
              width: 16,
              height: 16,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Support and Helpdesk',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Name
              CommonTextField(
                title: 'Name',
                controller: controller.nameController,
                hintText: 'Enter',
                borderSide: true,
                borderRadius: 28,
                elevation: 1,
                counterText: '',
                maxLines: 1,
                titleSize: 14,
                titleFontWeight: FontWeight.w500,
                borderColor: AppColor.borderColor,
                focusBorderColor: AppColor.borderColor,
              ),

              const SizedBox(height: 20),

              /// Email
              CommonTextField(
                title: 'Email (Optional)',
                controller: controller.emailController,
                hintText: 'Enter',
                borderSide: true,
                borderRadius: 28,
                elevation: 1,
                counterText: '',
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                titleSize: 14,
                titleFontWeight: FontWeight.w500,
                borderColor: AppColor.borderColor,
                focusBorderColor: AppColor.borderColor,
              ),

              const SizedBox(height: 20),

              /// Phone Number
              CommonTextField(
                title: 'Phone Number',
                controller: controller.phoneController,
                hintText: 'Enter Phone Number',
                borderSide: true,
                borderRadius: 28,
                elevation: 1,
                counterText: '',
                maxLines: 1,
                maxLength: 14,
                keyboardType: TextInputType.phone,
                borderColor: AppColor.borderColor,
                focusBorderColor: AppColor.borderColor,
                prefixIcon: GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (country) {
                        controller.selectedDialCode.value =
                        "+${country.phoneCode}";
                        controller.selectedFlag.value = country.flagEmoji;
                      },
                    );
                  },
                  child: Obx(
                        () => Padding(
                      padding: const EdgeInsets.only(left: 16),
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
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Message
              CommonTextField(
                title: 'Message',
                controller: controller.otpController, // reused safely
                hintText: 'Write',
                borderSide: true,
                borderRadius: 20,
                elevation: 1,
                counterText: '',
                maxLines: 5,
                borderColor: AppColor.borderColor,
                focusBorderColor: AppColor.borderColor,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
