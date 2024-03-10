import 'package:flutter/material.dart';
import 'package:physik_facharbeit/sim_calculator.dart';
import 'package:physik_facharbeit/sim_result_view.dart';
import 'package:physik_facharbeit/sim_top_view.dart';

class SimUI extends StatefulWidget {
  final double height;
  final double width;

  const SimUI({super.key, required this.height, required this.width});

  @override
  State<SimUI> createState() => _SimUIState();
}

class _SimUIState extends State<SimUI> {
  late SimCalculator simCalculator = SimCalculator(
    height: widget.height,
    width: widget.width,
    wellenlaenge: 600,
    spaltabstand: 2000,
    abstandZumSchirm: 20000,
    spaltbreite: 1200
  );

  TextEditingController wellenlaengeController = TextEditingController();
  TextEditingController spaltbreiteController = TextEditingController();
  TextEditingController abstandZumSensorController = TextEditingController();
  TextEditingController spaltabstandController = TextEditingController();

  double wellenlaengeMaximum = 780;
  double spaltbreiteMaximum = 4000;
  double spaltabstandMaximum = 5000;
  double abstandZumSensorMaximum = 30000;

  @override
  void initState() {
    wellenlaengeController.text = simCalculator.wellenlaenge.toInt().toString();
    spaltbreiteController.text = simCalculator.spaltbreite.toInt().toString();
    spaltabstandController.text = simCalculator.spaltabstand.toInt().toString();
    abstandZumSensorController.text = simCalculator.abstandZumSchirm.toInt().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            SizedBox(
                height: widget.height * 0.56,
                child: PageView(
                  children: <Widget> [
                    SimTopView(
                      simCalculator: simCalculator,
                    ),
                    SimResultView(
                      simCalculator: simCalculator,
                    ),
                  ]
                )
            ),
            Container(
              width: double.infinity,
              height: widget.height * 0.34,
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border(top: BorderSide(color: Colors.grey.shade600, width: 5))
              ),
              child: ListView(
                children: [
                  wellenlaengeSlider(),
                  spaltbreiteSlider(),
                  spaltabsstandSlider(),
                  abstandZumSchirmSlider(),
                  Text(
                    'Auslenkungswinkel des 1. Maximums: ${simCalculator.alphaBerechnen(1).round().toString()}°',
                    textScaler: const TextScaler.linear(1.5),
                  ),
                  Text(
                    'Abstand zum 0. Maximum des 1. Maximums: ${simCalculator.abstandZumNulltenMaximum(1).round().toString()}nm',
                    textScaler: const TextScaler.linear(1.5),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget spaltbreiteSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Spaltbreite', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: simCalculator.spaltbreite,
                    max: spaltbreiteMaximum,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        spaltbreiteController.text = value.toInt().toString();
                        simCalculator.spaltbreite = value.toInt().toDouble();
                      });
                    }
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: spaltbreiteController,
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              if (double.parse(newValue) < 20000) {
                if (double.parse(newValue) < spaltbreiteMaximum) {
                  setState(() {
                    simCalculator.spaltbreite = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    spaltbreiteMaximum = double.parse(newValue);
                    simCalculator.spaltbreite = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  spaltbreiteMaximum = 20000;
                  simCalculator.spaltbreite = 20000;
                  spaltbreiteController.text = '20000';
                });
              }
            },
          ),
        ),
        const SizedBox(width: 20,),
      ],
    );
  }

  Widget spaltabsstandSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Spaltabstand', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: simCalculator.spaltabstand,
                    max: 5000,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        simCalculator.spaltabstand = value.toInt().toDouble();
                        spaltabstandController.text = simCalculator.spaltabstand.toInt().toString();
                      });
                    }
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: spaltabstandController,
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              if (double.parse(newValue) < 20000) {
                if (double.parse(newValue) < spaltabstandMaximum) {
                  setState(() {
                    simCalculator.spaltabstand = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    spaltabstandMaximum = double.parse(newValue);
                    simCalculator.spaltabstand = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  spaltabstandMaximum = 20000;
                  simCalculator.spaltabstand = 20000;
                  spaltabstandController.text = '20000';
                });
              }
            },
          ),
        ),
        const SizedBox(width: 20,),
      ],
    );
  }

  Widget abstandZumSchirmSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Abstand zum Schirm', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: simCalculator.abstandZumSchirm,
                    min: 200,
                    max: 30000,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        simCalculator.abstandZumSchirm = value.toInt().toDouble();
                        abstandZumSensorController.text = simCalculator.abstandZumSchirm.toInt().toString();
                      });
                    }
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: abstandZumSensorController,
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              if (double.parse(newValue) < 30000) {
                if (double.parse(newValue) < spaltbreiteMaximum) {
                  setState(() {
                    simCalculator.abstandZumSchirm = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    abstandZumSensorMaximum = double.parse(newValue);
                    simCalculator.abstandZumSchirm = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  abstandZumSensorMaximum = 30000;
                  simCalculator.abstandZumSchirm = 30000;
                  abstandZumSensorController.text = '30000';
                });
              }
            },
          ),
        ),
        const SizedBox(width: 20,),
      ],
    );
  }

  Widget wellenlaengeSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Wellenlänge', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: simCalculator.wellenlaenge,
                    min: 380,
                    max: 780,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        simCalculator.wellenlaenge = value.toInt().toDouble();
                        wellenlaengeController.text = simCalculator.wellenlaenge.toInt().toString();
                      });
                    }
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: wellenlaengeController,
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              if (double.parse(newValue) < 780) {
                if (double.parse(newValue) < wellenlaengeMaximum) {
                  setState(() {
                    simCalculator.wellenlaenge = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    wellenlaengeMaximum = double.parse(newValue);
                    simCalculator.wellenlaenge = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  wellenlaengeMaximum = 780;
                  simCalculator.wellenlaenge = 780;
                  wellenlaengeController.text = '780';
                });
              }
            },
          ),
        ),
        const SizedBox(width: 20,),
      ],
    );
  }
}