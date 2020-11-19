import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/requests/search_request_page.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOngoingJobRequestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              Expanded(
                child: Container(
                  height: size.height * 0.8,
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      _JobCard(),
                      _JobCard(),
                      _JobCard(),
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: appTheme.accentColor.withOpacity(0.75),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ListTile(
        // leading: Container(
        //   height: double.infinity,
        //   child: Icon(
        //     IconData(jobList[index].operationType.iconCode, fontFamily: jobList[index].operationType.iconFamily),
        //     size: 40.0,
        //     color: appTheme.primaryColor,
        //   ),
        // ),
        // trailing: Container(
        //   height: double.infinity,
        //   child: Icon(
        //     Icons.chevron_right,
        //     size: 40.0,
        //     color: appTheme.primaryColor,
        //   ),
        // ),
        title: RichText(
          text: TextSpan(
            children: [
              // TextSpan(text: "(Pendiente) ", style: appTheme.textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)),
              TextSpan(text: "jobList[index].title", style: appTheme.textTheme.bodyText2),
            ],
          ),
        ),
        subtitle: Text("jobList[index].description"),
        contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.03),
        onTap: () async {
          await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => SearchRequestPage()));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: appTheme.primaryColor),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Solicitudes en curso');
  }
}
