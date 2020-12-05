// To parse this JSON data, do
//
//     final pushNotification = pushNotificationFromJson(jsonString);

import 'dart:convert';

import 'package:arreglapp/src/models/job_request.dart';

PushNotification pushNotificationFromJson(String str) => PushNotification.fromJson(json.decode(str));

String pushNotificationToJson(PushNotification data) => json.encode(data.toJson());

class PushNotification {
  PushNotification({
    this.notification,
    this.data,
  });

  Notification notification;
  Data data;

  factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification(
        notification: Notification.fromJson(json["notification"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "notification": notification.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.jobRequest,
  });

  JobRequest jobRequest;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jobRequest: JobRequest.fromJson(json["job_request"]),
      );

  Map<String, dynamic> toJson() => {
        "jobRequest": jobRequest.toJson(),
      };
}

class Notification {
  Notification({
    this.title,
    this.body,
    this.clickAction,
  });

  String title;
  String body;
  String clickAction;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        title: json["title"],
        body: json["body"],
        clickAction: json["click_action"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "click_action": clickAction,
      };
}
