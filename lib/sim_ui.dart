import 'package:flutter/material.dart';
import 'package:physik_facharbeit/sim_calculator.dart';
import 'package:physik_facharbeit/sim_graph_view.dart';
import 'package:physik_facharbeit/sim_result_view.dart';
import 'package:physik_facharbeit/sim_top_view.dart';

class SimUI extends StatefulWidget {
  final double height;
  final double width;

  const SimUI({super.key, required this.height, required this.width});

  @override
  State<SimUI> createState() => _SimUIState();
}

class _SimUIState extends State<SimUI> with WidgetsBindingObserver {
  late final SimCalculator _simCalculator = SimCalculator(
    height: widget.height,
    width: widget.width,
    wellenlaenge: 450,
    spaltabstand: 1500,
    abstandZumSchirm: 20000,
    spaltbreite: 300
  );

  TextEditingController wellenlaengeController = TextEditingController();
  TextEditingController spaltbreiteController = TextEditingController();
  TextEditingController abstandZumSensorController = TextEditingController();
  TextEditingController spaltabstandController = TextEditingController();

  double _wellenlaengeMaximum = 780;
  double _spaltbreiteMaximum = 4000;
  double _spaltabstandMaximum = 5000;
  double _abstandZumSchirmMaximum = 30000;

  int _k = 1;

  @override
  void didChangeMetrics() {
    setState(() {
      _simCalculator.height = MediaQuery.of(context).size.height;
      _simCalculator.width = MediaQuery.of(context).size.width;
    });
  }

  @override
  void initState() {
    wellenlaengeController.text = _simCalculator.wellenlaenge.toInt().toString();
    spaltbreiteController.text = _simCalculator.spaltbreite.toInt().toString();
    spaltabstandController.text = _simCalculator.spaltabstand.toInt().toString();
    abstandZumSensorController.text = _simCalculator.abstandZumSchirm.toInt().toString();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                      simCalculator: _simCalculator,
                    ),
                    SimResultView(
                      simCalculator: _simCalculator,
                    ),
                    SimGraphView(
                      simCalculator: _simCalculator,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    _wellenlaengeSlider(),
                    _spaltbreiteSlider(),
                    _spaltabsstandSlider(),
                    _abstandZumSchirmSlider(),
                    _kSlider(),
                    Text(
                      'Auslenkungswinkel des k. Maximums: ${_simCalculator.alphaBerechnen(_k).toStringAsFixed(2)}°',
                      textScaler: const TextScaler.linear(1.5),
                    ),
                    Text(
                      'Abstand zum 0. Maximum des k. Maximums: ${_simCalculator.abstandZumNulltenMaximum(_k).toStringAsFixed(2)}nm',
                      textScaler: const TextScaler.linear(1.5),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _kSlider() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('k', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: _k.toDouble(),
                    max: _simCalculator.anzahlMaximaBerechnen().toDouble(),
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        _k = value.toInt();
                      });
                    }
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            _k.toString(),
            textScaler: const TextScaler.linear(1.5),
          ),
        ),
      ],
    );
  }

  Widget _spaltbreiteSlider() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Spaltbreite', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: _simCalculator.spaltbreite,
                    max: _simCalculator.spaltabstand * 2,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        spaltbreiteController.text = value.toInt().toString();
                        _simCalculator.spaltbreite = value.toInt().toDouble();
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
                if (double.parse(newValue) < _spaltbreiteMaximum) {
                  setState(() {
                    _simCalculator.spaltbreite = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    _spaltbreiteMaximum = double.parse(newValue);
                    _simCalculator.spaltbreite = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  _spaltbreiteMaximum = 20000;
                  _simCalculator.spaltbreite = 20000;
                  spaltbreiteController.text = '20000';
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _spaltabsstandSlider() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Spaltabstand', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: _simCalculator.spaltabstand,
                    min: _simCalculator.spaltbreite / 2,
                    max: 5000,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        _simCalculator.spaltabstand = value.toInt().toDouble();
                        spaltabstandController.text = _simCalculator.spaltabstand.toInt().toString();
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
                if (double.parse(newValue) < _spaltabstandMaximum) {
                  setState(() {
                    _simCalculator.spaltabstand = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    _spaltabstandMaximum = double.parse(newValue);
                    _simCalculator.spaltabstand = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  _spaltabstandMaximum = 20000;
                  _simCalculator.spaltabstand = 20000;
                  spaltabstandController.text = '20000';
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _abstandZumSchirmSlider() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Abstand zum Schirm', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: _simCalculator.abstandZumSchirm,
                    min: 200,
                    max: _abstandZumSchirmMaximum,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        _simCalculator.abstandZumSchirm = value.toInt().toDouble();
                        abstandZumSensorController.text = _simCalculator.abstandZumSchirm.toInt().toString();
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
                if (double.parse(newValue) < _spaltbreiteMaximum) {
                  setState(() {
                    _simCalculator.abstandZumSchirm = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    _abstandZumSchirmMaximum = double.parse(newValue);
                    _simCalculator.abstandZumSchirm = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  _abstandZumSchirmMaximum = 30000;
                  _simCalculator.abstandZumSchirm = 30000;
                  abstandZumSensorController.text = '30000';
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _wellenlaengeSlider() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              const Text('Wellenlänge', textScaler: TextScaler.linear(1.5),),
              Expanded(
                child: Slider (
                    value: _simCalculator.wellenlaenge,
                    min: 380,
                    max: 780,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Colors.limeAccent,
                    onChanged: (value) {
                      setState(() {
                        _simCalculator.wellenlaenge = value.toInt().toDouble();
                        wellenlaengeController.text = _simCalculator.wellenlaenge.toInt().toString();
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
                if (double.parse(newValue) < _wellenlaengeMaximum) {
                  setState(() {
                    _simCalculator.wellenlaenge = double.parse(newValue);
                  });
                } else {
                  setState(() {
                    _wellenlaengeMaximum = double.parse(newValue);
                    _simCalculator.wellenlaenge = double.parse(newValue);
                  });
                }
              } else {
                setState(() {
                  _wellenlaengeMaximum = 780;
                  _simCalculator.wellenlaenge = 780;
                  wellenlaengeController.text = '780';
                });
              }
            },
          ),
        ),
      ],
    );
  }
}