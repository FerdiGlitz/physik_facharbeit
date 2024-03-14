import 'dart:math';
import 'package:flutter/material.dart';
import 'package:physik_facharbeit/lines/line.dart';
import 'package:physik_facharbeit/sim_calculator.dart';

class LinePainter extends CustomPainter {
  final List<Line> lines;

  final double lineWidth;

  final Color lineColor;

  final SimCalculator simCalculator;

  const LinePainter ({required this.lines, required this.lineWidth, required this.lineColor, required this.simCalculator});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = lineColor;
    paint.strokeWidth = lineWidth;
    paint.style = PaintingStyle.stroke;
    //paintCircles(canvas);
    for (int i = 0; i < lines.length; i++) {
      canvas.drawLine(lines[i].lineStart, lines[i].lineEnd, paint);
    }
  }

  void paintCircles(Canvas canvas) {
    Paint circlePaint = Paint();
    circlePaint.color = lineColor;
    circlePaint.strokeWidth = 2;
    circlePaint.style = PaintingStyle.stroke;

    debugPrint(lines[1].lineStart.toString());///NICHT LÖSCHEN! Keine Ahnung warum das funktioniert aber ohne gehts nicht
    debugPrint(simCalculator.wellenlaengePixelBerechnen().toString());

    double radiusLimit = sqrt(pow(simCalculator.height, 2) + pow(simCalculator.width * simCalculator.abstandZumSchirm * 0.00002, 2));
    for (int i = 0; i * (simCalculator.wellenlaengePixelBerechnen()) < radiusLimit; i++) {
      canvas.drawCircle(simCalculator.mitteUntererSpalt(), i * (simCalculator.wellenlaengePixelBerechnen()), circlePaint);
    }
    for (int i = 0; i * (simCalculator.wellenlaengePixelBerechnen()) < radiusLimit; i++) {
      canvas.drawCircle(simCalculator.mitteObererSpalt(), i * (simCalculator.wellenlaengePixelBerechnen()), circlePaint);
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}