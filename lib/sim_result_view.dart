import 'package:flutter/material.dart';

class SimResultView extends StatefulWidget {
  final double height;
  final double width;
  final double wellenlaenge;
  final double spaltbreite;
  final double spaltabstand;
  final double abstandZumSensor;

  const SimResultView({
    Key? key,
    required this.height,
    required this.width,
    required this.wellenlaenge,
    required this.spaltbreite,
    required this.spaltabstand,
    required this.abstandZumSensor
  }) : super(key: key);

  @override
  State<SimResultView> createState() => _SimResultViewState();
}

class _SimResultViewState extends State<SimResultView> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.green,
          height: widget.height * 0.9,
          width: widget.width,
        ),
        Container(
          color: Theme.of(context).colorScheme.background,
          width: widget.width,
          height: widget.height * 0.1,
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