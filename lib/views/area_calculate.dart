import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreaCalculate extends StatefulWidget {
  final List<Map<String, dynamic>> roomDimensions;

  const AreaCalculate({Key? key, required this.roomDimensions}) : super(key: key);

  @override
  _AreaCalculateState createState() => _AreaCalculateState();
}

class _AreaCalculateState extends State<AreaCalculate> {
  String _totalAreaUnit = 'ft'; // Default unit for total area - set to ft
  final double sqMeterToSqFt = 10.764; // Conversion factor
  final double cardPadding = 12.0; // Define a consistent padding value
  final double roomAreaFontSize = 16.0; // Define font size for room areas

  @override
  Widget build(BuildContext context) {
    double totalAreaInMeters = 0;
    double totalAreaInFeet = 0;

    for (var room in widget.roomDimensions) {
      double length = double.tryParse(room['length'] ?? '0') ?? 0;
      double width = double.tryParse(room['width'] ?? '0') ?? 0;
      String unit = room['unit'];

      if (unit == 'm') {
        totalAreaInMeters += length * width;
      } else {
        totalAreaInFeet += length * width;
      }
    }

    double totalArea;
    if (_totalAreaUnit == 'm') {
      totalArea = totalAreaInMeters;
      totalArea += totalAreaInFeet / sqMeterToSqFt;  // Convert sq ft to sq m and add
    } else {
      totalArea = totalAreaInFeet;
      totalArea += totalAreaInMeters * sqMeterToSqFt; // Convert sq m to sq ft and add
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Room Area Calculation', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFFFFCA07).withOpacity(0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Room Areas:',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            ...widget.roomDimensions.map((room) {
                              // Safely parse the length and width, providing a default of 0 if parsing fails
                              double length = double.tryParse(room['length'] ?? '0') ?? 0;
                              double width = double.tryParse(room['width'] ?? '0') ?? 0;
                              String unit = room['unit'];
                              double area = length * width;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '${room['roomType']}: ${area.toStringAsFixed(2)} sq $unit',
                                  style: GoogleFonts.poppins(fontSize: 10), // Use the defined font size
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Area:',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${totalArea.toStringAsFixed(2)} sq $_totalAreaUnit',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  SizedBox(width: 20),
                                  DropdownButton<String>(
                                    value: _totalAreaUnit,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: GoogleFonts.poppins(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _totalAreaUnit = newValue!;
                                      });
                                    },
                                    items: <String>['m', 'ft']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}