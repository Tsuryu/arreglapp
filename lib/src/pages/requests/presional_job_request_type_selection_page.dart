import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/requests/job_request_list_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfesionalJobRequestTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              _Items(),
            ];
          },
        ),
      ),
    );
  }
}

class _Items extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        children: [
          _JobCard(
            title: "Buscar solicitudes",
            onTap: () async {
              final requestProvider = Provider.of<RequestProvider>(context, listen: false);
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              requestProvider.isNew = true;
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => JobRequestListPage(
                    myRequest: false,
                    title: "Buscar solicitudes",
                    searchFunction: () async {
                      return await JobRequestService().searchRequests(sessionProvider.session.jwt);
                    },
                  ),
                ),
              );
              requestProvider.isNew = false;
            },
          ),
          _JobCard(
            title: "Solicitudes en curso",
            onTap: () {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => JobRequestListPage(
                      myRequest: false,
                      title: "Solicitudes en curso",
                      searchFunction: () async {
                        return await JobRequestService().searchOngoing(sessionProvider.session.jwt);
                      }),
                ),
              );
              // Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => MyOngoingJobRequestListPage()));
            },
          ),
          _JobCard(
            title: "Historial de solicitudes",
            onTap: () {
              showInfoSnackbar(context, "En construccion");
            },
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String title;
  final Function onTap;

  const _JobCard({this.title, this.onTap});

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
        trailing: Container(
          height: double.infinity,
          child: Icon(
            Icons.chevron_right,
            size: 40.0,
            color: appTheme.primaryColor,
          ),
        ),
        title: Text(this.title, textScaleFactor: 1.3, style: appTheme.textTheme.bodyText2.copyWith()),
        contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.03),
        onTap: this.onTap,
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
    return PlainTitleHeader(title: 'Solicitudes');
  }
}
