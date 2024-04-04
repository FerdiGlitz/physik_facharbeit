import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physik_facharbeit/settings/settings.dart';
import 'package:physik_facharbeit/sim_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facharbeit von Ferdinand Glitz',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.yellowAccent),
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SimUI(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}