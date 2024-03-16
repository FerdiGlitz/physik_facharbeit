import 'package:flutter/material.dart';
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
          child: ListView.separated(
            itemCount: formeln.length,
            itemBuilder: (BuildContext context, int index) {
              return formeln[index].toWidget();
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
      ),
    );
  }
  
  List<Source> formeln = [
    Source(usage: "Formel für λ zu RGB", source: "http://www.olos.de/~ukern/publ/tex/pdf/dtk200504.pdf"),
    Source(usage: "Formel für Lichtintensität", source: "https://www.leifiphysik.de/optik/beugung-und-interferenz/ausblick/doppelspalt-intensitaetsverteilung")
  ];
}