import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextLabel extends StatelessWidget {
  final String label;
  final String text;
  final double fontSize;

  const TextLabel({this.label, this.text, this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$label: ', style: appTheme.textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold, fontSize: this.fontSize)),
          TextSpan(text: text, style: appTheme.textTheme.bodyText2.copyWith(fontSize: this.fontSize)),
        ],
      ),
    );
  }
}
