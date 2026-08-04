import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../common/apputills.dart';
import '../../controller/ride_booking_controller.dart';
import '../../network/api_constants.dart';
import '../../routes/app_routes.dart';

class RideBookingMainScreen extends StatelessWidget {
  RideBookingMainScreen({super.key});
  final RideBookingController controller = Get.put(RideBookingController());

  static const Color _amber = Color(0xFFFFC107);
  static const Color _amberSoft = Color(0xFFFFF8E1);

  @override
  Widget build(BuildContext context) {
    // Capture initial position once to avoid map rebuild loops when pickupLat changes
    final initialTarget = LatLng(controller.pickupLat.value, controller.pickupLng.value);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [
          Obx(() => GoogleMap(
                key: const ValueKey("ride_booking_map"),
                initialCameraPosition: CameraPosition(target: initialTarget, zoom: 15),
                onMapCreated: (cont) => controller.mapController = cont,
                onCameraMove: (pos) {
                  if (controller.currentStep.value == 0) {
                    controller.tempCenterLocation = pos.target;
                  }
                },
                onCameraIdle: () => controller.onMapIdle(),
                polylines: Set<Polyline>.of(controller.polylines),
                markers: Set<Marker>.of(controller.markers),
                padding: EdgeInsets.only(
                  bottom: controller.currentStep.value == 1 ? 420 : 250,
                  top: 60,
                ),
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
              )),

          // Center Pin (Visible only during location selection)
          Obx(() => controller.currentStep.value == 0
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: _CenterPin(),
                  ),
                )
              : const SizedBox.shrink()),

