import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final bool mainButton;
  final Function onPressed;
  static dynamic _dummyOnPressed() {}

  const CommonButton({@required this.text, this.mainButton = true, this.onPressed = _dummyOnPressed});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.5;

    return Container(
      width: buttonWidth,
      height: buttonWidth / 4,
      child: FlatButton(
        onPressed: this.onPressed,
        child: Text(this.text, style: this.mainButton ? appTheme.textTheme.bodyText2 : appTheme.accentColor),
        color: this.mainButton ? appTheme.accentColor : appTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(color: this.mainButton ? Colors.white : appTheme.backgroundColor),
        ),
      ),
    );
  }
}
