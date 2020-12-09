import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/requests/job_request_list_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/widgets/common_card.dart';
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
          CommonCard(
            title: "Buscar solicitudes",
            onTap: () async {
              final requestProvider = Provider.of<RequestProvider>(context, listen: false);
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              requestProvider.isNew = true;
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => JobRequestListPage(
                    isSearchNewRequests: true,
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
          CommonCard(
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
                    },
                  ),
                ),
              );
              // Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => MyOngoingJobRequestListPage()));
            },
          ),
          CommonCard(
            title: "Historial de solicitudes",
            onTap: () async {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => JobRequestListPage(
                    myRequest: false,
                    title: "Historial de solicitudes",
                    searchFunction: () async {
                      return await JobRequestService().getHistory(sessionProvider.session.jwt);
                    },
                  ),
                ),
              );
            },
          ),
        ],
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
