import 'dart:math';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:physik_facharbeit/lines/intensity_line.dart';
import 'lines/line.dart';

class SimCalculator {
  double height;
  double width;
  double wellenlaenge;
  double spaltbreite;
  double spaltabstand;
  double abstandZumSchirm;

  SimCalculator({
    required this.height,
    required this.width,
    required this.wellenlaenge,
    required this.spaltbreite,
    required this.spaltabstand,
    required this.abstandZumSchirm
  });

  ///Lichtintensität an einem beliebigen Punkt auf dem Schirm berechen
  double calculateIntensity(double position) {
    ///HP bei unendlich
    if (position == 0) {
      position = 0.000001;
    }
    ///Aufteilung in mehrere Rechnungen zur Vermeidung von Fehlern
    double a = sin((2 * pi * spaltabstand * sin(position)) / wellenlaenge);
    double b = sin((pi * spaltabstand * sin(position)) / wellenlaenge);
    double c = sin((pi * spaltbreite * sin(position)) / wellenlaenge);
    double e = (pi * spaltbreite * sin(position)) / wellenlaenge;

    double intensity = pow(a / b, 2) * pow(c / e, 2).toDouble();
    return intensity;
  }

  ///Schirmbild berechnen
  List<IntensityLine> calculateIntensityLines() {
    ///! = 0 da f(0) == unendlich
    double maxIntensity = calculateIntensity(0.000000001);

    List<IntensityLine> lines = [];

    if (0 < spaltbreite) {
      lines.add(
        IntensityLine(
          lineStart: Offset(width / 2, 0),
          lineEnd: Offset(width / 2, height),
          intensity: maxIntensity
        ),
      );

      for (int i = 1; i < width / 2; i++) {
        lines.addAll (
            [
              IntensityLine(
                  lineStart: Offset(width / 2 - i, 0),
                  lineEnd: Offset(width / 2 - i, height),
                  intensity: calculateIntensity(i * (1 / (width / 2))) * (1 / maxIntensity)
              ),
              IntensityLine(
                  lineStart: Offset(width / 2 + i, 0),
                  lineEnd: Offset(width / 2 + i, height),
                  intensity: calculateIntensity(i * (1 / (width / 2))) * (1 / maxIntensity)
              ),
            ]
        );
      }
    }

    return lines;
  }

  ///Mittelpunkt zwischen den Spalten
  Offset resultLineStart() {
    return Offset(
        abstandLampeSpaltPixelBerechnen() + width * 0.1025, height * 0.28);
  }

  ///genaue Startpunkte
  Offset mitteUntererSpalt() {
    Offset mitte = resultLineStart();
    double spaltbreitePixel = spaltbreite * 0.01 * height * 0.0005;
    double spaltabstandPixel = spaltabstand * 0.01 * height * 0.0005;
    return Offset(mitte.dx, mitte.dy + spaltbreitePixel / 2 + spaltabstandPixel / 2);
  }

  Offset mitteObererSpalt() {
    Offset mitte = resultLineStart();
    double spaltbreitePixel = spaltbreite * 0.01 * height * 0.0005;
    double spaltabstandPixel = spaltabstand * 0.01 * height * 0.0005;
    return Offset(mitte.dx, mitte.dy - spaltbreitePixel / 2 - spaltabstandPixel / 2);
  }

  Offset lampePositionPixel() {
    return Offset(width * 0.1, height * 0.28);
  }

  double abstandLampeSpaltPixelBerechnen() {
    return width - (width * abstandZumSchirm * 0.00002 + width * 0.11);
  }

  double wellenlaengePixelBerechnen() {
    return wellenlaenge * 0.02;
  }

  ///berechnet abstand des k.Maximums zum 0.Maximum (ak) in nm
  ///k element von {1; 2; 3; ...}
  ///line target = Höhe des Doppelspaltes + ak (in Pixel)
  double abstandZumNulltenMaximum(int k) {
    double ak = 0;
    double o = (k * wellenlaenge) / spaltabstand;
    ///formula only valid while 0 < 1
    if (o < 1) {
      ak = sqrt((pow(o, 2) * pow(abstandZumSchirm, 2)) / pow(1 - o, 2));///neue Formel
    }
    else {
      ak = 0;
    }
    return ak;
  }

