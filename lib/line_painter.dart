import 'package:flutter/material.dart';
import 'package:physik_facharbeit/line.dart';

class LinePainter extends CustomPainter {
  final List<Line> lines;

  final double lineWidth;

  const LinePainter ({required this.lines, required this.lineWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.yellow;
    paint.strokeWidth = lineWidth;
    for (int i = 0; i < lines.length; i++) {
      canvas.drawLine(lines[i].lineStart, lines[i].lineEnd, paint);
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}