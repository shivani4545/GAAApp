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
  final AppointmentDetails? initialFormData;
  final Function(AppointmentDetails) onFormSubmit;
  final Function(AppointmentDetails) onFormDataChange;
  final int appointmentId;
  const FieldEngineerForm({
    super.key,
    this.initialFormData,
    required this.onFormSubmit,
    required this.onFormDataChange,
    required this.appointmentId,
  });

  @override
  State<FieldEngineerForm> createState() =>
      _FieldEngineerFormState(); // This is correct now!
}

class _FieldEngineerFormState extends State<FieldEngineerForm> {
  final ImagePicker _picker = ImagePicker();

  // Using a more descriptive name
  final List<GlobalKey<FormState>> _formSteps = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentStepIndex = 0; // Renamed for clarity
  AppointmentDetails _formData = AppointmentDetails();
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
  final northCoverController = TextEditingController();
  final southCoverController = TextEditingController();
  final westCoverController = TextEditingController();
  final eastCoverController = TextEditingController();
  final plotAreaController = TextEditingController();
  final numberOfFloorsController = TextEditingController();
  final floorOfFlatController = TextEditingController();
  final yearOfConstructionController = TextEditingController();
  final personContacted = TextEditingController();
  final rentalRangeController = TextEditingController();
  final marketRateController = TextEditingController();
  final rentedAreaController = TextEditingController();
  final commercialAreaController = TextEditingController();
  final overHeadTankController = TextEditingController();
  final pumpController = TextEditingController();
  final landmarkController = TextEditingController();

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
    setState(() {

      _authToken = _prefs!.getString("access_token");
      _formData = widget.initialFormData ?? AppointmentDetails();
      ownerNameController.value = TextEditingValue(text: _formData.personalInfo?.clientName??"");
      propertyAddressController.value = TextEditingValue(text: _formData.personalInfo?.propertyAddress??"");
      inspectionDateController.value = TextEditingValue(text: _formData.personalInfo?.inspectionDate?.toIso8601String()??"");

      eastCoverController.value = TextEditingValue(text: _formData.locationInfo?.howItsCoveredEast??"");
      westCoverController.value = TextEditingValue(text: _formData.locationInfo?.howItsCoveredWest??"");
      northCoverController.value = TextEditingValue(text: _formData.locationInfo?.howItsCoveredNorth??"");
      southCoverController.value = TextEditingValue(text: _formData.locationInfo?.howItsCoveredSouth??"");

      applicableRateController.value = TextEditingValue(text: _formData.moreDetails?.applicableRate??"");
      twoPropertyDealersName1Controller.value = TextEditingValue(text: _formData.additionalDetails?.twoPropertyDealersName1??"");
      twoPropertyDealersName2Controller.value = TextEditingValue(text: _formData.additionalDetails?.twoPropertyDealersName2??"");
      plotAreaController.value = TextEditingValue(text: _formData.moreDetails?.areaOfPlot??"");
      floorOfFlatController.value = TextEditingValue(text: _formData.moreDetails?.floorOfFlat??"");
      yearOfConstructionController.value = TextEditingValue(text: _formData.moreDetails?.yearOfConstruction??"");
      numberOfFloorsController.value = TextEditingValue(text: _formData.moreDetails?.numberOfFloors??"");
      rentalRangeController.value = TextEditingValue(text: _formData.moreDetails?.rentalRange??"");
      personContacted.value = TextEditingValue(text: _formData.moreDetails?.personContacted??"");
      marketRateController.value = TextEditingValue(text: _formData.moreDetails?.marketRate??"");
      rentedAreaController.value = TextEditingValue(text: _formData.moreDetails?.rentedArea??"");
      commercialAreaController.value = TextEditingValue(text: _formData.moreDetails?.commercialArea??"");
      overHeadTankController.value = TextEditingValue(text: _formData.moreDetails?.overHeadTank??"");
      pumpController.value = TextEditingValue(text: _formData.moreDetails?.pump??"");
      gpsCoordinatesController.value = TextEditingValue(text: _formData.moreDetails?.gpsCoordinates??"");
      landmarkController.value = TextEditingValue(text: _formData.moreDetails?.landmark??"");


      setBacksFrontController.value = TextEditingValue(text: _formData.additionalDetails?.setBacksFront??"");
      setBacksRearController.value = TextEditingValue(text: _formData.additionalDetails?.setBacksRear??"");
      setBacksSide1Controller.value = TextEditingValue(text: _formData.additionalDetails?.setBacksSide1??"");
      setBacksSide2Controller.value = TextEditingValue(text: _formData.additionalDetails?.setBacksSide2??"");
      twoPropertyDealersContact1Controller.value = TextEditingValue(text: _formData.additionalDetails?.twoPropertyDealersContact1??"");
      twoPropertyDealersContact2Controller.value = TextEditingValue(text: _formData.additionalDetails?.twoPropertyDealersContact2??"");

    });
  }


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


  Future<void> _savePersonalInfo2() async {
    final url = Uri.parse(Apis.savePersonalInfo);

    log("File Path ${_formData.personalInfo?.imagePath}");
    final request = http.MultipartRequest("POST", url);
    request.fields['appointment_id']=widget.appointmentId.toString();
    request.fields['clientName']=_formData.personalInfo?.clientName??"";
    request.fields['propertyAddress']=_formData.personalInfo?.propertyAddress??"";
    request.fields['inspectionDate']=_formData.personalInfo?.inspectionDate!.toString()??"";
    request.fields['hasPhotoWithOwner']=_formData.personalInfo?.hasPhotoWithOwner == 'Yes' ? "true" : "false";
    request.fields['image_reason']=_formData.personalInfo?.imageReason??"";
    request.fields['zone']=_formData.personalInfo?.zone??"";
    request.fields['typeOfLocality']=_formData.personalInfo?.typeOfLocality??"";
    request.fields['typeOfColony']=_formData.personalInfo?.typeOfColony??"";

    if (_formData.personalInfo?.imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('owner_image', _formData.personalInfo?.imagePath!??""));
    }
    request.headers['Authorization'] = 'Bearer $_authToken';

    print(request.fields);

      final response = await request.send();


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
    print("Here");
    final url = Uri.parse(Apis.savePropertyInformation);

    String accessToken = _prefs!.getString("access_token") ?? "";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken', // Correct format
    };

    final body = jsonEncode({
      'typeOfOwnership': _formData.propertyInfo?.typeOfOwnership,
      'typeOfProperty': _formData.propertyInfo?.typeOfProperty,
      'neighborhoodClassification': _formData.propertyInfo?.neighborhoodClassification,
      'appointment_id': widget.appointmentId, // Add appointment ID

    });

    print(body);


    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );


      log("property type:${response.body}");
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
      'occupationStatus': _formData.locationInfo?.occupationStatus,
      'propertyUsage': _formData.locationInfo?.propertyUsage,
      'locationOfProperty': _formData.locationInfo?.locationOfProperty,
      'howItsCoveredNorth': _formData.locationInfo?.howItsCoveredNorth,
      'howItsCoveredSouth': _formData.locationInfo?.howItsCoveredSouth,
      'howItsCoveredEast': _formData.locationInfo?.howItsCoveredEast,
      'howItsCoveredWest': _formData.locationInfo?.howItsCoveredWest,
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
      'underSanctionPlan': _formData.moreDetails?.underSanctionPlan == 'Yes' ? true : false,
      'accToSanctionPlan': _formData.moreDetails?.accToSanctionPlan == 'Yes' ? true : false,
     // 'typeOfStructure': _formData.moreDetails?.typeOfStructure,
      'areaOfPlot': _formData.moreDetails?.areaOfPlot,
      'numberOfFloors': _formData.moreDetails?.numberOfFloors,
      'floorOfFlat': _formData.moreDetails?.floorOfFlat,
      'yearOfConstruction': _formData.moreDetails?.yearOfConstruction,
      'external': _formData.moreDetails?.external,
      'internal': _formData.moreDetails?.internal,
      'flooring': _formData.moreDetails?.flooring,
      'woodWork': _formData.moreDetails?.woodWork,
      'fittings': _formData.moreDetails?.fittings,
      'personContacted':_formData.moreDetails?.personContacted,
      'rentalRange':_formData.moreDetails?.rentalRange,
      'marketRate':_formData.moreDetails?.marketRate,
      'rentedArea': _formData.moreDetails?.rentedArea,
      'commercialArea': _formData.moreDetails?.commercialArea,
      'overHeadTank': _formData.moreDetails?.overHeadTank,
      'pump':_formData.moreDetails?.pump,
      'gpsCoordinates': _formData.moreDetails?.gpsCoordinates,
      'landmark':_formData.moreDetails?.landmark,
      'appointment_id': widget.appointmentId, //Add appointment id
      // 'basementAccomodation': _formData.moreDetails?.basementAccomodation,
      // 'basementActual': _formData.moreDetails?.basementActual,
      // 'basementPermissible': _formData.moreDetails?.basementPermissible,
      // 'mezzAccomodation': _formData.moreDetails?.mezzAccomodation,
      // 'mezzActual': _formData.moreDetails?.mezzActual,
      // 'mezzPermissible': _formData.moreDetails?.mezzPermissible,
      // 'gfAccomodation': _formData.moreDetails?.gfAccomodation,
      // 'gfActual': _formData.moreDetails?.gfActual,
      // 'gfPermissible': _formData.moreDetails?.gfPermissible,
      // 'ffAccomodation': _formData.moreDetails?.ffAccomodation,
      // 'ffActual': _formData.moreDetails?.ffActual,
      // 'ffPermissible': _formData.moreDetails?.ffPermissible,
      // 'sfAccomodation': _formData.moreDetails?.sfAccomodation,
      // 'sfActual': _formData.moreDetails?.sfActual,
      // 'sfPermissible': _formData.moreDetails?.sfPermissible,
      // 'tfAccomodation': _formData.moreDetails?.tfAccomodation,
      // 'tfActual': _formData.tfActual,
      // 'tfPermissible': _formData.moreDetails?.tfPermissible,
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
        String prettyJson = encoder.convert(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('More details saved successfully!')));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Failed to save More details data. Error: ${response
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
      'applicableRate': _formData.additionalDetails?.applicableRate,
      'twoPropertyDealersName1': _formData.additionalDetails?.twoPropertyDealersName1,
      'twoPropertyDealersContact1': _formData.additionalDetails?.twoPropertyDealersContact1,
      'twoPropertyDealersName2': _formData.additionalDetails?.twoPropertyDealersName2,
      'twoPropertyDealersContact2': _formData.additionalDetails?.twoPropertyDealersContact2,
      'setBacksFront': _formData.additionalDetails?.setBacksFront,
      'setBacksRear': _formData.additionalDetails?.setBacksRear,
      'setBacksSide1': _formData.additionalDetails?.setBacksSide1,
      'setBacksSide2': _formData.additionalDetails?.setBacksSide2,
      'levelOfDevelopment': _formData.additionalDetails?.levelOfDevelopment,
      'housesInVicinity': _formData.additionalDetails?.housesInVicinity,
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
        Get.to(()=>RoomSelectionPage(appID: widget.appointmentId.toString(),));// Add indent for readability

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
          _formData.personalInfo?.imagePath = pickedFile.path;
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
        content: _buildMoreDetailsForm(),
        isActive: _currentStepIndex == 3,
        state: _currentStepIndex >= 3 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Additional Details'),
        content: _buildAdditionalDetailsForm(),
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
              onSaved: (value) => _formData.personalInfo?.clientName = value,
              onChanged: (value) {
                _formData.personalInfo?.clientName = value;
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
              onSaved: (value) => _formData.personalInfo?.propertyAddress = value,
              onChanged: (value) {
                _formData.personalInfo?.propertyAddress = value;
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
                  initialDate: _formData.personalInfo?.inspectionDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _formData.personalInfo?.inspectionDate = pickedDate;
                    inspectionDateController.text =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
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
                groupValue: _formData.personalInfo?.hasPhotoWithOwner.toString()??"",
                onChanged: (value) {
                  setState(() {
                    _formData.personalInfo?.hasPhotoWithOwner = 1;
                    _formData.personalInfo?.imageReason = null;
                    _formData.personalInfo?.imagePath = null;
                    reasonController.clear();
                  });
                  widget.onFormDataChange(_formData);
                },
              ),
              const Text('Yes'),
              Radio<String>(
                value: 'No',
                groupValue: _formData.personalInfo?.hasPhotoWithOwner.toString()??"",
                onChanged: (value) {
                  setState(() {
                    _formData.personalInfo?.hasPhotoWithOwner = 0;
                  });
                  widget.onFormDataChange(_formData);
                },
              ),
              const Text('No'),
            ],
          ),

          if (_formData.personalInfo?.hasPhotoWithOwner == 0) ...[
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for no photo',
                hintText: 'Please provide a valid reason',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() => _formData.personalInfo?.imageReason = text);
                widget.onFormDataChange(_formData);
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],

          if (_formData.personalInfo?.hasPhotoWithOwner == 1) ...[
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
            if (_formData.personalInfo?.imagePath != null) ...[
              Text("Selected Image:", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.network(
                    _formData.personalInfo!.imagePath??"",
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
              value: _formData.personalInfo?.zone,
              items: const ['Central', 'East', 'West', 'North', 'South', 'Haryana', 'U.P.']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _formData.personalInfo?.zone = value;
                  });
                  widget.onFormDataChange(_formData);
                }
              },
              validator: (value) => value == null ? 'Please select a zone' : null,
              onSaved: (value) => _formData.personalInfo?.zone = value,
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
              value: _formData.personalInfo?.typeOfLocality,
              items: const ['Residential', 'Commercial', 'Industrial', 'Agricultural']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _formData.personalInfo?.typeOfLocality = value;
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) => value == null ? 'Please select a locality' : null,
              onSaved: (value) => _formData.personalInfo?.typeOfLocality = value,
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
              value: _formData.personalInfo?.typeOfColony,
              items: const ['Authorised', 'UnAuthorised']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _formData.personalInfo?.typeOfColony = value;
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) => value == null ? 'Please select type of Colony' : null,
              onSaved: (value) => _formData.personalInfo?.typeOfColony = value,
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
              value: _formData.propertyInfo?.typeOfOwnership,
              items: const <String>['Freehold', 'Leasehold']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _formData.propertyInfo?.typeOfOwnership = newValue;
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) =>
              value == null ? 'Please select type of Ownership' : null,
              onSaved: (String? value) {
                _formData.propertyInfo?.typeOfOwnership = value;
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
              value: _formData.propertyInfo?.typeOfProperty,
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
                  _formData.propertyInfo?.typeOfProperty = newValue;
                  _updateVisibleFloors(newValue);
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) =>
              value == null ? 'Please select type of Property' : null,
              onSaved: (String? value) {
                _formData.propertyInfo?.typeOfProperty = value;
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
              value: _formData.propertyInfo?.neighborhoodClassification,
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
                  _formData.propertyInfo?.neighborhoodClassification = newValue;
                });
                widget.onFormDataChange(_formData);
              },
              validator: (value) =>
              value == null
                  ? 'Please select Neighbourhood Classification'
                  : null,
              onSaved: (String? value) {
                _formData.propertyInfo?.neighborhoodClassification = value;
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
                value: _formData.locationInfo?.occupationStatus,
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
                    _formData.locationInfo?.occupationStatus = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Occupation Status' : null,
                onSaved: (String? value) {
                  _formData.locationInfo?.occupationStatus = value;
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
                      value: _formData.locationInfo?.propertyUsage,
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
                          _formData.locationInfo?.propertyUsage = newValue;
                        });
                        widget.onFormDataChange(_formData);
                      },
                      validator: (value) =>
                      value == null ? 'Please select Property Usage' : null,
                      onSaved: (String? value) {
                        _formData.locationInfo?.propertyUsage = value;
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
                value: _formData.locationInfo?.locationOfProperty,
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
                    _formData.locationInfo?.locationOfProperty = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Location Property' : null,
                onSaved: (String? value) {
                  _formData.locationInfo?.locationOfProperty = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("14. How it is covered on"),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: northCoverController,
                decoration: const InputDecoration(
                  hintText: 'North',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter North side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.locationInfo?.howItsCoveredNorth = value;
                },
                onChanged: (value) {
                  _formData.locationInfo?.howItsCoveredNorth = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: southCoverController,
                decoration: const InputDecoration(
                  hintText: 'South',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter South side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.locationInfo?.howItsCoveredSouth = value;
                },
                onChanged: (value) {
                  _formData.locationInfo?.howItsCoveredSouth = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: eastCoverController,
                decoration: const InputDecoration(
                  hintText: 'East',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter East side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.locationInfo?.howItsCoveredEast = value;
                },
                onChanged: (value) {
                  _formData.locationInfo?.howItsCoveredEast = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: westCoverController,
                decoration: const InputDecoration(
                  hintText: 'West',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter West side area covered on';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.locationInfo?.howItsCoveredWest = value;
                },
                onChanged: (value) {
                  _formData.locationInfo?.howItsCoveredWest = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildMoreDetailsForm() {
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
                      groupValue: _formData.moreDetails?.underSanctionPlan==1?"Yes":"No",
                      onChanged: (value) {
                        setState(() {
                          _formData.moreDetails?.underSanctionPlan = value=="Yes"?1:0;
                        });
                        widget.onFormDataChange(_formData);
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _formData.moreDetails?.underSanctionPlan==1?"Yes":"No",
                      onChanged: (value) {
                        setState(() {
                          _formData.moreDetails?.underSanctionPlan = value=="Yes"?1:0;
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
                      groupValue: _formData.moreDetails?.accToSanctionPlan==1?"Yes":"No",
                      onChanged: (value) {
                        setState(() {
                          _formData.moreDetails?.accToSanctionPlan = value=="Yes"?1:0;
                        });
                        widget.onFormDataChange(_formData);
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _formData.moreDetails?.accToSanctionPlan==1?"Yes":"No",
                      onChanged: (value) {
                        setState(() {
                          _formData.moreDetails?.accToSanctionPlan = value=="Yes"?1:0;
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
            // SizedBox(
            //   height: 40,
            //   child: DropdownButtonFormField<String>(
            //     decoration: const InputDecoration(
            //       hintText: 'Select Structure Type',
            //       border: OutlineInputBorder(),
            //       contentPadding: EdgeInsets.symmetric(
            //           horizontal: 12, vertical: 8),
            //       isDense: true,
            //     ),
            //     value: _formData.moreDetails?.typeOfStructure,
            //     // Corrected here
            //     items: const <String>[
            //       'R.C.C.Framed Structure',
            //       'Load bearing Wllas'
            //     ]
            //         .map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _formData.moreDetails?.typeOfStructure = newValue; // Corrected here
            //       });
            //       widget.onFormDataChange(_formData);
            //     },
            //     validator: (value) =>
            //     value == null ? 'Please select Structure Type' : null,
            //     onSaved: (String? value) {
            //       _formData.moreDetails?.typeOfStructure = value; // Corrected here
            //     },
            //   ),
            // ),
            const SizedBox(height: 16),
            const Text("18. Area of Plot"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: plotAreaController,
                decoration: const InputDecoration(
                  hintText: 'Enter Plot Area',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter area of plot';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.additionalDetails?.areaOfPlot = value;
                },

                onChanged: (value) {
                  _formData.additionalDetails?.areaOfPlot = value;

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
                      controller: numberOfFloorsController,
                      decoration: const InputDecoration(
                        hintText: 'Enter No. of Floors',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of floors';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData.additionalDetails?.numberOfFloors = value;

                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _formData.additionalDetails?.numberOfFloors = value;
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
                      controller: floorOfFlatController,
                      decoration: InputDecoration(
                        hintText: _floorHintText,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Floor at which flat situated';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData.additionalDetails?.floorOfFlat = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _formData.additionalDetails?.floorOfFlat = value;
                        widget.onFormDataChange(_formData);
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // if (_showFloorwiseInformationTable)
            //   _buildFloorwiseInformationTable(),
            const SizedBox(height: 16),
            const Text("22. Year of Construction"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: yearOfConstructionController,
                decoration: const InputDecoration(
                  hintText: 'Enter Construction Year',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
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
                  _formData.moreDetails?.yearOfConstruction = value;
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
                value: _formData.moreDetails?.external,
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
                    _formData.moreDetails?.external = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select external' : null,
                onSaved: (String? value) {
                  _formData.moreDetails?.external = value;
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
                value: _formData.moreDetails?.internal,
                items: const <String>['Excellent', 'Good', 'Fair', 'Poor']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.moreDetails?.internal = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Internal' : null,
                onSaved: (String? value) {
                  _formData.moreDetails?.internal = value;
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
                value: _formData.moreDetails?.flooring,
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
                    _formData.moreDetails?.flooring = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Flooring' : null,
                onSaved: (String? value) {
                  _formData.moreDetails?.flooring = value;
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
                value: _formData.moreDetails?.woodWork,
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
                    _formData.moreDetails?.woodWork = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Wood Work' : null,
                onSaved: (String? value) {
                  _formData.moreDetails?.woodWork = value;
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
                value: _formData.moreDetails?.fittings,
                items: const <String>['ISI', 'Ordinary', 'Superior']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _formData.moreDetails?.fittings = newValue;
                  });
                  widget.onFormDataChange(_formData);
                },
                validator: (value) =>
                value == null ? 'Please select Fittings' : null,
                onSaved: (String? value) {
                  _formData.moreDetails?.fittings = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("28. Person Contacted at Site"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: personContacted,
                decoration: const InputDecoration(
                  hintText: 'Enter Person Contacted at Site',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Person Contacted at Site';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.personContacted = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.personContacted = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("29. Rental Range"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: rentalRangeController,
                decoration: const InputDecoration(
                  hintText: 'Enter Rental Range',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Rental Range';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.rentalRange = value;
                },

                onChanged: (value) {
                  _formData.moreDetails?.rentalRange = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("30. Market Rate of land in locality Area"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: marketRateController,
                decoration: const InputDecoration(
                  hintText: 'Enter Market Rate',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Market Rate of land in locality Area';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.marketRate = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.marketRate = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("31. Rented Area of the Property"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: rentedAreaController,
                decoration: const InputDecoration(
                  hintText: 'Enter Rented Area',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Rented Area of the Property';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.rentedArea = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.rentedArea = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("32. Commercial Area of Property"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: commercialAreaController,
                decoration: const InputDecoration(
                  hintText: 'Enter Commercial Area',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Commercial Area of Property';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.commercialArea = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.commercialArea = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("33. Over Head Tank"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: overHeadTankController,
                decoration: const InputDecoration(
                  hintText: 'Enter Over Head Tank Details',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Over Head Tank';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.overHeadTank = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.overHeadTank = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("34. Pump"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: pumpController,
                decoration: const InputDecoration(
                  hintText: 'Enter Pump Details',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pump';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.pump = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.pump = value;
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
                              _formData.moreDetails?.gpsCoordinates = coordinates;
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
                  _formData.moreDetails?.gpsCoordinates = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text("36. Landmark"),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: landmarkController,
                decoration: const InputDecoration(
                  hintText: 'Enter Landmark',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Landmark';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData.moreDetails?.landmark = value;
                },
                onChanged: (value) {
                  _formData.moreDetails?.landmark = value;
                  widget.onFormDataChange(_formData);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildAdditionalDetailsForm() {
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
                      _formData.moreDetails?.applicableRate = value;
                    },
                    onChanged: (value) {
                      _formData.moreDetails?.applicableRate = value;
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
                      _formData.additionalDetails?.twoPropertyDealersName1 = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.twoPropertyDealersName1 = value;
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
                      _formData.additionalDetails?.twoPropertyDealersContact1 = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.twoPropertyDealersContact1 = value;
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
                      _formData.additionalDetails?.twoPropertyDealersName2 = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.twoPropertyDealersName2 = value;
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
                      _formData.additionalDetails?.twoPropertyDealersContact2 = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.twoPropertyDealersContact2 = value;
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
                      _formData.additionalDetails?.setBacksFront = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.setBacksFront = value;
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
                      _formData.additionalDetails?.setBacksRear = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.setBacksRear = value;
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
                      _formData.additionalDetails?.setBacksSide1 = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.setBacksSide1 = value;
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
                      _formData.additionalDetails?.setBacksSide2 = value;
                    },
                    onChanged: (value) {
                      _formData.additionalDetails?.setBacksSide2 = value;
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
                _formData.additionalDetails?.levelOfDevelopment = value;
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
                _formData.additionalDetails?.levelOfDevelopment = value;
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
                _formData.additionalDetails?.levelOfDevelopment = value;
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
                    _formData.additionalDetails?.housesInVicinity = newValue;
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

  // Widget _buildFloorwiseInformationTable() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         '21. Floorwise Built up area of Building',
  //       ),
  //       SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: DataTable(
  //           border: TableBorder.all(),
  //           columnSpacing: 20.0,
  //           columns: const [
  //             DataColumn(label: Expanded(child: Text('Floor'))),
  //             DataColumn(label: Expanded(child: Text('Accommodation'))),
  //             DataColumn(label: Expanded(child: Text('Actual'))),
  //             DataColumn(label: Expanded(child: Text('Permissible'))),
  //           ],
  //           rows: [
  //             if (_visibleFloors.contains('Basement'))
  //               _buildFloorDataRow(
  //                 'Basement',
  //                 basementAccomodationController,
  //                 basementActualController,
  //                 basementPermissibleController,
  //               ),
  //             if (_visibleFloors.contains('Mezzanine'))
  //               _buildFloorDataRow(
  //                 'Mezzanine',
  //                 mezzAccomodationController,
  //                 mezzActualController,
  //                 mezzPermissibleController,
  //               ),
  //             if (_visibleFloors.contains('Ground Floor'))
  //               _buildFloorDataRow(
  //                 'Ground Floor',
  //                 gfAccomodationController,
  //                 gfActualController,
  //                 gfPermissibleController,
  //               ),
  //             if (_visibleFloors.contains('First Floor'))
  //               _buildFloorDataRow(
  //                 'First Floor',
  //                 ffAccomodationController,
  //                 ffActualController,
  //                 ffPermissibleController,
  //               ),
  //             if (_visibleFloors.contains('Second Floor'))
  //               _buildFloorDataRow(
  //                 'Second Floor',
  //                 sfAccomodationController,
  //                 sfActualController,
  //                 sfPermissibleController,
  //               ),
  //             if (_visibleFloors.contains('Third Floor'))
  //               _buildFloorDataRow(
  //                 'Third Floor',
  //                 tfAccomodationController,
  //                 tfActualController,
  //                 tfPermissibleController,
  //               ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // DataRow _buildFloorDataRow(String floorName,
  //     TextEditingController accomodationController,
  //     TextEditingController actualController,
  //     TextEditingController permissibleController,) {
  //   return DataRow(
  //     cells: [
  //       DataCell(Text(floorName)),
  //       DataCell(
  //         SizedBox(
  //           width: 100.0,
  //           height: 35,
  //           child: TextFormField(
  //             decoration: const InputDecoration(
  //               hintText: 'Enter Accommodation',
  //               border: OutlineInputBorder(),
  //               contentPadding: EdgeInsets.symmetric(
  //                   horizontal: 8, vertical: 5),
  //               isDense: true,
  //             ),
  //             controller: accomodationController,
  //             style: const TextStyle(fontSize: 14),
  //             onChanged: (value) {
  //               switch (floorName) {
  //                 case 'Basement':
  //                   _formData.moreDetails?.basementAccomodation = value;
  //                   break;
  //                 case 'Mezzanine':
  //                   _formData.moreDetails?.mezzAccomodation = value;
  //                   break;
  //                 case 'Ground Floor':
  //                   _formData.moreDetails?.gfAccomodation = value;
  //                   break;
  //                 case 'First Floor':
  //                   _formData.moreDetails?.ffAccomodation = value;
  //                   break;
  //                 case 'Second Floor':
  //                   _formData.moreDetails?.sfAccomodation = value;
  //                   break;
  //                 case 'Third Floor':
  //                   _formData.moreDetails?.tfAccomodation = value;
  //                   break;
  //               }
  //               widget.onFormDataChange(_formData);
  //             },
  //           ),
  //         ),
  //       ),
  //       DataCell(
  //         SizedBox(
  //           width: 100.0,
  //           height: 35,
  //           child: TextFormField(
  //             decoration: const InputDecoration(
  //               hintText: 'Enter Actual',
  //               border: OutlineInputBorder(),
  //               contentPadding: EdgeInsets.symmetric(
  //                   horizontal: 8, vertical: 5),
  //               isDense: true,
  //             ),
  //             controller: actualController,
  //             style: const TextStyle(fontSize: 14),
  //             onChanged: (value) {
  //               switch (floorName) {
  //                 case 'Basement':
  //                   _formData.moreDetails?.basementActual = value;
  //                   break;
  //                 case 'Mezzanine':
  //                   _formData.moreDetails?.mezzActual = value;
  //                   break;
  //                 case 'Ground Floor':
  //                   _formData.moreDetails?.gfActual = value;
  //                   break;
  //                 case 'First Floor':
  //                   _formData.moreDetails?.ffActual = value;
  //                   break;
  //                 case 'Second Floor':
  //                   _formData.moreDetails?.sfActual = value;
  //                   break;
  //                 case 'Third Floor':
  //                   _formData.moreDetails?.tfActual = value;
  //                   break;
  //               }
  //               widget.onFormDataChange(_formData);
  //             },
  //           ),
  //         ),
  //       ),
  //       DataCell(
  //         SizedBox(
  //           width: 100.0,
  //           height: 35,
  //           child: TextFormField(
  //             decoration: const InputDecoration(
  //               hintText: 'Enter Permissible',
  //               border: OutlineInputBorder(),
  //               contentPadding: EdgeInsets.symmetric(
  //                   horizontal: 8, vertical: 5),
  //               isDense: true,
  //             ),
  //             controller: permissibleController,
  //             style: const TextStyle(fontSize: 14),
  //             onChanged: (value) {
  //               switch (floorName) {
  //                 case 'Basement':
  //                   _formData.moreDetails?.basementPermissible = value;
  //                   break;
  //                 case 'Mezzanine':
  //                   _formData.moreDetails?.mezzPermissible = value;
  //                   break;
  //                 case 'Ground Floor':
  //                   _formData.moreDetails?.gfPermissible = value;
  //                   break;
  //                 case 'First Floor':
  //                   _formData.moreDetails?.ffPermissible = value;
  //                   break;
  //                 case 'Second Floor':
  //                   _formData.moreDetails?.sfPermissible = value;
  //                   break;
  //                 case 'Third Floor':
  //                   _formData.moreDetails?.tfPermissible = value;
  //                   break;
  //               }
  //               widget.onFormDataChange(_formData);
  //             },
  //           ),
  //         ),),
  //     ],
  //   );
  // }
}

