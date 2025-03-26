import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _uploading = false;
  Map<String, dynamic>? _apiResponse;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image first.')));
      return;
    }

    setState(() {
      _uploading = true;
      _apiResponse = null;
    });

    try {
      var postUri = Uri.parse("YOUR_API_ENDPOINT_HERE"); // ***REPLACE***

      var request = new http.MultipartRequest("POST", postUri);

      // Add fields to the request (example)
      request.fields['user_id'] = '123'; // Example - your actual user ID
      request.fields['description'] = 'My Image'; // Example - image description

      String fileName = path.basename(_image!.path);
      String mimeType = 'image/${path.extension(fileName).substring(1)}';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // ***IMPORTANT: API field name***
          _image!.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        try {
          _apiResponse = jsonDecode(response.body);
          print('DECODED JSON RESPONSE: $_apiResponse');

          // ***Handle successful API response***
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image uploaded successfully!')));

        } catch (e) {
          print('ERROR DECODING JSON: $e');
          print('RAW RESPONSE BODY: ${response.body}'); //VERY HELPFUL
          _apiResponse = {
            'status': 'error',
            'message': 'Invalid JSON response from API'
          };
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid JSON response from API')));
        }
      } else {
        print('Image upload failed with status ${response.statusCode}');
        print('RAW RESPONSE BODY: ${response.body}'); //VERY HELPFUL
        _apiResponse = {
          'status': 'error',
          'message': 'Upload failed: ${response.reasonPhrase}'
        };
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.reasonPhrase}')));
      }
    } catch (error) {
      print('Error uploading image: $error');
      _apiResponse = {'status': 'error', 'message': 'Error: $error'};
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')));

    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
              _image!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.camera),
                  child: Text('Take Photo'),
                ),
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.gallery),
                  child: Text('Choose from Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploading ? null : uploadImage,
              child: _uploading
                  ? CircularProgressIndicator()
                  : Text('Upload Image'),
            ),
            SizedBox(height: 20),
            if (_apiResponse != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'API Response:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Status: ${_apiResponse!['status'] ?? 'N/A'}'),
                    Text('Message: ${_apiResponse!['message'] ?? 'N/A'}'),
                    if (_apiResponse!.containsKey('image_url'))
                      Text('Image URL: ${_apiResponse!['image_url']}'),
                    if (_apiResponse!.containsKey('image_path'))
                      Text('Image Path: ${_apiResponse!['image_path']}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}