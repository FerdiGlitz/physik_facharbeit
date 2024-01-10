import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physik_facharbeit/custom_widgets/list_button.dart';
import 'package:physik_facharbeit/settings/sources.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Einstellungen'),
      ),
      body: Center(
          child: ListView(
            children: [
              ListButton(
                title: "Quellen",
                textColor: Colors.white,
                iconColor: Colors.grey,
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const Sources()));
                },
              ),
              ListButton(
                title: "Lizenzen",
                textColor: Colors.white,
                iconColor: Colors.grey,
                onPressed: () => showLicensePage(
                  context: context,
                  applicationName: "Facharbeit von Ferdinand Glitz",
                  applicationVersion: '0.1',
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset('icon/icon.png', width: 48, height: 48,),//TODO: add asset to pubspec.yaml
                  )
                ),
              )
            ],
          )
      ),
    );
  }
}