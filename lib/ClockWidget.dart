import 'dart:math';

import 'package:weather/main.dart';
import 'package:flutter/material.dart';

class ClockWidget extends StatelessWidget {
  final int currentHour;

  ClockWidget({required this.currentHour});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors,
      ),
      child: CustomPaint(
        painter: ClockPainter(currentHour: currentHour),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final int currentHour;

  ClockPainter({required this.currentHour});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY);

    // Draw clock circle
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Draw clock hands
    final hourAngle = -pi / 2 + currentHour / 12 * 2 * pi;
    final minuteAngle = 0.0; // Adjust this if you want a minute hand
    final secondAngle = 0.0; // Adjust this if you want a second hand

    drawHand(canvas, centerX, centerY, radius * 0.5, hourAngle, 8.0);
    //drawHand(canvas, centerX, centerY, radius * 0.7, minuteAngle, 5.0);
    //drawHand(canvas, centerX, centerY, radius * 0.9, secondAngle, 2.0);
  }

  void drawHand(Canvas canvas, double centerX, double centerY, double length,
      double angle, double strokeWidth) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final endX = centerX + length * cos(angle);
    final endY = centerY + length * sin(angle);

    canvas.drawLine(Offset(centerX, centerY), Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
