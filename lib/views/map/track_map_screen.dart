import 'package:cached_network_image/cached_network_image.dart';
import 'package:carry_you_user/common/apputills.dart';
import 'package:carry_you_user/controller/track_map_controller.dart';
import 'package:carry_you_user/generated/assets.dart';
import 'package:carry_you_user/network/api_constants.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackMapScreen extends StatefulWidget {
  const TrackMapScreen({super.key});

  @override
  State<TrackMapScreen> createState() => _TrackMapScreenState();
}

class _TrackMapScreenState extends State<TrackMapScreen> {
  TrackMapController controller = Get.put(TrackMapController());

  @override
  void initState() {
    super.initState();
    controller.getBookingDetail();
  }

  // Steps:
  // 0: Confirm Pickup Spot
  // 1: Choose Trip (Car Selection)
  // 2: Connecting to Driver
  // 3: Driver Arrived

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.latitude.value,
                  controller.longitude.value,
                ),
                zoom: 12,
              ),
              onMapCreated: (mapController) =>
                  controller.mapController = mapController,
              polylines: controller.polylines.toSet(),
              markers: {
                if (controller.requestBody.value.status == 0) ...{
                  Marker(
                    markerId: MarkerId('pickup'),
                    position: controller.pickupLatLngLocation,
                    anchor: const Offset(0.5, 0.5),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                  Marker(
                    markerId: MarkerId('destination'),
                    position: controller.dropOffLatLngLocation,
                    anchor: const Offset(0.5, 0.5),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                }
                else if(controller.requestBody.value.status == 1) ...{
                  Marker(
                    markerId: const MarkerId('pickup'),
                    position: controller.pickupLatLngLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('driver'),
                    position: LatLng(
                      controller.driverLat.value,
                      controller.driverLng.value,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                }
                else ...{
                  Marker(
                    markerId: const MarkerId('driver'),
                    position: LatLng(
                      controller.driverLat.value,
                      controller.driverLng.value,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('dropOff'),
                    position: controller.dropOffLatLngLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                },
              },
              myLocationEnabled: true,
              zoomControlsEnabled: false,
            );
          }),

          // 3. Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          Obx(() {
            return Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomUI(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomUI() {
    switch (controller.requestBody.value.status) {
      case 0:
        return _connectingSheet();
      case 1:
        return _driverArrivalSheet();
      case 4 || 5 || 6:
        return _completeRideSheet();
      default:
        return SizedBox();
    }
  }

  // --- STEP 2: CONNECTING ---
  Widget _connectingSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _sheetStyle(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Title Section
          Text(
            "Connecting you to a driver",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Confirming driver details",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 15),
          const LinearProgressIndicator(
            color: Colors.black,
            backgroundColor: Color(0xFFEEEEEE),
            minHeight: 2,
          ),
          const SizedBox(height: 20),
          // 2. Trip Details Box
          GestureDetector(
            onTap: () {
              showRideDetailsSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trip Details",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Meet at the pickup point",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFFEEEEEE),
                    child: Icon(Icons.more_horiz, size: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Illustration Placeholder
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: const Color(0xFFF3E5F5), // Light purple background
                    child: Image.asset(
                      Assets.imagesPackageDel,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Send and receive packages",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Millions of people have used courier",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Simulation Button (Keep this for testing)
          const SizedBox(height: 10),
         /* TextButton(
            onPressed: () {},
            child: const Text(
              "Simulate Driver Found",
              style: TextStyle(color: Colors.blue),
            ),
          ),*/
        ],
      ),
    );
  }

  // --- STEP 3: DRIVER ARRIVAL ---
  Widget _driverArrivalSheet() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: _sheetStyle(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meet at your pickup spot",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    controller.duration.value,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            Row(
              children: [
                Center(
                  // Ensures the whole component is centered in the screen
                  child: SizedBox(
                    width: 140,
                    // Define a width that accommodates both Avatar + offset Car
                    height: 100,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      // Aligns Avatar to the left
                      children: [
                        // 1. Driver Image
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                ApiConstants.userImageUrl +
                                (controller
                                        .requestBody
                                        .value
                                        .driver
                                        ?.profilePicture ??
                                    ""),
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
                                Assets.imagesImagePlaceholder,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              );
                            },
                          ),
                        ),

                        Positioned(
                          right: -40,
                          bottom: -5,
                          child: Image.asset(
                            Assets.iconsCar,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Name and Car Plate
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        controller.requestBody.value.driver?.fullName ?? "",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        controller.requestBody.value.driver?.vehicleNumber ??
                            "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Honda Civic - Silver",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 3. Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Send Message Pill Button
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.chatScreen,
                        arguments: {
                          "id": controller.requestBody.value.driver?.id
                              .toString(),
                          "name": controller.requestBody.value.driver?.fullName
                              .toString(),
                          "image": controller.requestBody.value.driver?.profilePicture
                              .toString(),
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Send a message",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          const Icon(
                            Icons.send_rounded,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Circular Action Icons
                // _circularActionBtn(Icons.notification_important_outlined, 1),
                // const SizedBox(width: 10),
                _circularActionBtn(Icons.call, 2),
                // const SizedBox(width: 10),
                // _circularActionBtn(Icons.chat_bubble_outline,3),
              ],
            ),
            // Add this at the end of the children list in _driverArrivalSheet()
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  "SIMULATE: Driver reached destination",
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper for the small gray circular buttons
  Widget _circularActionBtn(IconData icon, int type) {
    return GestureDetector(
      onTap: () async {
        if (type == 3) {
          Get.toNamed(AppRoutes.chatScreen);
        }
        if (type == 2) {
          final String phone =
              (controller.requestBody.value.driver?.countryCode ?? "") +
              (controller.requestBody.value.driver?.phoneNumber ?? "");
          if (phone.isNotEmpty) {
            final Uri launchUri = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(launchUri)) {
              await launchUrl(launchUri);
            } else {
              Utils.showErrorToast(message: "Could not launch phone dialer");
            }
          } else {
            Utils.showErrorToast(message: "Driver phone number not available");
          }
        }
      },

      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: Colors.black87),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _actionIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  BoxDecoration _sheetStyle() => const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
    ],
  );

  void showRideDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Obx(() {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Ride Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const Divider(height: 30),
              _buildRouteRow(
                Icons.radio_button_checked,
                Colors.teal,
                controller.requestBody.value.pickUpLocation ?? "",
              ),
              _buildDashedLine(),
              _buildRouteRow(
                Icons.location_on,
                Colors.red,
                controller.requestBody.value.destinationLocation ?? "",
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Icon(Icons.person, size: 30),
                  const SizedBox(width: 15),
                  Text(
                    "\$${controller.requestBody.value.amount ?? ""}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Cancel Ride Button
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Close this sheet
                  showCancelConfirmationSheet(context); // Open next
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Cancel ride",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showCancelConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Cancel Ride",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            const Text(
              "Are you sure you want to cancel?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 15),
            const Text(
              "This trip has been offered to a driver right now, and should be confirmed within seconds.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                showCancellationReasonsSheet(context); // Open last sheet
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Cancel Request",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Wait for Driver",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCancellationReasonsSheet(BuildContext context) {
    // Track selection locally within the sheet
    String selectedReason = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        // Use StatefulBuilder to update selection
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    /*const Text(
                      "Cancel Ride",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),*/
                   /* TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Why do you want to cancel?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),

                // Map through reasons and pass selection state
                ...[
                  {
                    "icon": Icons.hourglass_bottom,
                    "text": "Wait time was too long",
                  },
                  {
                    "icon": Icons.report_problem,
                    "text": "Requested by accident",
                  },
                  {
                    "icon": Icons.directions_car,
                    "text": "Requested wrong vehicle",
                  },
                  {"icon": Icons.map, "text": "Selected wrong drop-off"},
                  {"icon": Icons.location_on, "text": "Selected wrong pick-up"},
                  {"icon": Icons.bubble_chart, "text": "Other"},
                ].map((reason) {
                  String title = reason["text"] as String;
                  bool isSelected = selectedReason == title;

                  return _reasonTile(
                    reason["icon"] as IconData,
                    title,
                    isSelected,
                    () {
                      setSheetState(() => selectedReason = title);
                    },
                  );
                }),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // If a reason is selected, process cancellation, otherwise just pop
                    if (selectedReason.isNotEmpty) {
                      controller.updateStatus("3",selectedReason);
                      Navigator.pop(context);
                    }else{
                      Utils.showErrorToast(message: "Please select a reason.");
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Confirm Cancellation",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text("Keep my Trip",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Updated Helper with Selection UI
  Widget _reasonTile(
    IconData icon,
    String title,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  Widget _buildRouteRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 20),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 11),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            width: 2,
            height: 5,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(vertical: 2),
          ),
        ),
      ),
    );
  }

  Widget _completeRideSheet() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Driver Profile Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        ApiConstants.userImageUrl +
                        (controller.requestBody.value.driver?.profilePicture ??
                            ""),
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
                        Assets.imagesImagePlaceholder,
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
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.reviewScreen);
                        },
                        child: Row(
                          children: [
                            ...List.generate(
                              4,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              (controller.requestBody.value.driver?.status ?? 0)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _carDetailText(
                        "Car Brand - ${controller.requestBody.value.driver?.typeOfVehicleId}",
                      ),
                      // _carDetailText("Color - Black"),
                      _carDetailText(
                        "Car Number- ${controller.requestBody.value.driver?.vehicleNumber}",
                      ),
                    ],
                  ),
                ),
                // Action Buttons from the top right of your design
                Row(
                  children: [
                    _circularActionBtn1(Icons.chat_bubble, Colors.black, 1),
                    SizedBox(width: 10),
                    _circularActionBtn1(Icons.call, Color(0xFFE85922), 2),
                    // Orange-red color
                  ],
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "Total Amount: \$${controller.requestBody.value.amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              "Ride Details",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),

            // 2. Trajectory and Distance Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCompleteRouteTimeline()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Total Distance",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      controller.distance.value,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 3. Complete Ride Button
           /* ElevatedButton(
              onPressed: () {
                showRideCompletedDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Complete Ride",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),*/
          ],
        ),
      );
    });
  }

  Widget _circularActionBtn1(IconData icon, Color color, int type) {
    return GestureDetector(
      onTap: () async {
        if (type == 1) {
          Get.toNamed(
            AppRoutes.chatScreen,
            arguments: {
              "id": controller.requestBody.value.driver?.id
                  .toString(),
              "name": controller.requestBody.value.driver?.fullName
                  .toString(),
              "image": controller.requestBody.value.driver?.profilePicture
                  .toString(),
            },
          );
        } else {
          final String phone =
              (controller.requestBody.value.driver?.countryCode ?? "") +
              (controller.requestBody.value.driver?.phoneNumber ?? "");
          if (phone.isNotEmpty) {
            final Uri launchUri = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(launchUri)) {
              await launchUrl(launchUri);
            } else {
              Utils.showErrorToast(message: "Could not launch phone dialer");
            }
          } else {
            Utils.showErrorToast(message: "Driver phone number not available");
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // Fixed Timeline with dashed lines to match image
  Widget _buildCompleteRouteTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _routeStep(
          Icons.radio_button_unchecked,
          controller.requestBody.value.pickUpLocation ?? "",
          isFirst: true,
        ),
        // _routeStep(Icons.circle, "Brundagein", isMiddle: true),
        _routeStep(
          Icons.location_on,
          controller.requestBody.value.destinationLocation ?? "",
          isLast: true,
        ),
      ],
    );
  }

  Widget _routeStep(
    IconData icon,
    String location, {
    bool isFirst = false,
    bool isMiddle = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Aligns text to the top of the icon
        children: [
          Column(
            children: [
              // Container ensures the icon takes up a predictable square space
              SizedBox(
                height: 22,
                width: 22,
                child: Icon(icon, size: 20, color: Colors.black),
              ),
              if (!isLast)
                Expanded(
                  child: CustomPaint(
                    size: const Size(1, 20),
                    painter: DashedLinePainter(),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Adding a small top padding to the text to align it with the icon center
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              location,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      ),
    );
  }

  void showRideCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Success Green Checkmark
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), // Uber success green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 25),

                // 2. Title
                Text(
                  "Ride Completed",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Description text
                Text(
                  "Your Ride Complete successfully.\nPlease give rating & reviews to driver.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // 4. Action Buttons (Rating Now & Later)
                Row(
                  children: [
                    // Rating Now Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.toNamed(AppRoutes.ratingScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Rating Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Later Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Return to home state
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Later",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter for the vertical dashed line in your design
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TripOption {
  final String name;
  final String time;
  final String price;
  final String icon;

  TripOption(this.name, this.time, this.price, this.icon);
}
