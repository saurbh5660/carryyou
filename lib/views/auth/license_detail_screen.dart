import 'dart:io';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../common/textform_field.dart';
import '../../controller/license_detail_controller.dart';

class LicenseDetailScreen extends StatefulWidget {
  const LicenseDetailScreen({super.key});

  @override
  State<LicenseDetailScreen> createState() => _LicenseDetailScreenState();
}

class _LicenseDetailScreenState extends State<LicenseDetailScreen> {
  LicenseDetailController controller = Get.put(LicenseDetailController());

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController textController, {
    bool isDOB = false,
  }) async {
    DateTime now = DateTime.now();

    // Logic for 18 years restriction
    DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDOB ? eighteenYearsAgo : now,
      firstDate: DateTime(1920),
      // Earliest date possible
      lastDate: isDOB ? eighteenYearsAgo : DateTime(now.year + 50),
      // Disable dates < 18 years for DOB
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      textController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

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
          'Licence Detail',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Licence Photos",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildUploadBox("Front Side", controller.licenseFront, 1),
              const SizedBox(height: 16),
              _buildUploadBox("Back Side", controller.licenseBack, 2),
              const SizedBox(height: 24),
              _buildField(
                "Licence Number",
                controller.licenseNoController,
                "Enter",
              ),
              _buildField(
                "Issued on",
                controller.issuedOnController,
                "Select Date",
                isDatePicker: true,
              ),
              _buildField(
                "License Type",
                controller.licenseTypeController,
                "Enter",
              ),
              _buildField(
                "Date of Birth",
                controller.dobController,
                "Select Date",
                isDatePicker: true,
                isDOB: true,
              ),
              _buildField(
                "Nationality",
                controller.nationalityController,
                "Enter",
              ),
              _buildField(
                "Expiry Date",
                controller.expiryController,
                "Select Date",
                isDatePicker: true,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (Get.arguments?['from'] == 'edit') {
                      Get.back();
                    } else {
                      Get.toNamed(AppRoutes.vehicleDetail);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    Get.arguments?['from'] == 'edit' ? 'Update' : 'Next',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildField(
    String title,
    TextEditingController ctr,
    String hint, {
    bool isDatePicker = false,
    bool isDOB = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: isDatePicker
            ? () => _selectDate(context, ctr, isDOB: isDOB)
            : null,
        child: AbsorbPointer(
          absorbing: isDatePicker,
          child: CommonTextField(
            title: title,
            controller: ctr,
            hintText: hint,
            titleFontWeight: FontWeight.w500,
            borderSide: true,
            titleSize: 14,
            borderRadius: 28,
            elevation: 0,
            titleColor: Colors.black,
            focusBorderColor: Colors.black,
            borderColor: Colors.grey.shade300,
            suffixIcon: isDatePicker
                ? const Icon(Icons.calendar_today_outlined, size: 18)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox(String label, RxnString imagePath, int code) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.cameraHelper.openImagePicker(code),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: imagePath.value == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.grey.shade400),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(imagePath.value!), fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}
