import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/providers/otp_provider.dart';
import 'package:arreglapp/src/providers/push_notifications_provider.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arreglapp/src/helpers/util.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeChanger(2)),
      ChangeNotifierProvider(create: (_) => SessionProvider()),
      ChangeNotifierProvider(create: (_) => OtpProvider()),
      ChangeNotifierProvider(create: (_) => RequestProvider()),
      ChangeNotifierProvider(create: (_) => PushNotificationsProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final pushProvider = Provider.of<PushNotificationsProvider>(context, listen: false);
    pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    changeStatusLight();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arreglapp',
      theme: appTheme.currentTheme,
      home: LoginPage(),
    );
  }
}
