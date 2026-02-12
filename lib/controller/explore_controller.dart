import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';
import '../model/explore_model.dart';

class ExploreController extends GetxController {
  final List<ExploreModel> exploreList = [
    ExploreModel(
      title: 'Basketball',
      subtitle: 'Training, Teams & Global Programs',
      points: [
        'Teams',
        'Coaches',
        'Videos',
        'Training Schedule',
      ],
      gradient: const LinearGradient(
        colors: [Color(0xFF4FACFE), Color(0xFF4B4FE4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Assets.iconsFootbalIcon,
    ),
    ExploreModel(
      title: 'Dance',
      subtitle: 'Classes for all levels',
      points: [
        'Browse classes',
        'Meet instructor',
        'Book in-person / online',
      ],
      gradient: const LinearGradient(
        colors: [Color(0xFFF2994A), Color(0xFFEB5757)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Assets.iconsDanceIcon,
    ),
    ExploreModel(
      title: 'Fitness & Wellness',
      subtitle: 'Workout, Recovery & Mental Health',
      points: [
        'Discover session',
        'Book wellness appointments',
        'Mental health resources',
      ],
      gradient: const LinearGradient(
        colors: [Color(0xFF27AE60), Color(0xFF219653)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Assets.iconsFitnessIcon,
    ),
  ];


}
