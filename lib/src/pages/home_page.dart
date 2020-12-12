import 'package:arreglapp/src/pages/create_request/job_request_type_selection_page.dart';
import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/pages/profile_page.dart';
import 'package:arreglapp/src/pages/requests/request_type_selection_page.dart';
import 'package:arreglapp/src/pages/support_page.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/widgets/grid_item.dart';
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
          backButton: false,
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
                title: 'Cargar solicitud',
                iconData: FontAwesomeIcons.searchLocation,
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => JobRequestTypeSelectionPage()));
                },
                delay: 250,
              ),
              Expanded(child: Container()),
              GridItem(
                title: 'Solicitudes',
                iconData: FontAwesomeIcons.fileAlt,
                delay: 500,
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => RequestTypeSelectionPage()));
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Flex(
            direction: Axis.horizontal,
            children: [
              GridItem(
                title: 'Mis datos',
                iconData: FontAwesomeIcons.cog,
                delay: 750,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ProfilePage()));
                },
              ),
              Expanded(child: Container()),
              GridItem(
                title: 'Soporte',
                iconData: FontAwesomeIcons.question,
                delay: 1000,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => SupportPage()));
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Flex(
            direction: Axis.horizontal,
            children: [
              GridItem(
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
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Arreglapp', backButton: false);
  }
}
