import 'package:arreglapp/src/pages/requests/job_request_list_page.dart';
import 'package:arreglapp/src/pages/requests/presional_job_request_type_selection_page.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/widgets/grid_item.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../external_background.dart';

class RequestTypeSelectionPage extends StatelessWidget {
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
                  height: size.height * 0.7,
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: Axis.horizontal,
                    children: [
                      GridItem(
                        iconData: FontAwesomeIcons.user,
                        title: "Cliente",
                        onTap: () {
                          final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => JobRequestListPage(
                                  myRequest: true,
                                  title: "Mis Solicitudes",
                                  searchFunction: () async {
                                    return await JobRequestService().listBy(sessionProvider.userProfile.username, sessionProvider.session.jwt);
                                  }),
                            ),
                          );
                        },
                      ),
                      GridItem(
                        iconData: FontAwesomeIcons.userAlt,
                        title: "Profesional",
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ProfesionalJobRequestTypeSelectionPage()));
                        },
                      ),
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Solicitudes');
  }
}
