import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/types/common-type.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'error_page.dart';
import 'external_background.dart';

class SuccessPage extends StatefulWidget {
  final String title;
  final Widget page;
  final FutureBoolCallback onPressed;

  const SuccessPage({@required this.title, @required this.page, this.onPressed});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    setState(() {});

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: ExternalBackground(
          child: Center(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.5,
                  width: size.height * 0.5,
                  child: FlareActor(
                    "assets/flare/check-inverted.flr",
                    animation: "Play",
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    widget.title,
                    style: appTheme.textTheme.bodyText2.copyWith(
                      fontSize: size.height * 0.03,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: CommonButton(
                    withBorder: false,
                    mainButton: false,
                    text: "Continuar",
                    onPressed: () async {
                      FocusManager.instance.primaryFocus.unfocus();
                      Widget nextPage = widget.page;
                      if (widget.onPressed != null && !await widget.onPressed()) {
                        nextPage = ErrorPage();
                      }
                      await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => nextPage));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
