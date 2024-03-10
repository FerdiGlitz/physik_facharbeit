import 'package:flutter/material.dart';
import 'package:physik_facharbeit/painters/intensity_line_painter.dart';
import 'package:physik_facharbeit/sim_calculator.dart';
import 'painters/line_painter.dart';

class SimResultView extends StatefulWidget {
  final SimCalculator simCalculator;

  ///optimiert die Berechnung des Schirmbildes durch auslassungen
  static int optimizer = 1;

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
          child: Stack(
            children: [
              ///Schirmbild nach Formel für Lichtintensität
              CustomPaint(
                size: const Size.fromWidth(0.5),
                painter: IntensityLinePainter(
                    simCalculator: widget.simCalculator,
                    lineColor: widget.simCalculator.farbeBerechnen(),
                    lineWidth: 1,
                    ///lines: widget.simCalculator.alphaLinienBerechnen()
                    lines: widget.simCalculator.calculateIntensityLines()
                ),
              ),
              ///Linien für Maxima nach Formel zur Berechnung der Maxima
              CustomPaint(
                size: const Size.fromWidth(0.5),
                painter: LinePainter(
                    simCalculator: widget.simCalculator,
                    lineColor: Colors.red,
                    lineWidth: 5,
                    lines: widget.simCalculator.alphaLinienBerechnen()
                ),
              ),
            ],
          )
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