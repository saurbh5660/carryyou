import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../common/apputills.dart';
import '../../controller/ride_booking_controller.dart';
import '../../network/api_constants.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class RideBookingMainScreen extends StatelessWidget {
  RideBookingMainScreen({super.key});

  final RideBookingController controller = Get.put(RideBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Reactive Google Map
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(controller.pickupLat.value, controller.pickupLng.value), zoom: 15),
            onMapCreated: (cont) => controller.mapController = cont,
            onCameraMove: (pos) { if (controller.currentStep.value == 0) controller.tempCenterLocation = pos.target; },
            onCameraIdle: () => controller.onMapIdle(),
            polylines: Set<Polyline>.of(controller.polylines),
            markers: Set<Marker>.of(controller.markers),

            // This padding pushes the route/pins to the top half of the screen
            padding: EdgeInsets.only(
                bottom: controller.currentStep.value == 1 ? 420 : 250,
                top: 60
            ),

            zoomControlsEnabled: false,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
          )),

          // 2. Center Pin (Visible only during location selection)
          Obx(() => controller.currentStep.value == 0
              ? Center(child: Padding(padding: const EdgeInsets.only(bottom: 35), child: Icon(Icons.location_on, size: 45, color: Colors.black)))
              : const SizedBox.shrink()),

          // 3. Floating Back Button
          Positioned(
            top: 50, left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Obx(() => Icon(controller.currentStep.value == 0 ? Icons.arrow_back : Icons.close, color: Colors.black)),
                onPressed: () {
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
          ),

          // 4. Reactive Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => controller.currentStep.value == 0
                ? _confirmPickupSheet()
                : _chooseTripSheet(context)),
          ),

          // 5. Global Loading Indicator
          Obx(() => controller.isLoading.value
              ? Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: Colors.black)))
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _confirmPickupSheet() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: _sheetStyle(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Confirm pick-up location", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const Divider(height: 30),
            Obx(() => Text(controller.pickupLocation.value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { controller.currentStep.value = 1; controller.fetchRoute(); },
              style: _btnStyle(),
              child: const Text("Confirm pick-up", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseTripSheet(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: _sheetStyle(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 15), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            Text("Choose a trip", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            Obx(() => Text(controller.distance.value, style: const TextStyle(fontSize: 12, color: Colors.grey))),
            const SizedBox(height: 15),
      
            Obx((){
              Logger().d("dddddddd---------");
              final selectedIdx = controller.selectedTripIndex.value;
             return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.vehicleTypes.length,
                itemBuilder: (context, index) {
                  var vehicle = controller.vehicleTypes[index];
                  bool isSelected = selectedIdx == index;
      
                  return GestureDetector(
                    onTap: (){
                      Logger().d("dfffffff--------- $isSelected");
                      controller.selectedTripIndex.value = index;
                      controller.vehicleTypes.refresh();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey.shade50 : Colors.white,
                        border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade200, width: isSelected ? 2 : 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isSelected
                          ? _selectedItemBody(vehicle.name ?? "", (vehicle.durationMinutes ?? "0").toString(), Utils.formatPrice(vehicle.estimatedFare), vehicle.image ?? "")
                          : _unselectedItemBody(vehicle.name ?? "", (vehicle.durationMinutes ?? "0").toString(), Utils.formatPrice(vehicle.estimatedFare), vehicle.image ?? ""),
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 15),

            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pets, size: 20, color: Colors.black54),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Traveling with pets?",
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Switch(
                    value: controller.isPetsAllowed.value,
                    activeColor: Colors.black,
                    onChanged: (val) => controller.isPetsAllowed.value = val,
                  ),
                ],
              ),
            )),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => controller.createBooking(), style: _btnStyle(), child: const Text("Choose Vehicle", style: TextStyle(color: Colors.white)))),
                const SizedBox(width: 10),
                _scheduleBtn(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedItemBody(String name, String time, String price, String img) {
    return Column(
      children: [
        Image.network("${ApiConstants.userImageUrl}$img", height: 80, errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, size: 80)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text("$time mins", style: TextStyle(color: Colors.grey.shade600))]),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ],
    );
  }

  Widget _unselectedItemBody(String name, String time, String price, String img) {
    return Row(
      children: [
        Image.network("${ApiConstants.userImageUrl}$img", height: 50, width: 70, errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, size: 40)),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), Text("$time mins", style: TextStyle(color: Colors.grey.shade600))])),
        const SizedBox(width: 5),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
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
      child: Container(height: 55, width: 55, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.departure_board)),
    );
  }

  ButtonStyle _btnStyle() => ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
  BoxDecoration _sheetStyle() => const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]);
}