import 'package:carry_you_user/network/api_constants.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../controller/activity_controller.dart';
import '../../model/booking_list_response.dart';
import 'map_screen.dart';

class ActivityScreen extends GetView<ActivityController> {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ActivityController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text("Ride History",
            style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.5)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2));
        }

        return RefreshIndicator(
          onRefresh: () => controller.getBookingList(),
          color: Colors.black,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ONGOING
              if (controller.ongoingRides.isNotEmpty) ...[
                _buildSectionHeader("Ongoing"),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildOngoingCard(controller.ongoingRides[index]),
                      childCount: controller.ongoingRides.length,
                    ),
                  ),
                ),
              ],

              // UPCOMING
              if (controller.upcomingRides.isNotEmpty) ...[
                _buildSectionHeader("Upcoming"),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildSimpleCard(controller.upcomingRides[index], isUpcoming: true),
                      childCount: controller.upcomingRides.length,
                    ),
                  ),
                ),
              ],

              // PAST
              _buildSectionHeader("Past History"),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = controller.pastRides[index];
                      return (index == 0) ? _buildFeaturedCard(item) : _buildSimpleCard(item);
                    },
                    childCount: controller.pastRides.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
        child: Text(title,
            style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87)),
      ),
    );
  }

  // ENHANCED: Large Card with Marker on Map
  Widget _buildFeaturedCard(Body item) {
    bool isCancelled = (item.status == 3 || item.status == 7);

    // Map URL with Marker
    final String mapUrl = "https://maps.googleapis.com/maps/api/staticmap?"
        "center=${item.pickUpLatitude},${item.pickUpLongitude}"
        "&zoom=15&size=600x300"
        "&markers=color:black|scale:2|${item.pickUpLatitude},${item.pickUpLongitude}" // MARKER ADDED
        "&key=${ApiConstants.placesKey}";

    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.rideDetailScreen,arguments: {"bookingId":item.id.toString()});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    mapUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, s) => Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.map_outlined, color: Colors.grey)
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.white.withOpacity(0.8), Colors.transparent]
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item.pickUpLocation ?? "Trip",
                            style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: -0.2)),
                      ),
                      Text("₹${item.amount}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${controller.formatDate(item.createdAt)} • ${controller.getStatusText(item.status)}",
                    style: TextStyle(
                      color: isCancelled ? Colors.redAccent : Colors.grey[600],
                      fontSize: 13,
                      fontWeight: isCancelled ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildActionButton("Rebook Ride", Icons.refresh,item, fullWidth: true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingCard(Body item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section with "Live" badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sensors, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text("LIVE",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800
                          )
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  controller.getStatusText(item.status).toUpperCase(),
                  style: GoogleFonts.montserrat(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.5
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse Effect Circle
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withOpacity(0.1),
                  ),
                ),
                const Icon(Icons.local_taxi_rounded, color: Colors.blueAccent, size: 28),
              ],
            ),
            title: Text(
              item.pickUpLocation ?? "Ongoing Trip",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Driver is on the way",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*Expanded(
                  child: _buildActionButton(
                      "View Map",
                      Icons.map_outlined,
                      isBlack: false,
                      small: true
                  ),
                ),*/
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                      "Track Driver",
                      Icons.near_me_rounded,
                      item,
                      isBlack: false,
                      small: true
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCard(Body item, {bool isUpcoming = false}) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.rideDetailScreen,arguments: {"bookingId":item.id.toString()});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.directions_run_rounded, color: Colors.grey[800]),
          ),
          title: Text(item.pickUpLocation ?? "",
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 15),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "${controller.formatDate(item.createdAt)}\n₹${item.amount} • ${controller.getStatusText(item.status)}",
              style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
            ),
          ),
          trailing: _buildActionButton(
              isUpcoming ? "Reserve" : "Rebook",
              isUpcoming ? Icons.calendar_month_rounded : Icons.refresh,
              item,
              small: true,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon,Body item, {bool small = false, bool isWhite = false, bool fullWidth = false, bool isBlack = false}) {
    return GestureDetector(
      onTap: (){
        Logger().d("dsfdsgdsg");
        if(label == "Rebook"){
          Get.to(
                () =>  RideBookingMainScreen(),
            arguments: {
              'pickup_address': item.pickUpLocation ?? "",
              'pickup_lat': item.pickUpLatitude,
              'pickup_lng': item.pickUpLongitude,
              'dest_address': item.destinationLocation,
              'dest_lat': item.destinationLatitude,
              'dest_lng': item.destinationLongitude,
            },
          );
        }
        if(label == "Track Driver"){
          Get.toNamed(AppRoutes.trackMapScreen,arguments: {"bookingId":item.id.toString()});
        }
      },
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: small ? 12 : 20, vertical: small ? 8 : 12),
        decoration: BoxDecoration(
          color: isWhite ? Colors.white : (isBlack ? Colors.black : const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: small ? 14 : 18, color: isWhite ? Colors.black : Colors.black),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.montserrat(
                    fontSize: small ? 12 : 14,
                    fontWeight: FontWeight.w700,
                    color: isWhite ? Colors.black : Colors.black)),
          ],
        ),
      ),
    );
  }
}