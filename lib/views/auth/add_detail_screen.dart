import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../common/app_colors.dart';
import '../../common/textform_field.dart';
import '../../controller/add_detail_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class AddDetailScreen extends StatefulWidget {
  const AddDetailScreen({super.key});

  @override
  State<AddDetailScreen> createState() => _AddDetailScreenState();
}

class _AddDetailScreenState extends State<AddDetailScreen> {
  AddDetailController controller = Get.put(AddDetailController());

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
          Get.arguments?['from'] == 'edit' ? 'Edit Profile' : 'Add Detail',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Gender',
                  style: GoogleFonts.montserrat(
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                openDropDown(controller),
                SizedBox(height: 20),
                Text(
                  'Date of Birth',
                  style: GoogleFonts.montserrat(
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                CommonTextField(
                  controller: controller.dateOfBirthController,
                  hintText: 'DD/MM/YYYY',
                  titleFontWeight: FontWeight.w500,
                  borderSide: true,
                  readOnly: true,
                  titleSize: 14,
                  borderRadius: 28,
                  elevation: 1,
                  maxLength: 30,
                  counterText: '',
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.dateOfBirthController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(pickedDate);
                    }
                  },
                  titleColor: Colors.black,
                  focusBorderColor: AppColor.borderColor,
                  keyboardType: TextInputType.name,
                  borderColor: AppColor.borderColor,
                ),
                SizedBox(height: 20),
                Text(
                  'Bio',
                  style: GoogleFonts.montserrat(
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                CommonTextField(
                  controller: controller.descriptionController,
                  hintText: 'Write...',
                  titleFontWeight: FontWeight.w500,
                  borderSide: true,
                  titleSize: 14,
                  borderRadius: 28,
                  maxLines: 5,
                  elevation: 1,
                  maxLength: 300,
                  counterText: '',
                  titleColor: Colors.black,
                  focusBorderColor: AppColor.borderColor,
                  keyboardType: TextInputType.name,
                  borderColor: AppColor.borderColor,
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.interestScreen,
                          arguments: {'from': Get.arguments?['from'] ?? ''},
                        );
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
                        'Next',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: AppColor.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget openDropDown(AddDetailController controller) {
    return Card(
      color: AppColor.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        // side: BorderSide(color: AppColor.borderColor, width: 1),
      ),
      child: Container(
        height: 55,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
        color: AppColor.transparent,
        child: Center(
          child: DropdownSearch<String>(
            items: (filter, cont) {
              return controller.genderList.map((gender) => gender).toList();
            },
            decoratorProps: DropDownDecoratorProps(
              textAlign: TextAlign.start,
              baseStyle: GoogleFonts.montserrat(
                color: AppColor.blackColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Select Gender',
                hintStyle: GoogleFonts.montserrat(
                  color: AppColor.hintColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
            popupProps: const PopupProps.menu(fit: FlexFit.loose),
            onChanged: (selectedValue) {
              controller.selectedGender.value = selectedValue.toString();
            },
          ),
        ),
      ),
    );
  }
}
