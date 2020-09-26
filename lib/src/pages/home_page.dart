import 'package:arreglapp/src/providers/user_profile_provider.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              Column(
                children: [
                  Text("Hola ${sessionProvider.session.userProfile.username}"),
                  Text("JWT ${sessionProvider.session.jwt}"),
                ],
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
    return PlainTitleHeader(title: 'Arreglapp');
  }
}