          // Top gradient scrim
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.15), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          // Floating Back / Close Button
          Positioned(
            top: 50,
            left: 20,
            child: _circleButton(
              child: Obx(() => Icon(
                    controller.currentStep.value == 0 ? Icons.arrow_back : Icons.close,
                    color: Colors.black,
                    size: 22,
                  )),
              onTap: () {
                if (controller.currentStep.value == 1) {
                  controller.currentStep.value = 0;
                  controller.polylines.clear();
                  controller.markers.clear();
                } else {
                  Get.back();
                }
              },
            ),
          ),

          // Reactive Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => controller.currentStep.value == 0
                ? _confirmPickupSheet()
                : _chooseTripSheet(context)),
          ),

          // Global Loading Indicator
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const CircularProgressIndicator(color: Colors.black),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _circleButton({required Widget child, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 46, height: 46, child: child),
      ),
    );
  }

  // ---------------- STEP 0: CONFIRM PICK-UP ----------------
  Widget _confirmPickupSheet() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
      decoration: _sheetStyle(),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _grabHandle(),
            const SizedBox(height: 16),
            Text(
              "Confirm pick-up location",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "Drag the map to adjust your pick-up point",
              style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897B).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.radio_button_checked,
                        color: Color(0xFF00897B), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PICK-UP",
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                              controller.pickupLocation.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _primaryButton(
              label: "Confirm pick-up",
              onTap: () {
                controller.currentStep.value = 1;
                controller.fetchRoute();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- STEP 1: CHOOSE A TRIP ----------------
  Widget _chooseTripSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: _sheetStyle(),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _grabHandle(),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text("Choose a trip",
                      style: GoogleFonts.poppins(
                          fontSize: 19, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Obx(() => controller.distance.value.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _amberSoft,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.route_rounded,
                                  size: 14, color: Color(0xFFB8860B)),
                              const SizedBox(width: 5),
                              Text(
                                controller.distance.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB8860B),
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() {
                Logger().d("dddddddd---------");
                final selectedIdx = controller.selectedTripIndex.value;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.vehicleTypes.length,
                  itemBuilder: (context, index) {
                    var vehicle = controller.vehicleTypes[index];
                    bool isSelected = selectedIdx == index;

                    double originalPrice =
                        double.tryParse(vehicle.estimatedFare.toString()) ?? 0.0;
                    double discountedPrice =
                        controller.calculateDiscountedFare(vehicle.estimatedFare);

                    return GestureDetector(
                      onTap: () {
                        controller.selectedTripIndex.value = index;
                        controller.vehicleTypes.refresh();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? _amberSoft : Colors.white,
                          border: Border.all(
                            color: isSelected ? _amber : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: isSelected
                            ? _selectedItemBody(
                                vehicle.name ?? "",
                                (vehicle.durationMinutes ?? "0").toString(),
                                originalPrice,
                                discountedPrice,
                                vehicle.image ?? "")
                            : _unselectedItemBody(
                                vehicle.name ?? "",
                                (vehicle.durationMinutes ?? "0").toString(),
                                originalPrice,
                                discountedPrice,
                                vehicle.image ?? ""),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 4),

              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.pets,
                              size: 18, color: Colors.black54),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Traveling with pets?",
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Switch(
                          value: controller.isPetsAllowed.value,
                          activeThumbColor: Colors.white,
                          activeTrackColor: _amber,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          onChanged: (val) => controller.isPetsAllowed.value = val,
                        ),
                      ],
                    ),
                  )),

              Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.isCouponApplied.value
                      ? _appliedCouponTile()
                      : _couponInputField(),
                );
              }),

              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _primaryButton(
                      label: "Choose Vehicle",
                      onTap: () => controller.createBooking(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _scheduleBtn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _couponInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, size: 20, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller.couponTextController,
              decoration: InputDecoration(
                hintText: "Enter promo code",
                border: InputBorder.none,
                isDense: true,
                hintStyle: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade500),
              ),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => controller.applyCoupon(),
            child: Text("Apply",
                style: GoogleFonts.poppins(
                    color: const Color(0xFF1A73E8),
                    fontWeight: FontWeight.w700)),
          )
        ],
      ),
    );
  }

  Widget _appliedCouponTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Code: ${controller.appliedCouponCode.value}",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700),
            ),
          ),
          GestureDetector(
            onTap: () => controller.removeCoupon(),
            child: const Icon(Icons.cancel, color: Colors.red, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _selectedItemBody(String name, String time, double originalPrice,
      double discountedPrice, String img) {
    return Column(
      children: [
        Image.network(
          "${ApiConstants.userImageUrl}$img",
          height: 84,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.directions_car, size: 80),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 18)),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text("$time mins",
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade600, fontSize: 12.5)),
                    ],
                  ),
                ],
              ),
            ),
            _priceWidget(originalPrice, discountedPrice),
          ],
        ),
      ],
    );
  }

  Widget _unselectedItemBody(String name, String time, double originalPrice,
      double discountedPrice, String img) {
    return Row(
      children: [
        Image.network(
          "${ApiConstants.userImageUrl}$img",
          height: 50,
          width: 70,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.directions_car, size: 40),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Text("$time mins",
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade600, fontSize: 12.5)),
            ],
          ),
        ),
        const SizedBox(width: 5),
        _priceWidget(originalPrice, discountedPrice),
      ],
    );
  }

  Widget _priceWidget(double originalFare, double discountedFare) {
    bool discounted = controller.isCouponApplied.value;
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Utils.formatPrice(discountedFare),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 18),
          ),
          if (discounted)
            Text(
              Utils.formatPrice(originalFare),
              style: GoogleFonts.poppins(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _scheduleBtn() {
    return InkWell(
      onTap: () async {
        final result = await Get.toNamed(AppRoutes.chooseTime);
        if (result != null) {
          controller.scheduleDate = result['dateTime'];
          controller.isScheduled = true;
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: _amberSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _amber.withValues(alpha: 0.5)),
        ),
        child: const Icon(Icons.departure_board, color: Color(0xFFB8860B)),
      ),
    );
  }

  Widget _primaryButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _grabHandle() => Center(
        child: Container(
          width: 42,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  BoxDecoration _sheetStyle() => const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, -6)),
        ],
      );
}

// Animated-looking static center pin with a soft shadow puck under it.
class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on, size: 46, color: Colors.black),
        Container(
          width: 14,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
