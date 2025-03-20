import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dimension_input_page.dart';

class RoomCounter extends StatefulWidget {
  final String roomType;
  final ValueChanged<int> onCountChanged;

  const RoomCounter({
    Key? key,
    required this.roomType,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  State<RoomCounter> createState() => _RoomCounterState();
}

class _RoomCounterState extends State<RoomCounter> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_getIndex()}. ${widget.roomType}',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.red),
                onPressed: () {
                  if (count > 0) {
                    setState(() {
                      count--;
                      widget.onCountChanged(count);
                    });
                  }
                },
              ),
              Text(
                '$count',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  setState(() {
                    count++;
                    widget.onCountChanged(count);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getIndex() {
    switch (widget.roomType) {
      case "Living Room":
        return 1;
      case "Bedroom":
        return 2;
      case "Kitchen":
        return 3;
      case "Bathroom":
        return 4;
      default:
        return 0;
    }
  }
}

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({Key? key}) : super(key: key);

  @override
  _RoomSelectionPageState createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  List<Map<String, dynamic>> rooms = [];
  String? selectedPropertyType; // Correct Initial Value (nullable)

  int livingRoomCount = 1;
  int bedroomCount = 1;
  int kitchenCount = 1;
  int bathroomCount = 1;

  @override
  void initState() {
    super.initState();
  }

  void addRoom() {
    setState(() {
      rooms.add({
        'roomType': '',
        'quantity': 1,
      });
    });
  }

  void removeRoom(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }

  void updateRoomType(int index, String value) {
    setState(() {
      rooms[index]['roomType'] = value;
    });
  }

  void updateQuantity(int index, int value) {
    setState(() {
      rooms[index]['quantity'] = value;
    });
  }

  void nextPage() {
    //Create copy of rooms
    List<Map<String, dynamic>> allRooms = List.from(rooms);
    //Append predefined rooms
    allRooms.addAll([
      {'roomType': 'Living Room', 'quantity': livingRoomCount},
      {'roomType': 'Bedroom', 'quantity': bedroomCount},
      {'roomType': 'Kitchen', 'quantity': kitchenCount},
      {'roomType': 'Bathroom', 'quantity': bathroomCount}
    ]);
    //Remove empty records
    List<Map<String, dynamic>> validRooms = allRooms.where((element) => element['roomType'] != '').toList();
    if (validRooms.any((room) => room['roomType'].isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all room type fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DimensionInputPage(rooms: validRooms),
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
        title: const Text('Home Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text("Select Property Type *"),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              value: selectedPropertyType,
              items: const [

                DropdownMenuItem(
                  value: "Independent Bunglow",
                  child: Row(
                    children: [
                      Icon(Icons.bungalow_outlined),
                      SizedBox(width: 8),
                      Text("Independent Bunglow"),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: " Society Flat",
                  child: Row(
                    children: [
                      Icon(Icons.home_work_outlined),
                      SizedBox(width: 8),
                      Text("Society Flat"),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: " Bulider Flat",
                  child: Row(
                    children: [
                      Icon(Icons.home_work_outlined),
                      SizedBox(width: 8),
                      Text("Bulider Flat"),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: " DDA Flat",
                  child: Row(
                    children: [
                      Icon(Icons.home_outlined),
                      SizedBox(width: 8),
                      Text("DDA Flat"),
                    ],
                  ),
                )
              ],
              onChanged: (value) {
                setState(() {
                  selectedPropertyType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Room Counter
            const Text("Select Number of Rooms*"),
            RoomCounter(
              roomType: "Living Room",
              onCountChanged: (value) {
                setState(() {
                  livingRoomCount = value;
                });
              },
            ),
            RoomCounter(
              roomType: "Bedroom",
              onCountChanged: (value) {
                setState(() {
                  bedroomCount = value;
                });
              },
            ),
            RoomCounter(
              roomType: "Kitchen",
              onCountChanged: (value) {
                setState(() {
                  kitchenCount = value;
                });
              },
            ),
            RoomCounter(
              roomType: "Bathroom",
              onCountChanged: (value) {
                setState(() {
                  bathroomCount = value;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text("Other Rooms"),
            ...rooms.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> room = entry.value;

              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Enter Room Type',
                        ),
                        onChanged: (value) => updateRoomType(index, value),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                if (room['quantity'] > 1) {
                                  updateQuantity(
                                      index, (room['quantity'] as int) - 1);
                                }
                              },
                            ),
                            Text(room['quantity'].toString()),
                            IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  updateQuantity(
                                      index, (room['quantity'] as int) + 1);
                                }
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => removeRoom(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addRoom,
              child: const Text('Add Room'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: nextPage,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}