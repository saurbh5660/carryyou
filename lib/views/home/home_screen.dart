import 'package:carry_you_user/sidebar/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../common/location_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(35.3733, -119.0187),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      drawer: const SideMenuDrawer(),
      body: Stack(
        children: [
          // The Real Google Map
          const GoogleMap(
            initialCameraPosition: _kInitialPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),

          // Custom Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),

              ),
            ),
          ),

          // Bottom Sheet: Find a Location
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 260,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("Find a Location",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      // Vertical Timeline Indicator
                      Column(
                        children: [
                          const Icon(Icons.radio_button_checked, color: Color(0xFF00897B), size: 22),
                          Container(height: 45, width: 1, color: Colors.grey.shade300),
                          const Icon(Icons.location_on, color: Colors.red, size: 22),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            _buildClickableField("Current Location", () => Get.to(() => const LocationSearchScreen(isDestination: false))),
                            const SizedBox(height: 15),
                            _buildClickableField("Enter Location", () => Get.to(() => const LocationSearchScreen(isDestination: true))),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildClickableField(String hint, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(hint, style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14)),
      ),
    );
  }
}