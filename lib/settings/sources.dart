import 'package:flutter/material.dart';
import 'package:physik_facharbeit/custom_widgets/list_button.dart';
import 'package:physik_facharbeit/settings/source.dart';

class Sources extends StatefulWidget {
  const Sources({super.key});

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Quellen'),
      ),
      body: Center(
          child: ListView.builder(
            itemCount: formeln.length,
            itemBuilder: (BuildContext context, int index) {
              return formeln[index].toWidget();
            },
          )
      ),
    );
  }
  
  List<Source> formeln = [
    Source(usage: "Planck - Konstante", source: "https://de.wikipedia.org/wiki/Planck-Konstante")
  ];
}