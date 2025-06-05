import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaa_adv/models/appointment_details.dart';
import 'package:gaa_adv/service/shared_pref_service.dart';
import 'package:gaa_adv/views/dimension_input_page.dart';
import 'package:gaa_adv/views/room_selection_page.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../models/inspection_data_form.dart';
import '../utils/apis.dart';
import 'package:get/get.dart';

// Renamed class for clarity
class FieldEngineerForm extends StatefulWidget {
  final Map<String, dynamic>? appointmentData;
  final InspectionFormData? initialFormData;
  final Function(InspectionFormData) onFormSubmit;
  final Function(InspectionFormData) onFormDataChange;
  final int appointmentId;
  final MediaType;
  const FieldEngineerForm({
    super.key,
    this.appointmentData,
    this.initialFormData,
    required this.onFormSubmit,
    required this.onFormDataChange,
    required this.appointmentId,
    required this.MediaType,
  });

  @override
  State<FieldEngineerForm> createState() =>
      _FieldEngineerFormState(); // This is correct now!
}

class _FieldEngineerFormState extends State<FieldEngineerForm> {
  final ImagePicker _picker = ImagePicker();


  // Preference Keys
  static const String clientNameKey = 'clientName';
  static const String propertyAddressKey = 'propertyAddress';
  static const String inspectionDateKey = 'inspectionDate';
  static const String hasPhotoWithOwnerKey = 'hasPhotoWithOwner';
  static const String photoWithOwnerReasonKey = 'OwnerReason';
  static const String zoneKey = 'zone';
  static const String localityTypeKey = 'typeOfLocality';
  static const String colonyTypeKey = 'typeOfColony';
  static const String ownershipTypeKey = 'typeOfOwnership';
  static const String propertyTypeKey = 'propertyType';
  static const String neighborhoodClassKey = 'neighborhoodClassification';
  static const String occupationStatusKey = 'occupationStatus';
  static const String propertyUsageKey = 'propertyUsage';
  static const String propertyLocationKey = 'locationOfProperty';
  static const String coveredNorthKey = 'howItsCoveredNorth';
  static const String coveredSouthKey = 'howItsCoveredSouth';
  static const String coveredEastKey = 'howItsCoveredEast';
  static const String coveredWestKey = 'howItsCoveredWest';
  static const String sanctionPlanSeenKey = 'underSanctionPlan';
  static const String accToSanctionPlanKey = 'accToSanctionPlan';
  static const String plotAreaKey = 'areaOfPlot';
  static const String numFloorsKey = 'numberOfFloors';
  static const String flatFloorKey = 'floorOfFlat';
  static const String constructionYearKey = 'yearOfConstruction';
  static const String externalFinishKey = 'external';
  static const String internalConditionKey = 'internal';
  static const String flooringTypeKey = 'flooring';
  static const String woodworkTypeKey = 'woodWork';
  static const String fittingsQualityKey = 'fittings';
  static const String contactedPersonKey = 'personContacted';
  static const String rentalRangeKey = 'rentalRange';
  static const String landMarketRateKey = 'marketRate';
  static const String rentedAreaKey = 'rentedArea';
  static const String commercialAreaKey = 'commercialArea';
  static const String overheadTankDetailsKey = 'overHeadTank';
  static const String overHeadTank = 'pump';
  static const String gpsCoordinatesKey = 'gpsCoordinates';
  static const String landmarkKey = 'landmark';
  static const String basementAccommKey = 'basementAccomodation';
  static const String basementActualKey = 'basementActual';
  static const String basementPermissibleKey = 'basementPermissible';
  static const String mezzAccommKey = 'mezzAccomodation';
  static const String mezzActualKey = 'mezzActual';
  static const String mezzPermissibleKey = 'mezzPermissible';
  static const String gfAccommKey = 'gfAccomodation';
  static const String gfActualKey = 'gfActual';
  static const String gfPermissibleKey = 'gfPermissible';
  static const String ffAccommKey = 'ffAccomodation';
  static const String ffActualKey = 'ffActual';
  static const String ffPermissibleKey = 'ffPermissible';
  static const String sfAccommKey = 'sfAccomodation';
  static const String sfActualKey = 'sfActual';
  static const String sfPermissibleKey = 'sfPermissible';
  static const String tfAccommKey = 'tfAccomodation';
  static const String tfActualKey = 'tfActual';
  static const String tfPermissibleKey = 'tfPermissible';
  static const String structureTypeKey = 'typeOfStructure';
  static const String applicableRateKey = 'applicableRate';
  static const String dealerName1Key = 'twoPropertyDealersName1';
  static const String dealerContact1Key = 'twoPropertyDealersContact1';
  static const String dealerName2Key = 'twoPropertyDealersName2';
  static const String dealerContact2Key = 'twoPropertyDealersContact2';
  static const String setbacksFrontKey = 'setBacksFront';
  static const String setbacksRearKey = 'setBacksRear';
  static const String setbacksSide1Key = 'setBacksSide1';
  static const String setbacksSide2Key = 'setBacksSide2';
  static const String developmentLevelKey = 'levelOfDevelopment';
  static const String housesVicinityKey = 'housesInVicinity';
  static const String keyAccessToken = 'access_token'; // Key to store the auth token
  static const String locationOfPropertyKey = 'locationOfProperty';
  static const String keyFormID = "appointment_id";
  static const String ownerImagePathKey = 'ownerImagePath';


  // Using a more descriptive name
  final List<GlobalKey<FormState>> _formSteps = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentStepIndex = 0; // Renamed for clarity
  InspectionFormData _formData = InspectionFormData();
  SharedPreferences? _prefs;
  String? _authToken; // Variable to store the authentication token


  // Controllers for floor information
  final basementAccomodationController = TextEditingController();
  final basementActualController = TextEditingController();
  final basementPermissibleController = TextEditingController();
  final mezzAccomodationController = TextEditingController();
  final mezzActualController = TextEditingController();
  final mezzPermissibleController = TextEditingController();
  final gfAccomodationController = TextEditingController();
  final gfActualController = TextEditingController();
  final gfPermissibleController = TextEditingController();
  final ffAccomodationController = TextEditingController();
  final ffActualController = TextEditingController();
  final ffPermissibleController = TextEditingController();
  final sfAccomodationController = TextEditingController();
  final sfActualController = TextEditingController();
  final sfPermissibleController = TextEditingController();
  final tfAccomodationController = TextEditingController();
  final tfActualController = TextEditingController();
  final tfPermissibleController = TextEditingController();
  final gpsCoordinatesController = TextEditingController();
  final ownerNameController = TextEditingController();
  final propertyAddressController = TextEditingController();
  late var reasonController = TextEditingController();
  final inspectionDateController = TextEditingController();
  final applicableRateController = TextEditingController();
  final twoPropertyDealersName1Controller = TextEditingController();
  final twoPropertyDealersContact1Controller = TextEditingController();
  final twoPropertyDealersName2Controller = TextEditingController();
  final twoPropertyDealersContact2Controller = TextEditingController();
  final setBacksFrontController = TextEditingController();
  final setBacksRearController = TextEditingController();
  final setBacksSide1Controller = TextEditingController();
  final setBacksSide2Controller = TextEditingController();
  final OwnerReasonController = TextEditingController();

  List<String> _visibleFloors = []; // Renamed for better understanding
  bool _showNumberOfFloors = true;
  bool _showFloorAtWhichFlatSituated = true;
  bool _showFloorwiseInformationTable = true;
  String _floorLabel = "Floor at which flat situated";
  String _floorHintText = "Enter Floor at which flat situated";
  String? _levelOfDevelopment;
  String _housesInVicinity = 'Yes'; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _housesInVicinity = 'Yes';

