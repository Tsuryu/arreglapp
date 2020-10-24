import 'package:flutter/material.dart';

class RequestProvider with ChangeNotifier {
  String _type;
  String _title;
  String _description;
  bool _locationAccepted = false;

  get type => this._type;
  get title => this._title;
  get description => this._description;
  get locationAccepted => this._locationAccepted;

  set type(String value) {
    this._type = value;
  }

  set title(String value) {
    this._title = value;
  }

  set description(String value) {
    this._description = value;
  }

  set locationAccepted(bool value) {
    this._locationAccepted = value;
    notifyListeners();
  }
}
