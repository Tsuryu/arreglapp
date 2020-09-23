import 'package:arreglapp/src/widgets/common_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';

class ProviderEnrollmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SliderPageWrapper(
          header: CommonHeader(),
          getChildren: () {
            return <Widget>[
              Text('hola mundo proveedor'),
            ];
          },
        ),
      ),
    );
  }
}
