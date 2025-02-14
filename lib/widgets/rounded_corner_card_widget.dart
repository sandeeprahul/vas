import 'package:flutter/material.dart';

class RoundedCornerCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  // final String kcal;
  final IconData icon;
  final BorderRadius borderRadius;
  final Color gradientStart;
  final Color gradientEnd;

  const RoundedCornerCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    // required this.kcal,
    required this.icon,
    this.borderRadius = const BorderRadius.only(
      topRight: Radius.circular(50),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
      topLeft: Radius.circular(20),
    ),
    this.gradientStart = const Color(0xFFFF9A9E),
    this.gradientEnd = const Color(0xFFFAD0C4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      // width: 140,
      decoration: BoxDecoration(
        color: Colors.blue,

        // gradient: LinearGradient(colors: [gradientStart, gradientEnd]),
        borderRadius: borderRadius,
        // shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),

          Icon(icon, size: 40, color: Colors.white),

          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

        ],
      ),
    );
  }
}

// Example Usage:
// CustomRoundedCard(
//   title: "Breakfast",
//   subtitle: "Bread, Peanut Butter, Apple",
//   kcal: "525",
//   imagePath: "assets/egg.png",
//   borderRadius: BorderRadius.only(
//     topLeft: Radius.circular(50),
//     bottomRight: Radius.circular(20),
//   ),
// )
