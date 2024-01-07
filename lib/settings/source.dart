import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Source {
  String usage;
  String source;

  Source({required this.usage, required this.source});

  Widget toWidget() {
    return InkWell(
        child: Text('$usage: $source', textScaleFactor: 2,),
        onTap: () => launchUrl(Uri.parse(source))
    );
  }
}