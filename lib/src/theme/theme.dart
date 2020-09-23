import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _darkTheme = false;
  bool _customTheme = false;

  ThemeData _currentTheme;

  bool get darkTheme => this._darkTheme;
  bool get customTheme => this._customTheme;
  ThemeData get currentTheme => this._currentTheme;

  Color _cream = Color(0xffe5dee5);
  Color _grey = Color(0xff816c6e);
  Color _lightBrown = Color(0xff98716a);
  Color _brown = Color(0xff7c3b30);
  Color _darkBrown = Color(0xff31130e);

  ThemeChanger(int theme) {
    switch (theme) {
      case 1: // light
        _darkTheme = false;
        _customTheme = false;
        _currentTheme = ThemeData.light().copyWith(
          accentColor: Colors.pink,
        );
        break;
      case 2: // light
        _darkTheme = true;
        _customTheme = false;
        _currentTheme = ThemeData.dark().copyWith(
          primaryColor: _lightBrown,
          // canvasColor: _lightBrown,
          toggleableActiveColor: _lightBrown,
          cursorColor: _lightBrown,
          textSelectionHandleColor: _lightBrown,
          iconTheme: IconThemeData(
            color: Colors.blueGrey[300],
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: _cream),
            bodyText2: TextStyle(color: _lightBrown),
            button: TextStyle(color: _lightBrown),
            headline1: TextStyle(color: _lightBrown),
            headline2: TextStyle(color: _lightBrown),
            headline3: TextStyle(color: _lightBrown),
            headline4: TextStyle(color: _lightBrown),
            headline5: TextStyle(color: _lightBrown),
            headline6: TextStyle(color: _lightBrown),
            // tile subtitle
            caption: TextStyle(color: _lightBrown),
            overline: TextStyle(color: _lightBrown),
            // tile title
            subtitle1: TextStyle(color: _lightBrown),
          ),
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
              color: Colors.blueGrey[300],
            ),
            contentTextStyle: TextStyle(
              color: Colors.blueGrey[300],
            ),
          ),
          accentColor: _cream,
          backgroundColor: _lightBrown,
          scaffoldBackgroundColor: _brown,
          cardColor: _grey,
          buttonTheme: ButtonThemeData(
            buttonColor: _brown,
          ),
        );
        break;
      case 3: // light
        _darkTheme = false;
        _customTheme = true;
        break;
      default:
        _darkTheme = false;
        _customTheme = false;
        _currentTheme = ThemeData.light();
    }
  }

  set darkTheme(bool value) {
    this._customTheme = false;
    this._darkTheme = value;
    if (value) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light().copyWith(
        accentColor: Colors.pink,
      );
    }
    notifyListeners();
  }

  set customTheme(bool value) {
    this._customTheme = value;
    this._darkTheme = false;
    if (value) {
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Color(0xff48A0EB),
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Color(0xff16202B),
        textTheme: TextTheme(
            // bodyText1: TextStyle(color: Colors.white),
            ),
        // appTheme.textTheme.bodyText1.color: Colors.white,
      );
    } else {
      _currentTheme = ThemeData.light();
    }
    notifyListeners();
  }
}
