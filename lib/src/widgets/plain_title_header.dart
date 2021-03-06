import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gesture_icon.dart';

class PlainTitleHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<GestureIcon> buttons;
  final bool backButton;

  const PlainTitleHeader({@required this.title, this.subtitle, this.buttons = const [], this.backButton = true});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      height: size.height * 0.15,
      alignment: Alignment.topLeft,
      // padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      // padding: EdgeInsets.only(left: size.width * 0.05, top: size.width * 0.05),
      padding: EdgeInsets.only(top: size.width * 0.05),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // backButton
          //     ? IconButton(
          //         icon: Icon(Icons.chevron_left),
          //         color: appTheme.accentColor,
          //         iconSize: size.height * 0.075,
          //         padding: EdgeInsets.all(0.0),
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //       )
          //     : Container(width: size.height * 0.075),
          Container(width: size.height * 0.075),
          Flexible(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: size.height * 0.04,
                    color: appTheme.textTheme.bodyText1.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                this.subtitle != null ? SizedBox(height: size.height * 0.01) : Container(),
                this.subtitle != null ? Text(this.subtitle, style: TextStyle(fontSize: size.height * 0.025)) : Container()
              ],
            ),
          ),
          // Spacer(),
          this.buttons.length > 0 ? Flexible(child: Container(child: Row(children: this.buttons, mainAxisAlignment: MainAxisAlignment.end))) : Container(),
        ],
      ),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50.0),
        ),
      ),
    );
  }
}
