import 'package:flutter/material.dart';
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
  double spaltbreite = 1200; //Einheit: Nanometer
  double spaltabstand = 2000; //Einheit: Nanometer
  double abstandZumSensor = 20000; //Einheit: Nanometer
  double wellenlaenge = 600; //Einheit: Nanometer

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
    wellenlaengeController.text = wellenlaenge.toInt().toString();
    spaltbreiteController.text = spaltbreite.toInt().toString();
    spaltabstandController.text = spaltabstand.toInt().toString();
    abstandZumSensorController.text = abstandZumSensor.toInt().toString();
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
                      height: widget.height,
                      width: widget.width,
                      wellenlaenge: wellenlaenge,
                      spaltbreite: spaltbreite,
                      spaltabstand: spaltabstand,
                      abstandZumSensor: abstandZumSensor,
                    ),
                    SimResultView(
                      height: widget.height * 0.56,
                      width: widget.width,
                      wellenlaenge: wellenlaenge,
                      spaltbreite: spaltbreite,
                      spaltabstand: spaltabstand,
                      abstandZumSensor: abstandZumSensor,
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
                  abstandZumSensorSlider()
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
              const Text('Spaltbreite', textScaleFactor: 1.5,),
              Expanded(
                child: Slider (
                    value: spaltbreite,
                    max: spaltbreiteMaximum,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        spaltbreiteController.text = value.toInt().toString();
                        spaltbreite = value.toInt().toDouble();
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
                    spaltbreite = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    spaltbreiteMaximum = double.parse(newValue);
                    spaltbreite = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  spaltbreiteMaximum = 20000;
                  spaltbreite = 20000;
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
              const Text('Spaltabstand', textScaleFactor: 1.5,),
              Expanded(
                child: Slider (
                    value: spaltabstand,
                    max: 5000,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        spaltabstand = value.toInt().toDouble();
                        spaltabstandController.text = spaltabstand.toInt().toString();
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
                    spaltabstand = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    spaltabstandMaximum = double.parse(newValue);
                    spaltabstand = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  spaltabstandMaximum = 20000;
                  spaltabstand = 20000;
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

  Widget abstandZumSensorSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Abstand zum Sensor', textScaleFactor: 1.5,),
              Expanded(
                child: Slider (
                    value: abstandZumSensor,
                    min: 200,
                    max: 30000,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        abstandZumSensor = value.toInt().toDouble();
                        abstandZumSensorController.text = abstandZumSensor.toInt().toString();
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
                    abstandZumSensor = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    abstandZumSensorMaximum = double.parse(newValue);
                    abstandZumSensor = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  abstandZumSensorMaximum = 30000;
                  abstandZumSensor = 30000;
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
              const Text('Wellenlänge', textScaleFactor: 1.5,),
              Expanded(
                child: Slider (
                    value: wellenlaenge,
                    min: 380,
                    max: 780,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        wellenlaenge = value.toInt().toDouble();
                        wellenlaengeController.text = wellenlaenge.toInt().toString();
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
                    wellenlaenge = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    wellenlaengeMaximum = double.parse(newValue);
                    wellenlaenge = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  wellenlaengeMaximum = 780;
                  wellenlaenge = 780;
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