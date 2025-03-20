import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'area_calculate.dart';
import 'room_selection_page.dart';

class DimensionInputPage extends StatefulWidget {
  final List<Map<String, dynamic>> rooms;

  DimensionInputPage({required this.rooms});

  @override
  _DimensionInputPageState createState() => _DimensionInputPageState();
}

class _DimensionInputPageState extends State<DimensionInputPage> {
  List<Map<String, dynamic>> roomDimensions = [];
  List<FocusNode> heightFocusNodes = [];
  List<FocusNode> widthFocusNodes = [];
  FocusNode? roomTypeFocusNode;

  @override
  void initState() {
    super.initState();
    roomTypeFocusNode = FocusNode();
    for (var room in widget.rooms) {
      for (int i = 0; i < (room['quantity'] as int); i++) {
        roomDimensions.add({
          'roomType': room['roomType'],
          'length': '',
          'width': '',
          'unit': 'm', // Initialize to Meter
        });
        heightFocusNodes.add(FocusNode());
        widthFocusNodes.add(FocusNode());
      }
    }
  }

  @override
  void dispose() {
    if (roomTypeFocusNode != null) {
      roomTypeFocusNode!.dispose();
    }
    for (var node in heightFocusNodes) {
      node.dispose();
    }
    for (var node in widthFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void updateDimension(int index, String field, String value) {
    setState(() {
      roomDimensions[index][field] = value;
    });
  }

  void updateUnit(int index, String unit) {
    setState(() {
      roomDimensions[index]['unit'] = unit;
    });
  }

  void submitData() {
    bool isValid = roomDimensions.every((room) =>
    room['length'] != '' && room['width'] != '');
    if (!isValid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // Convert roomDimensions to a JSON string
    String jsonString = jsonEncode(roomDimensions);

    // Print the JSON string to the console
    print(jsonString);

    // Navigate to AreaCalculate page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AreaCalculate(roomDimensions: roomDimensions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: const Color(0xFFFFCA07).withOpacity(0.5),
          ),
          backgroundColor: const Color(0xFFFFCA07).withOpacity(0.7),
          title: Text('Room Dimensions')),
      body: ListView(
        children: [
          ...roomDimensions.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> room = entry.value;
            return ListTile(
              title: Text('${room['roomType']} (Room ${index + 1})',
                  style: GoogleFonts.poppins()),
              subtitle: Card(
                // Removed color: cardBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: heightFocusNodes[index],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                hintText: 'Length',
                                // Removed hintStyle: GoogleFonts.poppins(color: textFieldHintColor),
                                hintStyle: GoogleFonts.poppins(),
                                // labelStyle: GoogleFonts.poppins(),
                              ),
                              style: GoogleFonts.poppins(),
                              onChanged: (value) =>
                                  updateDimension(index, 'length', value),
                              onEditingComplete: () {
                                widthFocusNodes[index].requestFocus();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: widthFocusNodes[index],
                                    keyboardType: TextInputType.numberWithOptions(
                                        decimal: true),
                                    decoration: InputDecoration(
                                      hintText: 'Width',
                                      hintStyle: GoogleFonts.poppins(),
                                      // Removed hintStyle: GoogleFonts.poppins(color: textFieldHintColor),
                                      // labelStyle: GoogleFonts.poppins(),
                                    ),
                                    style: GoogleFonts.poppins(),
                                    onChanged: (value) =>
                                        updateDimension(index, 'width', value),
                                    onEditingComplete: () {
                                      if (index < roomDimensions.length - 1) {
                                        heightFocusNodes[index + 1]
                                            .requestFocus();
                                      } else {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                DropdownButton<String>(
                                  value: room['unit'],
                                  onChanged: (String? newValue) {
                                    updateUnit(index, newValue!);
                                  },
                                  items: <String>['m', 'Ft']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child:
                                      Text(value, style: GoogleFonts.poppins()),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Call submitData function
                submitData();
              },
              child: Text('Submit', style: GoogleFonts.poppins()),
            ),
          ),
        ],
      ),
    );
  }
}