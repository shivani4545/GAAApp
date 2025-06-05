// field_form/personal_info_section.dart
import 'package:flutter/material.dart';
import 'package:gaa_adv/models/appointment_details.dart';

class PersonalInfoSection extends StatefulWidget {
  final PersonalInfo? initialData;
  final Function(PersonalInfo) onUpdate;

  const PersonalInfoSection({
    super.key,
    this.initialData,
    required this.onUpdate,
  });

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController clientName;
  late TextEditingController propertyAddress;

  @override
  void initState() {
    super.initState();
    clientName = TextEditingController(text: widget.initialData?.clientName ?? '');
    propertyAddress = TextEditingController(text: widget.initialData?.propertyAddress ?? '');
  }

  void _update() {
    widget.onUpdate(PersonalInfo(
      clientName: clientName.text,
      propertyAddress: propertyAddress.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _update,
      child: Column(
        children: [
          TextFormField(
            controller: clientName,
            decoration: const InputDecoration(labelText: 'Client Name'),
          ),
          TextFormField(
            controller: propertyAddress,
            decoration: const InputDecoration(labelText: 'Property Address'),
          ),
        ],
      ),
    );
  }
}

