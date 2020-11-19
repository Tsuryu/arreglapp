import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExternalBackground extends StatelessWidget {
  final Widget child;
  final bool withBorderImage;
  final bool backButton;

  const ExternalBackground({@required this.child, this.withBorderImage = true, this.backButton = true});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            appTheme.currentTheme.scaffoldBackgroundColor,
            appTheme.currentTheme.canvasColor,
          ],
          begin: const FractionalOffset(0.5, 0.0),
          end: const FractionalOffset(0.5, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // withBorderImage
          //     ? FlareActor(
          //         "assets/flare/background-v2.flr",
          //         fit: BoxFit.fill,
          //         alignment: Alignment.center,
          //       )
          //     : Container(),
          this.child,
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: this.backButton
                  ? IconButton(
                      icon: Icon(Icons.chevron_left),
                      color: appTheme.currentTheme.accentColor,
                      iconSize: size.height * 0.075,
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
