import 'package:flutter/material.dart';
import 'package:physik_facharbeit/sim_calculator.dart';
import 'lines/line.dart';
import 'painters/line_painter.dart';

class SimTopView extends StatefulWidget {
  final SimCalculator simCalculator;

  const SimTopView({
    Key? key,
    required this.simCalculator
  }) : super(key: key);

  @override
  State<SimTopView> createState() => _SimTopViewState();
}

class _SimTopViewState extends State<SimTopView> {
  Color aufbauFarbe = Colors.black;
  Color hintergrundFarbe = Colors.white70;

  late List<Line> resultLines = [
    Line(lineStart: widget.simCalculator.resultLineStart(), lineEnd: nulltesMaximumLineTarget()),
    //Linie zum 1.Maximum
    Line(
      lineStart: widget.simCalculator.resultLineStart(),
      lineEnd: Offset(widget.simCalculator.width - widget.simCalculator.width * 0.005, widget.simCalculator.height * 0.28 + widget.simCalculator.abstandZumNulltenMaximum(1) * 0.01)
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hintergrundFarbe.withOpacity(1),
      child: Stack(children: [
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
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      lampe(),
                      SizedBox(
                        width: widget.simCalculator.abstandLampeSpaltPixelBerechnen(),
                      ),
                      spalt(),
                    ],
                  ),
                ),
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
              ],
            ),
            SizedBox(
              width: widget.simCalculator.width * widget.simCalculator.abstandZumSchirm * 0.00002,
            ),
            schirm()
          ],
        ),
      ]),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: aufbauFarbe,
          height: widget.simCalculator.height * 0.1 - widget.simCalculator.spaltbreite * 0.01 * widget.simCalculator.height * 0.0005,
          width: widget.simCalculator.width * 0.005,
        ),
        SizedBox(
          height: widget.simCalculator.spaltbreite * 0.01 * widget.simCalculator.height * 0.0005,
          width: widget.simCalculator.width * 0.005,
        ),
        Container(
          color: aufbauFarbe,
          height: widget.simCalculator.spaltabstand * 0.01 * widget.simCalculator.height * 0.0005,
          width: widget.simCalculator.width * 0.005,
        ),
        SizedBox(
          height: widget.simCalculator.spaltbreite * 0.01 * widget.simCalculator.height * 0.0005,
          width: widget.simCalculator.width * 0.005,
        ),
        Container(
          color: aufbauFarbe,
          height: widget.simCalculator.height * 0.1 - widget.simCalculator.spaltbreite * 0.01 * widget.simCalculator.height * 0.0005,
          width: widget.simCalculator.width * 0.005,
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

  Offset nulltesMaximumLineTarget() {
    return Offset(
        widget.simCalculator.width - widget.simCalculator.width * 0.005,
        widget.simCalculator.height * 0.28
    );
  }
}
