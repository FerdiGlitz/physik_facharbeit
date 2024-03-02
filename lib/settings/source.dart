import 'package:flutter/material.dart';

class Source {
  String usage;
  String source;

  Source({required this.usage, required this.source});

  Widget toWidget() {
    return InkWell(
        child: SelectableText('$usage: $source', textScaleFactor: 2,),
    );
  }
}