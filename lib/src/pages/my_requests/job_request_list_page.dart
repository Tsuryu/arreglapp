import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:arreglapp/constants/constants.dart' as Constants;

class JobRequestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              Text('hola'),
              Text('hola'),
              Text('hola'),
              Text('hola'),
              // ItemList(),
            ];
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Mis solicitudes');
  }
}
