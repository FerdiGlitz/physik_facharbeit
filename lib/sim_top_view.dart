import 'package:flutter/material.dart';
import 'package:physik_facharbeit/sim_calculator.dart';
import 'lines/line.dart';
import 'painters/line_painter.dart';

class SimTopView extends StatefulWidget {
  final SimCalculator simCalculator;

  const SimTopView({
    super.key,
    required this.simCalculator
  });

  @override
  State<SimTopView> createState() => _SimTopViewState();
}

class _SimTopViewState extends State<SimTopView> {
  Color aufbauFarbe = Colors.black;
  Color hintergrundFarbe = Colors.white;

  late List<Line> resultLines = [
    //0. Maximum
    Line(lineStart: widget.simCalculator.resultLineStart(), lineEnd: widget.simCalculator.nulltesMaximumLineTarget()),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hintergrundFarbe.withOpacity(1),
      child: Stack(
        children: [
          Row(
            children: [
              CustomPaint(
                size: const Size.fromWidth(0.5),
                painter: LinePainter(
                  simCalculator: widget.simCalculator,
                  lineColor: widget.simCalculator.farbeBerechnen(),
                  lineWidth: 600 * 0.01 * widget.simCalculator.height * 0.0005,
                  lines: widget.simCalculator.maximaBerechnen()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CustomPaint(
                    size: const Size.fromWidth(0.5),
                    painter: LinePainter(
                        simCalculator: widget.simCalculator,
                        lineColor: widget.simCalculator.farbeBerechnen(),
                        lineWidth: widget.simCalculator.height * 0.2,
                        lines: [
                          //Linie zum Spalt
                          Line(
                              lineStart: widget.simCalculator.lampePositionPixel(),
                              lineEnd: Offset(
                                  widget.simCalculator.abstandLampeSpaltPixelBerechnen() + widget.simCalculator.width * 0.1025,
                                  widget.simCalculator.lampePositionPixel().dy
                              )
                          ),
                        ]
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      lampe(),
                      SizedBox(
                        width: widget.simCalculator.abstandLampeSpaltPixelBerechnen(),
                      ),
                      spalt(),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: widget.simCalculator.width * widget.simCalculator.abstandZumSchirm * 0.00002,
              ),
              schirm()
            ],
          ),
        ]
      ),
    );
  }

  Widget lampe() {
    return Container(
      color: aufbauFarbe,
      height: widget.simCalculator.height * 0.25,
      width: widget.simCalculator.width * 0.1,
    );
  }

  Widget spalt() {
    final double conversion = widget.simCalculator.conversionFactor;
    final double slitWidth = widget.simCalculator.width * 0.005;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: aufbauFarbe,
          height: widget.simCalculator.height * 0.11 - (widget.simCalculator.spaltbreite * conversion) - ((widget.simCalculator.spaltabstand * conversion - widget.simCalculator.spaltbreite * conversion) / 2),
          width: slitWidth,
        ),
        SizedBox(
          height: widget.simCalculator.spaltbreite * conversion,
          width: slitWidth,
        ),
        Container(
          color: aufbauFarbe,
          height: widget.simCalculator.spaltabstand * conversion - widget.simCalculator.spaltbreite * conversion,
          width: slitWidth,
        ),
        SizedBox(
          height: widget.simCalculator.spaltbreite * conversion,
          width: slitWidth,
        ),
        Container(
          color: aufbauFarbe,
          height: widget.simCalculator.height * 0.11 - (widget.simCalculator.spaltbreite * conversion) - ((widget.simCalculator.spaltabstand * conversion - widget.simCalculator.spaltbreite * conversion) / 2),
          width: slitWidth,
        ),
      ],
    );
  }

  Widget schirm() {
    return Container(
      height: double.infinity,
      width: widget.simCalculator.width * 0.005,
      color: aufbauFarbe,
    );
  }
}
