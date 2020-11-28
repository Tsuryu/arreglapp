import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/job_request.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/pages/budget_page.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:arreglapp/src/widgets/text_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class JobRequestPage extends StatelessWidget {
  final String traceID;
  final bool myRequest;
  final int index;
  final String title;
  final bool returnHome;

  const JobRequestPage({@required this.index, @required this.myRequest, this.traceID, this.title, this.returnHome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        popTo: returnHome ? HomePage() : null,
        child: SliderPageWrapper(
          // header: Hero(tag: "request_item$index", child: _Header()),
          header: _Header(title: this.title),
          getChildren: () {
            return <Widget>[
              _GeneralInfo(),
              _Chats(myRequest: myRequest, traceID: traceID),
              _BudgetButtom(myRequest: myRequest),
            ];
          },
        ),
      ),
    );
  }
}

class _Chats extends StatefulWidget {
  final bool myRequest;
  final String traceID;

  const _Chats({this.myRequest, this.traceID});

  @override
  __ChatsState createState() => __ChatsState();
}

class __ChatsState extends State<_Chats> with WidgetsBindingObserver {
  List<UserContactInfo> usersContactInfo = [];
  bool isProfessionalConfirmed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      Navigator.pop(context);
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      print("test");
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      print("test");
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    if (!widget.myRequest) {
      usersContactInfo.add(requestProvider.jobRequest.userContactInfo);
    } else {
      if (requestProvider.jobRequest.chats == null) {
        return Container();
      }

      for (UserContactInfo chat in requestProvider.jobRequest.chats) {
        if (chat.confirmed) {
          isProfessionalConfirmed = true;
        }
        usersContactInfo.add(chat);
      }
    }

    return BasicCard(
      title: 'Conversaciones',
      child: Flex(
        direction: Axis.vertical,
        children: List.generate(
          usersContactInfo.length,
          (index) => Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  usersContactInfo[index].firstname + " " + usersContactInfo[index].lastname,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Flexible(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.myRequest
                        ? IconButton(
                            padding: EdgeInsets.all(0),
                            alignment: Alignment.center,
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel_outlined,
                              size: 40.0,
                              color: appTheme.primaryColor,
                            ),
                          )
                        : Container(),
                    widget.myRequest
                        ? IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: isProfessionalConfirmed
                                ? null
                                : () async {
                                    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                                    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                                    final result = await JobRequestService().confirmProfessional(
                                      sessionProvider.session.jwt,
                                      requestProvider.jobRequest.id,
                                      usersContactInfo[index].username,
                                    );
                                    if (!result) {
                                      showErrorSnackbar(context, "No se pudo confirmar el proveedor");
                                      return;
                                    }

                                    Navigator.pop(context, "Profesional seleccionado OK");
                                  },
                            icon: Icon(
                              Icons.check_circle_outline,
                              size: 40.0,
                              color: isProfessionalConfirmed && !usersContactInfo[index].confirmed ? Colors.grey : appTheme.primaryColor,
                            ),
                          )
                        : Container(),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                        if (!widget.myRequest && requestProvider.isNew) {
                          final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                          final result = await JobRequestService().initChat(
                            sessionProvider.session.jwt,
                            requestProvider.jobRequest.id,
                            requestProvider.jobRequest.userContactInfo.username,
                          );
                          requestProvider.isNew = false;
                          if (!result) {
                            showErrorSnackbar(context, "No se pudo iniciar el chat");
                            return;
                          }
                        }
                        requestProvider.isNew = false;
                        FlutterOpenWhatsapp.sendSingleMessage("549" + usersContactInfo[index].phone, "");
                      },
                      icon: Icon(
                        Icons.message_outlined,
                        size: 40.0,
                        color: appTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetButtom extends StatelessWidget {
  final bool myRequest;

  const _BudgetButtom({@required this.myRequest});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.5, right: size.width * 0.04),
      child: CommonButton(
        disabled: !requestProvider.jobRequest.userContactInfo.confirmed && !myRequest,
        mainButton: false,
        withBorder: false,
        text: this.myRequest ? "Ver presupuesto" : "Presupuestar",
        onPressed: () async {
          if (requestProvider.jobRequest.budget != null && !myRequest) {
            return showInfoSnackbar(context, "Ya existe un presupuesto");
          }
          if (myRequest && requestProvider.jobRequest.budget == null) {
            return showInfoSnackbar(context, "Aun no se cargo un presupuesto");
          }
          final result = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => BudgetPage(myRequest: this.myRequest)));
          if (result != null) {
            showSuccessSnackbar(context, result);
          }
        },
      ),
    );
  }
}

class _GeneralInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return BasicCard(
      title: 'Datos de la solicitud',
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 1,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Icon(
                  IconData(requestProvider.jobRequest.operationType.iconCode, fontFamily: requestProvider.jobRequest.operationType.iconFamily),
                  size: size.height * 0.15,
                  color: appTheme.primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.05),
          Flexible(
            flex: 2,
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              direction: Axis.vertical,
              children: [
                TextLabel(label: "Titulo", text: requestProvider.jobRequest.title),
                TextLabel(label: "Estado", text: "Pendiente"),
                TextLabel(label: "Descripcion", text: requestProvider.jobRequest.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({this.title});

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: this.title != null ? this.title : "Solicitud");
  }
}
