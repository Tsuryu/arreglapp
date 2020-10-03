import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String title;

  const CommonHeader({this.title = 'Arreglap'});

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: this.title);
  }
}
