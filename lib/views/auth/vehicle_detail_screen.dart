import 'dart:io';
import 'package:carry_you_user/generated/assets.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../common/textform_field.dart';
import '../../controller/vehicle_detail_controller.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  final VehicleDetailController controller = Get.put(VehicleDetailController());

  Future<void> _selectDate(BuildContext context, TextEditingController textController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Usually expiry dates are in the future
      lastDate: DateTime(DateTime.now().year + 20),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.black, onPrimary: Colors.white, onSurface: Colors.black),
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
          'Vehicle Information',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadSection("Picture of Vehicle", controller.vehicleImage, 1),

              const SizedBox(height: 20),
              _buildLabel("Type of Vehicle"),
              _buildVehicleTypeDropdown(),

              const SizedBox(height: 20),
              _buildUploadSection("Picture of Vehicle Registration", controller.registrationImage, 2),

              const SizedBox(height: 20),
              _buildField("Registration Expiry Date", controller.registrationExpiryController, "Enter", isDate: true),

              const SizedBox(height: 20),
              _buildUploadSection("Insurance Policy", controller.insuranceImage, 3),

              const SizedBox(height: 20),
              _buildField("Write Insurance Expiry Date", controller.insuranceExpiryController, "Select", isDate: true, hasCalendarIcon: true),

              const SizedBox(height: 20),
              _buildField("Vehicle Number", controller.vehicleNumberController, "Enter"),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (Get.arguments?['from'] == 'edit') {
                      Get.back();
                    } else {
                      showSuccessDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),

                  child: Text(
                    Get.arguments?['from'] == 'edit' ? 'Update ': 'Submit',
                    style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      ),
    );
  }

  Widget _buildUploadSection(String label, RxnString imagePath, int code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Obx(() => GestureDetector(
          onTap: () => controller.cameraHelper.openImagePicker(code),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: imagePath.value == null
                ? Center(child: Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400, size: 28))
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(imagePath.value!), fit: BoxFit.cover),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() => DropdownButton<String>(
          value: controller.selectedVehicleType.value.isEmpty ? null : controller.selectedVehicleType.value,
          hint: Text("Select", style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          items: ["Car", "Bike", "Truck"].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            controller.selectedVehicleType.value = newValue!;
          },
        )),
      ),
    );
  }

  Widget _buildField(String title, TextEditingController ctr, String hint, {bool isDate = false, bool hasCalendarIcon = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title),
        GestureDetector(
          onTap: isDate ? () => _selectDate(context, ctr) : null,
          child: AbsorbPointer(
            absorbing: isDate,
            child: CommonTextField(
              controller: ctr,
              hintText: hint,
              borderSide: true,
              borderRadius: 28,
              elevation: 0,
              focusBorderColor: Colors.black,
              borderColor: Colors.grey.shade300,
              suffixIcon: hasCalendarIcon ? const Icon(Icons.calendar_month, color: Colors.black54) : null,
            ),
          ),
        ),
      ],
    );
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.iconsChecked,
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 24),
              Text(
                "Your details has been submitted successfully, Please wait for admin approval!",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed(AppRoutes.homeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Prevents closing by tapping outside
    );
  }
}