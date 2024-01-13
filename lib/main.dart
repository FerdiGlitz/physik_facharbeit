import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physik_facharbeit/settings/settings.dart';
import 'package:physik_facharbeit/sim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Facharbeit von Ferdinand Glitz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double spaltbreite = 500; //Einheit: Nanometer
  double spaltabstand = 2000; //Einheit: Nanometer
  double abstandZumSensor = 20000; //Einheit: Nanometer
  double wellenlaenge = 600; //Einheit: Nanometer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const Settings()));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.56,
              child: SimTopView(wellenlaenge: wellenlaenge, spaltbreite: spaltbreite, spaltabstand: spaltabstand, abstandZumSensor: abstandZumSensor)
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.34,
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
      ),
    );
  }

  Widget spaltbreiteSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        const Text('Spaltbreite', textScaleFactor: 1.5,),
        Expanded(
          child: Slider (
              value: spaltbreite,
              max: 4000,
              inactiveColor: Colors.grey.shade600,
              activeColor: Colors.limeAccent,
              onChanged: (value) {
                setState(() {
                  spaltbreite = value.toInt().toDouble();
                });
              }
          ),
        ),
        Text(spaltbreite.toInt().toString(), textScaleFactor: 1.5,),
        const SizedBox(width: 20,),
      ],
    );
  }

  Widget spaltabsstandSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        const Text('Spaltabstand', textScaleFactor: 1.5,),
        Expanded(
          child: Slider (
              value: spaltabstand,
              min: 500,
              max: 5000,
              inactiveColor: Colors.grey.shade600,
              activeColor: Colors.limeAccent,
              onChanged: (value) {
                setState(() {
                  spaltabstand = value.toInt().toDouble();
                });
              }
          ),
        ),
        Text(spaltabstand.toInt().toString(), textScaleFactor: 1.5,),
        const SizedBox(width: 20,),
      ],
    );
  }

  Widget abstandZumSensorSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
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
                });
              }
          ),
        ),
        Text(abstandZumSensor.toInt().toString(), textScaleFactor: 1.5,),
        const SizedBox(width: 20,),
      ],
    );
  }

  Widget wellenlaengeSlider() {
    return Row(
      children: [
        const SizedBox(width: 20,),
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
                });
              }
          ),
        ),
        Text(wellenlaenge.toInt().toString(), textScaleFactor: 1.5,),
        const SizedBox(width: 20,),
      ],
    );
  }
}