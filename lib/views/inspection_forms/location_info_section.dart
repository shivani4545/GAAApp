// field_form/location_info_section.dart
import 'package:flutter/material.dart';
import 'package:gaa_adv/models/appointment_details.dart';

class LocationInfoSection extends StatelessWidget {
  final LocationInfo? initialData;
  final Function(LocationInfo) onUpdate;

  const LocationInfoSection({super.key, this.initialData, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // implement location fields
        Text("Location section here"),
      ],
    );
  }
}