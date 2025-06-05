import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/appointment_details.dart';
import '../service/shared_pref_service.dart';
import '../utils/apis.dart';

class SummaryPage extends StatefulWidget {
  final String appointmentId;
  const SummaryPage({super.key,required this.appointmentId});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {

  AppointmentDetails details = AppointmentDetails();

  Future<void> getSummaryData() async {
    SharedPrefService sharedPrefService = SharedPrefService();
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
    print(token);

    try {
      final uri = Uri.parse(Apis.getAppointmentDetail(widget.appointmentId.toString()));

      final header = {"Authorization": "Bearer $token"};

      final response = await http.get(uri, headers: header);

      print(uri);
   //   log("Detailed Response ${response.body}");
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          details = AppointmentDetails.fromJson(responseData);

        });
      } else {

      }
    } catch (e) {
      Get.snackbar("Error", "${e.toString()}",duration: Duration(seconds: 3));
    }
  }

  @override
  void initState() {
    getSummaryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Personal Info'),
          _infoTile('Client Name', details.personalInfo?.clientName),
          _infoTile('Property Address', details.personalInfo?.propertyAddress),
          _infoTile('Inspection Date', details.personalInfo?.inspectionDate?.toString()),
          _infoTile('Zone', details.personalInfo?.zone),

          _sectionTitle('Property Info'),
          _infoTile('Ownership', details.propertyInfo?.typeOfOwnership),
          _infoTile('Type', details.propertyInfo?.typeOfProperty),

          _sectionTitle('Location Info'),
          _infoTile('Occupation Status', details.locationInfo?.occupationStatus),
          _infoTile('Usage', details.locationInfo?.propertyUsage),
          _infoTile('Location', details.locationInfo?.locationOfProperty),

          _sectionTitle('Room Details'),
          ...(details.roomDetails?.rooms ?? []).map((room) => _infoTile(
            room.roomType ?? 'Room',
            '${room.length} x ${room.width} ${room.unit}',
          )),

          _sectionTitle('Images'),
          if ((details.images ?? []).isEmpty)
            const Text('No images found'),
          if ((details.images ?? []).isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: details.images!.map((img) {
                return Image.network(
                  img,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, _, __) => const Icon(Icons.image_not_supported),
                );
              }).toList(),
            ),

          ExpansionTile(
            title: _sectionTitle('More Details', dense: true),
            children: [
              _infoTile('Area of Plot', details.moreDetails?.areaOfPlot?.toString()),
              _infoTile('Floors', details.moreDetails?.numberOfFloors?.toString()),
              _infoTile('Floor of Flat', details.moreDetails?.floorOfFlat?.toString()),
              _infoTile('Year of Construction', details.moreDetails?.yearOfConstruction?.toString()),
              _infoTile('GPS', details.moreDetails?.gpsCoordinates),
            ],
          ),

          ExpansionTile(
            title: _sectionTitle('Additional Details', dense: true),
            children: [
              _infoTile('Applicable Rate', details.additionalDetails?.applicableRate),
              _infoTile('Dealer 1', details.additionalDetails?.twoPropertyDealersName1),
              _infoTile('Contact 1', details.additionalDetails?.twoPropertyDealersContact1),
              _infoTile('Dealer 2', details.additionalDetails?.twoPropertyDealersName2),
              _infoTile('Contact 2', details.additionalDetails?.twoPropertyDealersContact2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? 'N/A'),
      dense: true,
    );
  }

  Widget _sectionTitle(String title, {bool dense = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 8 : 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
