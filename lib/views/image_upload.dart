// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'package:geolocator/geolocator.dart';
//
// import '../utils/apis.dart';
//
// // Renamed class for clarity
// class FieldEngineerForm extends StatefulWidget {
//   final Map<String, dynamic>? appointmentData;
//   final InspectionFormData? initialFormData;
//   final Function(InspectionFormData) onFormSubmit;
//   final Function(InspectionFormData) onFormDataChange;
//   final int appointmentId;
//
//   const FieldEngineerForm({
//     super.key,
//     this.appointmentData,
//     this.initialFormData,
//     required this.onFormSubmit,
//     required this.onFormDataChange,
//     required this.appointmentId,
//   });
//
//   @override
//   State<FieldEngineerForm> createState() => _FieldEngineerFormState();
// }
//
// class _FieldEngineerFormState extends State<FieldEngineerForm> {
//   // Preference Keys
//   static const String clientNameKey = 'clientName';
//   static const String propertyAddressKey = 'propertyAddress';
//   static const String inspectionDateKey = 'inspectionDate';
//   static const String hasPhotoWithOwnerKey = 'hasPhotoWithOwner';
//   static const String zoneKey = 'zone';
//   static const String localityTypeKey = 'typeOfLocality';
//   static const String colonyTypeKey = 'typeOfColony';
//   static const String ownershipTypeKey = 'typeOfOwnership';
//   static const String propertyTypeKey = 'propertyType';
//   static const String neighborhoodClassKey = 'neighborhoodClassification';
//   static const String occupationStatusKey = 'occupationStatus';
//   static const String propertyUsageKey = 'propertyUsage';
//   static const String propertyLocationKey = 'locationOfProperty';
//   static const String howItsCoveredNorth = 'howItsCoveredNorth';
//   static const String howItsCoveredSouth = 'howItsCoveredSouth';
//   static const String howItsCoveredEast = 'howItsCoveredEast';
//   static const String howItsCoveredWest = 'howItsCoveredWest';
//   static const String underSanctionPlan = 'underSanctionPlan';
//   static const String accToSanctionPlan = 'accToSanctionPlan';
//   static const String areaOfPlot = 'areaOfPlot';
//   static const String numberOfFloors = 'numberOfFloors';
//   static const String floorOfFlat = 'floorOfFlat';
//   static const String yearOfConstruction = 'yearOfConstruction';
//   static const String external = 'external';
//   static const String internal = 'internal';
//   static const String flooring = 'flooring';
//   static const String woodWork = 'woodWork';
//   static const String fittings = 'fittings';
//   static const String contactedPersonKey = 'contactedPersonKey';
//   static const String rentalRangeKey = 'rentalRange';
//   static const String landMarketRateKey = 'marketRate';
//   static const String rentedAreaKey = 'rentedArea';
//   static const String commercialAreaKey = 'commercialArea';
//   static const String overheadTankDetailsKey = 'overheadTank';
//   static const String pumpDetailsKey = 'pumpDetails';
//   static const String gpsCoordinatesKey = 'gpsCoordinates';
//   static const String landmarkKey = 'landmark';
//   static const String basementAccomodation = 'basementAccomodation';
//   static const String basementActual = 'basementActual';
//   static const String basementPermissible = 'basementPermissible';
//   static const String mezzAccomodation = 'mezzAccomodation';
//   static const String mezzActual = 'mezzActual';
//   static const String mezzPermissible = 'mezzPermissible';
//   static const String gfAccomodation = 'gfAccomodation';
//   static const String gfActual = 'gfActual';
//   static const String gfPermissible = 'gfPermissible';
//   static const String ffAccomodation = 'ffAccomodation';
//   static const String ffActual = 'ffActual';
//   static const String ffPermissible = 'ffPermissible';
//   static const String sfAccomodation = 'sfAccomodation';
//   static const String sfActual = 'sfActual';
//   static const String sfPermissible = 'sfPermissible';
//   static const String tfAccomodation = 'tfAccomodation';
//   static const String tfActual = 'tfActual';
//   static const String tfPermissible = 'tfPermissible';
//   static const String structureTypeKey = 'typeOfStructure';
//   static const String applicableRateKey = 'applicableRate';
//   static const String dealerNameKey = 'twoPropertyDealersName';
//   static const String dealerContactKey = 'twoPropertyDealersContact';
//   static const String setbacksFrontKey = 'setBacksFront';
//   static const String setbacksRearKey = 'setBacksRear';
//   static const String setbacksSide1Key = 'setBacksSide1';
//   static const String setbacksSide2Key = 'setBacksSide2';
//   static const String developmentLevelKey = 'levelOfDevelopment';
//   static const String housesVicinityKey = 'housesInVicinity';
//   static const String keyAccessToken = 'access_token';
//   static const String locationOfPropertyKey = 'locationOfProperty';
//   static const String keyFormID = "appointment_id";
//
//   final List<GlobalKey<FormState>> _formSteps = [
//     GlobalKey<FormState>(),
//     GlobalKey<FormState>(),
//     GlobalKey<FormState>(),
//     GlobalKey<FormState>(),
//     GlobalKey<FormState>(),
//   ];
//
//   int _currentStepIndex = 0;
//   InspectionFormData _formData = InspectionFormData();
//   SharedPreferences? _prefs;
//   String? _authToken;
//
//   // Controllers for floor information
//   final basementAccomodationController = TextEditingController();
//   final basementActualController = TextEditingController();
//   final basementPermissibleController = TextEditingController();
//   final mezzAccomodationController = TextEditingController();
//   final mezzActualController = TextEditingController();
//   final mezzPermissibleController = TextEditingController();
//   final gfAccomodationController = TextEditingController();
//   final gfActualController = TextEditingController();
//   final gfPermissibleController = TextEditingController();
//   final ffAccomodationController = TextEditingController();
//   final ffActualController = TextEditingController();
//   final ffPermissibleController = TextEditingController();
//   final sfAccomodationController = TextEditingController();
//   final sfActualController = TextEditingController();
//   final sfPermissibleController = TextEditingController();
//   final tfAccomodationController = TextEditingController();
//   final tfActualController = TextEditingController();
//   final tfPermissibleController = TextEditingController();
//   final gpsCoordinatesController = TextEditingController();
//   final ownerNameController = TextEditingController();
//   final propertyAddressController = TextEditingController();
//   final inspectionDateController = TextEditingController();
//   final applicableRateController = TextEditingController();
//   final twoPropertyDealersNameController = TextEditingController();
//   final twoPropertyDealersContactController = TextEditingController();
//   final setBacksFrontController = TextEditingController();
//   final setBacksRearController = TextEditingController();
//   final setBacksSide1Controller = TextEditingController();
//   final setBacksSide2Controller = TextEditingController();
//
//   List<String> _visibleFloors = [];
//   bool _showNumberOfFloors = true;
//   bool _showFloorAtWhichFlatSituated = true;
//   bool _showFloorwiseInformationTable = true;
//   String _floorLabel = "Floor at which flat situated";
//   String _floorHintText = "Enter Floor at which flat situated";
//   String? _levelOfDevelopment;
//   String _housesInVicinity = 'Yes';
//
//   @override
//   void initState() {
//     super.initState();
//     _housesInVicinity = 'Yes';
//     _initializeForm();
//   }
//
//   Future<void> _initializeForm() async {
//     _prefs = await SharedPreferences.getInstance();
//
//     _formData = widget.initialFormData ?? InspectionFormData();
//
//     // Load data from SharedPreferences (only on initial load)
//     _formData.clientName = _prefs!.getString(clientNameKey) ?? _formData.clientName;
//     _formData.propertyAddress = _prefs!.getString(propertyAddressKey) ?? _formData.propertyAddress;
//     _formData.applicableRate = _prefs!.getString(applicableRateKey) ?? _formData.applicableRate;
//     _formData.twoPropertyDealersName = _prefs!.getString(dealerNameKey) ?? _formData.twoPropertyDealersName;
//     _formData.twoPropertyDealersContact = _prefs!.getString(dealerContactKey) ?? _formData.twoPropertyDealersContact;
//     _formData.setBacksFront = _prefs!.getString(setbacksFrontKey) ?? _formData.setBacksFront;
//     _formData.setBacksRear = _prefs!.getString(setbacksRearKey) ?? _formData.setBacksRear;
//     _formData.setBacksSide1 = _prefs!.getString(setbacksSide1Key) ?? _formData.setBacksSide1;
//     _formData.setBacksSide2 = _prefs!.getString(setbacksSide2Key) ?? _formData.setBacksSide2;
//
//     String? housesInVicinity = _prefs!.getString(housesVicinityKey);
//     _housesInVicinity = housesInVicinity ?? 'Yes';
//     _formData.levelOfDevelopment = _prefs!.getString(developmentLevelKey) ?? _formData.levelOfDevelopment;
//
//     String? dateString = _prefs!.getString(inspectionDateKey);
//     if (dateString != null) {
//       _formData.inspectionDate = DateTime.tryParse(dateString) ?? _formData.inspectionDate;
//     }
//
//     // Populate form data from appointment data if available
//     if (widget.appointmentData != null) {
//       _formData = InspectionFormData(
//         clientName: widget.appointmentData!['clientName'] ?? _formData.clientName ?? '',
//         propertyAddress: widget.appointmentData!['propertyAddress'] ?? _formData.propertyAddress ?? '',
//         inspectionDate: widget.appointmentData!['inspectionDate'] != null
//             ? DateTime.tryParse(widget.appointmentData!['inspectionDate']) ?? _formData.inspectionDate
//             : _formData.inspectionDate,
//         hasPhotoWithOwner: widget.appointmentData!['hasPhotoWithOwner'] ?? _formData.hasPhotoWithOwner,
//         zone: widget.appointmentData!['zone'] ?? _formData.zone,
//         typeOfLocality: widget.appointmentData!['typeOfLocality'] ?? _formData.typeOfLocality,
//         typeOfColony: widget.appointmentData!['typeOfColony'] ?? _formData.typeOfColony,
//         typeOfOwnership: widget.appointmentData!['typeOfOwnership'] ?? _formData.typeOfOwnership,
//         typeOfProperty: widget.appointmentData!['typeOfProperty'] ?? _formData.typeOfProperty,
//         neighborhoodClassification: widget.appointmentData!['neighborhoodClassification'] ?? _formData.neighborhoodClassification,
//         occupationStatus: widget.appointmentData!['occupationStatus'] ?? _formData.occupationStatus,
//         propertyUsage: widget.appointmentData!['propertyUsage'] ?? _formData.propertyUsage,
//         locationOfProperty: widget.appointmentData!['locationOfProperty'] ?? _formData.locationOfProperty,
//         howItsCoveredNorth: widget.appointmentData!['howItsCoveredNorth'] ?? _formData.howItsCoveredNorth,
//         howItsCoveredSouth: widget.appointmentData!['howItsCoveredSouth'] ?? _formData.howItsCoveredSouth,
//         howItsCoveredEast: widget.appointmentData!['howItsCoveredEast'] ?? _formData.howItsCoveredEast,
//         howItsCoveredWest: widget.appointmentData!['howItsCoveredWest'] ?? _formData.howItsCoveredWest,
//         underSanctionPlan: widget.appointmentData!['underSanctionPlan'] ?? _formData.underSanctionPlan,
//         accToSanctionPlan: widget.appointmentData!['accToSanctionPlan'] ?? _formData.accToSanctionPlan,
//         areaOfPlot: widget.appointmentData!['areaOfPlot'] ?? _formData.areaOfPlot,
//         numberOfFloors: widget.appointmentData!['numberOfFloors'] ?? _formData.numberOfFloors,
//         floorOfFlat: widget.appointmentData!['floorOfFlat'] ?? _formData.floorOfFlat,
//         yearOfConstruction: widget.appointmentData!['yearOfConstruction'] ?? _formData.yearOfConstruction,
//         external: widget.appointmentData!['external'] ?? _formData.external,
//         internal: widget.appointmentData!['internal'] ?? _formData.internal,
//         flooring: widget.appointmentData!['flooring'] ?? _formData.flooring,
//         woodWork: widget.appointmentData!['woodWork'] ?? _formData.woodWork,
//         fittings: widget.appointmentData!['fittings'] ?? _formData.fittings,
//         contactedPersonKey: widget.appointmentData!['contactedPersonKey'] ?? _formData.contactedPersonKey,
//         rentalRange: widget.appointmentData!['rentalRange'] ?? _formData.rentalRange,
//         marketRate: widget.appointmentData!['marketRate'] ?? _formData.marketRate,
//         rentedArea: widget.appointmentData!['rentedArea'] ?? _formData.rentedArea,
//         commercialArea: widget.appointmentData!['commercialArea'] ?? _formData.commercialArea,
//         overHeadTank: widget.appointmentData!['overHeadTank'] ?? _formData.overHeadTank,
//         pump: widget.appointmentData!['pumpDetails'] ?? _formData.pump,
//         gpsCoordinates: widget.appointmentData!['gpsCoordinates'] ?? _formData.gpsCoordinates,
//         landmark: widget.appointmentData!['landmark'] ?? _formData.landmark,
//         basementAccomodation: widget.appointmentData!['basementAccomodation'] ?? _formData.basementAccomodation,
//         basementActual: widget.appointmentData!['basementActual'] ?? _formData.basementActual,
//         basementPermissible: widget.appointmentData!['basementPermissible'] ?? _formData.basementPermissible,
//         mezzAccomodation: widget.appointmentData!['mezzAccomodation'] ?? _formData.mezzAccomodation,
//         mezzActual: widget.appointmentData!['mezzActual'] ?? _formData.mezzActual,
//         mezzPermissible: widget.appointmentData!['mezzPermissible'] ?? _formData.mezzPermissible,
//         gfAccomodation: widget.appointmentData!['gfAccomodation'] ?? _formData.gfAccomodation,
//         gfActual: widget.appointmentData!['gfActual'] ?? _formData.gfActual,
//         gfPermissible: widget.appointmentData!['gfPermissible'] ?? _formData.gfPermissible,
//         ffAccomodation: widget.appointmentData!['ffAccomodation'] ?? _formData.ffAccomodation,
//         ffActual: widget.appointmentData!['ffActual'] ?? _formData.ffActual,
//         ffPermissible: widget.appointmentData!['ffPermissible'] ?? _formData.ffPermissible,
//         sfAccomodation: widget.appointmentData!['sfAccomodation'] ?? _formData.sfAccomodation,
//         sfActual: widget.appointmentData!['sfActual'] ?? _formData.sfActual,
//         sfPermissible: widget.appointmentData!['sfPermissible'] ?? _formData.sfPermissible,
//         tfAccomodation: widget.appointmentData!['tfAccomodation'] ?? _formData.tfAccomodation,
//         tfActual: widget.appointmentData!['tfActual'] ?? _formData.tfActual,
//         tfPermissible: widget.appointmentData!['tfPermissible'] ?? _formData.tfPermissible,
//         applicableRate: widget.appointmentData!['applicableRate'] ?? _formData.applicableRate,
//         twoPropertyDealersName: widget.appointmentData!['twoPropertyDealersName'] ?? _formData.twoPropertyDealersName,
//         twoPropertyDealersContact: widget.appointmentData!['twoPropertyDealersContact'] ?? _formData.twoPropertyDealersContact,
//         setBacksFront: widget.appointmentData!['setBacksFront'] ?? _formData.setBacksFront,
//         setBacksRear: widget.appointmentData!['setBacksRear'] ?? _formData.setBacksRear,
//         setBacksSide1: widget.appointmentData!['setBacksSide1'] ?? _formData.setBacksSide1,
//         setBacksSide2: widget.appointmentData!['setBacksSide2'] ?? _formData.setBacksSide2,
//         levelOfDevelopment: widget.appointmentData!['levelOfDevelopment'] ?? _formData.levelOfDevelopment,
//         housesInVicinity: widget.appointmentData!['housesInVicinity'] ?? _formData.housesInVicinity,
//       );
//     }
//
//     _housesInVicinity = _formData.housesInVicinity ?? 'Yes';
//     _authToken = _prefs!.getString(keyAccessToken);
//
//     _saveInitialData();
//
//     // Initialize controllers with form data
//     basementAccomodationController.text = _formData.basementAccomodation ?? '';
//     basementActualController.text = _formData.basementActual ?? '';
//     basementPermissibleController.text = _formData.basementPermissible ?? '';
//     mezzAccomodationController.text = _formData.mezzAccomodation ?? '';
//     mezzActualController.text = _formData.mezzActual ?? '';
//     mezzPermissibleController.text = _formData.mezzPermissible ?? '';
//     gfAccomodationController.text = _formData.gfAccomodation ?? '';
//     gfActualController.text = _formData.gfActual ?? '';
//     gfPermissibleController.text = _formData.gfPermissible ?? '';
//     ffAccomodationController.text = _formData.ffAccomodation ?? '';
//     ffActualController.text = _formData.ffActual ?? '';
//     ffPermissibleController.text = _formData.ffPermissible ?? '';
//     sfAccomodationController.text = _formData.sfAccomodation ?? '';
//     sfActualController.text = _formData.sfActual ?? '';
//     sfPermissibleController.text = _formData.sfPermissible ?? '';
//     tfAccomodationController.text = _formData.tfAccomodation ?? '';
//     tfActualController.text = _formData.tfActual ?? '';
//     tfPermissibleController.text = _formData.tfPermissible ?? '';
//     gpsCoordinatesController.text = _formData.gpsCoordinates ?? '';
//     ownerNameController.text = _formData.clientName ?? '';
//     propertyAddressController.text = _formData.propertyAddress ?? '';
//     inspectionDateController.text = _formData.inspectionDate != null ? DateFormat('dd/MM/yyyy').format(_formData.inspectionDate!) : '';
//     applicableRateController.text = _formData.applicableRate ?? '';
//     twoPropertyDealersNameController.text = _formData.twoPropertyDealersName ?? '';
//     twoPropertyDealersContactController.text = _formData.twoPropertyDealersContact ?? '';
//     setBacksFrontController.text = _formData.setBacksFront ?? '';
//     setBacksRearController.text = _formData.setBacksRear ?? '';
//     setBacksSide1Controller.text = _formData.setBacksSide1 ?? '';
//     setBacksSide2Controller.text = _formData.setBacksSide2 ?? '';
//     _levelOfDevelopment = _formData.levelOfDevelopment;
//   }
//   void _updateVisibleFloors(String? propertyType) {
//     setState(() {
//       _showNumberOfFloors = true;
//       _showFloorAtWhichFlatSituated = true;
//       _showFloorwiseInformationTable = true;
//
//       switch (propertyType) {
//         case 'Independent Bunglow':
//           _visibleFloors = [
//             'Basement',
//             'Mezzanine',
//             'Ground Floor',
//             'First Floor',
//             'Second Floor',
//             'Third Floor'
//           ];
//           _showNumberOfFloors = false;
//           _showFloorAtWhichFlatSituated = false;
//           break;
//         case 'Pent House':
//           _floorLabel = "Floor at which penthouse situated";
//           _floorHintText = "Enter Floor at which penthouse situated";
//           _showFloorwiseInformationTable = false;
//           _visibleFloors = [];
//           break;
//         case 'Society Flat':
//         case 'Bulider Flat':
//         case 'DDA Flat':
//           _floorLabel = "Floor at which flat situated";
//           _floorHintText = "Enter Floor at which flat situated";
//           _showFloorwiseInformationTable = false;
//           _visibleFloors = [];
//           break;
//         case 'Office':
//           _floorLabel = "Floor at which office situated";
//           _floorHintText = "Enter Floor at which office situated";
//           _visibleFloors = [
//             'Basement',
//             'Mezzanine',
//             'Ground Floor',
//             'First Floor',
//             'Second Floor',
//             'Third Floor'
//           ];
//           break;
//         default:
//           _visibleFloors = [];
//       }
//
//       if (propertyType == 'Society Flat' ||
//           propertyType == 'Bulider Flat' ||
//           propertyType == 'DDA Flat') {
//         _showFloorwiseInformationTable = false;
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     basementAccomodationController.dispose();
//     basementActualController.dispose();
//     basementPermissibleController.dispose();
//     mezzAccomodationController.dispose();
//     mezzActualController.dispose();
//     mezzPermissibleController.dispose();
//     gfAccomodationController.dispose();
//     gfActualController.dispose();
//     gfPermissibleController.dispose();
//     ffAccomodationController.dispose();
//     ffActualController.dispose();
//     ffPermissibleController.dispose();
//     sfAccomodationController.dispose();
//     sfActualController.dispose();
//     sfPermissibleController.dispose();
//     tfAccomodationController.dispose();
//     tfActualController.dispose();
//     tfPermissibleController.dispose();
//     gpsCoordinatesController.dispose();
//     ownerNameController.dispose();
//     propertyAddressController.dispose();
//     inspectionDateController.dispose();
//     applicableRateController.dispose();
//     twoPropertyDealersNameController.dispose();
//     twoPropertyDealersContactController.dispose();
//     setBacksFrontController.dispose();
//     setBacksRearController.dispose();
//     setBacksSide1Controller.dispose();
//     setBacksSide2Controller.dispose();
//
//     super.dispose();
//   }
//
//   Future<Position?> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them!')));
//       return null;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')));
//         return null;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return null;
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//   void _logFormData() {
//     final jsonData = jsonEncode(_formData.toJson());
//     print('Form Data: $jsonData');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: const Color(0xFFF9CB47).withOpacity(0.5),
//         ),
//         backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
//         title: const Text('Inspection Form'),
//       ),
//       body: Stepper(
//         currentStep: _currentStepIndex,
//         onStepCancel: () {
//           if (_currentStepIndex > 0) {
//             setState(() {
//               _currentStepIndex--;
//             });
//           }
//         },
//         onStepContinue: () {
//           if (_currentStepIndex < _formSteps.length - 1) {
//             if (_formSteps[_currentStepIndex].currentState?.validate() ?? false) {
//               _formSteps[_currentStepIndex].currentState?.save();
//
//               // Log the form data *after* saving the step's data
//               _logFormData();
//
//               // Print JSON data after saving each step
//               if (_currentStepIndex == 0) {
//                 // Call API to save personal information
//                 _savePersonalInformation();
//               }
//               if (_currentStepIndex == 1) {
//                 _savePropertyInformation();
//               }
//               if (_currentStepIndex == 2) {
//                 // Save Location Information
//                 _saveLocationInformation();
//               }
//               if (_currentStepIndex == 3) {
//                 // Save More Details Information
//                 _saveMoreDetailsInformation();
//               }
//               setState(() {
//                 _currentStepIndex++;
//               });
//             }
//           } else {
//             if (_formSteps[_currentStepIndex].currentState?.validate() ?? false) {
//               _formSteps[_currentStepIndex].currentState?.save();
//               _saveAdditionalDetailsInformation();
//
//               // Save additional details
//               _logFormData(); // Log the form data before submitting
//               widget.onFormSubmit(_formData);
//
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Form submitted successfully!')));
//             }
//           }
//         },
//         onStepTapped: (step) {
//           setState(() {
//             _currentStepIndex = step;
//           });
//         },
//         controlsBuilder: (BuildContext context, ControlsDetails details) {
//           return Row(
//             children: <Widget>[
//               if (_currentStepIndex > 0)
//                 TextButton(
//                   onPressed: details.onStepCancel,
//                   child: const Text('Back'),
//                 ),
//               ElevatedButton(
//                 onPressed: details.onStepContinue,
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.black,
//                 ),
//                 child: Text(_currentStepIndex == _formSteps.length - 1 ? 'Submit' : 'Continue'),
//               ),
//             ],
//           );
//         },
//         steps: _buildFormSteps(), // Renamed function
//       ),
//     );
//   }
//
//   List<Step> _buildFormSteps() {
//     return [
//       Step(
//         title: const Text('Personal Information'),
//         content: _buildPersonalInformationForm(),
//         isActive: _currentStepIndex == 0,
//         state: _currentStepIndex > 0 ? StepState.complete : StepState.indexed,
//       ),
//       Step(
//         title: const Text('Property Details'),
//         content: _buildPropertyDetailsForm(),
//         isActive: _currentStepIndex == 1,
//         state: _currentStepIndex > 1 ? StepState.complete : StepState.indexed,
//       ),
//       Step(
//         title: const Text('Location Details'),
//         content: _buildLocationDetailsForm(),
//         isActive: _currentStepIndex == 2,
//         state: _currentStepIndex > 2 ? StepState.complete : StepState.indexed,
//       ),
//       Step(
//         title: const Text('More Details'),
//         content: _buildAdditionalDetailsForm(),
//         isActive: _currentStepIndex == 3,
//         state: _currentStepIndex >= 3 ? StepState.complete : StepState.indexed,
//       ),
//       Step(
//         title: const Text('Additional Details'),
//         content: _buildMoreDetailsForm(),
//         isActive: _currentStepIndex == 4,
//         state: _currentStepIndex >= 4 ? StepState.complete : StepState.indexed,
//       ),
//     ];
//   }
//
//   // All your _buildForm methods remain the same
//   Widget _buildPersonalInformationForm() {
//     return Form(
//         key: _formSteps[0],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("1. Owner Name"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 controller: ownerNameController,
//                 decoration: const InputDecoration(
//                   hintText: 'Owner Name',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the Owner name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.clientName = value;
//                 },
//                 onChanged: (value) {
//                   _formData.clientName = value;
//                   _prefs?.setString(clientNameKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("2.Address"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 controller: propertyAddressController,
//                 decoration: const InputDecoration(
//                   hintText: 'Property Address',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the property address';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.propertyAddress = value;
//                 },
//                 onChanged: (value) {
//                   _formData.propertyAddress = value;
//                   _prefs?.setString(propertyAddressKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("3.Date"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 controller: inspectionDateController,
//                 decoration: const InputDecoration(
//                   hintText: 'Date',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: _formData.inspectionDate ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       _formData.inspectionDate = pickedDate;
//                       inspectionDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//                     });
//                     _prefs?.setString(inspectionDateKey, pickedDate.toIso8601String());
//                     widget.onFormDataChange(_formData);
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("4. Photograph with the owner(If No Reason)"),
//                 Row(
//                   children: [
//                     Radio<String>(
//                       value: 'Yes',
//                       groupValue: _formData.hasPhotoWithOwner,
//                       onChanged: (value) {
//                         setState(() {
//                           _formData.hasPhotoWithOwner = value;
//                           _prefs?.setString(hasPhotoWithOwnerKey, value!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                     const Text('Yes'),
//                     Radio<String>(
//                       value: 'No',
//                       groupValue: _formData.hasPhotoWithOwner,
//                       onChanged: (value) {
//                         setState(() {
//                           _formData.hasPhotoWithOwner = value;
//                           _prefs?.setString(hasPhotoWithOwnerKey, value!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                     const Text('No'),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16), const Text("5. Zone"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Zone',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.zone,
//                 items: const <String>[
//                   'Central',
//                   'East',
//                   'West',
//                   'North',
//                   'South',
//                   'Haryana',
//                   'U.P.'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     setState(() {
//                       _formData.zone = newValue;
//                       _prefs?.setString(zoneKey, newValue);
//                     });
//                     widget.onFormDataChange(_formData);
//                   }
//                 },
//                 validator: (value) => value == null ? 'Please select a zone' : null,
//                 onSaved: (String? value) {
//                   _formData.zone = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("6. Type of Locality"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Locality Type',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.typeOfLocality,
//                 items: const <String>[
//                   'Residential',
//                   'Commercial',
//                   'Industrial',
//                   'Agricultural'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.typeOfLocality = newValue;
//                     _prefs?.setString(localityTypeKey, newValue!);
//                   });
//                   widget.onFormDataChange(_formData);
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select a locality' : null,
//                 onSaved: (String? value) {
//                   _formData.typeOfLocality = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("7. Type of Colony"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Colony Type',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.typeOfColony,
//                 items: const <String>['Authorised', 'UnAuthorised']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.typeOfColony = newValue;
//                     _prefs?.setString(colonyTypeKey, newValue!);
//                   });
//                   widget.onFormDataChange(_formData);
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select type of Colony' : null,
//                 onSaved: (String? value) {
//                   _formData.typeOfColony = value;
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
//
//   Widget _buildPropertyDetailsForm() {
//     return Form(
//       key: _formSteps[1],
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("8. Type of Ownership"),
//           SizedBox(
//             height: 40,
//             child: DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 hintText: 'Select Ownership Type',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 isDense: true,
//               ),
//               value: _formData.typeOfOwnership,
//               items: const <String>['Freehold', 'Leasehold']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _formData.typeOfOwnership = newValue;
//                   _prefs?.setString(ownershipTypeKey, newValue!);
//                 });
//                 widget.onFormDataChange(_formData);
//               },
//               validator: (value) =>
//               value == null ? 'Please select type of Ownership' : null,
//               onSaved: (String? value) {
//                 _formData.typeOfOwnership = value;
//               },
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text("9. Type of Property"),
//           SizedBox(
//             height: 40,
//             child: DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 hintText: 'Select Property Type',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 isDense: true,
//               ),
//               value: _formData.typeOfProperty,
//               items: const <String>[
//                 'Independent Bunglow',
//                 'Pent House',
//                 'Society Flat',
//                 'Bulider Flat',
//                 'DDA Flat',
//                 'Office'
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _formData.typeOfProperty = newValue;
//                   _prefs?.setString(propertyTypeKey, newValue!);
//                   _updateVisibleFloors(newValue);
//                 });
//                 widget.onFormDataChange(_formData);
//               },
//               validator: (value) =>
//               value == null ? 'Please select type of Property' : null,
//               onSaved: (String? value) {
//                 _formData.typeOfProperty = value;
//               },
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text("10. Neighbourhood Classification"),
//           SizedBox(
//             height: 40,
//             child: DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 hintText: 'Select Neighbourhood Class',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 isDense: true,
//               ),
//               value: _formData.neighborhoodClassification,
//               items: const <String>[
//                 'Posh',
//                 'Good',
//                 'Middle',
//                 'Poor',
//                 'Upper Middle'
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _formData.neighborhoodClassification = newValue;
//                   _prefs?.setString(neighborhoodClassKey, newValue!);
//                 });
//                 widget.onFormDataChange(_formData);
//               },
//               validator: (value) => value == null
//                   ? 'Please select Neighbourhood Classification'
//                   : null,
//               onSaved: (String? value) {
//                 _formData.neighborhoodClassification = value;
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationDetailsForm() {
//     return Form(
//         key: _formSteps[2],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("11. Occupation Status"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Occupation Status',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.occupationStatus,
//                 items: const <String>[
//                   'Self Occupied',
//                   'Seller Occupied',
//                   'Vacant',
//                   'Under Const'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.occupationStatus = newValue;
//                     _prefs?.setString(occupationStatusKey, newValue!);
//                   });
//                   widget.onFormDataChange(_formData);
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Occupation Status' : null,
//                 onSaved: (String? value) {
//                   _formData.occupationStatus = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.only(top: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("12. Property Usage"),
//                   SizedBox(
//                     height: 40,
//                     child: DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         hintText: 'Select Property Usage',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         isDense: true,
//                       ),
//                       value: _formData.propertyUsage,
//                       items: const <String>[
//                         'Residential',
//                         'Commercial',
//                         'Rental by Self',
//                         'Rented by Seller'
//                       ].map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _formData.propertyUsage = newValue;
//                           _prefs?.setString(propertyUsageKey, newValue!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                       validator: (value) =>
//                       value == null ? 'Please select Property Usage' : null,
//                       onSaved: (String? value) {
//                         _formData.propertyUsage = value;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("13. Location Property"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Property Location',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.locationOfProperty,
//                 items: const <String>['Corner Plot', 'On Main Road', 'Inner Lane']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.locationOfProperty = newValue;
//                     _prefs?.setString(locationOfPropertyKey, newValue!);
//                   });
//                   widget.onFormDataChange(_formData);
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Location Property' : null,
//                 onSaved: (String? value) {
//                   _formData.locationOfProperty = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("14. How it is covered on"),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'North',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.howItsCoveredNorth,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter North side area covered on';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.howItsCoveredNorth = value;
//                 },
//                 onChanged: (value) {
//                   _formData.howItsCoveredNorth = value;
//                   _prefs?.setString(howItsCoveredNorth, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'South',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.howItsCoveredSouth,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter South side area covered on';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.howItsCoveredSouth = value;
//                 },
//                 onChanged: (value) {
//                   _formData.howItsCoveredSouth = value;
//                   _prefs?.setString(howItsCoveredSouth, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'East',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.howItsCoveredEast,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter East side area covered on';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.howItsCoveredEast = value;
//                 },
//                 onChanged: (value) {
//                   _formData.howItsCoveredEast = value;
//                   _prefs?.setString(howItsCoveredEast, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'West',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.howItsCoveredWest,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter West side area covered on';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.howItsCoveredWest = value;
//                 },
//                 onChanged: (value) {
//                   _formData.howItsCoveredWest = value;
//                   _prefs?.setString(howItsCoveredWest, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
//
//   Widget _buildAdditionalDetailsForm() {
//     return Form(
//         key: _formSteps[3],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("15. If under const,Sanction Plan/Estimate seen"),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Radio<String>(
//                       value: 'Yes',
//                       groupValue: _formData.underSanctionPlan,
//                       onChanged: (value) {
//                         setState(() {
//                           _formData.underSanctionPlan = value;
//                           _prefs?.setString(underSanctionPlan, value!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                     const Text('Yes'),
//                     Radio<String>(
//                       value: 'No',
//                       groupValue: _formData.underSanctionPlan,
//                       onChanged: (value) {
//                         setState(() {
//                           _formData.underSanctionPlan = value;
//                           _prefs?.setString(underSanctionPlan, value!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                     const Text('No'),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text("16. Is const.Acc to Sanction Plan "),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Radio<String>(
//                       value: 'Yes',
//                       groupValue: _formData.accToSanctionPlan,
//                       onChanged: (value) {
//                         setState(() {
//                           _formData.accToSanctionPlan = value;
//                           _prefs?.setString(accToSanctionPlan, value!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                     const Text('Yes'),
//                     Radio<String>(
//                       value: 'No',
//                       groupValue: _formData.accToSanctionPlan,
//                       onChanged: (value) {
//                         setState(() {
//                           _formData.accToSanctionPlan = value;
//                           _prefs?.setString(accToSanctionPlan, value!);
//                         });
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                     const Text('No'),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text("17. Type of Structure"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Structure Type',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.typeOfStructure, // Corrected here
//                 items: const <String>['R.C.C.Framed Structure', 'Load bearing Wllas']
//                     .map<DropdownMenuItem<String>> ((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.typeOfStructure = newValue; // Corrected here
//                     _prefs?.setString(structureTypeKey, newValue!);
//
//                   });
//                   widget.onFormDataChange(_formData);
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Structure Type' : null,
//                 onSaved: (String? value) {
//                   _formData.typeOfStructure = value; // Corrected here
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("18. Area of Plot"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Plot Area',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.areaOfPlot,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter area of plot';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.areaOfPlot = value;
//                 },
//                 // inputFormatters: [
//                 //   FilteringTextInputFormatter.allow(
//                 //       RegExp(r'[0-9.]')),
//                 // ],
//                 // keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   _formData.areaOfPlot = value;
//                   _prefs?.setString(areaOfPlot, value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_showNumberOfFloors)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("19. No of Floors in Building"),
//                   SizedBox(
//                     height: 40,
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         hintText: 'Enter No. of Floors',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         isDense: true,
//                       ),
//                       initialValue: _formData.numberOfFloors,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the number of floors';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _formData.numberOfFloors = value;
//                       },
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         _formData.numberOfFloors = value;
//                         _prefs?.setString(numberOfFloors, value);
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             if (_showFloorAtWhichFlatSituated)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("20. $_floorLabel"),  // Moved Text widget here
//                   SizedBox(
//                     height: 40,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: _floorHintText,
//                         border: const OutlineInputBorder(),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         isDense: true,
//                       ),
//                       initialValue: _formData.floorOfFlat,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the Floor at which flat situated';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _formData.floorOfFlat = value;
//                       },
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         _formData.floorOfFlat = value;
//                         _prefs?.setString(floorOfFlat,value);
//                         widget.onFormDataChange(_formData);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 16),
//
//             if (_showFloorwiseInformationTable)
//               _buildFloorwiseInformationTable(),
//             const SizedBox(height: 16),
//             const Text("22. Year of Construction"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Construction Year',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.yearOfConstruction,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the year of construction';
//                   }
//                   return null;
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(
//                       RegExp(r'[0-9.]')),
//                 ],
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   _formData.yearOfConstruction = value;
//                   _prefs?.setString(yearOfConstruction,value);
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("23. External"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select External Finish',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.external,
//                 items: const <String>[
//                   'Snowcom',
//                   'Grit Wash',
//                   'Dholpur',
//                   'Marble',
//                   'Tiles'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.external = newValue;
//                     _prefs?.setString(external, newValue!);
//                     widget.onFormDataChange(_formData);
//                   });
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select external' : null,
//                 onSaved: (String? value) {
//                   _formData.external = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("24. Internal"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Internal Condition',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.internal,
//                 items: const <String>['Excellent', 'Good', 'Fair', 'Poor']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.internal = newValue;
//                     _prefs?.setString(internal, newValue!);
//                     widget.onFormDataChange(_formData);
//                   });
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Internal' : null,
//                 onSaved: (String? value) {
//                   _formData.internal = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("25. Flooring"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Flooring Type',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.flooring,
//                 items: const <String>[
//                   'Kota',
//                   'Giazed',
//                   'Marble',
//                   'Mosaic',
//                   'Itallian Marble',
//                   'P.C.C',
//                   'V.Tiles'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.flooring = newValue;
//                     _prefs?.setString(flooring, newValue!);
//                     widget.onFormDataChange(_formData);
//                   });
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Flooring' : null,
//                 onSaved: (String? value) {
//                   _formData.flooring = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("26. Wood Work"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Wood Work Type',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.woodWork,
//                 items: const <String>['Panellied', 'Glazed', 'Toak', 'Flush', 'Tiles']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.woodWork = newValue;
//                     _prefs?.setString(woodWork, newValue!);
//                     widget.onFormDataChange(_formData);
//                   });
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Wood Work' : null,
//                 onSaved: (String? value) {
//                   _formData.woodWork = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("27. Fittings"),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   hintText: 'Select Fittings Quality',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 value: _formData.fittings,
//                 items: const <String>['ISI', 'Ordinary', 'Superior']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _formData.fittings = newValue;
//                     _prefs?.setString(fittings, newValue!);
//                     widget.onFormDataChange(_formData);
//                   });
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select Fittings' : null,
//                 onSaved: (String? value) {
//                   _formData.fittings = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("28. Person Contacted at Site"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Person Contacted at Site',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.contactedPersonKey,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Person Contacted at Site';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.contactedPersonKey = value;
//                   _prefs?.setString(contactedPersonKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 onChanged: (value) {
//                   _formData.contactedPersonKey = value;
//
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("29. Rental Range"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Rental Range',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.rentalRange,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Rental Range';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.rentalRange = value;
//                   _prefs?.setString(rentalRange, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 // inputFormatters: [
//                 //   FilteringTextInputFormatter.allow(
//                 //       RegExp(r'[0-9.]')),
//                 // ],
//                 // keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   _formData.rentalRange = value;
//
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("30. Market Rate of land in locality Area"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Market Rate',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.marketRate,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Market Rate of land in locality Area';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.marketRate = value;
//                   _prefs?.setString(landMarketRateKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 onChanged: (value) {
//                   _formData.marketRate = value;
//
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("31. Rented Area of the Property"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Rented Area',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.rentedArea,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Rented Area of the Property';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.rentedArea = value;
//                   _prefs?.setString(rentedAreaKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 onChanged: (value) {
//                   _formData.rentedArea = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("32. Commercial Area of Property"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Commercial Area',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.commercialArea,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Commercial Area of Property';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.commercialArea = value;
//                   _prefs?.setString(commercialAreaKey, value);
//                   widget.onFormDataChange(_formData);
//
//                 },
//                 onChanged: (value) {
//                   _formData.commercialArea = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("33. Over Head Tank"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Over Head Tank Details',
//
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.overHeadTank,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Over Head Tank';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.overHeadTank = value;
//                   _prefs?.setString(overheadTankDetailsKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 onChanged: (value) {
//                   _formData.overHeadTank = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("34. Pump"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Pump Details',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.pump,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Pump';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.pump = value;
//                   _prefs?.setString(pumpDetailsKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 onChanged: (value) {
//                   _formData.pump = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("35. GPS Coordinates"),
//             SizedBox(height: 40,
//               child: TextFormField(
//                 controller: gpsCoordinatesController,
//                 decoration: InputDecoration(
//                     hintText: 'GPS Coordinates',
//                     border: const OutlineInputBorder(),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     isDense: true,
//                     suffixIcon: IconButton(
//                         icon: const Icon(Icons.location_on),
//                         onPressed: () async {
//                           Position? position = await _getCurrentLocation();
//                           if (position != null) {
//                             setState(() {
//                               String coordinates =
//                                   "${position.latitude}, ${position.longitude}";
//                               gpsCoordinatesController.text = coordinates;
//                               _formData.gpsCoordinates = coordinates;
//                               _prefs?.setString(gpsCoordinatesKey, coordinates);
//                               widget.onFormDataChange(_formData);
//                             });
//
//                           }
//
//                         }
//
//                     )),
//                 readOnly: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please get GPS Coordinates';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.gpsCoordinates = value;
//                 },
//                 onChanged: (value) {
//                   _formData.gpsCoordinates = value;
//
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text("36. Landmark"),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Landmark',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   isDense: true,
//                 ),
//                 initialValue: _formData.landmark,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Landmark';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _formData.landmark = value;
//                   _prefs?.setString(landmarkKey, value);
//                   widget.onFormDataChange(_formData);
//                 },
//                 onChanged: (value) {
//                   _formData.landmark = value;
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ));
//   }
//
//   Widget _buildMoreDetailsForm() {
//     return Form(
//       key: _formSteps[4],
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //36 Number
//           Row(
//             children: [
//               const Expanded(
//                 child: Text('37. Applicable Rate',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: applicableRateController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Enter rate',
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.applicableRate = value;
//
//                     },
//                     onChanged: (value) {
//                       _formData.applicableRate = value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           //37 Number
//           const Text(
//             '38. Two Property Dealers',
//             style: TextStyle(fontSize: 16),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: twoPropertyDealersNameController,
//                     decoration: const InputDecoration(
//                       hintText: 'Name ',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.twoPropertyDealersName = value;
//                     },
//                     onChanged: (value) {
//                       _formData.twoPropertyDealersName = value;
//                       widget.onFormDataChange(_formData);
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: twoPropertyDealersContactController,
//                     decoration: const InputDecoration(
//                       hintText: 'Contact No.',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.twoPropertyDealersContact = value;
//                     },
//                     onChanged: (value) {
//                       _formData.twoPropertyDealersContact= value;
//
//                       widget.onFormDataChange(_formData);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16), // Add space between the rows
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: twoPropertyDealersNameController,
//                     decoration: const InputDecoration(
//                       hintText: 'Name ', // Changed Label
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.twoPropertyDealersName1 = value;
//                     },
//                     onChanged: (value) {
//                       _formData.twoPropertyDealersName1 = value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: twoPropertyDealersContactController,
//                     decoration: const InputDecoration(
//                       hintText: 'Contact No.',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.twoPropertyDealersContact1 = value;
//                     },
//                     onChanged: (value) {
//                       _formData.twoPropertyDealersContact1= value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: twoPropertyDealersNameController,
//                     decoration: const InputDecoration(
//                       hintText: 'Name ', // Changed Label
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.twoPropertyDealersName2 = value;
//                     },
//                     onChanged: (value) {
//                       _formData.twoPropertyDealersName2 = value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: twoPropertyDealersContactController,
//                     decoration: const InputDecoration(
//                       hintText: 'Contact No.',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.twoPropertyDealersContact2 = value;
//                     },
//                     onChanged: (value) {
//                       _formData.twoPropertyDealersContact2= value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           //39 Number
//           const Text(
//             '39. Set Backs',
//             style: TextStyle(fontSize: 16),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: setBacksFrontController,
//                     decoration: const InputDecoration(
//                       hintText: 'Front',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.setBacksFront = value;
//                     },
//                     onChanged: (value) {
//                       _formData.setBacksFront= value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: setBacksRearController,
//                     decoration: const InputDecoration(
//                       hintText: 'Rear',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.setBacksRear = value;
//                     },
//                     onChanged: (value) {
//                       _formData.setBacksRear= value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: setBacksSide1Controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Side 1',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.setBacksSide1 = value;
//                     },
//                     onChanged: (value) {
//                       _formData.setBacksSide1 = value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextFormField(
//                     controller: setBacksSide2Controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Side 2',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       isDense: true,
//                     ),
//                     onSaved: (value) {
//                       _formData.setBacksSide2 = value;
//                     },
//                     onChanged: (value) {
//                       _formData.setBacksSide2 = value;
//
//                       widget.onFormDataChange(_formData);
//
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           //40 Number
//           const Text(
//             '40. Level of Development of Plots',
//             style: TextStyle(fontSize: 16),
//           ),
//           RadioListTile<String>(
//             title: const Text('(1) Accessible through metaled/ Macadem Road'),
//             value: '(1) Accessible through metaled/ Macadem Road',
//             groupValue: _levelOfDevelopment,
//             onChanged: (value) {
//               setState(() {
//                 _levelOfDevelopment = value;
//                 _formData.levelOfDevelopment = value;
//               });
//               widget.onFormDataChange(_formData);
//             },
//           ),
//           RadioListTile<String>(
//             title: const Text('(2) Is the Plot in developed layout'),
//             value: '(2) Is the Plot in developed layout',
//             groupValue: _levelOfDevelopment,
//             onChanged: (value) {
//               setState(() {
//                 _levelOfDevelopment = value;
//                 _formData.levelOfDevelopment = value;
//               });
//               widget.onFormDataChange(_formData);
//             },
//           ),
//           RadioListTile<String>(
//             title: const Text(
//                 '(3) Is it a clearly demarcated plot or is it a plot of large layout'),
//             value: '(3) Is it a clearly demarcated plot or is it a plot of large layout',
//             groupValue: _levelOfDevelopment,
//             onChanged: (value) {
//               setState(() {
//                 _levelOfDevelopment = value;
//                 _formData.levelOfDevelopment = value;
//               });
//               widget.onFormDataChange(_formData);
//             },
//           ),
//           const SizedBox(height: 16),
//
//           //40 Number
//           Row(
//             children: [
//               const Expanded(
//                 child: Text(
//                   'Houses in the vicinity within 1 Km. rad.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               DropdownButton<String>(
//                 value: _housesInVicinity,
//                 items: <String>['Yes', 'No'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _housesInVicinity = newValue!;
//                     _formData.housesInVicinity = newValue;
//                   });
//                   widget.onFormDataChange(_formData);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildFloorwiseInformationTable() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           '21. Floorwise Built up area of Building',
//         ),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             border: TableBorder.all(),
//             columnSpacing: 20.0,
//             columns: const [
//               DataColumn(label: Expanded(child: Text('Floor'))),
//               DataColumn(label: Expanded(child: Text('Accommodation'))),
//               DataColumn(label: Expanded(child: Text('Actual'))),
//               DataColumn(label: Expanded(child: Text('Permissible'))),
//             ],
//             rows: [
//               if (_visibleFloors.contains('Basement'))
//                 _buildFloorDataRow(
//                   'Basement',
//                   basementAccomodationController,
//                   basementActualController,
//                   basementPermissibleController,
//                 ),
//               if (_visibleFloors.contains('Mezzanine'))
//                 _buildFloorDataRow(
//                   'Mezzanine',
//                   mezzAccomodationController,
//                   mezzActualController,
//                   mezzPermissibleController,
//                 ),
//               if (_visibleFloors.contains('Ground Floor'))
//                 _buildFloorDataRow(
//                   'Ground Floor',
//                   gfAccomodationController,
//                   gfActualController,
//                   gfPermissibleController,
//                 ),
//               if (_visibleFloors.contains('First Floor'))
//                 _buildFloorDataRow(
//                   'First Floor',
//                   ffAccomodationController,
//                   ffActualController,
//                   ffPermissibleController,
//                 ),
//               if (_visibleFloors.contains('Second Floor'))
//                 _buildFloorDataRow(
//                   'Second Floor',
//                   sfAccomodationController,
//                   sfActualController,
//                   sfPermissibleController,
//                 ),
//               if (_visibleFloors.contains('Third Floor'))
//                 _buildFloorDataRow(
//                   'Third Floor',
//                   tfAccomodationController,
//                   tfActualController,
//                   tfPermissibleController,
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   DataRow _buildFloorDataRow(
//       String floorName,
//       TextEditingController accomodationController,
//       TextEditingController actualController,
//       TextEditingController permissibleController,
//       ) {
//     return DataRow(
//       cells: [
//         DataCell(Text(floorName)),
//         DataCell(
//           SizedBox(
//             width: 100.0,
//             height: 35,
//             child: TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter Accommodation',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                 isDense: true,
//               ),
//               controller: accomodationController,
//               style: const TextStyle(fontSize: 14),
//               onChanged: (value) {
//                 switch (floorName) {
//                   case 'Basement':
//                     _formData.basementAccomodation = value;
//                     break;
//                   case 'Mezzanine':
//                     _formData.mezzAccomodation = value;
//                     break;
//                   case 'Ground Floor':
//                     _formData.gfAccomodation = value;
//                     break;
//                   case 'First Floor':
//                     _formData.ffAccomodation = value;
//                     break;
//                   case 'Second Floor':
//                     _formData.sfAccomodation = value;
//                     break;
//                   case 'Third Floor':
//                     _formData.tfAccomodation = value;
//                     break;
//                 }
//                 widget.onFormDataChange(_formData);
//               },
//             ),
//           ),
//         ),
//         DataCell(
//           SizedBox(
//             width: 100.0,
//             height: 35,
//             child: TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter Actual',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                 isDense: true,
//               ),
//               controller: actualController,
//               style: const TextStyle(fontSize: 14),
//               onChanged: (value) {
//                 switch (floorName) {
//                   case 'Basement':
//                     _formData.basementActual = value;
//                     break;
//                   case 'Mezzanine':
//                     _formData.mezzActual = value;
//                     break;
//                   case 'Ground Floor':
//                     _formData.gfActual = value;
//                     break;
//                   case 'First Floor':
//                     _formData.ffActual = value;
//                     break;
//                   case 'Second Floor':
//                     _formData.sfActual = value;
//                     break;
//                   case 'Third Floor':
//                     _formData.tfActual = value;
//                     break;
//                 }
//                 widget.onFormDataChange(_formData);
//               },
//             ),
//           ),
//         ),
//         DataCell(
//           SizedBox(
//             width: 100.0,
//             height: 35,
//             child: TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter Permissible',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                 isDense: true,
//               ),
//               controller: permissibleController,
//               style: const TextStyle(fontSize: 14),
//               onChanged: (value) {
//                 switch (floorName) {
//                   case 'Basement':
//                     _formData.basementPermissible = value;
//                     break;
//                   case 'Mezzanine':
//                     _formData.mezzPermissible = value;
//                     break;
//                   case 'Ground Floor':
//                     _formData.gfPermissible = value;
//                     break;
//                   case 'First Floor':
//                     _formData.ffPermissible = value;
//                     break;                  case 'Second Floor':
//                   _formData.sfPermissible = value;
//                   break;
//                   case 'Third Floor':
//                     _formData.tfPermissible = value;
//                     break;
//                 }
//                 widget.onFormDataChange(_formData);
//               },
//             ),
//           ),        ),
//       ],
//     );
//   }
// }
//
// class InspectionFormData {
//   String? clientName;
//   String? propertyAddress;
//   DateTime? inspectionDate;
//   String? hasPhotoWithOwner;
//   String? zone;
//   String? typeOfLocality;
//   String? typeOfColony;
//   String? typeOfOwnership;
//   String? typeOfProperty;
//   String? neighborhoodClassification;
//   String? occupationStatus;
//   String? propertyUsage;
//   String? locationOfProperty;
//   String? howItsCoveredNorth;
//   String? howItsCoveredSouth;
//   String? howItsCoveredEast;
//   String? howItsCoveredWest;
//   String? underSanctionPlan;
//   String? accToSanctionPlan;
//   String? areaOfPlot;
//   String? numberOfFloors;
//   String? floorOfFlat;
//   String? yearOfConstruction;
//   String? external;
//   String? internal;
//   String? flooring;
//   String? woodWork;
//   String? fittings;
//   String? contactedPersonKey;
//   String? rentalRange;
//   String? marketRate;
//   String? rentedArea;
//   String? commercialArea;
//   String? overHeadTank;
//   String? pump;
//   String? gpsCoordinates;
//   String? landmark;
//   String? basementAccomodation;
//   String? basementActual;
//   String? basementPermissible;
//   String? mezzAccomodation;
//   String? mezzActual;
//   String? mezzPermissible;
//   String? gfAccomodation;String? gfActual;  String? gfPermissible;
//   String? ffAccomodation;
//   String? ffActual;
//   String? ffPermissible;
//   String? sfAccomodation;
//   String? sfActual;
//   String? sfPermissible;
//   String? tfAccomodation;
//   String? tfActual;
//   String? tfPermissible;
//   String? typeOfStructure;
//   String? applicableRate;
//   String? twoPropertyDealersName;
//   String? twoPropertyDealersContact;
//   String? twoPropertyDealersName1;
//   String? twoPropertyDealersContact1;
//   String? twoPropertyDealersName2;
//   String? twoPropertyDealersContact2;
//   String? setBacksFront;
//   String? setBacksRear;
//   String? setBacksSide1;
//   String? setBacksSide2;
//   String? levelOfDevelopment;
//   String? housesInVicinity;
//
//   InspectionFormData({
//     this.clientName,
//     this.propertyAddress,
//     this.inspectionDate,
//     this.hasPhotoWithOwner,
//     this.zone,
//     this.typeOfLocality,
//     this.typeOfColony,
//     this.typeOfOwnership,
//     this.typeOfProperty,
//     this.neighborhoodClassification,
//     this.occupationStatus,this.propertyUsage,
//     this.locationOfProperty,
//     this.howItsCoveredNorth,
//     this.howItsCoveredSouth,
//     this.howItsCoveredEast,
//     this.howItsCoveredWest,
//     this.underSanctionPlan,
//     this.accToSanctionPlan,
//     this.areaOfPlot,
//     this.numberOfFloors,
//     this.floorOfFlat,
//     this.yearOfConstruction,
//     this.external,
//     this.internal,
//     this.flooring,
//     this.woodWork,
//     this.fittings,
//     this.contactedPersonKey,
//     this.rentalRange,
//     this.marketRate,
//     this.rentedArea,
//     this.commercialArea,
//     this.overHeadTank,
//     this.pump,
//     this.gpsCoordinates,
//     this.landmark,
//     this.basementAccomodation,
//     this.basementActual,
//     this.basementPermissible,
//     this.mezzAccomodation,
//     this.mezzActual,
//     this.mezzPermissible,
//     this.gfAccomodation,
//     this.gfActual,
//     this.gfPermissible,
//     this.ffAccomodation,
//     this.ffActual,
//     this.ffPermissible,
//     this.sfAccomodation,
//     this.sfActual,
//     this.sfPermissible,
//     this.tfAccomodation,
//     this.tfActual,
//     this.tfPermissible,
//     this.typeOfStructure,
//     this.applicableRate,
//     this.twoPropertyDealersName,
//     this.twoPropertyDealersContact,
//     this.twoPropertyDealersName1,
//     this.twoPropertyDealersContact1,
//     this.twoPropertyDealersName2,
//     this.twoPropertyDealersContact2,
//     this.setBacksFront,
//     this.setBacksRear,
//     this.setBacksSide1,
//     this.setBacksSide2,
//     this.levelOfDevelopment,
//     this.housesInVicinity,
//   });
//
//   //toJson method to convert InspectionFormData to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'clientName': clientName,
//       'propertyAddress': propertyAddress,
//       'inspectionDate': inspectionDate?.toIso8601String(),
//       'hasPhotoWithOwner': hasPhotoWithOwner,
//       'zone': zone,
//       'typeOfLocality': typeOfLocality,
//       'typeOfColony': typeOfColony,
//       'typeOfOwnership': typeOfOwnership,
//       'typeOfProperty': typeOfProperty,
//       'neighborhoodClassification': neighborhoodClassification,
//       'occupationStatus': occupationStatus,
//       'propertyUsage': propertyUsage,
//       'locationOfProperty': locationOfProperty,
//       'howItsCoveredNorth': howItsCoveredNorth,
//       'howItsCoveredSouth': howItsCoveredSouth,
//       'howItsCoveredEast': howItsCoveredEast,
//       'howItsCoveredWest': howItsCoveredWest,
//       'underSanctionPlan': underSanctionPlan,
//       'accToSanctionPlan': accToSanctionPlan,
//       'areaOfPlot': areaOfPlot,
//       'numberOfFloors': numberOfFloors,
//       'floorOfFlat': floorOfFlat,
//       'yearOfConstruction': yearOfConstruction,
//       'external': external,
//       'internal': internal,
//       'flooring': flooring,
//       'woodWork': woodWork,
//       'fittings': fittings,
//       'personContacted': contactedPersonKey,
//       'rentalRange': rentalRange,
//       'marketRate': marketRate,
//       'rentedArea': rentedArea,
//       'commercialArea': commercialArea,
//       'overHeadTank': overHeadTank,
//       'pump': pump,
//       'gpsCoordinates': gpsCoordinates,
//       'landmark': landmark,
//       'basementAccomodation': basementAccomodation,
//       'basementActual': basementActual,
//       'basementPermissible': basementPermissible,
//       'mezzAccomodation': mezzAccomodation,
//       'mezzActual': mezzActual,
//       'mezzPermissible': mezzPermissible,
//       'gfAccomodation': gfAccomodation,
//       'gfActual': gfActual,
//       'gfPermissible': gfPermissible,
//       'ffAccomodation': ffAccomodation,
//       'ffActual': ffActual,
//       'ffPermissible': ffPermissible,
//       'sfAccomodation': sfAccomodation,
//       'sfActual': sfActual,
//       'sfPermissible': sfPermissible,
//       'tfAccomodation': tfAccomodation,
//       'tfActual': tfActual,
//       'tfPermissible': tfPermissible,
//       'typeOfStructure': typeOfStructure,
//       'applicableRate': applicableRate,
//       'twoPropertyDealersName': twoPropertyDealersName,
//       'twoPropertyDealersContact': twoPropertyDealersContact,
//       'twoPropertyDealersName1': twoPropertyDealersName1,
//       'twoPropertyDealersContact1': twoPropertyDealersContact1,
//       'twoPropertyDealersName2': twoPropertyDealersName2,
//       'twoPropertyDealersContact2': twoPropertyDealersContact2,
//       'setBacksFront': setBacksFront,
//       'setBacksRear': setBacksRear,
//       'setBacksSide1': setBacksSide1,
//       'setBacksSide2': setBacksSide2,
//       'levelOfDevelopment': levelOfDevelopment,
//       'housesInVicinity': housesInVicinity,
//     };
//   }
// }