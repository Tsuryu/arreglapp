import 'package:animate_do/animate_do.dart';
import 'package:arreglapp/src/pages/create_request/job_request_type_selection_page.dart';
import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/pages/my_requests/job_request_list_page.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'external_background.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: ExternalBackground(
          child: SliderPageWrapper(
            header: _Header(),
            getChildren: () {
              return <Widget>[
                ItemList(),
              ];
            },
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.02),
          Flex(
            direction: Axis.horizontal,
            children: [
              GridItem(
                color: Colors.yellow,
                title: 'Buscar expertos',
                iconData: FontAwesomeIcons.searchLocation,
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => JobRequestTypeSelectionPage()));
                },
                delay: 250,
              ),
              Expanded(child: Container()),
              GridItem(color: Colors.green, title: 'Ofrecer servicios', iconData: FontAwesomeIcons.userTie, delay: 500),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Flex(
            direction: Axis.horizontal,
            children: [
              GridItem(
                color: Colors.lightBlue,
                title: 'Mis Solicitudes',
                iconData: FontAwesomeIcons.fileAlt,
                delay: 750,
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => JobRequestListPage()));
                },
              ),
              Expanded(child: Container()),
              GridItem(color: Colors.purple, title: 'Configurar', iconData: FontAwesomeIcons.cog, delay: 1000),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Flex(
            direction: Axis.horizontal,
            children: [
              GridItem(
                color: Colors.brown,
                title: 'Salir',
                iconData: FontAwesomeIcons.doorOpen,
                onTap: () async {
                  FocusManager.instance.primaryFocus.unfocus();
                  final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                  sessionProvider.session = null;
                  sessionProvider.userProfile = null;
                  await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
                },
                delay: 1250,
              ),
              Expanded(child: Container()),
              GridItem(color: Colors.lightGreen, title: 'Soporte', iconData: FontAwesomeIcons.question, delay: 1500),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Flex(
            direction: Axis.horizontal,
            children: [
              GridItem(color: Colors.grey, title: 'Proximamente', iconData: FontAwesomeIcons.ad, delay: 1750),
              Expanded(child: Container()),
              GridItem(color: Colors.grey, title: 'Proximamente', iconData: FontAwesomeIcons.ad, delay: 2000),
            ],
          ),
        ],
      ),
    );
  }
}

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
          color: this.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            side: BorderSide(color: appTheme.primaryColor),
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
                  Icon(this.iconData, size: 40, color: Colors.white),
                  SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      this.title,
                      style: appTheme.textTheme.bodyText1.copyWith(
                        color: Colors.white,
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

class GridItems extends StatelessWidget {
  const GridItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Arreglapp');
  }
}
