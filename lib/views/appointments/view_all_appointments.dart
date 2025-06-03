import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/views/appointments/completed_appointments.dart';
import 'package:gaa_adv/views/appointments/upcoming_appointments.dart';
import 'package:get/get.dart';

class ViewAllAppointments extends StatelessWidget {
  const ViewAllAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentController>();
    return Scaffold(
        body: Obx(()=>Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*.98,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap:(){
                                controller.updateSelection(0);
                              },
                              child: Card(
                                elevation: controller.selectedIndex.value==0? 5:0,
                                color: controller.selectedIndex.value==0?Colors.yellow.shade400:null,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(child: Text("Current")),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap:(){
                                controller.updateSelection(1);
                              },
                              child: Card(
                                elevation: controller.selectedIndex.value==1? 5:0,
                                color: controller.selectedIndex.value==1?Colors.yellow.shade400:null,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(child: Text("Upcoming")),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap:(){
                                controller.updateSelection(2);
                              },
                              child: Card(
                                elevation: controller.selectedIndex.value==2? 5:0,
                                color: controller.selectedIndex.value==2?Colors.yellow.shade400:null,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(child: Text("Completed")),

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        child: controller.selectedIndex.value==0? Container():controller.selectedIndex.value ==1?UpcomingAppointments():controller.selectedIndex.value==2?CompletedAppointments():Container(),
                      )
                  )
                ])))
    );
  }
}
