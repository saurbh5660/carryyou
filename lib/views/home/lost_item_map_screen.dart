import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/lost_item_map_controller.dart';
import '../../generated/assets.dart';
import '../../network/api_constants.dart';

class LostItemMapScreen extends StatelessWidget {
  const LostItemMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LostItemMapController());
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.latitude.value,
                  controller.longitude.value,
                ),
                zoom: 14,
              ),
              onMapCreated: (m) => controller.mapController = m,
              polylines: controller.polylines.toSet(),
              markers: {
                Marker(
                  markerId: const MarkerId('user'),
                  position: controller.pickupLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                ),
                Marker(
                  markerId: const MarkerId('driver'),
                  position: controller.dropOffLatLng,
                  anchor: const Offset(0.5, 0.5),
                  icon: controller.driverIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),

          // 2. Navigation Shortcut
          Positioned(
            top: 60,
            right: 20,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: () => launchUrl(
                Uri.parse(
                  "google.navigation:q=${controller.dropOffLatLng.latitude},${controller.dropOffLatLng.longitude}",
                ),
              ),
              child: const Icon(Icons.navigation, color: Colors.black),
            ),
          ),

          // 3. Bottom Action Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildActionSheet(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSheet(LostItemMapController controller) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 25, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        ApiConstants.userImageUrl +
                            (controller.requestBody.value.driver?.profilePicture ?? ""),
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 48,
                        height: 48,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.images.imagePlaceholder.path,
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.requestBody.value.driver?.fullName ?? "",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      // Text(
                      //   "Return Earning: \$${Get.arguments?["amount"] ?? ""}",
                      //   style: const TextStyle(
                      //     color: Colors.green,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () =>
                      launchUrl(Uri.parse("tel:${controller.requestBody.value.driver?.phoneNumber}")),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  Widget _largeButton(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
