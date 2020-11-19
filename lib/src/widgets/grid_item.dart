import 'package:animate_do/animate_do.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData iconData;
  final Function onTap;
  final int delay;

  const GridItem({this.color, this.title = "", this.subtitle = "", @required this.iconData, this.onTap, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return ZoomIn(
      delay: Duration(milliseconds: this.delay),
      duration: Duration(milliseconds: 250),
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.4,
        child: Card(
          color: this.color != null ? this.color : appTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            // side: BorderSide(color: appTheme.accentColor),
          ),
          child: InkWell(
            onTap: () {
              this.onTap();
            },
            child: Center(
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(this.iconData, size: 40, color: appTheme.accentColor),
                  SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      this.title,
                      style: appTheme.textTheme.bodyText1.copyWith(
                        color: appTheme.accentColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
