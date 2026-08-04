import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment Status",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 1. Route Timeline
              _buildRouteTimeline(),
              const SizedBox(height: 30),
        
              // 2. Payment Method Row
              Row(
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png',
                    width: 40,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Credit Card",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
        
              // 3. Summary Cards (Total & Distance)
              Row(
                children: [
                  Expanded(child: _buildSummaryCard("\$105.75", "Total")),
                  const SizedBox(width: 15),
                  Expanded(child: _buildSummaryCard("3.5 Miles", "Distance")),
                ],
              ),
              const SizedBox(height: 30),
        
              // 4. Customer Details
              Text("Customer Details",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 15),
              _buildCustomerSection(),
              const SizedBox(height: 30),
        
              // 5. Order Details List
              Text("Order Details",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 15),
              _buildPriceRow("Service Fee", "\$2.00"),
              _buildPriceRow("Delivery Charges", "\$10.00"),
              _buildPriceRow("Cart Fee", "\$2.00"),
              const Divider(height: 30),
              _buildPriceRow("Total", "\$105.75", isBold: true),
        
              const SizedBox(height: 40),
        
              // 6. Done Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.offAllNamed(AppRoutes.homeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    "Done",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteTimeline() {
    return Column(
      children: [
        _buildLocationRow(Icons.circle, Colors.black, "371 7th Ave, New York, NY 10001"),
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 30,
              width: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        _buildLocationRow(Icons.location_on, Colors.black, "33 3rd Ave, New York, NY 10003"),
      ],
    );
  }

  Widget _buildLocationRow(IconData icon, Color color, String address) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            address,
            style: GoogleFonts.montserrat(
                fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(label,
              style: GoogleFonts.montserrat(
                  color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=mark'),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mark Jack",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 15)),
            Text("Order No: #901233",
                style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12)),
            Text("Total: \$60.00",
                style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12)),
            Text("Delivery: Packet",
                style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12)),
            Text("Timestamps: 02:00PM",
                style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                  color: isBold ? Colors.black : Colors.black54)),
          Text(price,
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
    );
  }
}