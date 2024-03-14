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
    for (double i = -size.width / 2; i < size.width / 2; i += 0.5) {
      Offset point = Offset(i + size.width / 2, size.height - (functionX(i * (2 / size.width)) * (1/max) * size.height));
      Offset point2 = Offset(i + 0.25 + size.width / 2, size.height - (functionX((i + 0.25) * (2 / size.width)) * (1/max) * size.height));
      canvas.drawLine(point, point2, paint);
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}