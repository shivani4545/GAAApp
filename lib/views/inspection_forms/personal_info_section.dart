import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  late TextEditingController ownerNameController;
  late TextEditingController propertyAddressController;
  late TextEditingController inspectionDateController;
  late TextEditingController reasonController;

  late PersonalInfo _formData;

  @override
  void initState() {
    super.initState();
    _formData = widget.initialData ?? PersonalInfo();

    ownerNameController = TextEditingController(text: _formData.clientName ?? '');
    propertyAddressController = TextEditingController(text: _formData.propertyAddress ?? '');
    inspectionDateController = TextEditingController(
      text: _formData.inspectionDate != null
          ? DateFormat('dd/MM/yyyy').format(_formData.inspectionDate!)
          : '',
    );
    reasonController = TextEditingController(text: _formData.imageReason ?? '');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _formData.imagePath = picked.path;
      });
      widget.onUpdate(_formData);
    }
  }

  @override
  void dispose() {
    ownerNameController.dispose();
    propertyAddressController.dispose();
    inspectionDateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("1. Owner Name"),
          const SizedBox(height: 8),
          TextFormField(
            controller: ownerNameController,
            decoration: const InputDecoration(
              hintText: 'Owner Name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter the Owner name' : null,
            onChanged: (value) {
              _formData.clientName = value;
              widget.onUpdate(_formData);
            },
          ),
          const SizedBox(height: 16),

          const Text("2. Address"),
          const SizedBox(height: 8),
          TextFormField(
            controller: propertyAddressController,
            decoration: const InputDecoration(
              hintText: 'Property Address',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter the property address' : null,
            onChanged: (value) {
              _formData.propertyAddress = value;
              widget.onUpdate(_formData);
            },
          ),
          const SizedBox(height: 16),

          const Text("3. Date"),
          const SizedBox(height: 8),
          TextFormField(
            controller: inspectionDateController,
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Date',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _formData.inspectionDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _formData.inspectionDate = pickedDate;
                  inspectionDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                });
                widget.onUpdate(_formData);
              }
            },
          ),
          const SizedBox(height: 16),

          const Text("4. Photograph with the owner"),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: _formData.hasPhotoWithOwner,
                onChanged: (value) {
                  setState(() {
                    _formData.hasPhotoWithOwner = value;
                    _formData.imageReason = null;
                    _formData.imagePath = null;
                    reasonController.clear();
                  });
                  widget.onUpdate(_formData);
                },
              ),
              const Text('Yes'),
              Radio<int>(
                value: 0,
                groupValue: _formData.hasPhotoWithOwner,
                onChanged: (value) {
                  setState(() {
                    _formData.hasPhotoWithOwner = value;
                  });
                  widget.onUpdate(_formData);
                },
              ),
              const Text('No'),
            ],
          ),

          if (_formData.hasPhotoWithOwner == 0) ...[
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for no photo',
                hintText: 'Please provide a valid reason',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                _formData.imageReason = text;
                widget.onUpdate(_formData);
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],

          if (_formData.hasPhotoWithOwner == 1) ...[
            const SizedBox(height: 16),
            const Text("Upload supporting image:", style: TextStyle(fontWeight: FontWeight.bold)),
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
            if (_formData.imagePath != null) ...[
              const SizedBox(height: 10),
              Text("Selected Image:", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Image.file(
                File(_formData.imagePath!),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
          ],

          const SizedBox(height: 16),
          const Text("5. Zone"),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
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
              setState(() => _formData.zone = value);
              widget.onUpdate(_formData);
            },
            validator: (value) => value == null ? 'Please select a zone' : null,
          ),
          const SizedBox(height: 16),

          const Text("6. Type of Locality"),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
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
              setState(() => _formData.typeOfLocality = value);
              widget.onUpdate(_formData);
            },
            validator: (value) => value == null ? 'Please select a locality type' : null,
          ),
          const SizedBox(height: 16),

          const Text("7. Type of Colony"),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
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
              setState(() => _formData.typeOfColony = value);
              widget.onUpdate(_formData);
            },
            validator: (value) => value == null ? 'Please select type of colony' : null,
          ),
        ],
      ),
    );
  }
}
