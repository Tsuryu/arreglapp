// To parse this JSON data, do
//
//     final jobRequest = jobRequestFromJson(jsonString);

import 'dart:convert';

JobRequest jobRequestFromJson(String str) => JobRequest.fromJson(json.decode(str));

String jobRequestToJson(JobRequest data) => json.encode(data.toJson());

class JobRequest {
  JobRequest({
    this.username,
    this.type,
    this.title,
    this.description,
    this.location,
  });

  String username;
  String type;
  String title;
  String description;
  Location location;

  factory JobRequest.fromJson(Map<String, dynamic> json) => JobRequest(
        username: json["username"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "type": type,
        "title": title,
        "description": description,
        "location": location.toJson(),
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
