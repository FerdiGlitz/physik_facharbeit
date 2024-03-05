import 'package:flutter/material.dart';
import 'package:physik_facharbeit/sim_calculator.dart';

import 'line_painter.dart';

class SimResultView extends StatefulWidget {
  final SimCalculator simCalculator;

  const SimResultView({
    Key? key,
    required this.simCalculator
  }) : super(key: key);

  @override
  State<SimResultView> createState() => _SimResultViewState();
}

class _SimResultViewState extends State<SimResultView> {
  Color hintergrundFarbe = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: hintergrundFarbe,
          height: widget.simCalculator.height * 0.52,
          width: widget.simCalculator.width,
          child: CustomPaint(
            size: const Size.fromWidth(0.5),
            painter: LinePainter(
                lineColor: widget.simCalculator.farbeBerechnen(),
                lineWidth: 600 * 0.01 * widget.simCalculator.height * 0.0005,
                lines: widget.simCalculator.alphaLinienBerechnen()
            ),
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.background,
          width: widget.simCalculator.width,
          height: widget.simCalculator.height * 0.04,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('90°'),
              Text('60°'),
              Text('30°'),
              Text('0°'),
              Text('30°'),
              Text('60°'),
              Text('90°'),
            ],
          ),
        )
      ],
    );
  }
}