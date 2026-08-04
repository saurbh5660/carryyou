import 'package:cached_network_image/cached_network_image.dart';
import 'package:carry_you_user/controller/banner_controller.dart';
import 'package:carry_you_user/controller/home_map_controller.dart';
import 'package:carry_you_user/sidebar/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../common/db_helper.dart';
import '../../common/location_screen.dart';
import '../../generated/assets.dart';
import '../../network/api_constants.dart';
import '../../routes/app_routes.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  HomeMapController controller = Get.put(HomeMapController());
  final BannerController bannerController = Get.put(BannerController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _bannerPageController = PageController();
  int _bannerIndex = 0;

  static const Color _amber = Color(0xFFFFC107);

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideMenuDrawer(),
      body: Stack(
        children: [
          Obx(() {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(controller.latitude.value, controller.longitude.value),
                zoom: 15,
              ),
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },
              onCameraMove: (pos) {
                pos.target;
              },
            );
          }),

          // Top header: greeting bar + banner carousel
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 16),
                  _buildBannerSection(),
                ],
              ),
            ),
          ),

          // Bottom anchored "Where to?" card
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSearchSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final user = DbHelper().getUserModel();
    final String firstName =
        (user?.fullName ?? "").trim().isEmpty ? "there" : user!.fullName!.split(' ').first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: const Color(0xFFF5F6F8),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(Icons.menu_rounded, color: Colors.black, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _greeting,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Hi, $firstName",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profileScreen),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _amber, width: 2),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: ApiConstants.userImageUrl +
                      (DbHelper().getUserModel()?.profilePicture ?? ""),
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(width: 38, height: 38, color: Colors.white),
                  ),
                  errorWidget: (context, error, stackTrace) => Image.asset(
                    Assets.images.imagePlaceholder.path,
                    fit: BoxFit.cover,
                    width: 38,
                    height: 38,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Obx(() {
      if (bannerController.isLoading.value && bannerController.banners.isEmpty) {
        return _bannerShell(
          child: const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      final banners = bannerController.banners
          .where((b) => (b.image ?? '').trim().isNotEmpty)
          .toList();
      if (banners.isEmpty) return const SizedBox.shrink();

      return _bannerShell(
        child: Stack(
          children: [
            PageView.builder(
              controller: _bannerPageController,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => _bannerIndex = i),
              itemBuilder: (context, index) {
                return Image.network(
                  _resolveBannerUrl(banners[index].image),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stack) =>
                      Container(color: Colors.grey.shade100),
                );
              },
            ),
            if (banners.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: _bannerIndex == i ? 18 : 6,
                      decoration: BoxDecoration(
                        color: _bannerIndex == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _bannerShell({required Widget child}) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildSearchSection() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, -6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Where to?",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Plan your ride in a few taps",
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.radio_button_checked,
                        color: Color(0xFF00897B), size: 20),
                    Container(
                      height: 42,
                      width: 1.4,
                      color: Colors.grey.shade300,
                    ),
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildClickableField(
                        icon: Icons.my_location,
                        hint: "Current Location",
                        onTap: () => Get.to(
                          () => const LocationSearchScreen(isDestination: false),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildClickableField(
                        icon: Icons.search,
                        hint: "Enter Destination",
                        isPrimary: true,
                        onTap: () => Get.to(
                          () => const LocationSearchScreen(isDestination: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _resolveBannerUrl(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    if (v.startsWith('/')) return "${ApiConstants.userImageUrl}$v";
    return "${ApiConstants.userImageUrl}/$v";
  }

  Widget _buildClickableField({
    required IconData icon,
    required String hint,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary ? const Color(0xFFF1F5FE) : const Color(0xFFF5F6F8),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary ? const Color(0xFF1A73E8).withValues(alpha: 0.35) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 19,
                  color: isPrimary ? const Color(0xFF1A73E8) : Colors.grey.shade500),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hint,
                  style: GoogleFonts.poppins(
                    color: isPrimary ? Colors.black87 : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
