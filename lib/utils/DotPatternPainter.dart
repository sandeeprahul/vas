import 'dart:ui';

import 'package:flutter/material.dart';

class DotPatternPainter extends CustomPainter {
  final Color color;
  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dotSize = 4;
    double spacing = 20;
    var paint = Paint()
      ..color = color
      ..strokeWidth = dotSize
      ..strokeCap = StrokeCap.round;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawPoints(
          PointMode.points,
          [Offset(i, j)],
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}