import 'package:flutter/material.dart';
import 'package:physik_facharbeit/lines/intensity_line.dart';
import 'line_painter.dart';

class IntensityLinePainter extends LinePainter {

  IntensityLinePainter({required super.lines, required super.lineWidth, required super.lineColor, required super.simCalculator});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = lineColor;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < lines.length; i++) {
      IntensityLine line = lines[i] as IntensityLine;
      if (line.intensity <= 1) {
        paint.color = lineColor.withOpacity(line.intensity);
      } else {
        paint.color = lineColor.withOpacity(1);
      }
      canvas.drawLine(super.lines[i].lineStart, lines[i].lineEnd, paint);
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}