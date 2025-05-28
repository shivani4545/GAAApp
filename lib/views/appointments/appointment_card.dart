import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/upcoming_appointments.dart';

class AppointmentCard extends StatelessWidget {
  final UpcomingAppointments upcomingAppointments;
  final VoidCallback onStartInspection;


  const AppointmentCard({
    super.key,
    required this.upcomingAppointments,
    required this.onStartInspection
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Appointment ID", upcomingAppointments.id.toString()),
            _buildRow("Customer Name", upcomingAppointments.clientName1??"NA"),
            _buildRow("Address", upcomingAppointments.addressLine1??"${upcomingAppointments.addressLine2}"??""),
            _buildRow("Visit Date & Time", "${DateFormat("dd-MM-yyyy").format(upcomingAppointments.dateOfAvailability!)}: ${upcomingAppointments.timeOfAvailability}"),
            _buildRow("Contact Number", upcomingAppointments.phone??"NA"),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onStartInspection,
                icon: const Icon(Icons.play_arrow,color: Colors.white,),
                label: const Text("Start Inspection",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9CB47),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
