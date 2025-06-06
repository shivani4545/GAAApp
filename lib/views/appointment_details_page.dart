import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/views/field_engineer_form.dart';
import 'package:gaa_adv/views/room_selection_page.dart';
import 'package:intl/intl.dart';
import '../models/appointment_details.dart';
import 'package:get/get.dart';
class AppointmentDetailsPage extends StatelessWidget {
  final AppointmentDetails details;
  final String appID;

  const AppointmentDetailsPage({super.key, required this.details,required this.appID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment #${details.personalInfo?.caseId ?? ''}'),
        backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (details.personalInfo != null)
              _buildPersonalInfo(context, details.personalInfo!),

            const SizedBox(height: 16),
            if (details.propertyInfo != null)
              _buildPropertyInfo(context, details.propertyInfo!),
            const SizedBox(height: 16),
            if (details.locationInfo != null)
              _buildLocationInfo(context, details.locationInfo!),

            const SizedBox(height: 16),
            if (details.moreDetails != null)
              _buildMoreDetails(context, details.moreDetails!),
            const SizedBox(height: 16),
            if (details.additionalDetails != null)
              _buildAdditionalDetails(context, details.additionalDetails!),

            const SizedBox(height: 16),
            if (details.roomDetails != null &&
                details.roomDetails!.rooms != null &&
                details.roomDetails!.rooms!.isNotEmpty)
              _buildRoomDetails(context, details.roomDetails!),

            const SizedBox(height: 16),

              _buildImageGallery(context, details.images!),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for Building Sections ---

  Widget _buildPersonalInfo(BuildContext context, PersonalInfo info) {
    final appController  = Get.find<AppointmentController>();

    return _SectionCard(
      title: 'Personal Information',
      onEditCall: () {
        appController.resumeInspection(appID);
      },
      children: [
        if (info.ownerImage != null && info.ownerImage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(info.ownerImage!),
                onBackgroundImageError: (exception, stackTrace) =>
                const Icon(Icons.person, size: 50),
              ),
            ),
          ),
        _DetailRow(label: 'Client Name', value: info.clientName),
        _DetailRow(label: 'Property Address', value: info.propertyAddress),
        _DetailRow(
          label: 'Inspection Date',
          value: info.inspectionDate != null
              ? DateFormat.yMMMMd().format(info.inspectionDate!)
              : null,
        ),
        _DetailRow(label: 'Type of Locality', value: info.typeOfLocality),
        _DetailRow(label: 'Zone', value: info.zone),
        _DetailRow(label: 'Type of Colony', value: info.typeOfColony),
      ],
    );
  }

