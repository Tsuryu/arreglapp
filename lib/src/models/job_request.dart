// To parse this JSON data, do
//
//     final jobRequest = jobRequestFromJson(jsonString);

import 'dart:convert';

List<JobRequest> jobRequestFromJson(String str) => List<JobRequest>.from(json.decode(str).map((x) => JobRequest.fromJson(x)));
List<UserContactInfo> chatsFromJson(String str) => List<UserContactInfo>.from(json.decode(str).map((x) => UserContactInfo.fromJson(x)));

String jobRequestToJson(List<JobRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String chatsToJson(List<UserContactInfo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobRequest {
  JobRequest({
    this.id,
    this.username,
    this.type,
    this.title,
    this.description,
    this.location,
    this.operationType,
    this.userContactInfo,
    this.chats,
    this.budget,
    this.payed,
    this.transactionFeePayed,
    this.canceled,
  });

  String id;
  String username;
  String type;
  String title;
  String description;
  Location location;
  OperationType operationType;
  UserContactInfo userContactInfo;
  List<UserContactInfo> chats;
  Budget budget;
  bool payed;
  bool transactionFeePayed;
  bool canceled;

  factory JobRequest.fromJson(Map<String, dynamic> json) => JobRequest(
        id: json["id"],
        username: json["username"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        location: Location.fromJson(json["location"]),
        operationType: OperationType.fromJson(json["operation_type"]),
        userContactInfo: UserContactInfo.fromJson(json["user_contact_info"]),
        chats: json["chats"] != null ? List<UserContactInfo>.from(json["chats"].map((x) => UserContactInfo.fromJson(x))) : null,
        budget: json["budget"] != null ? Budget.fromJson(json["budget"]) : null,
        payed: json["payed"],
        transactionFeePayed: json["transaction_fee_payed"],
        canceled: json["canceled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "type": type,
        "title": title,
        "description": description,
        "location": location != null ? location.toJson() : null,
        "operation_type": operationType != null ? operationType.toJson() : null,
        "user_contact_info": userContactInfo != null ? userContactInfo.toJson() : null,
        "chats": chats != null ? chatsToJson(chats) : null,
        "budget": budget != null ? budget.toJson() : null,
        "payed": payed,
        "transaction_fee_payed": transactionFeePayed,
        "canceled": canceled,
      };
}

class Budget {
  Budget({
    this.amount,
    this.date,
    this.username,
  });

  double amount;
  DateTime date;
  String username;

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        amount: json["Amount"].toDouble(),
        date: DateTime.parse(json["Date"]),
        username: json["Username"],
      );

  Map<String, dynamic> toJson() => {
        "Amount": amount,
        "Date": date.toIso8601String(),
        "Username": username,
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

class OperationType {
  OperationType({
    this.id,
    this.name,
    this.description,
    this.active,
    this.iconCode,
    this.iconFamily,
  });

  String id;
  String name;
  String description;
  bool active;
  int iconCode;
  String iconFamily;

  factory OperationType.fromJson(Map<String, dynamic> json) => OperationType(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        active: json["active"],
        iconCode: json["icon_code"],
        iconFamily: json["icon_family"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "active": active,
        "icon_code": iconCode,
        "icon_family": iconFamily,
      };
}

class UserContactInfo {
  UserContactInfo({
    this.firstname,
    this.lastname,
    this.phone,
    this.username,
    this.confirmed,
  });

  String firstname;
  String lastname;
  String phone;
  String username;
  bool confirmed;

  factory UserContactInfo.fromJson(Map<String, dynamic> json) => UserContactInfo(
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        username: json["username"],
        confirmed: json["confirmed"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "username": username,
        "confirmed": confirmed,
      };
}
