import 'package:arreglapp/src/models/job_request.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/my_requests/job_request_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/flight_shuttle_builder.dart';
import 'package:arreglapp/src/widgets/loading.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobRequestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              JobList(),
              // ItemList(),
            ];
          },
        ),
      ),
    );
  }
}

class JobList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return FutureBuilder(
      future: JobRequestService().listBy(sessionProvider.userProfile.username, sessionProvider.session.jwt),
      builder: (BuildContext context, AsyncSnapshot<List<JobRequest>> snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data.length > 0) {
          return _List(jobList: snapshot.data, itemCount: snapshot.data.length);
        } else {
          return Loading();
        }
      },
    );
  }
}

class _List extends StatelessWidget {
  final List<JobRequest> jobList;
  final int itemCount;

  const _List({this.jobList, this.itemCount});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    return Flex(
      direction: Axis.vertical,
      children: List.generate(
        itemCount,
        (index) => Hero(
          flightShuttleBuilder: flightShuttleBuilder,
          tag: "request_item$index",
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.01),
            decoration: BoxDecoration(
              color: appTheme.accentColor.withOpacity(0.75),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: ListTile(
              leading: Container(
                height: double.infinity,
                child: Icon(
                  IconData(jobList[index].operationType.iconCode, fontFamily: jobList[index].operationType.iconFamily),
                  size: 40.0,
                  color: appTheme.primaryColor,
                ),
              ),
              trailing: Container(
                height: double.infinity,
                child: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                  color: appTheme.primaryColor,
                ),
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "(Pendiente) ", style: appTheme.textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(text: jobList[index].title, style: appTheme.textTheme.bodyText2),
                  ],
                ),
              ),
              subtitle: Text(jobList[index].description),
              contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.03),
              onTap: () async {
                final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                requestProvider.jobRequest = jobList[index];
                await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => JobRequestPage(index: index)));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                side: BorderSide(color: appTheme.primaryColor),
              ),
            ),
          ),
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