  Widget _buildImageGallery(BuildContext context, List<dynamic> images) {
    final appController  = Get.find<AppointmentController>();

    return _SectionCard(
      title: 'Property Images',
      onEditCall: () {
        appController.resumeInspection(appID);
      },
      children: [
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              // Assuming images are strings (URLs)
              final imageUrl = images[index].toString();
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 200,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey, size: 40),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyInfo(BuildContext context, PropertyInfo info) {
    return _SectionCard(
      title: 'Property Information',
      onEditCall: () {
        Get.to(()=>FieldEngineerForm(onFormSubmit: (formData){}, onFormDataChange: (form){}, appointmentId: details.personalInfo!.caseId!));

      },
      children: [
        _DetailRow(label: 'Type of Ownership', value: info.typeOfOwnership),
        _DetailRow(label: 'Type of Property', value: info.typeOfProperty),
        _DetailRow(
            label: 'Neighborhood Classification',
            value: info.neighborhoodClassification),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context, LocationInfo info) {
    return _SectionCard(
      title: 'Location Information',
      onEditCall: () {  },
      children: [
        _DetailRow(label: 'Occupation Status', value: info.occupationStatus),
        _DetailRow(label: 'Property Usage', value: info.propertyUsage),
        _DetailRow(label: 'Location of Property', value: info.locationOfProperty),
        _DetailRow(label: 'Boundary: North', value: info.howItsCoveredNorth),
        _DetailRow(label: 'Boundary: South', value: info.howItsCoveredSouth),
        _DetailRow(label: 'Boundary: East', value: info.howItsCoveredEast),
        _DetailRow(label: 'Boundary: West', value: info.howItsCoveredWest),
      ],
    );
  }

  Widget _buildRoomDetails(BuildContext context, RoomDetails info) {
    return _SectionCard(
      title: 'Room Details',
      onEditCall: () {
        Get.to(()=>RoomSelectionPage(appID: details.personalInfo!.caseId.toString()));
        //Get.to(()=>FieldEngineerForm(onFormSubmit: (formData){}, onFormDataChange: (form){}, appointmentId: details.personalInfo!.caseId!))

      },
      children: [
        DataTable(
          columnSpacing: 16,
          columns: const [
            DataColumn(label: Text('Room')),
            DataColumn(label: Text('Length')),
            DataColumn(label: Text('Width')),
            DataColumn(label: Text('Unit')),
          ],
          rows: info.rooms!
              .map(
                (room) => DataRow(
              cells: [
                DataCell(Text(room.roomType ?? 'N/A')),
                DataCell(Text(room.length ?? 'N/A')),
                DataCell(Text(room.width ?? 'N/A')),
                DataCell(Text(room.unit ?? 'N/A')),
              ],
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMoreDetails(BuildContext context, MoreDetails info) {
    return _SectionCard(
      title: 'Construction & Market Details',
      onEditCall: () {
        Get.to(()=>FieldEngineerForm(onFormSubmit: (formData){}, onFormDataChange: (form){}, appointmentId: details.personalInfo!.caseId!));

      },
      children: [
        _DetailRow(label: 'Year of Construction', value: info.yearOfConstruction?.toString()),
        _DetailRow(label: 'Market Rate', value: info.marketRate?.toString()),
        _DetailRow(label: 'Rental Range', value: info.rentalRange?.toString()),
        _DetailRow(label: 'Person Contacted', value: info.personContacted),
        _DetailRow(label: 'Landmark', value: info.landmark),
        _DetailRow(label: 'GPS Coordinates', value: info.gpsCoordinates),
        const SizedBox(height: 8),
        Text("Quality of Construction", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const Divider(),
        _DetailRow(label: 'Flooring', value: info.flooring),
        _DetailRow(label: 'Wood Work', value: info.woodWork),
        _DetailRow(label: 'Fittings', value: info.fittings),
        _DetailRow(label: 'Internal Finish', value: info.internal),
        _DetailRow(label: 'External Finish', value: info.external),
      ],
    );
  }

  Widget _buildAdditionalDetails(BuildContext context, AdditionalDetails info) {
    return _SectionCard(
      title: 'Additional Details',
      onEditCall: () {

        Get.to(()=>FieldEngineerForm(onFormSubmit: (formData){}, onFormDataChange: (form){}, appointmentId: details.personalInfo!.caseId!));

      },
      children: [
        _DetailRow(label: 'Applicable Rate', value: info.applicableRate),
        _DetailRow(label: 'Area of Plot', value: info.areaOfPlot),
        _DetailRow(label: 'Total Floors', value: info.numberOfFloors?.toString()),
        _DetailRow(label: 'Floor of Flat', value: info.floorOfFlat?.toString()),
        _DetailRow(label: 'Level of Development', value: info.levelOfDevelopment),
        _DetailRow(label: 'Houses in Vicinity', value: info.housesInVicinity),
        _DetailRow(label: 'Stage of Completion', value: info.stageComplete),
        _DetailRow(
          label: 'Construction Under Sanctioned Plan?',
          value: info.underSanctionPlan == 1 ? 'Yes' : 'No',
        ),
        _DetailRow(
          label: 'Construction Acc. to Sanctioned Plan?',
          value: info.accToSanctionPlan == 1 ? 'Yes' : 'No',
        ),
        const SizedBox(height: 8),
        Text("Property Dealer Contacts", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const Divider(),
        _DetailRow(label: 'Dealer 1 Name', value: info.twoPropertyDealersName1),
        _DetailRow(label: 'Dealer 1 Contact', value: info.twoPropertyDealersContact1),
        _DetailRow(label: 'Dealer 2 Name', value: info.twoPropertyDealersName2),
        _DetailRow(label: 'Dealer 2 Contact', value: info.twoPropertyDealersContact2),
      ],
    );
  }
}


class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onEditCall;

  const _SectionCard({
    required this.title,
    required this.children,
    required this.onEditCall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: onEditCall,
                    child: const Icon(Icons.edit))
              ],
            ),
            const Divider(thickness: 1.5, height: 24.0),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const _DetailRow({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) {
      return const SizedBox.shrink(); // Don't show a row if value is null/empty
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}