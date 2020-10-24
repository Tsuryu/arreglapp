import 'package:arreglapp/src/models/operation_type.dart';
import 'package:arreglapp/src/pages/create_request/job_request_details_page.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/operation_type_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';

class JobRequestTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);

    return Scaffold(
      body: ExternalBackground(
        withBorderImage: false,
        child: FutureBuilder<List<OperationType>>(
          future: OperationTypeService().getAll(sessionProvider.session.jwt),
          builder: (BuildContext context, AsyncSnapshot<List<OperationType>> snapshot) {
            if (snapshot.hasData && !snapshot.hasError && snapshot.data.length > 0) {
              requestProvider.title = snapshot.data[0].name;
              return _LocalSwiper(types: snapshot.data, itemCount: snapshot.data.length);
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }
}

class _LocalSwiper extends StatelessWidget {
  final List<OperationType> types;
  final int itemCount;

  const _LocalSwiper({@required this.types, @required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context);
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.1),
          child: Swiper(
            onIndexChanged: (index) {
              requestProvider.title = types[index].name;
            },
            itemCount: this.itemCount,
            // layout: SwiperLayout.STACK,
            // itemWidth: size.width * 0.8,
            // itemHeight: size.height,
            viewportFraction: 0.8,
            scale: 0.9,
            itemBuilder: (BuildContext context, int index) {
              final isEven = index % 2 == 0;
              final operationType = types[index];
              return _LocalCard(operationType: operationType, isEven: isEven, appTheme: appTheme);
            },
          ),
        ),
        Positioned(
          bottom: size.height * 0.02,
          right: size.width * 0.03,
          child: CommonButton(
            mainButton: false,
            withBorder: false,
            text: 'Siguiente',
            onPressed: () {
              FocusManager.instance.primaryFocus.unfocus();
              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => JobRequestDetailsPage()));
            },
          ),
        ),
      ],
    );
  }
}

class _LocalCard extends StatelessWidget {
  const _LocalCard({
    @required this.operationType,
    @required this.isEven,
    @required this.appTheme,
  });

  final OperationType operationType;
  final bool isEven;
  final ThemeChanger appTheme;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SlimyCard(
      slimeEnabled: true,
      topCardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            operationType.iconCode == null ? Icons.contact_support : IconData(operationType.iconCode, fontFamily: operationType.iconFamily),
            color: isEven ? appTheme.currentTheme.backgroundColor : appTheme.currentTheme.accentColor,
            size: size.height * 0.1,
          ),
          Text(
            operationType.name,
            style: TextStyle(
              fontSize: size.height * 0.05,
              color: isEven ? appTheme.currentTheme.backgroundColor : appTheme.currentTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      color: isEven ? appTheme.currentTheme.accentColor : appTheme.currentTheme.backgroundColor,
      topCardHeight: size.height * 0.3,
      bottomCardHeight: size.height * 0.4,
      bottomCardWidget: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.02),
          child: Text(
            operationType.description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20.0, color: isEven ? appTheme.currentTheme.backgroundColor : appTheme.currentTheme.accentColor),
            maxLines: 10,
          ),
        ),
      ),
    );
  }
}
