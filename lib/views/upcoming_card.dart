import 'package:flutter/material.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/inspection_data_form.dart';
import 'camera_screen.dart';
import 'field_engineer_form.dart';

class UpcomingCard extends StatelessWidget {
  final UpcomingAppointments upcomingAppointment;

  const UpcomingCard({Key? key, required this.upcomingAppointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Client Name", upcomingAppointment.clientName1 ?? "NA"),
            _buildRow("Id", upcomingAppointment.id?.toString() ?? "NA"),
            _buildRow("Contact", upcomingAppointment.phone?.toString() ?? "NA"),
            _buildAddressRow(
                "Address",
                "${upcomingAppointment.addressLine1 ?? 'NA'}, ${upcomingAppointment.addressLine2 ?? 'NA'}"),
            _buildRow(
              "Date",
              upcomingAppointment.dateOfAvailability != null
                  ? DateFormat('dd/MM/yyyy')
                  .format(upcomingAppointment.dateOfAvailability!)
                  : "NA",
            ),
            _buildRow(
              "Time",
              upcomingAppointment.timeOfAvailability != null
                  ? _formatTime(upcomingAppointment.timeOfAvailability!)
                  : "NA",
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _makePhoneCall(upcomingAppointment.phone);
                    },
                    child: const Text("Call"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Check if appointmentId is not null before navigating
                      if (upcomingAppointment.id != null) {
                        Get.to(() => FieldEngineerForm(
                          appointmentData:
                          _prepareAppointmentData(upcomingAppointment),
                          appointmentId: upcomingAppointment.id!, // Use ! to assert that it's not null
                          initialFormData: InspectionFormData(
                            clientName: upcomingAppointment.clientName1,
                            propertyAddress:
                            "${upcomingAppointment.addressLine1 ?? ''}, ${upcomingAppointment.addressLine2 ?? ''}",
                          ),
                          onFormSubmit: (formData) {
                            Get.back();
                            Get.snackbar("Success", "Inspection Completed!");
                          },
                          onFormDataChange: (formData) { // Provide the onFormDataChange callback
                            // Handle form data changes (e.g., save to local storage)
                            print("Form data changed: $formData");
                          }, MediaType: null,
                        ));
                      } else {
                        // Handle the case where the appointment ID is missing
                        Get.snackbar("Error", "Appointment ID is missing.");
                      }
                    },
                    child: const Text("Inspect"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to prepare appointment data
  Map<String, dynamic> _prepareAppointmentData(
      UpcomingAppointments appointment) {
    return {
      'clientName': appointment.clientName1 ?? '',
      'propertyAddress':
      "${appointment.addressLine1 ?? ''}, ${appointment.addressLine2 ?? ''}",
      'inspectionDate': appointment.dateOfAvailability?.toIso8601String(),
    };
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label + ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label + ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(timeString);
      final formattedTime = DateFormat("HH:mm").format(parsedTime);
      return formattedTime;
    } catch (e) {
      print("Error parsing time: $e");
      return "NA";
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final formattedPhoneNumber =
      phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      final Uri launchUri = Uri(scheme: 'tel', path: formattedPhoneNumber);

      try {
        final bool nativeAppLaunchSuccess = await launchUrl(
          launchUri,
          mode: LaunchMode.externalApplication,
        );
        if (!nativeAppLaunchSuccess) {
          Get.snackbar("Error", "Could not launch $launchUri");
          print('Could not launch $launchUri');
        }
      } catch (e) {
        Get.snackbar("Error", "An error occurred while launching the call: $e");
        print('An error occurred while launching the call: $e');
      }
    } else {
      Get.snackbar("Error", "Phone number is not available");
      print("Phone number is not available");
    }
  }
}