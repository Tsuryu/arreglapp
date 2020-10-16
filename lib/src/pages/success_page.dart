import 'package:arreglapp/src/models/session.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/session_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuccessPage extends StatefulWidget {
  final String title;
  final Widget page;

  const SuccessPage({@required this.title, @required this.page});

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
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    return Scaffold(
      body: Center(
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
                mainButton: false,
                text: "Continuar",
                onPressed: () async {
                  final Session result =
                      await SessionService().login(sessionProvider.userProfile.username, sessionProvider.userProfile.password);

                  sessionProvider.session = result;
                  await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => widget.page));
                  FocusManager.instance.primaryFocus.unfocus();
                  sessionProvider.session = null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
