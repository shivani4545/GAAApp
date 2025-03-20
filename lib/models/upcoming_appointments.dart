import 'dart:convert';

List<UpcomingAppointments> upcomingAppointmentsFromJson(String str) =>
    List<UpcomingAppointments>.from(json.decode(str).map((x) => UpcomingAppointments.fromJson(x)));

String upcomingAppointmentsToJson(List<UpcomingAppointments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpcomingAppointments {
  String? clientName1;
  String? phone;
  String? addressLine1;
  String? addressLine2;
  int? id;
  String? propertyType;
  DateTime? dateOfAvailability;
  String? timeOfAvailability;

  UpcomingAppointments({
    this.clientName1,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.id,
    this.propertyType,
    this.dateOfAvailability,
    this.timeOfAvailability,
  });

  factory UpcomingAppointments.fromJson(Map<String, dynamic> json) => UpcomingAppointments(
    clientName1: json["client_name1"],
    phone: json["Phone"],
    addressLine1: json["Address_line1"],
    addressLine2: json["Address_line2"],
    id: json["id"],
    propertyType: json["property_type"],
    dateOfAvailability: json["date_of_availability"] == null
        ? null
        : DateTime.tryParse(json["date_of_availability"]), // Updated to tryParse
    timeOfAvailability: json["time_of_availability"],
  );

  Map<String, dynamic> toJson() => {
    "client_name1": clientName1,
    "Phone": phone,
    "Address_line1": addressLine1,
    "Address_line2": addressLine2,
    "id": id,
    "property_type": propertyType,
    "date_of_availability": dateOfAvailability != null
        ? "${dateOfAvailability!.year.toString().padLeft(4, '0')}-${dateOfAvailability!.month.toString().padLeft(2, '0')}-${dateOfAvailability!.day.toString().padLeft(2, '0')}"
        : null, // Handle null dates
    "time_of_availability": timeOfAvailability,
  };
}