import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../generated/assets.dart';
import '../routes/app_routes.dart';
import 'app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Material(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
          height:40,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10,
                offset: Offset(0, 4),

              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                index: 0,
                selectedIcon: Assets.iconsHomeSelected,
                unselectedIcon: Assets.iconsHomeUnselected,
              ),
              NavBarItem(
                index: 1,
                selectedIcon: Assets.iconsEventSelected,
                unselectedIcon: Assets.iconsEventUnselected,
              ),
              NavBarItem(
                index: 2,
                selectedIcon: Assets.iconsAddUnselected,
                unselectedIcon: Assets.iconsAddUnselected,
              ),
              NavBarItem(
                index: 3,
                selectedIcon: Assets.iconsExploreSelected,
                unselectedIcon: Assets.iconsExploreUnselected,
              ),
              NavBarItem(
                index: 4,
                selectedIcon: Assets.iconsProfileSelected,
                unselectedIcon: Assets.iconsProfileUnselected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends GetView<DashboardController> {
  final int index;
  final String selectedIcon;
  final String unselectedIcon;

  const NavBarItem({
    super.key,
    required this.index,
    required this.selectedIcon,
    required this.unselectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) {
            Get.toNamed(AppRoutes.addFeedScreen);
          } else {
            controller.onChangeIndex(index);
          }
        },
        child: Obx(() {
          final currentIndex = controller.currentIndex.value;
          return Container(
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? AppColor.transparent
                  : AppColor.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  currentIndex == index ? selectedIcon : unselectedIcon,
                  height: currentIndex == index ? 35 : 25,
                  width: currentIndex == index ? 35 : 25,

                ),
              ],

            ),
          );
        }),
      ),
    );
  }
}
