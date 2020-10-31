import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:arreglapp/src/widgets/text_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';

class JobRequestPage extends StatelessWidget {
  final int index;
  const JobRequestPage({@required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: Hero(tag: "request_item$index", child: _Header()),
          getChildren: () {
            return <Widget>[
              _GeneralInfo(),
              _Chats(),
            ];
          },
        ),
      ),
    );
  }
}

class _Chats extends StatelessWidget {
  final List<UserProfile> userProfiles = [
    UserProfile(firstName: "Elida", lastName: "Torres", phone: "1153891653"),
    UserProfile(firstName: "Sebastian", lastName: "Seballos", phone: "1165613345"),
    UserProfile(firstName: "Carina", lastName: "Farias", phone: "1161132370"),
    UserProfile(firstName: "Nelson", lastName: "Tavella", phone: "1138712046"),
  ];

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return BasicCard(
      title: 'Conversaciones',
      child: Flex(
        direction: Axis.vertical,
        children: List.generate(
          userProfiles.length,
          (index) => Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  userProfiles[index].firstName + " " + userProfiles[index].lastName,
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
                    IconButton(
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.center,
                      onPressed: () {},
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 40.0,
                        color: appTheme.primaryColor,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.check_circle_outline,
                        size: 40.0,
                        color: appTheme.primaryColor,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        print(userProfiles[index].phone);
                        FlutterOpenWhatsapp.sendSingleMessage("549" + userProfiles[index].phone, "");
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
  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return PlainTitleHeader(
      title: "Mis solicitudes",
      // subtitle: requestProvider.jobRequest.title,
    );
  }
}