  ///Berechnet die Anzahl der Maxima
  ///Formel durch Lehrkraft vorgegeben
  int anzahlMaximaBerechnen() {
    return spaltabstand ~/ wellenlaenge;
  }

  ///Berechnet alle Linien für die vorhandenen Maxima
  List<Line> maximaBerechnen() {
    List<Line> lines = [];
    if (0 < spaltbreite) {
      for (int i = 0; i < anzahlMaximaBerechnen(); i++) {
        lines.addAll(
            calculateLine(
                k: i
            )
        );
      }
    }
    return lines;
  }

  ///Berechnet die Linie in der Darstellung für das k. Maximum
  ///k element von {1; 2; 3; ...}
  List<Line> calculateLine({required int k}) {
    double ePixel = width - width * 0.005 - resultLineStart().dx;
    double ak = abstandZumNulltenMaximum(k);
    double stretchFactor = ePixel / abstandZumSchirm;

    ///epixel / e = faktor für ak
    double akUI = ak * stretchFactor;
    //debugPrint('Alpha UI $k. Maximum: ${alphaBerechnen(k).toString()}');
    Line lineBottom = Line(
        lineStart: resultLineStart(),
        lineEnd: Offset(width - width * 0.005, height * 0.28 + akUI)
    );
    Line lineTop = Line(
        lineStart: resultLineStart(),
        lineEnd: Offset(width - width * 0.005, height * 0.28 - akUI)
    );
    return [lineBottom, lineTop];
  }

  ///Berechnet den Auslenkungswinkel des k. Maximum
  double alphaBerechnen(int k) {
    double laengeAnkathete = abstandZumSchirm;
    double laengeGegenkathete = abstandZumNulltenMaximum(k);
    return atan(laengeGegenkathete / laengeAnkathete) * (180 / pi);///Grad
  }

  ///Berechnet den Auslenkungswinkel für alle Maxima
  List<double> maximaBerechnenAlpha() {
    List<double> result = [];
    for (int i = 0; i < anzahlMaximaBerechnen(); i++) {
      result.add(alphaBerechnen(i));
    }
    return result;
  }

  ///Berechnet die Linien für die Maxima in der Schirmansicht
  List<Line> alphaLinienBerechnen() {
    List<double> maxima = maximaBerechnenAlpha();
    List<Line> result = [];
    for (int i = 0; i < maxima.length; i++) {
      result.addAll(
        [
          Line(
              lineStart: Offset(width * 0.5 + (width * 0.5 / 90) * maxima[i], 0),
              lineEnd: Offset(width * 0.5 + (width * 0.5 / 90) * maxima[i], height)
          ),
          Line(
              lineStart: Offset(width * 0.5 - (width * 0.5 / 90) * maxima[i], 0),
              lineEnd: Offset(width * 0.5 - (width * 0.5 / 90) * maxima[i], height)
          )
        ]
      );
    }
    return result;
  }

  ///Farbe der Linien berechnen mithilfe des Algorithmus von Bruton
  ///Quelle für Formel: http://www.olos.de/~ukern/publ/tex/pdf/dtk200504.pdf
  Color farbeBerechnen() {
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
    return Color.fromRGBO(pow(r * f, 0.8).toInt(), pow(g * f, 0.8).toInt(), pow(b * f, 0.8).toInt(), 1);
  }

  double fBerechnen(double wellenlaenge) {
    switch (wellenlaenge) {
      case >= 380 && < 420:
        return 0.3 + 0.7 * ((wellenlaenge - 380) / 40);
      case > 420 && < 700:
        return 1;
      case > 700 && <= 780:
        return 0.3 + 0.7 * ((780 - wellenlaenge) / 80);
    }
    return 1;
  }
}