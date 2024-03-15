import 'package:flutter/material.dart';

class GraphPainter extends CustomPainter {
  double Function(double x) functionX;
  
  double lineWidth;
  
  GraphPainter({required this.functionX, required this.lineWidth});

  @override
  void paint(Canvas canvas, Size size) {
    double max = functionX(0);///ausreichend für diesen usecase
    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    ///vermeidet doppelte Berechnung von Punkten
    Offset tempPoint = Offset(-size.width / 2 + size.width / 2, size.height - (functionX((-size.width / 2) * (2 / size.width)) * (1/max) * size.height));
    for (double i = -size.width / 2 + 1; i < size.width / 2; i++) {
      Offset point = Offset(i + size.width / 2, size.height - (functionX(i * (2 / size.width)) * (1/max) * size.height));
      canvas.drawLine(tempPoint, point, paint);
      tempPoint = point;
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}