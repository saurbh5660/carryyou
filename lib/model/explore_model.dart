import 'package:flutter/material.dart';

class ExploreModel {
  final String title;
  final String subtitle;
  final List<String> points;
  final LinearGradient gradient;
  final String icon;

  ExploreModel({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.gradient,
    required this.icon,
  });
}
