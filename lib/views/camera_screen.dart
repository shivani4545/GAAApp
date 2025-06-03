import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gaa_adv/views/summary_page.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/image_upload_list_response.dart';
import '../service/upload_img_service.dart';


class ImageUploadScreen extends StatefulWidget {
  final String appointmentID;
  const ImageUploadScreen({super.key, required this.appointmentID});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}
  class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false; // Changed from _uploading for clarity

  // Stores the result or error for display
  Map<String, dynamic>? _uiDisplayResult;

  final TextEditingController _appointmentIdController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  final ImageUploadService _imageUploadService = ImageUploadService();

  // Define the maximum allowed file size in bytes (e.g., 2MB)
  static const int maxFileSizeInBytes = 5 * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    // Example values, ensure these are appropriate for your testing/use case
    _appointmentIdController.text = "97";
    _roomNameController.text = "living room";
  }

  @override
  void dispose() {
    _appointmentIdController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (!mounted || pickedFile == null) {
      if (pickedFile == null && kDebugMode) print('[UI] No image selected.');
      return;
    }
    setState(() {
      _image = File(pickedFile.path);
      _uiDisplayResult = null; // Clear previous result
    });
  }

  Future<void> _handleImageUpload() async {
    if (_image == null) {
      _showSnackBar('Please select an image first.', isError: true);
      return;
    }

    // --- PRE-UPLOAD SIZE CHECK ---
    final int imageSize = _image!.lengthSync();
    if (imageSize > maxFileSizeInBytes) {
      final double imageSizeMB = imageSize / (1024 * 1024);
      const double maxSizeMB = maxFileSizeInBytes / (1024 * 1024);
      _showSnackBar(
        'Image is too large (${imageSizeMB.toStringAsFixed(1)}MB). Max is ${maxSizeMB.toStringAsFixed(0)}MB.',
        isError: true,
      );
      return;
    }
    // --- END PRE-UPLOAD SIZE CHECK ---

    String appointmentId = _appointmentIdController.text.trim();
    String roomName = _roomNameController.text.trim();

    if (appointmentId.isEmpty) {
      _showSnackBar('Appointment ID is required.', isError: true);
      return;
    }
    if (roomName.isEmpty) {
      _showSnackBar('Room Name is required.', isError: true);
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _uiDisplayResult = null;
    });

    try {
      final ImageUploadListResponse serviceResponse = await _imageUploadService.uploadImage(
        imageFile: _image!,
        appointmentId: appointmentId,
        roomName: roomName,
      );

      if (!mounted) return; // Check again after await
      setState(() {
        _uiDisplayResult = {
          'success': serviceResponse.success ?? false, // API success flag
          'message': serviceResponse.message ?? 'Upload processed.',
          'isServiceSuccess': true // Flag to indicate service call didn't throw client-side error
        };
      });
      _showSnackBar(serviceResponse.message ?? 'Image uploaded successfully!');

    } on AuthenticationException catch (e) {
      _handleUploadError(e.toString(), isAuthError: true);
    } on ImageUploadApiException catch (e) {
      // This will catch the "Data too long for column 'name'" if the service throws it
      String detailedMessage = e.message;
      if (e.statusCode == 500 && e.message.contains("Data too long for column")) {
        detailedMessage = "Server Error: The filename is too long for the database. Please inform support. (Details: ${e.message})";
      } else if (e.statusCode == 500) {
        detailedMessage = "A server error occurred (${e.statusCode}). Please try again later. (Details: ${e.message})";
      } else if (e.statusCode == 422) {
        detailedMessage = "Invalid data provided (${e.statusCode}): ${e.message}";
      }
      _handleUploadError(detailedMessage, statusCode: e.statusCode, errorBody: e.errorBody);
    } catch (e) { // Catch-all for other unexpected client-side errors
      _handleUploadError('An unexpected client-side error occurred: $e');
      if (kDebugMode) print("[UI] Unexpected error during upload: $e");
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleUploadError(String message, {bool isAuthError = false, int? statusCode, dynamic errorBody}) {
    if (!mounted) return;
    setState(() {
      _uiDisplayResult = {
        'success': false,
        'message': message,
        'isServiceSuccess': false, // Service call threw an exception
        'statusCode': statusCode,
        'errorBody': errorBody?.toString() // Store string representation for display
      };
    });
    _showSnackBar(message, isError: true, durationSeconds: isAuthError || statusCode==500 ? 5 : 3);
  }

  void _showSnackBar(String message, {bool isError = false, int durationSeconds = 3}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool displayApiSuccess = _uiDisplayResult?['success'] ?? false;
    String displayMessage = _uiDisplayResult?['message'] ?? "Awaiting action.";
    bool wasServiceCallAttempted = _uiDisplayResult != null; // Indicates if an attempt was made
    bool wasServiceCallLocallySuccessful = _uiDisplayResult?['isServiceSuccess'] ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // TextFormField(
              //   controller: _appointmentIdController,
              //   decoration: const InputDecoration(labelText: 'Appointment ID', border: OutlineInputBorder()),
              //   keyboardType: TextInputType.text,
              // ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _roomNameController,
                decoration: const InputDecoration(labelText: 'Room Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? Container(
                width: 200, height: 200,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('No image selected.')),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(icon: const Icon(Icons.camera_alt), onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera), label: const Text('Take Photo')),
                  ElevatedButton.icon(icon: const Icon(Icons.photo_library), onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery), label: const Text('Gallery')),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)) : const Icon(Icons.cloud_upload),
                onPressed: _isLoading ? null : _handleImageUpload,
                label: _isLoading ? const Text('Uploading...') : const Text('Upload Image'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), textStyle: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                Get.to(()=>SummaryPage(appointmentId: widget.appointmentID));
              }, child: Text("Review Appointment"))

            ],
          ),
        ),
      ),
    );
  }
}