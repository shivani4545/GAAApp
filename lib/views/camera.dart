// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:http_parser/http_parser.dart';
// import 'package:path/path.dart' as path;
//
// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }
//
// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   File? _image;
//   final picker = ImagePicker();
//   bool _uploading = false;
//   Map<String, dynamic>? _apiResponse; // Store the API response
//
//   Future getImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<void> uploadImage() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please select an image first.')));
//       return;
//     }
//
//     setState(() {
//       _uploading = true;
//       _apiResponse = null; // Clear previous response
//     });
//
//     try {
//       var postUri = Uri.parse("YOUR_API_ENDPOINT_HERE");
//
//       var request = new http.MultipartRequest("POST", postUri);
//
//       request.fields['user_id'] = '123';
//       request.fields['description'] = 'My Image';
//
//       String fileName = path.basename(_image!.path);
//       String mimeType = 'image/${path.extension(fileName).substring(1)}';
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           _image!.path,
//           filename: fileName,
//           contentType: MediaType.parse(mimeType),
//         ),
//       );
//
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         print('Image uploaded successfully');
//
//         // Decode the JSON response
//         try {
//           _apiResponse = jsonDecode(response.body);
//           print('Decoded JSON: $_apiResponse');
//         } catch (e) {
//           print('Error decoding JSON: $e');
//           _apiResponse = {'status': 'error', 'message': 'Invalid JSON response'};
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Image uploaded successfully!')));
//       } else {
//         print('Image upload failed with status ${response.statusCode}');
//         _apiResponse = {
//           'status': 'error',
//           'message': 'Upload failed: ${response.reasonPhrase}'
//         };
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Image upload failed: ${response.reasonPhrase}')));
//       }
//     } catch (error) {
//       print('Error uploading image: $error');
//       _apiResponse = {'status': 'error', 'message': 'Error: $error'};
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error uploading image: $error')));
//     } finally {
//       setState(() {
//         _uploading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null
//                 ? const Text('No image selected.')
//                 : Image.file(
//               _image!,
//               width: 200,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => getImage(ImageSource.camera),
//                   child: const Text('Take Photo'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => getImage(ImageSource.gallery),
//                   child: const Text('Choose from Gallery'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploading ? null : uploadImage,
//               child: _uploading
//                   ? CircularProgressIndicator()
//                   : Text('Upload Image'),
//             ),
//             SizedBox(height: 20),
//             if (_apiResponse != null) // Display API response
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'API Response:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text('Status: ${_apiResponse!['status'] ?? 'N/A'}'),
//                     Text('Message: ${_apiResponse!['message'] ?? 'N/A'}'),
//                     if (_apiResponse!.containsKey('image_url'))
//                       Text('Image URL: ${_apiResponse!['image_url']}'),
//                     if (_apiResponse!.containsKey('image_path'))
//                       Text('Image Path: ${_apiResponse!['image_path']}'),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }