import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../common/app_colors.dart';
import '../../common/db_helper.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () async {
      final isLoggedIn = DbHelper().getIsLoggedIn();
      if (!isLoggedIn) {
        Get.offAllNamed(AppRoutes.onboardingView);
        return;
      }
      /* final routeData = await NotificationService().getPushNotificationRoute();
      if (routeData case (String routeName, Object? arguments)) {
        Logger().d("dsadsgdfsg");
        Get.offAllNamed(routeName, arguments: arguments);
        return;
      }*/
      Get.offAllNamed(AppRoutes.homeScreen);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: true,
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset(
                  Assets.iconsSplashLogo,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
