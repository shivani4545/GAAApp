import 'package:flutter/material.dart';

import 'appointment_card.dart';


class ViewAllAppointments extends StatefulWidget {
  const ViewAllAppointments({super.key});

  @override
  State<ViewAllAppointments> createState() => _ViewAllAppointmentsState();
}

class _ViewAllAppointmentsState extends State<ViewAllAppointments> {

  int selectedIndex =0;

  updateSelection(int index){
    setState(() {
      selectedIndex =index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Appointments"),
          backgroundColor: Colors.yellow.shade400,
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
                child: Column(
                    children: [

                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*.90,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap:(){
                                    updateSelection(0);
                                  },
                                  child: Card(
                                    elevation: selectedIndex==0? 5:0,
                                    color: selectedIndex==0?Colors.yellow.shade400:null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Container(
                                      padding: EdgeInsets.all(10),

                                      child: Center(child: Text("Current")),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap:(){
                                    updateSelection(1);
                                  },
                                  child: Card(
                                    elevation: selectedIndex==1? 5:0,
                                    color: selectedIndex==1?Colors.yellow.shade400:null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: Text("Upcoming")),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap:(){
                                    updateSelection(2);
                                  },
                                  child: Card(
                                    elevation: selectedIndex==2? 5:0,
                                    color: selectedIndex==2?Colors.yellow.shade400:null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: Text("Completed")),

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child:ListView(
                            children: [

                            ],
                          )
                      )
                    ])
            )));
  }
}
