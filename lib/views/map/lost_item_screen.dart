import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import '../../controller/lost_item_controller.dart';

class LostItemScreen extends StatelessWidget {
  final controller = Get.put(LostItemController());
  LostItemScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Recover Lost Item",
            style: GoogleFonts.montserrat(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        switch (controller.currentStatus.value) {
          case LostItemStatus.reporting:
            return _buildReportForm(context);
          case LostItemStatus.contactOptions:
            return _buildContactOptions();
          case LostItemStatus.arrangingReturn:
            return _buildPaymentView(context);
          case LostItemStatus.escalated:
            return _buildEscalationView();
          case LostItemStatus.completed:
            return _buildSuccessView();
        }
      }),
    );
  }

  Widget _buildReportForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What did you lose?",
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: controller.descController,
            decoration: InputDecoration(
                hintText: "e.g. phone",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 25),
          Text("Contact number for driver",
              style: GoogleFonts.montserrat(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter phone number",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      controller.selectedDialCode.value = "+${country.phoneCode}";
                      controller.selectedFlag.value = country.flagEmoji;
                    },
                  );
                },
                child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12),
                    Text(controller.selectedFlag.value,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 5),
                    Text(controller.selectedDialCode.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    const SizedBox(width: 5),
                    Container(height: 24, width: 1, color: Colors.grey[300]),
                    const SizedBox(width: 10),
                  ],
                )),
              ),
            ),
          ),
          const Spacer(),
          SafeArea(
            child: _largeButton("Submit Request", Colors.black, () {
              controller.validSubmitRequest(
                  controller.descController.text, controller.phoneController.text);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Return Delivery",
              style: GoogleFonts.montserrat(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Where should the driver drop the item?",
              style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              controller.openPlacePicker();
            },
            child: AbsorbPointer(
              child: TextField(
                controller: controller.addressController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                  hintText: "Select drop off location",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: const Icon(Icons.map_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Upfront Return Fee",
                    style: TextStyle(fontSize: 16)),

                Text("\$20", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          SafeArea(
            child: _largeButton("Pay & Confirm Return", Colors.black, () {
              controller.payAmountLostItem();
              // controller.processReturn(controller.addressController.text);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOptions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 20),
          Text("Request Sent",
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
              "Please call ${controller.driverName.value} to verify if the item was found.",
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          _largeButton("Call Driver", Colors.green, () => controller.callDriver()),
          const Divider(height: 60),
          _actionButton("Driver confirmed item found", Colors.black,
                  () {
            controller.driverFoundItemConfirmUser();
                  }),
          const SizedBox(height: 12),
          _actionButton("I couldn't reach the driver", Colors.grey[200]!,
                  () {
            controller.sendRequestToAdmin();
                  // controller.onCouldNotReach();
                  },
              isSecondary: true),
        ],
      ),
    );
  }

  Widget _buildEscalationView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.headset_mic, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text("Support Notified",
                style: GoogleFonts.montserrat(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
                "CarryU support is now looking into this. We will contact the driver and get back to you.",
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            _largeButton("Close", Colors.black, () => Get.back()),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_shipping, size: 100, color: Colors.black),
          const SizedBox(height: 20),
          Text("Delivery in Progress",
              style: GoogleFonts.montserrat(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("The driver is on the way to your location."),
          const SizedBox(height: 40),
          // _largeButton("Back to Home", Colors.black, () => Get.back()),
        ],
      ),
    );
  }

  Widget _largeButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0),
        onPressed: onTap,
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap,
      {bool isSecondary = false}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0),
        onPressed: onTap,
        child: Text(label,
            style: TextStyle(
                color: isSecondary ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}