import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardController extends GetxController
    with SingleGetTickerProviderMixin {

  late AnimationController animationController;
  late Animation<double> rotationAnimation;

  RxBool canSpinToday = true.obs;
  RxBool isSpinning = false.obs;

  final rewards = [
    '100',
    '10%',
    '20',
    '80',
    '0',
    '250',
    '50',
    '500',
  ];

  final Random random = Random();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutQuart,
      ),
    );
  }

  void spinWheel() {
    if (!canSpinToday.value || isSpinning.value) return;

    isSpinning.value = true;

    final index = random.nextInt(rewards.length);
    final anglePerItem = 2 * pi / rewards.length;

    final targetAngle = (6 * 2 * pi) + (index * anglePerItem);

    rotationAnimation = Tween<double>(
      begin: 0,
      end: targetAngle,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutQuart,
      ),
    );

    animationController.forward(from: 0).whenComplete(() {
      isSpinning.value = false;
      canSpinToday.value = false;

      _showReward(rewards[index]);
    });
  }

  void _showReward(String reward) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('🎉 Congratulations'),
        content: Text('You won $reward'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
