import 'package:cached_network_image/cached_network_image.dart';
import 'package:carry_you_user/controller/rating_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart'; // Using the library
import '../../generated/assets.dart';
import '../../network/api_constants.dart';

class RatingScreen extends StatelessWidget {
  RatingScreen({super.key});
  final controller = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    // Controller for the text field
    final TextEditingController _commentController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Rating",
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          var driver = controller.requestBody.value.driver;
          var vehicle = controller.requestBody.value.typeOfVechile;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1. Driver Info Card
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: ApiConstants.userImageUrl + (driver?.profilePicture ?? ""),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(width: 70, height: 70, color: Colors.white),
                          ),
                          errorWidget: (context, error, stackTrace) => Image.asset(
                            Assets.images.imagePlaceholder.path,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver?.fullName ?? "Driver Name",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            // Read-only Rating Bar from Library
                            RatingBar.readOnly(
                              filledIcon: Icons.star,
                              halfFilledIcon: Icons.star_half,
                              emptyIcon: Icons.star_border,
                              initialRating: double.tryParse(driver?.avgRating?.toString() ?? "0") ?? 0.0,
                              maxRating: 5,
                              size: 18,
                              filledColor: Colors.orange,
                            ),
                            const SizedBox(height: 4),
                            _driverDetailText("${vehicle?.name ?? "N/A"} • ${driver?.vehicleNumber ?? "N/A"}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// 2. Interactive Rating Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        "How was your trip?",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your feedback will help us improve\ndriver experience",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      // Interactive Rating Bar
                      RatingBar(
                        filledIcon: Icons.star,
                        halfFilledIcon: Icons.star_half,
                        emptyIcon: Icons.star_border,
                        onRatingChanged: (value) {
                          controller.selectedStars = value;
                        },
                        initialRating: controller.selectedStars,
                        maxRating: 5,
                        size: 42,
                        filledColor: Colors.orange,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// 3. Your Review Section
                Text(
                  "Write a Review",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _commentController,
                    maxLines: 5,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Anything else you want to add...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 4. Submit Button
                ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    controller.submitRating(
                      rating: controller.selectedStars,
                      comment: _commentController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : Text(
                    "Submit Review",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _driverDetailText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
    );
  }
}