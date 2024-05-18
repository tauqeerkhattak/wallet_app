import 'package:flutter/material.dart';

class CardPainter extends CustomPainter {
  final MaterialColor color;
  final int index;

  CardPainter({
    required this.color,
    required this.index,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(colors: [
        color.shade100,
        color,
        color.shade900,
      ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();
    path.moveTo(size.width, size.height * 0.222);
    path.lineTo(5, size.height * 0.42);
    path.lineTo(size.width * 0.55, size.height);
    path.lineTo(size.width, size.height);

    canvas.drawShadow(path, Colors.grey, 4.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CardPainter oldDelegate) {
    return false;
  }
}
