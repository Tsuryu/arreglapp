import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Arreglapp');
  }
}
