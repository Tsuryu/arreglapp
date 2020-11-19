import 'package:arreglapp/src/models/job_request.dart';
import 'package:flutter/material.dart';

class RequestProvider with ChangeNotifier {
  String _type;
  String _title;
  String _description;
  bool _locationAccepted = false;
  JobRequest _jobRequest;
  bool _isNew = false;

  get type => this._type;
  get title => this._title;
  get description => this._description;
  get locationAccepted => this._locationAccepted;
  get jobRequest => this._jobRequest;
  get isNew => this._isNew;

  set isNew(bool value) {
    this._isNew = value;
  }

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

  set jobRequest(JobRequest value) {
    this._jobRequest = value;
  }
}
