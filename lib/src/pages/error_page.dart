import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class ErrorPage extends StatefulWidget {
  final String title;

  const ErrorPage({this.title = "Lo sentimos hubo un error inesperado"});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> with SingleTickerProviderStateMixin {
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
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              appTheme.scaffoldBackgroundColor,
              appTheme.canvasColor,
            ],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.5, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.5,
                width: size.height * 0.5,
                child: FlareActor(
                  "assets/flare/error.flr",
                  animation: "go",
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
                  mainButton: false,
                  withBorder: false,
                  text: "Volver",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => sessionProvider.session != null ? HomePage() : LoginPage(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
