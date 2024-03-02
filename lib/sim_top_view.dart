import 'dart:math';
import 'package:flutter/material.dart';
import 'line.dart';
import 'line_painter.dart';

class SimTopView extends StatefulWidget {
  final double height;
  final double width;

  final double wellenlaenge;
  final double spaltbreite;
  final double spaltabstand;
  final double abstandZumSensor;

  const SimTopView({
    Key? key,
    required this.height,
    required this.width,
    required this.wellenlaenge,
    required this.spaltbreite,
    required this.spaltabstand,
    required this.abstandZumSensor
  }) : super(key: key);

  @override
  State<SimTopView> createState() => _SimTopViewState();
}

class _SimTopViewState extends State<SimTopView> {
  Color aufbauFarbe = Colors.black;
  Color hintergrundFarbe = Colors.white70;

  late List<Line> resultLines = [
    Line(lineStart: resultLineStart(), lineEnd: nulltesMaximumLineTarget()),
    //Linie zum 1.Maximum
    Line(
        lineStart: resultLineStart(),
        lineEnd: Offset(
            widget.width -
                widget.width * 0.005,
            widget.height * 0.28 +
                abstandZumNulltenMaximum(
                    widget.wellenlaenge, widget.spaltabstand, widget.abstandZumSensor, 1) *
                    0.01))
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
                  lineColor: farbeBerechnen(widget.wellenlaenge),
                  lineWidth: widget.spaltbreite *
                      0.01 *
                      widget.height *
                      0.0005,
                  lines: [
                    //Linie zum oberen Spalt
                    Line(
                        lineStart: elektronenKanonePositionPixel(),
                        lineEnd: Offset(
                            abstandKanoneSpaltPixelBerechnen() +
                                widget.width * 0.1025,
                            widget.height * 0.28 -
                                (widget.spaltabstand *
                                    0.01 *
                                    widget.height *
                                    0.0005) /
                                    2 -
                                (widget.spaltbreite *
                                    0.01 *
                                    widget.height *
                                    0.0005) /
                                    2)),
                    //Linie zum unteren Spalt
                    Line(
                        lineStart: elektronenKanonePositionPixel(),
                        lineEnd: Offset(
                            abstandKanoneSpaltPixelBerechnen() +
                                widget.width * 0.1025,
                            widget.height * 0.28 +
                                (widget.spaltabstand *
                                    0.01 *
                                    widget.height *
                                    0.0005) /
                                    2 +
                                (widget.spaltbreite *
                                    0.01 *
                                    widget.height *
                                    0.0005) /
                                    2)),
                  ]),
            ),
            CustomPaint(
              size: const Size.fromWidth(0.5),
              painter: LinePainter(
                  lineColor: farbeBerechnen(widget.wellenlaenge),
                  lineWidth:
                  600 * 0.01 * widget.height * 0.0005,
                  lines: maximaBerechnen()),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            lampe(),
            SizedBox(
              width: abstandKanoneSpaltPixelBerechnen(),
            ),
            spalt(),
            SizedBox(
              width: widget.width *
                  widget.abstandZumSensor *
                  0.00002,
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
      height: widget.height * 0.02,
      width: widget.width * 0.1,
    );
  }

  Widget spalt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: aufbauFarbe,
          height: widget.height * 0.1 -
              widget.spaltbreite *
                  0.01 *
                  widget.height *
                  0.0005,
          width: widget.width * 0.005,
        ),
        SizedBox(
          height: widget.spaltbreite *
              0.01 *
              widget.height *
              0.0005,
          width: widget.width * 0.005,
        ),
        Container(
          color: aufbauFarbe,
          height: widget.spaltabstand *
              0.01 *
              widget.height *
              0.0005,
          width: widget.width * 0.005,
        ),
        SizedBox(
          height: widget.spaltbreite *
              0.01 *
              widget.height *
              0.0005,
          width: widget.width * 0.005,
        ),
        Container(
          color: aufbauFarbe,
          height: widget.height * 0.1 -
              widget.spaltbreite *
                  0.01 *
                  widget.height *
                  0.0005,
          width: widget.width * 0.005,
        ),
      ],
    );
  }

  Widget schirm() {
    return Container(
      height: double.infinity,
      width: widget.width * 0.005,
      color: aufbauFarbe,
    );
  }

  Offset resultLineStart() {
    return Offset(
        abstandKanoneSpaltPixelBerechnen() +
            widget.width * 0.1025,
        widget.height * 0.28);
  }

  Offset nulltesMaximumLineTarget() {
    return Offset(
        widget.width -
            widget.width * 0.005,
        widget.height * 0.28);
  }

  Offset elektronenKanonePositionPixel() {
    return Offset(widget.width * 0.1,
        widget.height * 0.28);
  }

  double abstandKanoneSpaltPixelBerechnen() {
    return widget.width -
        (widget.width * widget.abstandZumSensor * 0.00002 +
            widget.width * 0.11);
  }

  ///berechnet abstand des k.Maximums zum 0.Maximum (ak) in nm
  ///d = Spaltabstand
  ///e = Abstand zwischen Doppelspalt und Schirm
  ///k element von {1; 2; 3; ...}
  ///line target = Höhe des Doppelspaltes + ak (in Pixel)
  double abstandZumNulltenMaximum(double wellenlaenge, double d, double e, int k) {
    double ak = tan(asin(k * wellenlaenge / d)) * e;
    return ak;
  }

  int anzahlMaximaBerechnen(double spaltbreite, double wellenlaenge) {
    return spaltbreite ~/ wellenlaenge;
  }

  List<Line> maximaBerechnen() {
    List<Line> lines = [];
    for (int i = 0; i < anzahlMaximaBerechnen(widget.spaltbreite, widget.wellenlaenge) && calculateLine(wellenlaenge: widget.wellenlaenge, d: widget.spaltabstand, e: widget.abstandZumSensor, k: i)[0].lineEnd.dy * widget.height * 0.0006 < widget.height; i++) {
      lines.addAll(calculateLine(
          wellenlaenge: widget.wellenlaenge,
          d: widget.spaltabstand,
          e: widget.abstandZumSensor,
          k: i)
      );
    }
    return lines;
  }

  ///d = Abstand zwischen Mittelpunkten der Spalte = Spaltabstand + Spaltbreite
  ///e = Abstand zwischen Doppelspalt und Schirm
  ///k element von {1; 2; 3; ...}
  List<Line> calculateLine({required double wellenlaenge, required double d, required double e, required int k}) {
    double ePixel = widget.width - widget.width * 0.005 - resultLineStart().dx;
    double ak = abstandZumNulltenMaximum(wellenlaenge, d, e, k);
    double stretchFactor = ePixel / e;

    ///epixel / e = faktor für ak
    double akUI = ak * stretchFactor;
    //debugPrint('Alpha UI $k. Maximum: ${alphaBerechnen(ePixel, akUI).toString()}');
    Line lineBottom = Line(
        lineStart: resultLineStart(),
        lineEnd: Offset(widget.width - widget.width * 0.005, widget.height * 0.28 + akUI)
    );
    Line lineTop = Line(
        lineStart: resultLineStart(),
        lineEnd: Offset(widget.width - widget.width * 0.005, widget.height * 0.28 - akUI)
    );
    return [lineBottom, lineTop];
  }

  double alphaBerechnen(double e, double ak) {
    double laengeAnkathete = e;
    double laengeGegenkathete = ak;
    return atan(laengeGegenkathete / laengeAnkathete) * (180 / pi);///Grad
  }

  ///Farbe der Linien berechnen mithilfe des Algorithmus von Bruton
  ///Quelle für Formel: http://www.olos.de/~ukern/publ/tex/pdf/dtk200504.pdf
  Color farbeBerechnen(double wellenlaenge) {
    int r;
    int g;
    int b;

    switch (wellenlaenge) {
      case >= 380 && < 440:
        r = 255 * (440 - wellenlaenge) ~/ 60;
        g = 0;
        b = 255;
        break;
      case >= 440 && < 490:
        r = 0;
        g = 255 * (wellenlaenge - 440) ~/ 50;
        b = 255;
        break;
      case >= 490 && < 510:
        r = 0;
        g = 255;
        b = 255 * (510 - wellenlaenge) ~/ 20;
        break;
      case >= 510 && < 580:
        r = 255 * (wellenlaenge - 510) ~/ 70;
        g = 255;
        b = 0;
        break;
      case >= 580 && < 645:
        r = 255;
        g = 255 * (645 - wellenlaenge) ~/ 65;
        b = 0;
        break;
      case >= 645 && <= 780:
        r = 255;
        g = 0;
        b = 0;
        break;
      default:
        r = 255;
        g = 255;
        b = 255;
        break;
    }
    double f = fBerechnen(wellenlaenge);
    return Color.fromRGBO(pow(r * f, 0.8).toInt(), pow(g * f, 0.8).toInt(),
        pow(b * f, 0.8).toInt(), 1);
  }

  double fBerechnen(double wellenlaenge) {
    switch (wellenlaenge) {
      case > 380 && < 420:
        return 0.3 + 0.7 * ((wellenlaenge - 380) / 40);
      case > 420 && < 700:
        return 1;
      case > 700 && < 780:
        return 0.3 + 0.7 * ((780 - wellenlaenge) / 80);
    }
    return 1;
  }
}
