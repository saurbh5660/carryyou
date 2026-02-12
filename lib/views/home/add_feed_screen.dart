import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../common/textform_field.dart';
import '../../controller/add_feed_controller.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  AddFeedController controller = Get.put(AddFeedController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        title: Text(
          'Create Post',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        Assets.iconsProfileIcon,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Jolly Marker',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'What do you want to talk about?',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                SizedBox(height: 12),
                CommonTextField(
                  controller: controller.descriptionController,
                  hintText: 'Write',
                  hintSize: 14,
                  hintTextColor: Colors.black.withOpacity(0.5),
                  hintFontFamily: GoogleFonts.poppins().fontFamily,
                  titleFontWeight: FontWeight.w500,
                  borderSide: true,
                  titleSize: 14,
                  textColor: Colors.black,
                  borderRadius: 24,
                  elevation: 1,
                  maxLines: 5,
                  maxLength: 300,
                  counterText: '',
                  focusBorderColor: AppColor.borderColor,
                  keyboardType: TextInputType.name,
                  borderColor: AppColor.borderColor,
                ),
                SizedBox(height: 12),
                Text(
                  'Hashtag',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                CommonTextField(
                  controller: controller.hashtagController,
                  hintText: 'Enter',
                  hintSize: 14,
                  hintTextColor: Colors.black.withOpacity(0.5),
                  hintFontFamily: GoogleFonts.poppins().fontFamily,
                  titleFontWeight: FontWeight.w500,
                  borderSide: true,
                  titleSize: 14,
                  borderRadius: 24,
                  textColor: Colors.black,
                  elevation: 1,
                  maxLines: 5,
                  minLines: 1,
                  maxLength: 300,
                  counterText: '',
                  focusBorderColor: AppColor.borderColor,
                  keyboardType: TextInputType.name,
                  borderColor: AppColor.borderColor,
                ),
                SizedBox(height: 20),
                Obx(() => SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length + 1,
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      // The first item is the "Add" button
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () => controller.pickImage(),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 30),
                          ),
                        );
                      }

                      String imagePath = controller.selectedImages[index - 1];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(imagePath),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index - 1),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.close, size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )),

                SizedBox(height: 60),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.dashboardView);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Post", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
