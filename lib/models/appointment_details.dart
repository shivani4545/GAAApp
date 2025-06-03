// To parse this JSON data, do
//
//     final appointmentDetails = appointmentDetailsFromJson(jsonString);

import 'dart:convert';

AppointmentDetails appointmentDetailsFromJson(String str) => AppointmentDetails.fromJson(json.decode(str));

String appointmentDetailsToJson(AppointmentDetails data) => json.encode(data.toJson());

class AppointmentDetails {
  PersonalInfo? personalInfo;
  PropertyInfo? propertyInfo;
  LocationInfo? locationInfo;
  MoreDetails? moreDetails;
  AdditionalDetails? additionalDetails;
  RoomDetails? roomDetails;
  List<dynamic>? images;

  AppointmentDetails({
    this.personalInfo,
    this.propertyInfo,
    this.locationInfo,
    this.moreDetails,
    this.additionalDetails,
    this.roomDetails,
    this.images,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) => AppointmentDetails(
    personalInfo: json["personalInfo"] == null ? null : PersonalInfo.fromJson(json["personalInfo"]),
    propertyInfo: json["propertyInfo"] == null ? null : PropertyInfo.fromJson(json["propertyInfo"]),
    locationInfo: json["locationInfo"] == null ? null : LocationInfo.fromJson(json["locationInfo"]),
    moreDetails: json["moreDetails"] == null ? null : MoreDetails.fromJson(json["moreDetails"]),
    additionalDetails: json["additionalDetails"] == null ? null : AdditionalDetails.fromJson(json["additionalDetails"]),
    roomDetails: json["roomDetails"] == null ? null : RoomDetails.fromJson(json["roomDetails"]),
    images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "personalInfo": personalInfo?.toJson(),
    "propertyInfo": propertyInfo?.toJson(),
    "locationInfo": locationInfo?.toJson(),
    "moreDetails": moreDetails?.toJson(),
    "additionalDetails": additionalDetails?.toJson(),
    "roomDetails": roomDetails?.toJson(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}

class AdditionalDetails {
  String? applicableRate;
  String? twoPropertyDealersName1;
  String? twoPropertyDealersContact1;
  String? twoPropertyDealersName2;
  String? twoPropertyDealersContact2;
  String? setBacksFront;
  String? setBacksRear;
  String? setBacksSide1;
  String? setBacksSide2;
  String? levelOfDevelopment;
  int? housesInVicinity;

  AdditionalDetails({
    this.applicableRate,
    this.twoPropertyDealersName1,
    this.twoPropertyDealersContact1,
    this.twoPropertyDealersName2,
    this.twoPropertyDealersContact2,
    this.setBacksFront,
    this.setBacksRear,
    this.setBacksSide1,
    this.setBacksSide2,
    this.levelOfDevelopment,
    this.housesInVicinity,
  });

  factory AdditionalDetails.fromJson(Map<String, dynamic> json) => AdditionalDetails(
    applicableRate: json["applicableRate"],
    twoPropertyDealersName1: json["twoPropertyDealersName1"],
    twoPropertyDealersContact1: json["twoPropertyDealersContact1"],
    twoPropertyDealersName2: json["twoPropertyDealersName2"],
    twoPropertyDealersContact2: json["twoPropertyDealersContact2"],
    setBacksFront: json["setBacksFront"],
    setBacksRear: json["setBacksRear"],
    setBacksSide1: json["setBacksSide1"],
    setBacksSide2: json["setBacksSide2"],
    levelOfDevelopment: json["levelOfDevelopment"],
    housesInVicinity: json["housesInVicinity"],
  );

  Map<String, dynamic> toJson() => {
    "applicableRate": applicableRate,
    "twoPropertyDealersName1": twoPropertyDealersName1,
    "twoPropertyDealersContact1": twoPropertyDealersContact1,
    "twoPropertyDealersName2": twoPropertyDealersName2,
    "twoPropertyDealersContact2": twoPropertyDealersContact2,
    "setBacksFront": setBacksFront,
    "setBacksRear": setBacksRear,
    "setBacksSide1": setBacksSide1,
    "setBacksSide2": setBacksSide2,
    "levelOfDevelopment": levelOfDevelopment,
    "housesInVicinity": housesInVicinity,
  };
}

class LocationInfo {
  String? occupationStatus;
  String? propertyUsage;
  String? locationOfProperty;
  String? howItsCoveredNorth;
  String? howItsCoveredSouth;
  String? howItsCoveredEast;
  String? howItsCoveredWest;

  LocationInfo({
    this.occupationStatus,
    this.propertyUsage,
    this.locationOfProperty,
    this.howItsCoveredNorth,
    this.howItsCoveredSouth,
    this.howItsCoveredEast,
    this.howItsCoveredWest,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
    occupationStatus: json["occupationStatus"],
    propertyUsage: json["propertyUsage"],
    locationOfProperty: json["locationOfProperty"],
    howItsCoveredNorth: json["howItsCoveredNorth"],
    howItsCoveredSouth: json["howItsCoveredSouth"],
    howItsCoveredEast: json["howItsCoveredEast"],
    howItsCoveredWest: json["howItsCoveredWest"],
  );

  Map<String, dynamic> toJson() => {
    "occupationStatus": occupationStatus,
    "propertyUsage": propertyUsage,
    "locationOfProperty": locationOfProperty,
    "howItsCoveredNorth": howItsCoveredNorth,
    "howItsCoveredSouth": howItsCoveredSouth,
    "howItsCoveredEast": howItsCoveredEast,
    "howItsCoveredWest": howItsCoveredWest,
  };
}

class MoreDetails {
  dynamic underSanctionPlan;
  dynamic accToSanctionPlan;
  dynamic areaOfPlot;
  dynamic numberOfFloors;
  dynamic floorOfFlat;
  dynamic yearOfConstruction;
  dynamic personContacted;
  dynamic rentalRange;
  dynamic marketRate;
  dynamic rentedArea;
  dynamic commercialArea;
  dynamic overHeadTank;
  dynamic pump;
  dynamic moreDetailsExternal;
  dynamic internal;
  dynamic flooring;
  dynamic woodWork;
  dynamic fittings;
  dynamic landmark;
  dynamic gpsCoordinates;

  MoreDetails({
    this.underSanctionPlan,
    this.accToSanctionPlan,
    this.areaOfPlot,
    this.numberOfFloors,
    this.floorOfFlat,
    this.yearOfConstruction,
    this.personContacted,
    this.rentalRange,
    this.marketRate,
    this.rentedArea,
    this.commercialArea,
    this.overHeadTank,
    this.pump,
    this.moreDetailsExternal,
    this.internal,
    this.flooring,
    this.woodWork,
    this.fittings,
    this.landmark,
    this.gpsCoordinates,
  });

  factory MoreDetails.fromJson(Map<String, dynamic> json) => MoreDetails(
    underSanctionPlan: json["underSanctionPlan"],
    accToSanctionPlan: json["accToSanctionPlan"],
    areaOfPlot: json["areaOfPlot"],
    numberOfFloors: json["numberOfFloors"],
    floorOfFlat: json["floorOfFlat"],
    yearOfConstruction: json["yearOfConstruction"],
    personContacted: json["personContacted"],
    rentalRange: json["rentalRange"],
    marketRate: json["marketRate"],
    rentedArea: json["rentedArea"],
    commercialArea: json["commercialArea"],
    overHeadTank: json["overHeadTank"],
    pump: json["pump"],
    moreDetailsExternal: json["external"],
    internal: json["internal"],
    flooring: json["flooring"],
    woodWork: json["woodWork"],
    fittings: json["fittings"],
    landmark: json["landmark"],
    gpsCoordinates: json["gpsCoordinates"],
  );

  Map<String, dynamic> toJson() => {
    "underSanctionPlan": underSanctionPlan,
    "accToSanctionPlan": accToSanctionPlan,
    "areaOfPlot": areaOfPlot,
    "numberOfFloors": numberOfFloors,
    "floorOfFlat": floorOfFlat,
    "yearOfConstruction": yearOfConstruction,
    "personContacted": personContacted,
    "rentalRange": rentalRange,
    "marketRate": marketRate,
    "rentedArea": rentedArea,
    "commercialArea": commercialArea,
    "overHeadTank": overHeadTank,
    "pump": pump,
    "external": moreDetailsExternal,
    "internal": internal,
    "flooring": flooring,
    "woodWork": woodWork,
    "fittings": fittings,
    "landmark": landmark,
    "gpsCoordinates": gpsCoordinates,
  };
}

class PersonalInfo {
  int? caseId;
  String? clientName;
  String? propertyAddress;
  DateTime? inspectionDate;
  String? typeOfLocality;
  String? zone;
  String? typeOfColony;
  int? hasPhotoWithOwner;
  String? imageReason;
  String? ownerImage;
  String? imagePath;

  PersonalInfo({
    this.caseId,
    this.clientName,
    this.propertyAddress,
    this.inspectionDate,
    this.typeOfLocality,
    this.zone,
    this.typeOfColony,
    this.hasPhotoWithOwner,
    this.imageReason,
    this.ownerImage,
    this.imagePath,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    caseId: json["case_id"],
    clientName: json["clientName"],
    propertyAddress: json["propertyAddress"],
    inspectionDate: json["inspectionDate"] == null ? null : DateTime.parse(json["inspectionDate"]),
    typeOfLocality: json["typeOfLocality"],
    zone: json["zone"],
    typeOfColony: json["typeOfColony"],
    hasPhotoWithOwner: json["hasPhotoWithOwner"],
    imageReason: json["image_reason"],
    ownerImage: json["owner_image"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "case_id": caseId,
    "clientName": clientName,
    "propertyAddress": propertyAddress,
    "inspectionDate": inspectionDate?.toIso8601String(),
    "typeOfLocality": typeOfLocality,
    "zone": zone,
    "typeOfColony": typeOfColony,
    "hasPhotoWithOwner": hasPhotoWithOwner,
    "image_reason": imageReason,
    "owner_image": ownerImage,
    "image_path": imagePath,
  };
}

class PropertyInfo {
  String? typeOfOwnership;
  String? typeOfProperty;
  String? neighborhoodClassification;

  PropertyInfo({
    this.typeOfOwnership,
    this.typeOfProperty,
    this.neighborhoodClassification,
  });

  factory PropertyInfo.fromJson(Map<String, dynamic> json) => PropertyInfo(
    typeOfOwnership: json["typeOfOwnership"],
    typeOfProperty: json["typeOfProperty"],
    neighborhoodClassification: json["neighborhoodClassification"],
  );

  Map<String, dynamic> toJson() => {
    "typeOfOwnership": typeOfOwnership,
    "typeOfProperty": typeOfProperty,
    "neighborhoodClassification": neighborhoodClassification,
  };
}

class RoomDetails {
  List<Room>? rooms;

  RoomDetails({
    this.rooms,
  });

  factory RoomDetails.fromJson(Map<String, dynamic> json) => RoomDetails(
    rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
  };
}

class Room {
  String? roomType;
  String? length;
  String? width;
  String? unit;

  Room({
    this.roomType,
    this.length,
    this.width,
    this.unit,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    roomType: json["roomType"],
    length: json["length"],
    width: json["width"],
    unit: json["unit"],
  );

  Map<String, dynamic> toJson() => {
    "roomType": roomType,
    "length": length,
    "width": width,
    "unit": unit,
  };
}
