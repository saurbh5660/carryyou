import 'package:carry_you_user/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/app_navigation_bar.dart';
import '../../controller/dashboard_controller.dart';
import '../home/event_screen.dart';
import '../home/explore_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Obx(
                () => [
              HomeScreen(),
              EventScreen(),
              SizedBox(),
              ExploreScreen(),
              ProfileScreen(),
            ][controller.currentIndex.value],
          ),
        ),
        bottomNavigationBar: SafeArea(child: AppNavigationBar())
    );
  }
}
