import 'package:flutter/material.dart';
import 'package:gaa_adv/views/camera_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AreaCalculate extends StatefulWidget {
  final List<Map<String, dynamic>> roomDimensions;

  const AreaCalculate({super.key, required this.roomDimensions});

  @override
  _AreaCalculateState createState() => _AreaCalculateState();
}

class _AreaCalculateState extends State<AreaCalculate> {
  String _totalAreaUnit = 'ft'; // Default unit for total area - set to ft
  final double sqMeterToSqFt = 10.764; // Conversion factor
  final double cardPadding = 12.0; // Define a consistent padding value
  final double roomAreaFontSize = 16.0; // Define font size for room areas

  TextEditingController pricePerUnit= TextEditingController();
  String finalValuation ="0";
  String formatIndianCurrency(num value) {
    if (value >= 10000000) {
      // Crore
      return "${(value / 10000000).toStringAsFixed(2)} Cr";
    } else if (value >= 100000) {
      // Lakh
      return "${(value / 100000).toStringAsFixed(2)} L";
    } else if (value >= 1000) {
      // Thousand
      return "${(value / 1000).toStringAsFixed(2)} K";
    } else {
      // Less than thousand
      return value.toString();
    }
  }
  String valueInFormat="";

  calculateFinalPrice(double totalArea,String val){
    print("Final ${val}");
    setState(() {
      finalValuation = (totalArea*double.parse(val.isEmpty?"0":val)).toStringAsFixed(3);
      valueInFormat =formatIndianCurrency(num.parse(finalValuation));
    });
  }
  Map<String, dynamic> content = new Map();
  makeRequest(String totalArea,String valuePerUnit,String unit,String finalValue){
    content ={
      "totalArea":totalArea,
      "roomDetails":widget.roomDimensions,
      "valuePerUnit":valuePerUnit,
      "unit":unit,
      "finalValue":finalValue
    };
    Get.to(()=>ImageUploadScreen());
    print("Final Data ${content}");
  }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Areas:',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                              style: GoogleFonts.poppins(fontSize: 16), // Use the defined font size
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
        
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
                              const SizedBox(width: 20),
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
        
              Container(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Property Valuation",style: GoogleFonts.poppins(fontSize: 18),),
                        const SizedBox(height: 15,),
                        TextFormField(
                          controller: pricePerUnit,
                          keyboardType: TextInputType.number,
                          onChanged: (val){
                            setState(() {
                              calculateFinalPrice(totalArea,val!);

                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Price Per $_totalAreaUnit",
                            label: Text("Valuation Per $_totalAreaUnit"),
                            isDense: true,
                            border: const OutlineInputBorder()
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              const Text("X",style: TextStyle(fontSize: 16),),
                              const SizedBox(width: 10,),
                              Text(totalArea.toString(),style: GoogleFonts.poppins(fontSize: 20),),
                              const SizedBox(width: 10,),
                              Text(_totalAreaUnit,style: const TextStyle(fontSize: 16),),
        
        
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Divider(),
                        const Text("Final Valuation"),
                        const SizedBox(height: 5,),
                        Text("$finalValuation ($valueInFormat)",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w600),)
                      ],
                    ),
                  ),
                ),
              ),
              
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                  ),
                    onPressed: (){
                    makeRequest(totalArea.toString(), pricePerUnit.text , _totalAreaUnit, finalValuation);
                    },
                    child: const Text("Submit")),
              )
        
            ],
          ),
        ),
      ),
    );
  }
}