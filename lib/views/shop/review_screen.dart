import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/review_controller.dart';
import '../../generated/assets.dart';
import '../../model/review_listing_response.dart';
import '../../network/api_constants.dart';

class ReviewRateScreen extends StatelessWidget {
   ReviewRateScreen({super.key});
  final ReviewController controller = Get.put(ReviewController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Review & Rate',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.reviewBody.isEmpty) {
          return const Center(child: Text("No reviews yet"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ratingSummary(),
              const SizedBox(height: 20),

              /// Review List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.reviewBody.length,
                itemBuilder: (context, index) {
                  final review = controller.reviewBody[index];
                  return _reviewItem(review);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ⭐ Rating Summary with Dynamic Calculations
  Widget _ratingSummary() {
    double averageRating = 0.0;

    if (controller.reviewBody.isNotEmpty) {
      double sum = controller.reviewBody.fold(0.0, (double prev, element) {
        // Use double.tryParse because the API returns "2.0" as a String
        double ratingValue = double.tryParse(element.rating.toString()) ?? 0.0;
        return prev + ratingValue;
      });

      averageRating = sum / controller.reviewBody.length;
    }

    Map<int, double> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in controller.reviewBody) {
      // Parse String to double, then round/convert to int for the map keys
      double rDouble = double.tryParse(review.rating.toString()) ?? 0.0;
      int r = rDouble.toInt();

      if (distribution.containsKey(r)) {
        distribution[r] = distribution[r]! + 1;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w400),
            ),
            Text(
              '${controller.reviewBody.length} ratings',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [5, 4, 3, 2, 1].map((star) {
              double count = distribution[star]!;
              double progress = controller.reviewBody.isEmpty ? 0 : count / controller.reviewBody.length;
              return _ratingBar(star, progress);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _ratingBar(int stars, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            stars.toString(),
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewItem(ReviewBody review) {
    // Parse rating safely
    double ratingValue = double.tryParse(review.rating.toString()) ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                  ApiConstants.userImageUrl + (review.user?.profilePicture ?? ""),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) {
                    return Image.asset(
                      Assets.images.imagePlaceholder.path,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user?.fullName ?? "Anonymous",
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    _starRow(ratingValue.toInt()),
                  ],
                ),
              ),
              Text(
                // You might want to format this date string later
                review.createdAt?.split("T").first ?? "",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment ?? "No comment provided",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _starRow(int count, {double size = 14}) {
    return Row(
      children: List.generate(
        5,
            (index) => Icon(
          Icons.star,
          size: size,
          color: index < count ? Colors.orange : Colors.grey.shade300,
        ),
      ),
    );
  }
}