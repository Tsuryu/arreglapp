import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
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
          child: Stack(
            children: [
              _ItemList(),
              _Header(),
            ],
          ),
          //           Text("Hola ${sessionProvider.userProfile.username}"),
          //           Text("JWT ${sessionProvider.session.jwt}"),
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: GridView.count(
        padding: EdgeInsets.only(top: size.width * 0.3),
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: [
          GridItem(color: Colors.yellow, title: 'Buscar expertos', iconData: FontAwesomeIcons.searchLocation),
          GridItem(color: Colors.green, title: 'Ofrecer servicios', iconData: FontAwesomeIcons.userTie),
          GridItem(color: Colors.purple, title: 'Configurar', iconData: FontAwesomeIcons.cog),
          GridItem(color: Colors.lightBlue, title: 'Soporte', iconData: FontAwesomeIcons.question),
          GridItem(color: Colors.grey, title: 'Proximamente', iconData: FontAwesomeIcons.ad),
          GridItem(color: Colors.grey, title: 'Proximamente', iconData: FontAwesomeIcons.ad),
          GridItem(color: Colors.grey, title: 'Proximamente', iconData: FontAwesomeIcons.ad),
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

  const GridItem({this.color, this.title = "", this.subtitle = "", @required this.iconData});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final cardItemSize = size.width * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: cardItemSize, vertical: cardItemSize / 3),
      child: Card(
        color: this.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: appTheme.primaryColor),
        ),
        child: InkWell(
          onTap: () {
            print("click");
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
