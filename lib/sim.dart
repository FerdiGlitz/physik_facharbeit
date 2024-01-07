import 'package:flutter/material.dart';
import 'package:physik_facharbeit/line_painter.dart';
import 'package:physik_facharbeit/line.dart';

class SimTopView extends StatefulWidget {
  final double spaltbreite;
  final double spaltabstand;
  final double abstandZumSensor;

  const SimTopView({Key? key,
      required this.spaltbreite,
      required this.spaltabstand,
      required this.abstandZumSensor
      }) : super(key: key);

  @override
  State<SimTopView> createState() => _SimTopViewState();
}

class _SimTopViewState extends State<SimTopView> {

  late double spaltbreitePixel = widget.spaltbreite * 0.01 * MediaQuery.of(context).size.height * 0.0005;
  late double spaltabstandPixel = widget.spaltabstand * 0.01 * MediaQuery.of(context).size.height * 0.0005;
  late double abstandZumSensorPixel = widget.abstandZumSensor * 0.01 * MediaQuery.of(context).size.height * 0.0005;

  late List<Line> resultLines = [
    Line(lineStart: resultLineStart(), lineEnd: nulltesMaximumLineTarget()),
    //Linie zum 1.Maximum
    Line(lineStart: resultLineStart(), lineEnd: Offset(MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.005, MediaQuery.of(context).size.height * 0.28 + abstandZumNulltenMaximum(600, widget.spaltabstand, widget.abstandZumSensor, 1) * 0.01))
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        children: [
          CustomPaint(
            size: const Size.fromWidth(0.5),
            painter: LinePainter(
                lineWidth: spaltbreitePixel,
                lines: [
                  //Linie zum oberen Spalt
                  Line(lineStart: elektronenKanonePositionPixel(), lineEnd: Offset(abstandKanoneSpaltPixelBerechnen() + MediaQuery.of(context).size.width * 0.1025, MediaQuery.of(context).size.height * 0.28 - spaltabstandPixel / 2 - spaltbreitePixel / 2)),
                  //Linie zum unteren Spalt
                  Line(lineStart: elektronenKanonePositionPixel(), lineEnd: Offset(abstandKanoneSpaltPixelBerechnen() + MediaQuery.of(context).size.width * 0.1025, MediaQuery.of(context).size.height * 0.28 + spaltabstandPixel / 2 + spaltbreitePixel / 2)),
                ]
            ),
          ),
          CustomPaint(
            size: const Size.fromWidth(0.5),
            painter: LinePainter(
                lineWidth: spaltbreitePixel,
                lines: maximaBerechnen()
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          elektronenKanone(),
          SizedBox(
            width: abstandKanoneSpaltPixelBerechnen(),
          ),
          spalt(),
          SizedBox(
            width: MediaQuery.of(context).size.width * widget.abstandZumSensor * 0.00002,
          ),
          schirm()
        ],
      ),
    ]);
  }

  Widget elektronenKanone() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.02,
      width: MediaQuery.of(context).size.width * 0.1,
    );
  }

  Widget spalt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: neuBerechen(),
          height: MediaQuery.of(context).size.height * 0.1 - spaltbreitePixel,
          width: MediaQuery.of(context).size.width * 0.005,
        ),
        SizedBox(
          height: spaltbreitePixel,
          width: MediaQuery.of(context).size.width * 0.005,
        ),
        Container(
          color: Colors.white,
          height: spaltabstandPixel,
          width: MediaQuery.of(context).size.width * 0.005,
        ),
        SizedBox(
          height: spaltbreitePixel,
          width: MediaQuery.of(context).size.width * 0.005,
        ),
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.1 - spaltbreitePixel,
          width: MediaQuery.of(context).size.width * 0.005,
        ),
      ],
    );
  }

  Widget schirm() {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.005,
      color: Colors.white,
    );
  }

  Color neuBerechen() {
    spaltbreitePixel = widget.spaltbreite * 0.01 * MediaQuery.of(context).size.height * 0.0005;
    spaltabstandPixel = widget.spaltabstand * 0.01 * MediaQuery.of(context).size.height * 0.0005;
    abstandZumSensorPixel = widget.abstandZumSensor * 0.01 * MediaQuery.of(context).size.height * 0.0005;
    return Colors.white; ///return color to update on setState
  }

  Offset resultLineStart() {
    return Offset(abstandKanoneSpaltPixelBerechnen() + MediaQuery.of(context).size.width * 0.1025, MediaQuery.of(context).size.height * 0.28);
  }

  Offset nulltesMaximumLineTarget () {
    return Offset(MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.005, MediaQuery.of(context).size.height * 0.28);
  }

  Offset elektronenKanonePositionPixel () {
    return Offset(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.height * 0.28);
  }

  double abstandKanoneSpaltPixelBerechnen () {
    return MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * widget.abstandZumSensor * 0.00002 + MediaQuery.of(context).size.width * 0.11);
  }

  ///berechnet abstand des k.Maximums zum 0.Maximum (ak)
  ///wellenlaenge = const für Versuch mit Elektronen
  ///d = Abstand zwischen Mittelpunkten der Spalte = Spaltabstand + Spaltbreite
  ///e = Abstand zwischen Doppelspalt und Schirm
  ///k element von {1; 2; 3; ...}
  ///line target = Höhe des Doppelspaltes + ak (in Pixel)
  double abstandZumNulltenMaximum (double wellenlaenge, double d, double e, int k) {
    double ak = (wellenlaenge * e * k) / d;
    return ak;
  }

  List<Line> maximaBerechnen() {
    List<Line> lines = [];
    for (int i = 0; abstandZumNulltenMaximum(600, widget.spaltabstand, widget.abstandZumSensor, i) * 0.01 * MediaQuery.of(context).size.height * 0.0005 < MediaQuery.of(context).size.height * 0.28; i++) {
      lines.add(Line(lineStart: resultLineStart(), lineEnd: Offset(MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.005, MediaQuery.of(context).size.height * 0.28 + abstandZumNulltenMaximum(600, widget.spaltabstand, widget.abstandZumSensor, i) * 0.01 * MediaQuery.of(context).size.height * 0.0005)));
      lines.add(Line(lineStart: resultLineStart(), lineEnd: Offset(MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.005, MediaQuery.of(context).size.height * 0.28 - abstandZumNulltenMaximum(600, widget.spaltabstand, widget.abstandZumSensor, i) * 0.01 * MediaQuery.of(context).size.height * 0.0005)));
    }
    return lines;
  }
}