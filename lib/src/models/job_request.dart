// To parse this JSON data, do
//
//     final jobRequest = jobRequestFromJson(jsonString);

import 'dart:convert';

import 'operation_type.dart';

List<JobRequest> jobRequestFromJson(String str) => List<JobRequest>.from(json.decode(str).map((x) => JobRequest.fromJson(x)));

String jobRequestToJson(List<JobRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobRequest {
  JobRequest({
    this.id,
    this.username,
    this.type,
    this.title,
    this.description,
    this.location,
    this.operationType,
  });

  String id;
  String username;
  String type;
  String title;
  String description;
  Location location;
  OperationType operationType;

  factory JobRequest.fromJson(Map<String, dynamic> json) => JobRequest(
        id: json["id"],
        username: json["username"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        location: Location.fromJson(json["location"]),
        operationType: OperationType.fromJson(json["operation_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "type": type,
        "title": title,
        "description": description,
        "location": location != null ? location.toJson() : null,
        "operation_type": operationType != null ? operationType.toJson() : null,
      };
}

class Location {
  Location({
    this.longitude,
    this.latitude,
  });

  double longitude;
  double latitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}
