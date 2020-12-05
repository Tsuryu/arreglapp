import 'package:arreglapp/src/helpers/job_request_util.dart';
import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/job_request.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/requests/job_request_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/types/common-type.dart';
import 'package:arreglapp/src/widgets/loading.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobRequestListPage extends StatelessWidget {
  final FutureListGenerator searchFunction;
  final String title;
  final bool myRequest;
  final bool isSearchNewRequests;

  const JobRequestListPage({@required this.searchFunction, @required this.title, @required this.myRequest, this.isSearchNewRequests = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(title: this.title),
          getChildren: () {
            return <Widget>[
              JobList(searchFunction: searchFunction, myRequest: myRequest, title: title, isSearchNewRequests: this.isSearchNewRequests),
            ];
          },
        ),
      ),
    );
  }
}

class JobList extends StatefulWidget {
  final bool isSearchNewRequests;
  final FutureListGenerator searchFunction;
  final bool myRequest;
  final String title;

  const JobList({this.searchFunction, this.myRequest, this.title, this.isSearchNewRequests});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  Future<List<JobRequest>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.delayed(Duration(milliseconds: 50), widget.searchFunction);
  }

  _runFuture() {
    setState(() {
      _future = Future.delayed(Duration(milliseconds: 50), widget.searchFunction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<JobRequest>> snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Loading();
        }

        if (snapshot.data.length == 0) {
          return Container();
        } else {
          return _List(
            jobList: snapshot.data,
            itemCount: snapshot.data.length,
            myRequest: widget.myRequest,
            updateFunction: _runFuture,
            title: widget.title,
            isSearchNewRequests: widget.isSearchNewRequests,
          );
        }
      },
    );
  }
}

class _List extends StatelessWidget {
  final bool isSearchNewRequests;
  final List<JobRequest> jobList;
  final int itemCount;
  final bool myRequest;
  final Function updateFunction;
  final String title;

  const _List({this.jobList, this.itemCount, this.myRequest, this.updateFunction, this.title, this.isSearchNewRequests});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    return Flex(
      direction: Axis.vertical,
      children: List.generate(
        itemCount,
        // (index) => Hero(
        (index) => Container(
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
                  TextSpan(
                      text: "(${JobRequestUtil().getJobRequestStatus(this.myRequest, jobList[index], isSearchNewRequests: this.isSearchNewRequests)}) ",
                      style: appTheme.textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(text: jobList[index].title, style: appTheme.textTheme.bodyText2),
                ],
              ),
            ),
            subtitle: Text(jobList[index].description),
            contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.03),
            onTap: () async {
              requestProvider.jobRequest = jobList[index];
              var result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => JobRequestPage(
                    index: index,
                    myRequest: this.myRequest,
                    title: title,
                    isSearchNewRequests: this.isSearchNewRequests,
                  ),
                ),
              );
              if (result != null) {
                showSuccessSnackbar(context, result);
              }
              updateFunction();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              side: BorderSide(color: appTheme.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({this.title});

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: this.title);
  }
}
