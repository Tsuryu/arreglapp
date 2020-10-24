// To parse this JSON data, do
//
//     final operationType = operationTypeFromJson(jsonString);

import 'dart:convert';

List<OperationType> operationTypeFromJson(String str) => List<OperationType>.from(json.decode(str).map((x) => OperationType.fromJson(x)));

String operationTypeToJson(List<OperationType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        id: json["ID"],
        name: json["Name"],
        description: json["Description"],
        active: json["Active"],
        iconCode: json["icon_code"] == null ? null : json["icon_code"],
        iconFamily: json["icon_family"] == null ? null : json["icon_family"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Description": description,
        "Active": active,
        "icon_code": iconCode == null ? null : iconCode,
        "icon_family": iconFamily == null ? null : iconFamily,
      };
}
