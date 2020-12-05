import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final Widget content;
  final Function onTap;
  final bool hideTrailing;
  final bool hidePadding;

  const CommonCard({this.title = "", this.onTap, this.icon, this.hideTrailing = false, this.content, this.hidePadding = false});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: appTheme.accentColor.withOpacity(0.75),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ListTile(
        leading: icon,
        trailing: hideTrailing
            ? null
            : Container(
                height: double.infinity,
                child: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                  color: appTheme.primaryColor,
                ),
              ),
        title: this.content ?? Text(this.title, textScaleFactor: 1.3, style: appTheme.textTheme.bodyText2.copyWith()),
        contentPadding: this.hidePadding ? null : EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.03),
        onTap: this.onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: appTheme.primaryColor),
        ),
      ),
    );
  }
}
