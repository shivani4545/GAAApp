class InspectionFormData {
  String? clientName;
  String? propertyAddress;
  DateTime? inspectionDate;
  String? hasPhotoWithOwner;
  String? zone;
  String? typeOfLocality;
  String? typeOfColony;
  String? typeOfOwnership;
  String? typeOfProperty;
  String? neighborhoodClassification;
  String? occupationStatus;
  String? propertyUsage;
  String? locationOfProperty;
  String? howItsCoveredNorth;
  String? howItsCoveredSouth;
  String? howItsCoveredEast;
  String? howItsCoveredWest;
  String? underSanctionPlan;
  String? accToSanctionPlan;
  String? areaOfPlot;
  String? numberOfFloors;
  String? floorOfFlat;
  String? yearOfConstruction;
  String? external;
  String? internal;
  String? flooring;
  String? woodWork;
  String? fittings;
  String? personContacted;
  String? rentalRange;
  String? marketRate;
  String? rentedArea;
  String? commercialArea;
  String? overHeadTank;
  String? pump;
  String? gpsCoordinates;
  String? landmark;
  String? basementAccomodation;
  String? basementActual;
  String? basementPermissible;
  String? mezzAccomodation;
  String? mezzActual;
  String? mezzPermissible;
  String? gfAccomodation;
  String? gfActual;
  String? gfPermissible;
  String? ffAccomodation;
  String? ffActual;
  String? ffPermissible;
  String? sfAccomodation;
  String? sfActual;
  String? sfPermissible;
  String? tfAccomodation;
  String? tfActual;
  String? tfPermissible;
  String? typeOfStructure;
  String? OwnerReason;
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
  String? housesInVicinity;
  String? appointment_id;
  String? ownerImagePath;

  InspectionFormData({
    this.clientName,
    this.propertyAddress,
    this.inspectionDate,
    this.hasPhotoWithOwner,
    this.zone,
    this.ownerImagePath,
    this.OwnerReason,
    this.typeOfLocality,
    this.typeOfColony,
    this.typeOfOwnership,
    this.typeOfProperty,
    this.neighborhoodClassification,
    this.occupationStatus, this.propertyUsage,
    this.locationOfProperty,
    this.howItsCoveredNorth,
    this.howItsCoveredSouth,
    this.howItsCoveredEast,
    this.howItsCoveredWest,
    this.underSanctionPlan,
    this.accToSanctionPlan,
    this.areaOfPlot,
    this.numberOfFloors,
    this.floorOfFlat,
    this.yearOfConstruction,
    this.external,
    this.internal,
    this.flooring,
    this.woodWork,
    this.fittings,
    this.personContacted,
    this.rentalRange,
    this.marketRate,
    this.rentedArea,
    this.commercialArea,
    this.overHeadTank,
    this.pump,
    this.gpsCoordinates,
    this.landmark,
    this.basementAccomodation,
    this.basementActual,
    this.basementPermissible,
    this.mezzAccomodation,
    this.mezzActual,
    this.mezzPermissible,
    this.gfAccomodation,
    this.gfActual,
    this.gfPermissible,
    this.ffAccomodation,
    this.ffActual,
    this.ffPermissible,
    this.sfAccomodation,
    this.sfActual,
    this.sfPermissible,
    this.tfAccomodation,
    this.tfActual,
    this.tfPermissible,
    this.typeOfStructure,
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
    this.appointment_id,
  });


  //toJson method to convert InspectionFormData to JSON
  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'propertyAddress': propertyAddress,
      'inspectionDate': inspectionDate?.toIso8601String(),
      'hasPhotoWithOwner': hasPhotoWithOwner,
      'zone': zone,
      'typeOfLocality': typeOfLocality,
      'typeOfColony': typeOfColony,
      'typeOfOwnership': typeOfOwnership,
      'typeOfProperty': typeOfProperty,
      'neighborhoodClassification': neighborhoodClassification,
      'occupationStatus': occupationStatus,
      'propertyUsage': propertyUsage,
      'locationOfProperty': locationOfProperty,
      'howItsCoveredNorth': howItsCoveredNorth,
      'howItsCoveredSouth': howItsCoveredSouth,
      'howItsCoveredEast': howItsCoveredEast,
      'howItsCoveredWest': howItsCoveredWest,
      'underSanctionPlan': underSanctionPlan,
      'accToSanctionPlan': accToSanctionPlan,
      'areaOfPlot': areaOfPlot,
      'numberOfFloors': numberOfFloors,
      'floorOfFlat': floorOfFlat,
      'yearOfConstruction': yearOfConstruction,
      'external': external,
      'internal': internal,
      'flooring': flooring,
      'woodWork': woodWork,
      'fittings': fittings,
      'personContacted': personContacted,
      'rentalRange': rentalRange,
      'marketRate': marketRate,
      'rentedArea': rentedArea,
      'commercialArea': commercialArea,
      'overHeadTank': overHeadTank,
      'pump': pump,
      'gpsCoordinates': gpsCoordinates,
      'landmark': landmark,
      'basementAccomodation': basementAccomodation,
      'basementActual': basementActual,
      'basementPermissible': basementPermissible,
      'mezzAccomodation': mezzAccomodation,
      'mezzActual': mezzActual,
      'mezzPermissible': mezzPermissible,
      'gfAccomodation': gfAccomodation,
      'gfActual': gfActual,
      'gfPermissible': gfPermissible,
      'ffAccomodation': ffAccomodation,
      'ffActual': ffActual,
      'ffPermissible': ffPermissible,
      'sfAccomodation': sfAccomodation,
      'sfActual': sfActual,
      'sfPermissible': sfPermissible,
      'tfAccomodation': tfAccomodation,
      'tfActual': tfActual,
      'tfPermissible': tfPermissible,
      'typeOfStructure': typeOfStructure,
      'applicableRate': applicableRate,
      'twoPropertyDealersName1': twoPropertyDealersName1,
      'twoPropertyDealersContact1': twoPropertyDealersContact1,
      'twoPropertyDealersName2': twoPropertyDealersName2,
      'twoPropertyDealersContact2': twoPropertyDealersContact2,
      'setBacksFront': setBacksFront,
      'setBacksRear': setBacksRear,
      'setBacksSide1': setBacksSide1,
      'setBacksSide2': setBacksSide2,
      'levelOfDevelopment': levelOfDevelopment,
      'housesInVicinity': housesInVicinity,
    };
  }

// Add this method inside your _MyFormWidgetState class

// void _showImageSourceActionSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (
//         BuildContext buildContext) { // Use a different name for inner context
//       return SafeArea( // Ensures content is not obscured by notches etc.
//         child: Wrap( // Use Wrap to lay out children horizontally, then wrap to next line
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Capture Photo from Camera'),
//               onTap: () {
//                 Navigator.pop(buildContext); // Close the bottom sheet
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Select Photo from Gallery'),
//               onTap: () {
//                 Navigator.pop(buildContext); // Close the bottom sheet
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }


// void _clearOwnerImage() {
//   setState(() {
//     var ownerImageFile = null;
//     _formData.ownerImagePath = null;
//     _prefs?.remove(ownerImagePathKey);
//   });
//   widget.onFormDataChange(_formData);
// }

}