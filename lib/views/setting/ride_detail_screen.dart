import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/ride_detail_controller.dart';
import '../../network/api_constants.dart';

class RideDetailScreen extends GetView<RideDetailController> {
  const RideDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        final data = controller.rideDetail.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ride details",
                  style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // 1. Static Map Placeholder (matching image style)
              _buildMapHeader(data),

              const SizedBox(height: 25),

              // 2. Title and Driver Avatar Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("${data.typeOfVechile?.name ?? "Ride"} ride",
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: data.driver?.profilePicture != null
                        ? NetworkImage(ApiConstants.userImageUrl + data.driver!.profilePicture!)
                        : null,
                    child: data.driver?.profilePicture == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                ],
              ),

              // 3. Date, Amount, Status
              Text(controller.formatDate(data.createdAt),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 5),
              Text("\$${data.amount?.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 10),

              // Status Badge (Dynamic)
              _buildStatusBadge(data.status?.toInt()),

              // const SizedBox(height: 25),

              // 4. Action Buttons (Receipt/Invoice)
             /* Row(
                children: [
                  _buildActionButton(Icons.receipt_long_outlined, "Receipt"),
                  const SizedBox(width: 15),
                  _buildActionButton(Icons.description_outlined, "Invoice"),
                ],
              ),*/

              const SizedBox(height: 30),
              const Divider(),

              // 5. Pickup & Dropoff Timeline
              _buildLocationTimeline(data),

              const Divider(),

              // 6. Rating & Tip Section
              // _buildInfoRow(Icons.pan_tool_alt_rounded, "No tip added"),
              // _buildInfoRow(Icons.star_outline, "No rating"),

              const SizedBox(height: 20),
              Text("Help & safety",
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildInfoRow(Icons.search, "Find lost item", showArrow: true),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMapHeader(data) {
    // Static Google Map URL using lat/lng from API
    final mapUrl = "https://maps.googleapis.com/maps/api/staticmap?"
        "center=${data.pickUpLatitude},${data.pickUpLongitude}"
        "&zoom=14&size=600x300&markers=color:black|${data.pickUpLatitude},${data.pickUpLongitude}"
        "&key=${ApiConstants.placesKey}";

    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(mapUrl, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.map, size: 50, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int? status) {
    // Logic: 6 is Completed, 3/7 is Canceled
    bool isCanceled = status == 3 || status == 7;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCanceled ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        isCanceled ? "Canceled" : "Completed",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLocationTimeline(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _locationItem(Icons.circle_outlined, data.pickUpLocation ?? ""),
          const SizedBox(height: 20),
          _locationItem(Icons.square_outlined, data.destinationLocation ?? ""),
        ],
      ),
    );
  }

  Widget _locationItem(IconData icon, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 15),
        Expanded(
          child: Text(address,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool showArrow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 16))),
          if (showArrow) const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}