import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/providers/user_profile_provider.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:arreglapp/src/helpers/util.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeChanger(2)),
      ChangeNotifierProvider(create: (_) => UserProfileProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
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
