// field_form/property_info_section.dart
import 'package:flutter/material.dart';
import 'package:gaa_adv/models/appointment_details.dart';

class PropertyInfoSection extends StatefulWidget {
  final PropertyInfo? initialData;
  final Function(PropertyInfo) onUpdate;

  const PropertyInfoSection({super.key, this.initialData, required this.onUpdate});

  @override
  State<PropertyInfoSection> createState() => _PropertyInfoSectionState();
}

class _PropertyInfoSectionState extends State<PropertyInfoSection> {
  late TextEditingController propertyType;
  late TextEditingController ownershipType;

  @override
  void initState() {
    super.initState();
    propertyType = TextEditingController(text: widget.initialData?.typeOfProperty ?? '');
    ownershipType = TextEditingController(text: widget.initialData?.typeOfOwnership ?? '');
  }

  void _update() {
    widget.onUpdate(PropertyInfo(
      typeOfProperty: propertyType.text,
      typeOfOwnership: ownershipType.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: propertyType,
          decoration: const InputDecoration(labelText: 'Property Type'),
          onChanged: (_) => _update(),
        ),
        TextField(
          controller: ownershipType,
          decoration: const InputDecoration(labelText: 'Ownership Type'),
          onChanged: (_) => _update(),
        ),
      ],
    );
  }
}