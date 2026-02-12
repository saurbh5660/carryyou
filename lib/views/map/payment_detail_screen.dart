import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({super.key});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  late GoogleMapController mapController;

  static const LatLng _pickup = LatLng(35.38, -119.03);
  static const LatLng _dropoff = LatLng(35.36, -119.01);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          "Pending Detail",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Details",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline)),
              const SizedBox(height: 20),
              _buildLocationTimeline(),
              const SizedBox(height: 25),
              _buildProfileRow(),
              const SizedBox(height: 25),
              Text("Delivery Details",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildPricingCard(),
              const SizedBox(height: 25),
              _buildSectionCard(
                title: "Delivery Address",
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("John Smith",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      "4025 Traders Alley Kansas City, Missouri\nUnited States\n+1 1234567890",
                      style: GoogleFonts.poppins(fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _buildSectionCard(
                title: "Payment Methods",
                content: Row(
                  children: [
                    Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/200px-Visa_Inc._logo.svg.png',
                        width: 40),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Marker",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("**** **** **** 1234",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- Status Row with Elevation ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Status: ", style: GoogleFonts.poppins(fontSize: 13)),
                        Text("Pending",
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.orange, fontWeight: FontWeight.bold)),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildGoogleMapContainer(),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMapContainer() {
    return Container(
      height: 250, // Fixed height for the map card
      width: double.infinity,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(target: LatLng(35.37, -119.02), zoom: 12),
          onMapCreated: (controller) => mapController = controller,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          // This fixes the "touch not working" issue inside SingleChildScrollView
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [_pickup, _dropoff],
              color: Colors.black,
              width: 3,
            )
          },
        ),
      ),
    );
  }

  // --- Supporting Widgets ---

  Widget _buildLocationTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _timelineItem(Icons.circle, "371 7th Ave, New York, NY 10001", isSmallIcon: true),
        Padding(
          padding: const EdgeInsets.only(left: 9),
          child: Column(
            children: List.generate(4, (index) => Container(
              width: 1.5, height: 4, margin: const EdgeInsets.symmetric(vertical: 2),
              color: Colors.grey.shade400,
            )),
          ),
        ),
        _timelineItem(Icons.location_on, "33 3rd Ave, New York, NY 10003", isSmallIcon: false),
      ],
    );
  }

  Widget _timelineItem(IconData icon, String address, {required bool isSmallIcon}) {
    return Row(
      children: [
        isSmallIcon ? SizedBox(width: 3,) : SizedBox(),
        Icon(icon, size: isSmallIcon ? 14 : 20, color: Colors.black),
        const SizedBox(width: 15),
        // Text("- ", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
        Expanded(child: Text(address, style: GoogleFonts.poppins(fontSize: 12))),
      ],
    );
  }

  Widget _buildProfileRow() {
    return Row(
      children: [
        const CircleAvatar(radius: 35, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=jack')),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mark Jack", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Order No: #901233", style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
              Text("Total: \$60.00", style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
              Text("Delivery: Packet", style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Color(0xFF48C95F), shape: BoxShape.circle),
          child: const Icon(Icons.chat_bubble, color: Colors.white, size: 20),
        )
      ],
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _priceLine("Subtotal", "\$100.00"),
          _priceLine("Delivery", "\$5.00"),
          _priceLine("Service Fee", "\$0.75"),
          const Divider(height: 20, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("\$105.75", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceLine(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
          Text(val, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: _cardDecoration(), child: content),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
      ],
    );
  }
}