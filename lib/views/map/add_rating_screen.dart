import 'package:cached_network_image/cached_network_image.dart';
import 'package:carry_you_user/controller/rating_controller.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import '../../generated/assets.dart';
import '../../network/api_constants.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final RatingController controller = Get.put(RatingController());
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rating",
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Obx(() {
            var driver = controller.requestBody.value.driver;
            var vehicle = controller.requestBody.value.typeOfVechile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Driver Info Card
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: ApiConstants.userImageUrl + (driver?.profilePicture ?? ""),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(width: 80, height: 80, color: Colors.white),
                          ),
                          errorWidget: (context, error, stackTrace) => Image.asset(
                            Assets.imagesImagePlaceholder,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
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
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                RatingBar.readOnly(
                                  initialRating: double.tryParse(driver?.avgRating?.toString() ?? "0") ?? 0.0,
                                  filledIcon: Icons.star,
                                  halfFilledIcon: Icons.star_half,
                                  emptyIcon: Icons.star_border,
                                  filledColor: Colors.orange,
                                  maxRating: 5,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  driver?.avgRating?.toString() ?? "0.0",
                                  style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            _driverDetailText("Car Brand - ${vehicle?.name ?? "N/A"}"),
                            _driverDetailText("Car Number- ${driver?.vehicleNumber ?? "N/A"}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. Your Rating Section (Interactive)
                Text(
                  "Your Rating",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RatingBar(
                      initialRating: controller.selectedStars,
                      onRatingChanged: (value) {
                        setState(() {
                          controller.selectedStars = value;
                        });
                      },
                      filledIcon: Icons.star,
                      halfFilledIcon: Icons.star_half,
                      emptyIcon: Icons.star_border,
                      filledColor: Colors.orange,
                      emptyColor: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      controller.selectedStars.toString(),
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                Text(
                  "Your Review",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _commentController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Anything else you want to add",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // 4. Submit Button
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
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Submit",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _driverDetailText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 12, height: 1.4),
    );
  }
}