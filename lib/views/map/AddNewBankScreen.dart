import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../common/app_colors.dart'; // Ensure these paths match your project structure
import '../../common/textform_field.dart';

class AddNewBankScreen extends StatefulWidget {
  const AddNewBankScreen({super.key});

  @override
  State<AddNewBankScreen> createState() => _AddNewBankScreenState();
}

class _AddNewBankScreenState extends State<AddNewBankScreen> {
  final TextEditingController swiftController = TextEditingController();
  final TextEditingController bankBranchController = TextEditingController();
  final TextEditingController accountNoController = TextEditingController();
  final TextEditingController confirmAccountController = TextEditingController();
  final TextEditingController holderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add New Bank',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              _buildBankField(
                title: 'Swift Code',
                controller: swiftController,
                hintText: 'Enter',
              ),
              const SizedBox(height: 20),

              // Bank Branch Input
              _buildBankField(
                title: 'Bank Branch',
                controller: bankBranchController,
                hintText: 'Enter',
              ),

              const SizedBox(height: 20),

              // Account Number Input
              _buildBankField(
                title: 'Account Number',
                controller: accountNoController,
                hintText: 'Enter',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Confirm Account Number Input
              _buildBankField(
                title: 'Confirm Account Number',
                controller: confirmAccountController,
                hintText: 'Enter',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Account Holder Name Input
              _buildBankField(
                title: 'Account Holder Name',
                controller: holderNameController,
                hintText: 'Enter',
              ),

              const SizedBox(height: 60),

              // Save Button (Matching your Signup Screen style)
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
                    elevation: 2,
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent text fields
  Widget _buildBankField({
    required String title,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Reusing your CommonTextField logic with the styling from your screenshot
    return CommonTextField(
      title: title,
      controller: controller,
      hintText: hintText,
      titleFontWeight: FontWeight.w500,
      borderSide: true,
      titleSize: 14,
      borderRadius: 28,
      elevation: 1, // Subtle shadow matching your reference
      maxLines: 1,
      titleColor: Colors.black87,
      focusBorderColor: Colors.black,
      keyboardType: keyboardType,
      borderColor: AppColor.borderColor, // Using your defined AppColor
    );
  }
}