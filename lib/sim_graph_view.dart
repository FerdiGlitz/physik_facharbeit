import 'package:flutter/material.dart';
import 'package:physik_facharbeit/painters/graph_painter.dart';
import 'package:physik_facharbeit/sim_calculator.dart';

class SimGraphView extends StatefulWidget {
  final SimCalculator simCalculator;

  const SimGraphView({
    Key? key,
    required this.simCalculator
  }) : super(key: key);

  @override
  State<SimGraphView> createState() => _SimGraphViewState();
}

class _SimGraphViewState extends State<SimGraphView> {
  Color hintergrundFarbe = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        Column(
          children: [
            Container(
              color: hintergrundFarbe,
              height: widget.simCalculator.height * 0.03,
              width: widget.simCalculator.width,
              child: const Text("100%", style: TextStyle(color: Colors.black),),
            ),
            Container(
              color: hintergrundFarbe,
              height: widget.simCalculator.height * 0.49,
              width: widget.simCalculator.width,
              child: CustomPaint(
                size: const Size.fromWidth(1),
                painter: GraphPainter(
                  lineWidth: 1,
                  functionX: (double x) => widget.simCalculator.calculateIntensity(x),
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
        ),
        yAxis()
      ],
    );
  }

  Widget yAxis() {
    return Column(
      children: [
        SizedBox(
          height: widget.simCalculator.height * 0.51,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: widget.simCalculator.height * 0.02772),///verrechnet mit Sim-Fenstergröße
                color: Colors.black,
                height: widget.simCalculator.height * 0.001,
                width: widget.simCalculator.width,
              );
            },
          ),
        ),
        ///x-achse und margin ignorieren
        SizedBox(
          height: widget.simCalculator.height * 0.05,
        )
      ],
    );
  }
}