import 'package:flutter/material.dart';
import 'package:gaa_adv/models/appointment_details.dart';

import 'package:gaa_adv/views/inspection_forms/personal_info_section.dart';
import 'package:gaa_adv/views/inspection_forms/property_info_section.dart';

import 'additional_details_screen.dart';
import 'location_info_section.dart';

class FieldEngineerFormOP extends StatefulWidget {
  final AppointmentDetails? initialData;
  final Function(AppointmentDetails) onFormSubmit;
  final Function(AppointmentDetails) onFormDataChange;

  const FieldEngineerFormOP({
    super.key,
    this.initialData,
    required this.onFormSubmit,
    required this.onFormDataChange,
  });

  @override
  State<FieldEngineerFormOP> createState() => _FieldEngineerFormState();
}

class _FieldEngineerFormState extends State<FieldEngineerFormOP> {
  late AppointmentDetails formData;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    formData = widget.initialData ?? AppointmentDetails();
  }

  void updateForm(AppointmentDetails updatedData) {
    setState(() => formData = updatedData);
    widget.onFormDataChange(formData);
  }

  List<Step> get steps => [
    Step(
      title: const Text("Personal Info"),
      content: PersonalInfoSection(
        initialData: formData.personalInfo,
        onUpdate: (data) {
          formData.personalInfo = data;
          updateForm(formData);
        },
      ),
    ),
    Step(
      title: const Text("Property Info"),
      content: PropertyInfoSection(
        initialData: formData.propertyInfo,
        onUpdate: (data) {
          formData.propertyInfo = data;
          updateForm(formData);
        },
      ),
    ),
    Step(
      title: const Text("Location Info"),
      content: LocationInfoSection(
        initialData: formData.locationInfo,
        onUpdate: (data) {
          formData.locationInfo = data;
          updateForm(formData);
        },
      ),
    ),
    Step(
      title: const Text("Additional Info"),
      content: AdditionalDetailsSection(
        initialData: formData.additionalDetails,
        onUpdate: (data) {
          formData.additionalDetails = data;
          updateForm(formData);
        },
      ),
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Field Engineer Form")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < steps.length - 1) {
            setState(() => _currentStep++);
          } else {
            widget.onFormSubmit(formData);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        steps: steps,
      ),
    );
  }
}
