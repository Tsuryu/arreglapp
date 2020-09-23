import 'package:arreglapp/src/pages/client_enrollment_page.dart';
import 'package:arreglapp/src/pages/provider_enrollment_page.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnrollmentTypeSelectionPage extends StatelessWidget {
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
              _TypeSelection(),
            ];
          },
        ),
      ),
    );
  }
}

class _TypeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.6,
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: Axis.vertical,
        children: [
          CommonButton(
            text: 'Cliente',
            onPressed: () async {
              bool result = await Navigator.push(
                  context, CupertinoPageRoute(builder: (BuildContext context) => ClientEnrollmentPage()));
              if (result) {
                Navigator.pop(context);
              }
            },
          ),
          CommonButton(
            text: 'Proveedor',
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ProviderEnrollmentPage()));
            },
          ),
        ],
      ),
    );
  }
}
