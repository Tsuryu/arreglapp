import 'package:flutter/material.dart';

class OtpProvider with ChangeNotifier {
  String _email;
  String _otp;
  String _traceId;

  String get email => this._email;
  String get otp => this._otp;
  String get traceId => this._traceId;

  set email(String value) {
    this._email = value;
  }

  set otp(String value) {
    this._otp = value;
  }

  set traceId(String value) {
    this._traceId = value;
  }
}
