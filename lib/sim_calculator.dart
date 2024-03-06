import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:physik_facharbeit/sim_ui.dart';

import 'line.dart';

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

  Offset resultLineStart() {
    return Offset(
        abstandLampeSpaltPixelBerechnen() +
            width * 0.1025,
        height * 0.28);
  }

  Offset lampePositionPixel() {
    return Offset(width * 0.1,
        height * 0.28);
  }

  double abstandLampeSpaltPixelBerechnen() {
    return width -
        (width * abstandZumSchirm * 0.00002 +
            width * 0.11);
  }

  ///berechnet abstand des k.Maximums zum 0.Maximum (ak) in nm
  ///k element von {1; 2; 3; ...}
  ///line target = Höhe des Doppelspaltes + ak (in Pixel)
  double abstandZumNulltenMaximum(int k) {
    double ak = tan(asin(k * wellenlaenge / spaltabstand)) * abstandZumSchirm;///Alte Formel
    if (SimUI.useNewWrongFormula) {
      double o = (k * wellenlaenge)/spaltabstand;
      ak = sqrt(((o*o)*(abstandZumSchirm * abstandZumSchirm))/((1-o)*(1-o)));///neue Formel
    }
    //debugPrint(ak.toString());
    return ak;
  }

  ///Berechnet die Anzahl der Maxima
  int anzahlMaximaBerechnen() {
    return spaltbreite ~/ wellenlaenge;
  }

  ///Berechnet alle Linien für die vorhandenen Maxima
  List<Line> maximaBerechnen() {
    List<Line> lines = [];
    for (int i = 0; i < anzahlMaximaBerechnen(); i++) {
      lines.addAll(
        calculateLine(
          k: i
        )
      );
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