    _initializeForm(); // Renamed function
  }

  Future<void> getSavedDetails() async {
    SharedPrefService sharedPrefService = SharedPrefService();
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
    print(token);

    try {
      final uri = Uri.parse(Apis.getAppointmentDetail(widget.appointmentId.toString()));

      final header = {"Authorization": "Bearer $token"};

      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        AppointmentDetails appointmentDetails = AppointmentDetails.fromJson(responseData);
        //_initializeForm2(appointmentDetails);
      } else {

      }
    } catch (e) {
      Get.snackbar("Error", "${e.toString()}",duration: Duration(seconds: 3));
    }
  }



  Future<void> _initializeForm() async {
    _prefs = await SharedPreferences.getInstance();

    // Load initial data
    _formData = widget.initialFormData ?? InspectionFormData();

    // Load data from SharedPreferences (only on initial load)
    _formData.clientName =
        _prefs!.getString(clientNameKey) ?? _formData.clientName;
    _formData.propertyAddress =
        _prefs!.getString(propertyAddressKey) ?? _formData.propertyAddress;
    _formData.applicableRate =
        _prefs!.getString(applicableRateKey) ?? _formData.applicableRate;
    _formData.twoPropertyDealersName1 =
        _prefs!.getString(dealerName1Key) ?? _formData.twoPropertyDealersName1;
    _formData.twoPropertyDealersContact1 =
        _prefs!.getString(dealerContact1Key) ??
            _formData.twoPropertyDealersContact2;
    _formData.twoPropertyDealersName2 =
        _prefs!.getString(dealerName2Key) ?? _formData.twoPropertyDealersName1;
    _formData.twoPropertyDealersContact2 =
        _prefs!.getString(dealerContact2Key) ??
            _formData.twoPropertyDealersContact2;

    _formData.setBacksFront =
        _prefs!.getString(setbacksFrontKey) ?? _formData.setBacksFront;
    _formData.setBacksRear =
        _prefs!.getString(setbacksRearKey) ?? _formData.setBacksRear;
    _formData.setBacksSide1 =
        _prefs!.getString(setbacksSide1Key) ?? _formData.setBacksSide1;
    _formData.setBacksSide2 =
        _prefs!.getString(setbacksSide2Key) ?? _formData.setBacksSide2;

    String? housesInVicinity = _prefs!.getString(housesVicinityKey);
    _housesInVicinity = housesInVicinity ?? 'Yes';

    _formData.levelOfDevelopment =
        _prefs!.getString(developmentLevelKey) ?? _formData.levelOfDevelopment;

    String? dateString = _prefs!.getString(inspectionDateKey);
    if (dateString != null) {
      _formData.inspectionDate =
          DateTime.tryParse(dateString) ?? _formData.inspectionDate;
    }

    // Populate form data from appointment data if available
    if (widget.appointmentData != null) {
      _formData = InspectionFormData(
        clientName: widget.appointmentData!['clientName'] ??
            _formData.clientName ?? '',
        propertyAddress: widget.appointmentData!['propertyAddress'] ??
            _formData.propertyAddress ?? '',
        inspectionDate: widget.appointmentData!['inspectionDate'] != null
            ? DateTime.tryParse(widget.appointmentData!['inspectionDate']) ??
            _formData.inspectionDate
            : _formData.inspectionDate,
        hasPhotoWithOwner: widget.appointmentData!['hasPhotoWithOwner'] ??
            _formData.hasPhotoWithOwner,
        OwnerReason:widget.appointmentData!['OwnerReason']??_formData.OwnerReason,

        zone: widget.appointmentData!['zone'] ?? _formData.zone,
        typeOfLocality: widget.appointmentData!['typeOfLocality'] ??
            _formData.typeOfLocality,
        typeOfColony: widget.appointmentData!['typeOfColony'] ??
            _formData.typeOfColony,
        typeOfOwnership: widget.appointmentData!['typeOfOwnership'] ??
            _formData.typeOfOwnership,
        typeOfProperty: widget.appointmentData!['typeOfProperty'] ??
            _formData.typeOfProperty,
        neighborhoodClassification: widget
            .appointmentData!['neighborhoodClassification'] ??
            _formData.neighborhoodClassification,
        occupationStatus: widget.appointmentData!['occupationStatus'] ??
            _formData.occupationStatus,
        propertyUsage: widget.appointmentData!['propertyUsage'] ??
            _formData.propertyUsage,
        locationOfProperty: widget.appointmentData!['locationOfProperty'] ??
            _formData.locationOfProperty,
        howItsCoveredNorth: widget.appointmentData!['howItsCoveredNorth'] ??
            _formData.howItsCoveredNorth,
        howItsCoveredSouth: widget.appointmentData!['howItsCoveredSouth'] ??
            _formData.howItsCoveredSouth,
        howItsCoveredEast: widget.appointmentData!['howItsCoveredEast'] ??
            _formData.howItsCoveredEast,
        howItsCoveredWest: widget.appointmentData!['howItsCoveredWest'] ??
            _formData.howItsCoveredWest,
        underSanctionPlan: widget.appointmentData!['underSanctionPlan'] ??
            _formData.underSanctionPlan,
        accToSanctionPlan: widget.appointmentData!['accToSanctionPlan'] ??
            _formData.accToSanctionPlan,
        areaOfPlot: widget.appointmentData!['areaOfPlot'] ??
            _formData.areaOfPlot,
        numberOfFloors: widget.appointmentData!['numberOfFloors'] ??
            _formData.numberOfFloors,
        floorOfFlat: widget.appointmentData!['floorOfFlat'] ??
            _formData.floorOfFlat,
        yearOfConstruction: widget.appointmentData!['yearOfConstruction'] ??
            _formData.yearOfConstruction,
        external: widget.appointmentData!['external'] ?? _formData.external,
        internal: widget.appointmentData!['internal'] ?? _formData.internal,
        flooring: widget.appointmentData!['flooring'] ?? _formData.flooring,
        woodWork: widget.appointmentData!['woodWork'] ?? _formData.woodWork,
        fittings: widget.appointmentData!['fittings'] ?? _formData.fittings,
        personContacted: widget.appointmentData!['personContacted'] ??
            _formData.personContacted,
        rentalRange: widget.appointmentData!['rentalRange'] ??
            _formData.rentalRange,
        marketRate: widget.appointmentData!['marketRate'] ??
            _formData.marketRate,
        rentedArea: widget.appointmentData!['rentedArea'] ??
            _formData.rentedArea,
        commercialArea: widget.appointmentData!['commercialArea'] ??
            _formData.commercialArea,
        overHeadTank: widget.appointmentData!['overHeadTank'] ??
            _formData.overHeadTank,
        pump: widget.appointmentData!['pump'] ?? _formData.pump,
        gpsCoordinates: widget.appointmentData!['gpsCoordinates'] ??
            _formData.gpsCoordinates,
        landmark: widget.appointmentData!['landmark'] ?? _formData.landmark,
        basementAccomodation: widget.appointmentData!['basementAccomodation'] ??
            _formData.basementAccomodation,
        basementActual: widget.appointmentData!['basementActual'] ??
            _formData.basementActual,
        basementPermissible: widget.appointmentData!['basementPermissible'] ??
            _formData.basementPermissible,
        mezzAccomodation: widget.appointmentData!['mezzAccomodation'] ??
            _formData.mezzAccomodation,
        mezzActual: widget.appointmentData!['mezzActual'] ??
            _formData.mezzActual,
        mezzPermissible: widget.appointmentData!['mezzPermissible'] ??
            _formData.mezzPermissible,
        gfAccomodation: widget.appointmentData!['gfAccomodation'] ??
            _formData.gfAccomodation,
        gfActual: widget.appointmentData!['gfActual'] ?? _formData.gfActual,
        gfPermissible: widget.appointmentData!['gfPermissible'] ??
            _formData.gfPermissible,
        ffAccomodation: widget.appointmentData!['ffAccomodation'] ??
            _formData.ffAccomodation,
        ffActual: widget.appointmentData!['ffActual'] ?? _formData.ffActual,
        ffPermissible: widget.appointmentData!['ffPermissible'] ??
            _formData.ffPermissible,
        sfAccomodation: widget.appointmentData!['sfAccomodation'] ??
            _formData.sfAccomodation,
        sfActual: widget.appointmentData!['sfActual'] ?? _formData.sfActual,
        sfPermissible: widget.appointmentData!['sfPermissible'] ??
            _formData.sfPermissible,
        tfAccomodation: widget.appointmentData!['tfAccomodation'] ??
            _formData.tfAccomodation,
        tfActual: widget.appointmentData!['tfActual'] ?? _formData.tfActual,
        tfPermissible: widget.appointmentData!['tfPermissible'] ??
            _formData.tfPermissible,
        applicableRate: widget.appointmentData!['applicableRate'] ??
            _formData.applicableRate,
        twoPropertyDealersName1: widget
            .appointmentData!['twoPropertyDealersName1'] ??
            _formData.twoPropertyDealersName1,
        twoPropertyDealersContact1: widget
            .appointmentData!['twoPropertyDealersContact1'] ??
            _formData.twoPropertyDealersContact1,
        twoPropertyDealersName2: widget
            .appointmentData!['twoPropertyDealersName2'] ??
            _formData.twoPropertyDealersName2,
        twoPropertyDealersContact2: widget
            .appointmentData!['twoPropertyDealersContact2'] ??
            _formData.twoPropertyDealersContact2,
        setBacksFront: widget.appointmentData!['setBacksFront'] ??
            _formData.setBacksFront,
        setBacksRear: widget.appointmentData!['setBacksRear'] ??
            _formData.setBacksRear,
        setBacksSide1: widget.appointmentData!['setBacksSide1'] ??
            _formData.setBacksSide1,
        setBacksSide2: widget.appointmentData!['setBacksSide2'] ??
            _formData.setBacksSide2,
        levelOfDevelopment: widget.appointmentData!['levelOfDevelopment'] ??
            _formData.levelOfDevelopment,
        housesInVicinity: widget.appointmentData!['housesInVicinity'] ??
            _formData.housesInVicinity,
      );
    }

    //  Initialize housesInVicinity from initial data or widget data
    _housesInVicinity = _formData.housesInVicinity ?? 'Yes';

    // Load the auth token from Shared Preferences
    _authToken = _prefs!.getString(keyAccessToken);


    _saveInitialData();
    // Populate controllers with form data
    basementAccomodationController.text = _formData.basementAccomodation ?? '';
    basementActualController.text = _formData.basementActual ?? '';
    basementPermissibleController.text = _formData.basementPermissible ?? '';
    mezzAccomodationController.text = _formData.mezzAccomodation ?? '';
    mezzActualController.text = _formData.mezzActual ?? '';
    mezzPermissibleController.text = _formData.mezzPermissible ?? '';
    gfAccomodationController.text = _formData.gfAccomodation ?? '';
    gfActualController.text = _formData.gfActual ?? '';
    gfPermissibleController.text = _formData.gfPermissible ?? '';
    ffAccomodationController.text = _formData.ffAccomodation ?? '';
    ffActualController.text = _formData.ffActual ?? '';
    ffPermissibleController.text = _formData.ffPermissible ?? '';
    sfAccomodationController.text = _formData.sfAccomodation ?? '';
    sfActualController.text = _formData.sfActual ?? '';
    sfPermissibleController.text = _formData.sfPermissible ?? '';
    tfAccomodationController.text = _formData.tfAccomodation ?? '';
    tfActualController.text = _formData.tfActual ?? '';
    tfPermissibleController.text = _formData.tfPermissible ?? '';
    gpsCoordinatesController.text = _formData.gpsCoordinates ?? '';
    ownerNameController.text = _formData.clientName ?? '';
    propertyAddressController.text = _formData.propertyAddress ?? '';
    inspectionDateController.text =
    _formData.inspectionDate != null ? DateFormat('dd/MM/yyyy').format(
        _formData.inspectionDate!) : '';
    reasonController =
        OwnerReasonController;
    applicableRateController.text = _formData.applicableRate ?? '';
    twoPropertyDealersName1Controller.text =
        _formData.twoPropertyDealersName1 ?? '';
    twoPropertyDealersContact1Controller.text =
        _formData.twoPropertyDealersContact1 ?? '';
    twoPropertyDealersName2Controller.text =
        _formData.twoPropertyDealersName2 ?? '';
    twoPropertyDealersContact2Controller.text =
        _formData.twoPropertyDealersContact2 ?? '';
    setBacksFrontController.text = _formData.setBacksFront ?? '';
    setBacksRearController.text = _formData.setBacksRear ?? '';
    setBacksSide1Controller.text = _formData.setBacksSide1 ?? '';
    setBacksSide2Controller.text = _formData.setBacksSide2 ?? '';
    _levelOfDevelopment = _formData.levelOfDevelopment;
  }

  Future<void> _saveInitialData() async {
    await _prefs?.setString(clientNameKey, _formData.clientName ?? '');
    await _prefs?.setString(
        propertyAddressKey, _formData.propertyAddress ?? '');
    await _prefs?.setString(
        inspectionDateKey, _formData.inspectionDate?.toIso8601String() ?? '');
    await _prefs?.setString(applicableRateKey, _formData.applicableRate ?? '');
    await _prefs?.setString(
        dealerName1Key, _formData.twoPropertyDealersName1 ?? '');
    await _prefs?.setString(
        dealerContact1Key, _formData.twoPropertyDealersContact1 ?? '');
    await _prefs?.setString(
        dealerName2Key, _formData.twoPropertyDealersName2 ?? '');
    await _prefs?.setString(
        dealerContact2Key, _formData.twoPropertyDealersContact2 ?? '');
    await _prefs?.setString(setbacksFrontKey, _formData.setBacksFront ?? '');
    await _prefs?.setString(setbacksRearKey, _formData.setBacksRear ?? '');
    await _prefs?.setString(setbacksSide1Key, _formData.setBacksSide1 ?? '');
    await _prefs?.setString(setbacksSide2Key, _formData.setBacksSide2 ?? '');
    await _prefs?.setString(
        developmentLevelKey, _formData.levelOfDevelopment ?? '');
    await _prefs?.setString(housesVicinityKey, _housesInVicinity);
    await _prefs?.setString(ownershipTypeKey,
        _formData.typeOfOwnership ?? ''); // Save ownership type
    await _prefs?.setString(
        propertyTypeKey, _formData.typeOfProperty ?? ''); // Save property type
    await _prefs?.setString(neighborhoodClassKey,
        _formData.neighborhoodClassification ?? ''); //Save neighborhood
    await _prefs?.setString(occupationStatusKey,
        _formData.occupationStatus ?? ''); //Save occupation status
    await _prefs?.setString(
        propertyUsageKey, _formData.propertyUsage ?? ''); // save property usage
    await _prefs?.setString(locationOfPropertyKey,
        _formData.locationOfProperty ?? ''); // property location
    await _prefs?.setString(externalFinishKey, _formData.external ?? '');
    await _prefs?.setString(internalConditionKey, _formData.internal ?? '');
    await _prefs?.setString(flooringTypeKey, _formData.flooring ?? '');
    await _prefs?.setString(woodworkTypeKey, _formData.woodWork ?? '');
    await _prefs?.setString(fittingsQualityKey, _formData.rentalRange ?? '');
    await _prefs?.setString(
        contactedPersonKey, _formData.personContacted ?? '');
    await _prefs?.setString(rentalRangeKey, _formData.rentalRange ?? '');
    await _prefs?.setString(landMarketRateKey, _formData.marketRate ?? '');
    await _prefs?.setString(rentedAreaKey, _formData.rentedArea ?? '');
    await _prefs?.setString(commercialAreaKey, _formData.commercialArea ?? '');
    await _prefs?.setString(
        overheadTankDetailsKey, _formData.overHeadTank ?? '');
    await _prefs?.setString(overHeadTank, _formData.pump ?? '');
    await _prefs?.setString(gpsCoordinatesKey, _formData.gpsCoordinates ?? '');
    await _prefs?.setString(landmarkKey, _formData.landmark ?? '');
    await _prefs?.setString(keyFormID, _formData.appointment_id ?? '');
    await _prefs?.setString(basementAccommKey,_formData.basementAccomodation ??'');
    await _prefs?.setString(basementActualKey, _formData.basementActual ?? '');
    await _prefs?.setString(basementPermissibleKey,_formData.basementPermissible ?? '');
    await _prefs?.setString(mezzAccommKey, _formData.mezzAccomodation ?? '');
    await _prefs?.setString(mezzActualKey, _formData.mezzActual ?? '');
    await _prefs?.setString(mezzPermissibleKey, _formData.mezzPermissible ?? '');
    await _prefs?.setString(gfAccommKey, _formData.gfAccomodation ?? '');
    await _prefs?.setString(gfPermissibleKey, _formData.gfPermissible ?? '');
    await _prefs?.setString(gfActualKey, _formData.gfActual ?? '');
    await _prefs?.setString(ffAccommKey, _formData.ffAccomodation ?? '');
    await _prefs?.setString(ffActualKey, _formData.ffActual ?? '');
    await _prefs?.setString(ffPermissibleKey, _formData.ffPermissible ?? '');
    await _prefs?.setString(sfAccommKey, _formData.sfAccomodation ?? '');
    await _prefs?.setString(sfActualKey, _formData.sfActual ?? '');



    await _prefs?.setString(structureTypeKey, _formData.typeOfStructure ?? '');
  }

  // Renamed function for clarity
  void _updateVisibleFloors(String? propertyType) {
    setState(() {
      _showNumberOfFloors = true;
      _showFloorAtWhichFlatSituated = true;
      _showFloorwiseInformationTable = true;

      switch (propertyType) {
        case 'Independent Bunglow':
          _visibleFloors = [
            'Basement',
            'Mezzanine',
            'Ground Floor',
            'First Floor',
            'Second Floor',
            'Third Floor'
          ];
          _showNumberOfFloors = false;
          _showFloorAtWhichFlatSituated = false;
          break;
        case 'Pent House':
          _floorLabel = "Floor at which penthouse situated";
          _floorHintText = "Enter Floor at which penthouse situated";
          _showFloorwiseInformationTable = false;
          _visibleFloors = [];
          break;
        case 'Society Flat':
        case 'Bulider Flat':
        case 'DDA Flat':
          _floorLabel = "Floor at which flat situated";
          _floorHintText = "Enter Floor at which flat situated";
          _showFloorwiseInformationTable = false;
          _visibleFloors = [];
          break;
        case 'Office':
          _floorLabel = "Floor at which office situated";
          _floorHintText = "Enter Floor at which office situated";
          _visibleFloors = [
            'Basement',
            'Mezzanine',
            'Ground Floor',
            'First Floor',
            'Second Floor',
            'Third Floor'
          ];
          break;
        default:
          _visibleFloors = [];
      }

      if (propertyType == 'Society Flat' ||
          propertyType == 'Bulider Flat' ||
          propertyType == 'DDA Flat') {
        _showFloorwiseInformationTable = false;
      }
    });
  }

  @override
  void dispose() {
    basementAccomodationController.dispose();
    basementActualController.dispose();
    basementPermissibleController.dispose();
    mezzAccomodationController.dispose();
    mezzActualController.dispose();
    mezzPermissibleController.dispose();
    gfAccomodationController.dispose();
    gfActualController.dispose();
    gfPermissibleController.dispose();
    ffAccomodationController.dispose();
    ffActualController.dispose();
    ffPermissibleController.dispose();
    sfAccomodationController.dispose();
    sfActualController.dispose();
    sfPermissibleController.dispose();
    tfAccomodationController.dispose();
    tfActualController.dispose();
    tfPermissibleController.dispose();
    gpsCoordinatesController.dispose();
    ownerNameController.dispose();
    propertyAddressController.dispose();
    inspectionDateController.dispose();
    applicableRateController.dispose();
    twoPropertyDealersName1Controller.dispose();
    twoPropertyDealersContact1Controller.dispose();
    twoPropertyDealersName2Controller.dispose();
    twoPropertyDealersContact2Controller.dispose();
    setBacksFrontController.dispose();
    setBacksRearController.dispose();
    setBacksSide1Controller.dispose();
    setBacksSide2Controller.dispose();
    OwnerReasonController.dispose();
    super.dispose();
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable them!')));
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _savePersonalInfo() async {
    final url = Uri.parse(Apis.savePersonalInfo);
   var request = http.MultipartRequest("post", url);
   request.fields['appointment_id']=widget.appointmentId.toString();
   request.fields['clientName']=_formData.clientName??"";
   request.fields['propertyAddress']=_formData.propertyAddress??"";
   request.fields['inspectionDate']=_formData.inspectionDate!.toIso8601String();
   request.fields['hasPhotoWithOwner']=_formData.hasPhotoWithOwner == 'Yes' ? "true" : "false";
   request.fields['image_reason']=_formData.OwnerReason??"";
   request.fields['zone']=_formData.zone??"";
   request.fields['typeOfLocality']=_formData.typeOfLocality??"";
   request.fields['typeOfColony']=_formData.typeOfColony??"";
   request.files.add(await http.MultipartFile.fromPath('imageFile',_formData.ownerImagePath!));

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken',
      // Make sure this is the correct format
    };
    final body = jsonEncode({
      'appointment_id': widget.appointmentId, // Add appointment ID
      'clientName': _formData.clientName,
      'propertyAddress': _formData.propertyAddress,
      'inspectionDate': _formData.inspectionDate?.toIso8601String(),
      'hasPhotoWithOwner': _formData.hasPhotoWithOwner == 'Yes' ? "true" : "false",
     // 'image_reason':_formData.image_reason,
      'owner_image':_formData.OwnerReason,
      'zone': _formData.zone,
      'typeOfLocality': _formData.typeOfLocality,
      'typeOfColony': _formData.typeOfColony,

    });


    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
        //allow_redirects: true,  // Try with automatic redirects first
      );


      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        JsonEncoder encoder = const JsonEncoder.withIndent(
            '  '); // Add indent for readability
        String prettyJson = encoder.convert(responseData);

        await _prefs!.setString(
            "appointment_id", responseData['appointment_id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Personal information saved successfully!')));
      } else if (response.statusCode == 302) {
        // --- Manual Redirect Handling ---
        final redirectUrl = response.headers['location'];

        if (redirectUrl != null) {

          try {
            final redirectResponse = await http.get(
              Uri.parse(redirectUrl),
              headers: headers, // Pass the headers including Authorization
            );


            if (redirectResponse.statusCode == 200) {
              final redirectResponseData = jsonDecode(redirectResponse.body);
              // **NEW: Print decoded JSON with indentation for better readability**
              JsonEncoder encoder = const JsonEncoder.withIndent(
                  '  '); // Add indent for readability
              String prettyJson = encoder.convert(redirectResponseData);

              // Success after redirecting!
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                      'Personal information saved successfully ')));
            } else {
              // Handle the error after redirecting
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(
                      'Failed to save data after redirect. Error: ${redirectResponse
                          .statusCode}')));
            }
          } catch (redirectError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error during redirect: $redirectError')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                  'Redirection URL missing in the Location header!')));
        }
      }
      else if (response.statusCode == 401) {
        // Token might be expired
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Session expired. Please login again.')));

      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Failed to save data. Error: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Network error occurred. Please try again.')));
    }
  }

  Future<void> _savePersonalInfo2() async {
    final url = Uri.parse(Apis.savePersonalInfo);

    log("File Path ${_formData.ownerImagePath}");
    final request = http.MultipartRequest("POST", url);
    request.fields['appointment_id'] = widget.appointmentId.toString();
    request.fields['clientName'] = _formData.clientName ?? "";
    request.fields['propertyAddress'] = _formData.propertyAddress ?? "";
    request.fields['inspectionDate'] = _formData.inspectionDate?.toIso8601String() ?? "";
    request.fields['hasPhotoWithOwner'] = _formData.hasPhotoWithOwner??"";
    request.fields['image_reason'] = _formData.OwnerReason ?? "";
    request.fields['zone'] = _formData.zone ?? "";
    request.fields['typeOfLocality'] = _formData.typeOfLocality ?? "";
    request.fields['typeOfColony'] = _formData.typeOfColony ?? "";

    if (_formData.ownerImagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('owner_image', _formData.ownerImagePath!));
    }
    request.headers['Authorization'] = 'Bearer $_authToken';

    print(request.fields);

      final response = await request.send();
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
      //
      // });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);
        await _prefs!.setString("appointment_id", responseData['appointment_id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personal information saved successfully!')),
        );
      } else if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];

        if (redirectUrl != null) {
          try {
            final redirectResponse = await http.get(
              Uri.parse(redirectUrl),
              headers: {'Authorization': 'Bearer $_authToken'},
            );

            if (redirectResponse.statusCode == 200) {

              print(redirectResponse.body);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Personal information saved after redirect!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Redirect failed: ${redirectResponse.statusCode}')),
              );
            }
          } catch (redirectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Redirect error: $redirectError')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Missing redirect URL.')),
          );
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
        // Consider token refresh or redirection to login.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data. Code: ${response.statusCode}')),
        );
      }

  }

  Future<void> _savePropertyInformation() async {
    final url = Uri.parse(Apis.savePropertyInformation);

    String keyFormID = _prefs!.getString("appointment_id") ?? "";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken', // Correct format
    };

    final body = jsonEncode({
      'typeOfOwnership': _formData.typeOfOwnership,
      'typeOfProperty': _formData.typeOfProperty,
      'neighborhoodClassification': _formData.neighborhoodClassification,
      'appointment_id': widget.appointmentId, // Add appointment ID

    });


    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );


      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // **NEW: Print decoded JSON with indentation for better readability**
        JsonEncoder encoder = const JsonEncoder.withIndent(
            '  '); // Add indent for readability
        String prettyJson = encoder.convert(responseData);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Property information saved successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Failed to save property data. Error: ${response
                    .statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Network error occurred. Please try again.')));
    }
  }

  Future<void> _saveLocationInformation() async {
    final url = Uri.parse(Apis.saveLocationInformation);
    String formID = _prefs!.getString("appointment_id") ?? "";


    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken', // Correct format
    };

    final body = jsonEncode({
      'occupationStatus': _formData.occupationStatus,
      'propertyUsage': _formData.propertyUsage,
      'locationOfProperty': _formData.locationOfProperty,
      'howItsCoveredNorth': _formData.howItsCoveredNorth,
      'howItsCoveredSouth': _formData.howItsCoveredSouth,
      'howItsCoveredEast': _formData.howItsCoveredEast,
      'howItsCoveredWest': _formData.howItsCoveredWest,
      'appointment_id': widget.appointmentId, //Add appointment id
    });


    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );


      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);


        JsonEncoder encoder = const JsonEncoder.withIndent(
            '  '); // Add indent for readability
        String prettyJson = encoder.convert(responseData);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location information saved successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Failed to save location data. Error: ${response
                    .statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Network error occurred. Please try again.')));
    }
  }

  Future<void> _saveMoreDetailsInformation() async {
    // Added function for save data
    final url = Uri.parse(Apis.saveMoreDetails);
    String formID = _prefs!.getString("appointment_id") ?? "";


    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken', // Correct format
    };
    final body = jsonEncode({
      'underSanctionPlan': _formData.underSanctionPlan == 'Yes' ? true : false,
      'accToSanctionPlan': _formData.accToSanctionPlan == 'Yes' ? true : false,
      'typeOfStructure': _formData.typeOfStructure,
      'areaOfPlot': _formData.areaOfPlot,
      'numberOfFloors': _formData.numberOfFloors,
      'floorOfFlat': _formData.floorOfFlat,
      'yearOfConstruction': _formData.yearOfConstruction,
      'external': _formData.external,
      'internal': _formData.internal,
      'flooring': _formData.flooring,
      'woodWork': _formData.woodWork,
      'fittings': _formData.fittings,
      'personContacted':_formData.personContacted,
      'rentalRange':_formData.rentalRange,
      'marketRate':_formData.marketRate,
      'rentedArea': _formData.rentedArea,
      'commercialArea': _formData.commercialArea,
      'overHeadTank': _formData.overHeadTank,
      'pump':_formData.pump,
      'gpsCoordinates': _formData.gpsCoordinates,
      'landmark':_formData.landmark,
      'rentalRange': _formData.rentalRange,
      'appointment_id': widget.appointmentId, //Add appointment id
      'basementAccomodation': _formData.basementAccomodation,
      'basementActual': _formData.basementActual,
      'basementPermissible': _formData.basementPermissible,
      'mezzAccomodation': _formData.mezzAccomodation,
      'mezzActual': _formData.mezzActual,
      'mezzPermissible': _formData.mezzPermissible,
      'gfAccomodation': _formData.gfAccomodation,
      'gfActual': _formData.gfActual,
      'gfPermissible': _formData.gfPermissible,
      'ffAccomodation': _formData.ffAccomodation,
      'ffActual': _formData.ffActual,
      'ffPermissible': _formData.ffPermissible,
      'sfAccomodation': _formData.sfAccomodation,
      'sfActual': _formData.sfActual,
      'sfPermissible': _formData.sfPermissible,
      'tfAccomodation': _formData.tfAccomodation,
      'tfActual': _formData.tfActual,
      'tfPermissible': _formData.tfPermissible,
    });

    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );


      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        JsonEncoder encoder = const JsonEncoder.withIndent('  '); //
        Get.to(()=>RoomSelectionPage(appID: widget.appointmentId.toString(),));// Add indent for readability
        String prettyJson = encoder.convert(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Additional details saved successfully!')));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Failed to save Additional details data. Error: ${response
                    .statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Network error occurred. Please try again.')));
    }
  }

  Future<void> _saveAdditionalDetailsInformation() async {
    // Added function for save data
    final url = Uri.parse(Apis.saveAdditionalDetails);
    String formID = _prefs!.getString("appointment_id") ?? "";


    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken', // Correct format
    };
    final body = jsonEncode({
      'appointment_id': widget.appointmentId, //Add appointment id
      'applicableRate': _formData.applicableRate,
      'twoPropertyDealersName1': _formData.twoPropertyDealersName1,
      'twoPropertyDealersContact1': _formData.twoPropertyDealersContact1,
      'twoPropertyDealersName2': _formData.twoPropertyDealersName2,
      'twoPropertyDealersContact2': _formData.twoPropertyDealersContact2,
      'setBacksFront': _formData.setBacksFront,
      'setBacksRear': _formData.setBacksRear,
      'setBacksSide1': _formData.setBacksSide1,
      'setBacksSide2': _formData.setBacksSide2,
      'levelOfDevelopment': _formData.levelOfDevelopment,
      'housesInVicinity': _formData.housesInVicinity,
    });

    print(body);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );


      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);


        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        String prettyJson = encoder.convert(responseData);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Additional details saved successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Failed to save Additional details data. Error: ${response
                    .statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Network error occurred. Please try again.')));
    }
  }

  void _logFormData() {
    final jsonData = jsonEncode(_formData.toJson());
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (pickedFile != null) {
        setState(() {
          var ownerImageFile = File(pickedFile.path);
          _formData.ownerImagePath = pickedFile.path;
          _prefs?.setString(ownerImagePathKey, pickedFile.path);
        });
        widget.onFormDataChange(_formData);
      }
    } catch (e) {
      if (mounted) { // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color(0xFFF9CB47).withOpacity(0.5),
        ),
        backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
        title: const Text('Inspection Form'),
      ),
      body: Stepper(
        currentStep: _currentStepIndex,
        onStepCancel: () {
          if (_currentStepIndex > 0) {
            setState(() {
              _currentStepIndex--;
            });
          }
        },
        onStepContinue: () {
          if (_currentStepIndex < _formSteps.length - 1) {
            if (_formSteps[_currentStepIndex].currentState?.validate() ??
                false) {
              _formSteps[_currentStepIndex].currentState?.save();

              // Log the form data *after* saving the step's data
              _logFormData();

              // Print JSON data after saving each step
              if (_currentStepIndex == 0) {
                // Call API to save personal information
                _savePersonalInfo2();
              }
              if (_currentStepIndex == 1) {
                _savePropertyInformation();
              }
              if (_currentStepIndex == 2) {
                // Save Location Information
                _saveLocationInformation();
              }
              if (_currentStepIndex == 3) {
                // Save More Details Information
                _saveMoreDetailsInformation();
              }

              setState(() {
                _currentStepIndex++;
              });
            }
          } else {
            if (_formSteps[_currentStepIndex].currentState?.validate() ??
                false) {
              _formSteps[_currentStepIndex].currentState?.save();
              _saveAdditionalDetailsInformation();
              _logFormData(); // Log the form data before submitting

              widget.onFormSubmit(_formData);
            }
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStepIndex = step;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              if (_currentStepIndex > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: Text(_currentStepIndex == _formSteps.length - 1
                    ? 'Submit'
                    : 'Continue'),
              ),
            ],
          );
        },
        steps: _buildFormSteps(), // Renamed function
      ),
    );
  }

  List<Step> _buildFormSteps() {
    return [
      Step(
        title: const Text('Personal Information'),
        content: _buildPersonalInformationForm(),
        isActive: _currentStepIndex == 0,
        state: _currentStepIndex > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Property Details'),
        content: _buildPropertyDetailsForm(),
        isActive: _currentStepIndex == 1,
        state: _currentStepIndex > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Location Details'),
        content: _buildLocationDetailsForm(),
        isActive: _currentStepIndex == 2,
        state: _currentStepIndex > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('More Details'),
        content: _buildAdditionalDetailsForm(),
        isActive: _currentStepIndex == 3,
        state: _currentStepIndex >= 3 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Additional Details'),
        content: _buildMoreDetailsForm(),
        isActive: _currentStepIndex == 4,
        state: _currentStepIndex >= 4 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget _buildPersonalInformationForm() {
    return Form(
      key: _formSteps[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("1. Owner Name"),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: TextFormField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                hintText: 'Owner Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter the Owner name' : null,
              onSaved: (value) => _formData.clientName = value,
              onChanged: (value) {
                _formData.clientName = value;
                _prefs?.setString(clientNameKey, value);
                widget.onFormDataChange(_formData);
              },
            ),
          ),

          const SizedBox(height: 16),
          const Text("2. Address"),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: TextFormField(
              controller: propertyAddressController,
              decoration: const InputDecoration(
                hintText: 'Property Address',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter the property address' : null,
              onSaved: (value) => _formData.propertyAddress = value,
              onChanged: (value) {
                _formData.propertyAddress = value;
                _prefs?.setString(propertyAddressKey, value);
                widget.onFormDataChange(_formData);
              },
            ),
          ),

          const SizedBox(height: 16),
          const Text("3. Date"),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: TextFormField(
              controller: inspectionDateController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Date',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _formData.inspectionDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _formData.inspectionDate = pickedDate;
                    inspectionDateController.text =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
                  _prefs?.setString(inspectionDateKey, pickedDate.toIso8601String());
                  widget.onFormDataChange(_formData);
                }
              },
            ),
          ),

          const SizedBox(height: 16),
          const Text("4. Photograph with the owner (Reason and Photo if No)"),
          Row(
            children: [
              Radio<String>(
                value: 'Yes',
                groupValue: _formData.hasPhotoWithOwner,
                onChanged: (value) {
                  setState(() {
                    _formData.hasPhotoWithOwner = value;
                    _formData.OwnerReason = null;
                    _formData.ownerImagePath = null;
                    reasonController.clear();
                    _prefs?.setString(hasPhotoWithOwnerKey, value!);
                    _prefs?.remove(photoWithOwnerReasonKey!);
                    _prefs?.remove(ownerImagePathKey);
                  });
                  widget.onFormDataChange(_formData);
                },
              ),
              const Text('Yes'),
              Radio<String>(
                value: 'No',
                groupValue: _formData.hasPhotoWithOwner,
                onChanged: (value) {
                  setState(() {
                    _formData.hasPhotoWithOwner = value;
                    _prefs?.setString(hasPhotoWithOwnerKey, value!);
                  });
                  widget.onFormDataChange(_formData);
                },
              ),
              const Text('No'),
            ],
          ),

          if (_formData.hasPhotoWithOwner == 'No') ...[
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for no photo',
                hintText: 'Please provide a valid reason',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() => _formData.OwnerReason = text);
                _prefs?.setString(photoWithOwnerReasonKey!, text);
                widget.onFormDataChange(_formData);
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],

          if (_formData.hasPhotoWithOwner == 'Yes') ...[
            const SizedBox(height: 16),
            const Text(
              "Upload supporting image:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_formData.ownerImagePath != null) ...[
              Text("Selected Image:", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(
                    File(_formData.ownerImagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ],

          const SizedBox(height: 16),
          const Text("5. Zone"),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Zone',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: _formData.zone,
              items: const ['Central', 'East', 'West', 'North', 'South', 'Haryana', 'U.P.']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _formData.zone = value;
                    _prefs?.setString(zoneKey, value);
                  });
                  widget.onFormDataChange(_formData);
                }
              },
              validator: (value) => value == null ? 'Please select a zone' : null,
              onSaved: (value) => _formData.zone = value,
            ),
          ),

          const SizedBox(height: 16),
          const Text("6. Type of Locality"),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Locality Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: _formData.typeOfLocality,
              items: const ['Residential', 'Commercial', 'Industrial', 'Agricultural']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _formData.typeOfLocality = value;
                  _prefs?.setString(localityTypeKey, value!);
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) => value == null ? 'Please select a locality' : null,
              onSaved: (value) => _formData.typeOfLocality = value,
            ),
          ),

          const SizedBox(height: 16),
          const Text("7. Type of Colony"),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Colony Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: _formData.typeOfColony,
              items: const ['Authorised', 'UnAuthorised']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _formData.typeOfColony = value;
                  _prefs?.setString(colonyTypeKey, value!);
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) => value == null ? 'Please select type of Colony' : null,
              onSaved: (value) => _formData.typeOfColony = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsForm() {
    return Form(
      key: _formSteps[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("8. Type of Ownership"),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Ownership Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: _formData.typeOfOwnership,
              items: const <String>['Freehold', 'Leasehold']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _formData.typeOfOwnership = newValue;
                  _prefs?.setString(ownershipTypeKey, newValue!);
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) =>
              value == null ? 'Please select type of Ownership' : null,
              onSaved: (String? value) {
                _formData.typeOfOwnership = value;
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text("9. Type of Property"),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Property Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: _formData.typeOfProperty,
              items: const <String>[
                'Independent Bunglow',
                'Pent House',
                'Society Flat',
                'Bulider Flat',
                'DDA Flat',
                'Office'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _formData.typeOfProperty = newValue;
                  _prefs?.setString(propertyTypeKey, newValue!);
                  _updateVisibleFloors(newValue);
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) =>
              value == null ? 'Please select type of Property' : null,
              onSaved: (String? value) {
                _formData.typeOfProperty = value;
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text("10. Neighbourhood Classification"),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Neighbourhood Class',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: _formData.neighborhoodClassification,
              items: const <String>[
                'Posh',
                'Good',
                'Middle',
                'Poor',
                'Upper Middle'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _formData.neighborhoodClassification = newValue;
                  _prefs?.setString(neighborhoodClassKey, newValue!);
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) =>
              value == null
                  ? 'Please select Neighbourhood Classification'
                  : null,
              onSaved: (String? value) {
                _formData.neighborhoodClassification = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDetailsForm() {
    return Form(
        key: _formSteps[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("11. Occupation Status"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Occupation Status',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.occupationStatus,
                items: const <String>[
                  'Self Occupied',
                  'Seller Occupied',
                  'Vacant',
                  'Under Const'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.occupationStatus = newValue;
                    _prefs?.setString(occupationStatusKey, newValue!);
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Occupation Status' : null,
                onSaved: (String? value) {
                  _formData.occupationStatus = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("12. Property Usage"),
                  SizedBox(
                    height: 40,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Select Property Usage',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      value: _formData.propertyUsage,
                      items: const <String>[
                        'Residential',
                        'Commercial',
                        'Rental by Self',
                        'Rented by Seller'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _formData.propertyUsage = newValue;
                          _prefs?.setString(propertyUsageKey, newValue!);
                        });
                        widget.onFormDataChange(_formData);
                      },
                      validator: (value) =>
                      value == null ? 'Please select Property Usage' : null,
                      onSaved: (String? value) {
                        _formData.propertyUsage = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("13. Location Property"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Property Location',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.locationOfProperty,
                items: const <String>[
                  'Corner Plot',
                  'On Main Road',
                  'Inner Lane'
                ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.locationOfProperty = newValue;
                    _prefs?.setString(propertyLocationKey, newValue!);
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Location Property' : null,
                onSaved: (String? value) {
                  _formData.locationOfProperty = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("14. How it is covered on"),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'North',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.howItsCoveredNorth,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter North side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.howItsCoveredNorth = value;
                },
                onChanged: (value) {
                  _formData.howItsCoveredNorth = value;
                  _prefs?.setString(coveredNorthKey, value);
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'South',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.howItsCoveredSouth,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter South side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.howItsCoveredSouth = value;
                },
                onChanged: (value) {
                  _formData.howItsCoveredSouth = value;
                  _prefs?.setString(coveredSouthKey, value);
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'East',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.howItsCoveredEast,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter East side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.howItsCoveredEast = value;
                },
                onChanged: (value) {
                  _formData.howItsCoveredEast = value;
                  _prefs?.setString(coveredEastKey, value);
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'West',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.howItsCoveredWest,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter West side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.howItsCoveredWest = value;
                },
                onChanged: (value) {
                  _formData.howItsCoveredWest = value;
                  _prefs?.setString(coveredWestKey, value);
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildAdditionalDetailsForm() {
    return Form(
        key: _formSteps[3],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("15. If under const,Sanction Plan/Estimate seen"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _formData.underSanctionPlan,
                      onChanged: (value) {
                        setState(() {
                          _formData.underSanctionPlan = value;
                          _prefs?.setString(sanctionPlanSeenKey, value!);
                        });
                        widget.onFormDataChange(_formData);
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _formData.underSanctionPlan,
                      onChanged: (value) {
                        setState(() {
                          _formData.underSanctionPlan = value;
                          _prefs?.setString(sanctionPlanSeenKey, value!);
                        });
                        widget.onFormDataChange(_formData);
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("16. Is const.Acc to Sanction Plan "),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _formData.accToSanctionPlan,
                      onChanged: (value) {
                        setState(() {
                          _formData.accToSanctionPlan = value;
                          _prefs?.setString(accToSanctionPlanKey, value!);
                        });
                        widget.onFormDataChange(_formData);
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _formData.accToSanctionPlan,
                      onChanged: (value) {
                        setState(() {
                          _formData.accToSanctionPlan = value;
                          _prefs?.setString(accToSanctionPlanKey, value!);
                        });
                        widget.onFormDataChange(_formData);
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("17. Type of Structure"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Structure Type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.typeOfStructure,
                // Corrected here
                items: const <String>[
                  'R.C.C.Framed Structure',
                  'Load bearing Wllas'
                ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.typeOfStructure = newValue; // Corrected here
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Structure Type' : null,
                onSaved: (String? value) {
                  _formData.typeOfStructure = value; // Corrected here
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("18. Area of Plot"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Plot Area',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.areaOfPlot,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter area of plot';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.areaOfPlot = value;
                },
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(
                //       RegExp(r'[0-9.]')),
                // ],
                // keyboardType: TextInputType.number,
                onChanged: (value) {
                  _formData.areaOfPlot = value;
                  _prefs?.setString(plotAreaKey, value);
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_showNumberOfFloors)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("19. No of Floors in Building"),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter No. of Floors',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      initialValue: _formData.numberOfFloors,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of floors';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData.numberOfFloors = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _formData.numberOfFloors = value;
                        _prefs?.setString(numFloorsKey, value);
                        widget.onFormDataChange(_formData);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (_showFloorAtWhichFlatSituated)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("20. $_floorLabel"), // Moved Text widget here
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: _floorHintText,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      initialValue: _formData.floorOfFlat,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Floor at which flat situated';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData.floorOfFlat = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _formData.floorOfFlat = value;
                        _prefs?.setString(flatFloorKey, value);
                        widget.onFormDataChange(_formData);
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            if (_showFloorwiseInformationTable)
              _buildFloorwiseInformationTable(),
            const SizedBox(height: 16),
            const Text("22. Year of Construction"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Construction Year',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.yearOfConstruction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year of construction';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.]')),
                ],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _formData.yearOfConstruction = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("23. External"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select External Finish',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.external,
                items: const <String>[
                  'Snowcem',
                  'Grit Wash',
                  'Dholpur',
                  'Marble',
                  'Tiles'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.external = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select external' : null,
                onSaved: (String? value) {
                  _formData.external = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("24. Internal"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Internal Condition',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.internal,
                items: const <String>['Excellent', 'Good', 'Fair', 'Poor']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.internal = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Internal' : null,
                onSaved: (String? value) {
                  _formData.internal = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("25. Flooring"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Flooring Type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.flooring,
                items: const <String>[
                  'Kota',
                  'Granite',
                  'Marble',
                  'Mosaic',
                  'Itallian Marble',
                  'P.C.C.',
                  'V Tiles'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.flooring = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Flooring' : null,
                onSaved: (String? value) {
                  _formData.flooring = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("26. Wood Work"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Wood Work Type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.woodWork,
                items: const <String>[
                  'Panellied',
                  'Glazed',
                  'Teak',
                  'Flush',
                  'Almiraha',
                  'Windows'
                ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.woodWork = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Wood Work' : null,
                onSaved: (String? value) {
                  _formData.woodWork = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("27. Fittings"),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Fittings Quality',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: _formData.fittings,
                items: const <String>['ISI', 'Ordinary', 'Superior']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.fittings = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Fittings' : null,
                onSaved: (String? value) {
                  _formData.fittings = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("28. Person Contacted at Site"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Person Contacted at Site',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.personContacted,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Person Contacted at Site';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.personContacted = value;
                },
                onChanged: (value) {
                  _formData.personContacted = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("29. Rental Range"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Rental Range',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.rentalRange,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Rental Range';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.rentalRange = value;
                },
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(
                //       RegExp(r'[0-9.]')),
                // ],
                // keyboardType: TextInputType.number,
                onChanged: (value) {
                  _formData.rentalRange = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("30. Market Rate of land in locality Area"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Market Rate',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.marketRate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Market Rate of land in locality Area';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.marketRate = value;
                },
                onChanged: (value) {
                  _formData.marketRate = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("31. Rented Area of the Property"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Rented Area',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.rentedArea,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Rented Area of the Property';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.rentedArea = value;
                },
                onChanged: (value) {
                  _formData.rentedArea = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("32. Commercial Area of Property"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Commercial Area',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.commercialArea,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Commercial Area of Property';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.commercialArea = value;
                },
                onChanged: (value) {
                  _formData.commercialArea = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("33. Over Head Tank"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Over Head Tank Details',

                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.overHeadTank,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Over Head Tank';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.overHeadTank = value;
                },
                onChanged: (value) {
                  _formData.overHeadTank = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("34. Pump"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Pump Details',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.pump,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pump';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.pump = value;
                },
                onChanged: (value) {
                  _formData.pump = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("35. GPS Coordinates"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: gpsCoordinatesController,
                decoration: InputDecoration(
                    hintText: 'GPS Coordinates',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    isDense: true,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: () async {
                          Position? position = await _getCurrentLocation();
                          if (position != null) {
                            setState(() {
                              String coordinates =
                                  "${position.latitude}, ${position.longitude}";
                              gpsCoordinatesController.text = coordinates;
                              _formData.gpsCoordinates = coordinates;
                            });
                            widget.onFormDataChange(_formData);
                          }
                          widget.onFormDataChange(_formData);
                        }

                    )),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please get GPS Coordinates';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.gpsCoordinates = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("36. Landmark"),
            SizedBox(
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Landmark',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                initialValue: _formData.landmark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Landmark';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.landmark = value;
                },
                onChanged: (value) {
                  _formData.landmark = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildMoreDetailsForm() {
    return Form(
      key: _formSteps[4],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //36 Number
          Row(
            children: [
              const Expanded(
                child: Text('37. Applicable Rate',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: applicableRateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter rate',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.applicableRate = value;
                    },
                    onChanged: (value) {
                      _formData.applicableRate = value;
                      _prefs?.setString(applicableRateKey, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          //37 Number
          const Text(
            '38. Two Property Dealers',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: twoPropertyDealersName1Controller,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.twoPropertyDealersName1 = value;
                    },
                    onChanged: (value) {
                      _formData.twoPropertyDealersName1 = value;
                      _prefs?.setString(dealerName1Key, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: twoPropertyDealersContact1Controller,
                    decoration: const InputDecoration(
                      hintText: 'Contact No.',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.twoPropertyDealersContact1 = value;
                    },
                    onChanged: (value) {
                      _formData.twoPropertyDealersContact1 = value;
                      _prefs?.setString(dealerContact1Key, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add space between the rows
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: twoPropertyDealersName2Controller,
                    decoration: const InputDecoration(
                      hintText: 'Name', // Changed Label
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.twoPropertyDealersName2 = value;
                    },
                    onChanged: (value) {
                      _formData.twoPropertyDealersName2 = value;
                      _prefs?.setString(dealerName2Key, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: twoPropertyDealersContact2Controller,
                    decoration: const InputDecoration(
                      hintText: 'Contact No.',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.twoPropertyDealersContact2 = value;
                    },
                    onChanged: (value) {
                      _formData.twoPropertyDealersContact2 = value;
                      _prefs?.setString(dealerContact2Key, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),


          const Text(
            '39. Set Backs',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: setBacksFrontController,
                    decoration: const InputDecoration(
                      labelText: 'Front',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.setBacksFront = value;
                    },
                    onChanged: (value) {
                      _formData.setBacksFront = value;
                      _prefs?.setString(setbacksFrontKey, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: setBacksRearController,
                    decoration: const InputDecoration(
                      labelText: 'Rear',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.setBacksRear = value;
                    },
                    onChanged: (value) {
                      _formData.setBacksRear = value;
                      _prefs?.setString(setbacksRearKey, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: setBacksSide1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Side 1',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.setBacksSide1 = value;
                    },
                    onChanged: (value) {
                      _formData.setBacksSide1 = value;
                      _prefs?.setString(setbacksSide1Key, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: setBacksSide2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Side 2',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      _formData.setBacksSide2 = value;
                    },
                    onChanged: (value) {
                      _formData.setBacksSide2 = value;
                      _prefs?.setString(setbacksSide2Key, value);
                      widget.onFormDataChange(_formData);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

         // 39 Number
          const Text(
            '39. Level of Development of Plots',
            style: TextStyle(fontSize: 16),
          ),
          RadioListTile<String>(
            title: const Text('Accessible through metaled/ Macadem Road'),
            value: ' Accessible through metaled/ Macadem Road',
            groupValue: _levelOfDevelopment,
            onChanged: (value) {
              setState(() {
                _levelOfDevelopment = value;
                _formData.levelOfDevelopment = value;
                _prefs?.setString(developmentLevelKey, value!);
              });
              widget.onFormDataChange(_formData);
            },
          ),
          RadioListTile<String>(
            title: const Text(' Is the Plot in developed layout'),
            value: ' Is the Plot in developed layout',
            groupValue: _levelOfDevelopment,
            onChanged: (value) {
              setState(() {
                _levelOfDevelopment = value;
                _formData.levelOfDevelopment = value;
                _prefs?.setString(developmentLevelKey, value!);
              });
              widget.onFormDataChange(_formData);
            },
          ),
          RadioListTile<String>(
            title: const Text(
                ' Is it a clearly demarcated plot or is it a plot of large layout'),
            value: ' Is it a clearly demarcated plot or is it a plot of large layout',
            groupValue: _levelOfDevelopment,
            onChanged: (value) {
              setState(() {
                _levelOfDevelopment = value;
                _formData.levelOfDevelopment = value;
                _prefs?.setString(developmentLevelKey, value!);
              });
              widget.onFormDataChange(_formData);
            },
          ),
          const SizedBox(height: 16),

          //40 Number
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Houses in the vicinity within 1 Km. rad.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              DropdownButton<String>(
                value: _housesInVicinity,
                items: <String>['Yes', 'No'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _housesInVicinity = newValue!;
                    _formData.housesInVicinity = newValue;
                    _prefs?.setString(housesVicinityKey, newValue);
                  });
                  widget.onFormDataChange(_formData);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloorwiseInformationTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '21. Floorwise Built up area of Building',
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columnSpacing: 20.0,
            columns: const [
              DataColumn(label: Expanded(child: Text('Floor'))),
              DataColumn(label: Expanded(child: Text('Accommodation'))),
              DataColumn(label: Expanded(child: Text('Actual'))),
              DataColumn(label: Expanded(child: Text('Permissible'))),
            ],
            rows: [
              if (_visibleFloors.contains('Basement'))
                _buildFloorDataRow(
                  'Basement',
                  basementAccomodationController,
                  basementActualController,
                  basementPermissibleController,
                ),
              if (_visibleFloors.contains('Mezzanine'))
                _buildFloorDataRow(
                  'Mezzanine',
                  mezzAccomodationController,
                  mezzActualController,
                  mezzPermissibleController,
                ),
              if (_visibleFloors.contains('Ground Floor'))
                _buildFloorDataRow(
                  'Ground Floor',
                  gfAccomodationController,
                  gfActualController,
                  gfPermissibleController,
                ),
              if (_visibleFloors.contains('First Floor'))
                _buildFloorDataRow(
                  'First Floor',
                  ffAccomodationController,
                  ffActualController,
                  ffPermissibleController,
                ),
              if (_visibleFloors.contains('Second Floor'))
                _buildFloorDataRow(
                  'Second Floor',
                  sfAccomodationController,
                  sfActualController,
                  sfPermissibleController,
                ),
              if (_visibleFloors.contains('Third Floor'))
                _buildFloorDataRow(
                  'Third Floor',
                  tfAccomodationController,
                  tfActualController,
                  tfPermissibleController,
                ),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _buildFloorDataRow(String floorName,
      TextEditingController accomodationController,
      TextEditingController actualController,
      TextEditingController permissibleController,) {
    return DataRow(
      cells: [
        DataCell(Text(floorName)),
        DataCell(
          SizedBox(
            width: 100.0,
            height: 35,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Accommodation',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 5),
                isDense: true,
              ),
              controller: accomodationController,
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                switch (floorName) {
                  case 'Basement':
                    _formData.basementAccomodation = value;
                    break;
                  case 'Mezzanine':
                    _formData.mezzAccomodation = value;
                    break;
                  case 'Ground Floor':
                    _formData.gfAccomodation = value;
                    break;
                  case 'First Floor':
                    _formData.ffAccomodation = value;
                    break;
                  case 'Second Floor':
                    _formData.sfAccomodation = value;
                    break;
                  case 'Third Floor':
                    _formData.tfAccomodation = value;
                    break;
                }
                widget.onFormDataChange(_formData);
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100.0,
            height: 35,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Actual',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 5),
                isDense: true,
              ),
              controller: actualController,
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                switch (floorName) {
                  case 'Basement':
                    _formData.basementActual = value;
                    break;
                  case 'Mezzanine':
                    _formData.mezzActual = value;
                    break;
                  case 'Ground Floor':
                    _formData.gfActual = value;
                    break;
                  case 'First Floor':
                    _formData.ffActual = value;
                    break;
                  case 'Second Floor':
                    _formData.sfActual = value;
                    break;
                  case 'Third Floor':
                    _formData.tfActual = value;
                    break;
                }
                widget.onFormDataChange(_formData);
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100.0,
            height: 35,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Permissible',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 5),
                isDense: true,
              ),
              controller: permissibleController,
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                switch (floorName) {
                  case 'Basement':
                    _formData.basementPermissible = value;
                    break;
                  case 'Mezzanine':
                    _formData.mezzPermissible = value;
                    break;
                  case 'Ground Floor':
                    _formData.gfPermissible = value;
                    break;
                  case 'First Floor':
                    _formData.ffPermissible = value;
                    break;
                  case 'Second Floor':
                    _formData.sfPermissible = value;
                    break;
                  case 'Third Floor':
                    _formData.tfPermissible = value;
                    break;
                }
                widget.onFormDataChange(_formData);
              },
            ),
          ),),
      ],
    );
  }
}

