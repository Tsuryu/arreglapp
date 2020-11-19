import 'dart:async';

import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final bool mainButton;
  final Function onPressed;
  static dynamic _dummyOnPressed() {}
  final double width;
  final double height;
  final bool withBorder;
  final bool materialEffect;
  final bool disabled;

  const CommonButton({
    @required this.text,
    this.mainButton = true,
    this.onPressed = _dummyOnPressed,
    this.width,
    this.height,
    this.withBorder = true,
    this.materialEffect = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.5;
    final onPressedParamFunction = this.onPressed;

    return Container(
      width: this.width != null ? this.width : buttonWidth,
      height: this.height != null ? this.height : buttonWidth / 4,
      child: FlatButton(
        onPressed: this.disabled
            ? () {}
            : () {
                if (materialEffect) {
                  Timer(Duration(milliseconds: 150), () {
                    onPressedParamFunction();
                  });
                } else {
                  onPressedParamFunction();
                }
              },
        child: Text(
          this.text,
          textAlign: TextAlign.center,
          style: this.mainButton
              ? appTheme.textTheme.bodyText2
              : appTheme.textTheme.bodyText2.copyWith(color: this.disabled ? Color(0xff888888) : appTheme.accentColor),
        ),
        color: this.disabled
            ? Color(0xffaaaaaa)
            : this.mainButton
                ? appTheme.accentColor
                : appTheme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: this.withBorder
              ? BorderSide(color: this.mainButton ? Colors.white : appTheme.backgroundColor)
              : BorderSide(width: 0.0, color: Colors.transparent),
        ),
      ),
    );
  }
}
