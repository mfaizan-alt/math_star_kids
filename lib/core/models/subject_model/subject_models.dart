import 'package:flutter/material.dart';

class SubjectModel {
  final IconData icon;
  final String name;
  final String count;
  final List<Color> gradient;
  final String route;

  SubjectModel({
    required this.icon,
    required this.name,
    required this.count,
    required this.gradient,
    required this.route,
  });
}