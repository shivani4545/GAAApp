import 'dart:async';
import 'dart:developer' as developer; // Import for logging

import 'package:flutter/services.dart'; // Import for PlatformException
import 'package:gaa_adv/models/attendance_status_response.dart';
import 'package:gaa_adv/service/attendance_service.dart';
import 'package:geolocator/geolocator.dart' as geo; // Alias to avoid conflict
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc; // Alias to avoid conflict

import '../service/shared_pref_service.dart';

class AttendanceController extends GetxController {
  AttendanceService attendanceService = AttendanceService();
  SharedPrefService sharedPrefService = SharedPrefService();
  RxBool isStartShiftVisible = false.obs;
  RxBool isEndShiftVisible = false.obs;
  RxString startShiftTime = "".obs;
  RxString endShiftTime = "".obs;
  RxString totalDuration = "".obs;
  RxInt attendanceStatusVal = 0.obs;
  RxBool startShiftLoading = false.obs;
  RxBool endShiftLoading = false.obs;
  RxBool checkingAttendanceStatus = false.obs;
  Rx<AttendanceStatusResponse> attendanceStatus =
      AttendanceStatusResponse().obs;
  RxList<LocationList> locations = <LocationList>[].obs;
  RxBool isTracking = false.obs; // Track if location tracking is active

  loc.Location location = loc.Location(); // Instance of the location package
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    developer.log('AttendanceController: onInit called');
    checkShiftStatus();
  }

  @override
  void onClose() {
    developer.log('AttendanceController: onClose called');
    //_stopLocationTracking(); // Make sure to stop tracking on close
    super.onClose();
  }

  checkShiftStatus() async {
    checkingAttendanceStatus.value = true;
    try {
      attendanceStatus.value = await attendanceService.getAttendanceStatus();
      attendanceStatusVal.value = attendanceStatus.value.status ?? 0;
      update();

      if (attendanceStatus.value.status == 0) {
        isStartShiftVisible.value = true;
        isEndShiftVisible.value = false;
        isTracking.value = false;
        //_stopLocationTracking();
      } else if (attendanceStatus.value.status == 1) {
        isStartShiftVisible.value = false;
        isEndShiftVisible.value = true;
        isTracking.value = true;
        startShiftTime.value = DateFormat("hh:mm a").format(attendanceStatus.value.shiftStartTime!);
        _checkLocationPermissionAndStartTracking();
      } else if (attendanceStatus.value.status == 2) {
        isStartShiftVisible.value = false;
        isEndShiftVisible.value = false;
        isTracking.value = false;
        startShiftTime.value = DateFormat("hh:mm a").format(attendanceStatus.value.shiftStartTime!);
        endShiftTime.value = DateFormat("hh:mm a").format(attendanceStatus.value.shiftEndTime!);
        // Calculate the duration correctly
        Duration difference = attendanceStatus.value.shiftEndTime!.difference(attendanceStatus.value.shiftStartTime!);
        totalDuration.value = _formatDuration(difference);
        //_stopLocationTracking();
      }
    } catch (e) {
      developer.log('Error in checkShiftStatus: $e');
    } finally {
      checkingAttendanceStatus.value = false;
      update();
    }
  }

  // Helper function to format Duration into HH:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  startShift() async {
    developer.log('AttendanceController: startShift called');
    startShiftLoading.value = true;
    update();
    try {
      bool isMarked = await attendanceService.startShift();
      if (isMarked) {
        await sharedPrefService.saveShiftStatus("1");
        isTracking.value = true;
        _checkLocationPermissionAndStartTracking(); // Check permissions & start tracking
        checkShiftStatus();
      }
    } catch (e) {
      developer.log('Error in startShift: $e');
    } finally {
      startShiftLoading.value = false;
      update();
    }
  }

  endShift() async {
    developer.log('AttendanceController: endShift called');
    endShiftLoading.value = true;
    update();
    try {
      bool isMarked = await attendanceService.endShift();
      if (isMarked) {
        await sharedPrefService.saveShiftStatus("0");
        isTracking.value = false;
        //_stopLocationTracking();
        checkShiftStatus();
      }
    } catch (e) {
      developer.log('Error in endShift: $e');
    } finally {
      endShiftLoading.value = false;
      update();
    }
  }

  Future<void> _checkLocationPermissionAndStartTracking() async {
    developer.log(
        'AttendanceController: _checkLocationPermissionAndStartTracking called');
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          developer.log("Location service is disabled");
          Get.snackbar(
              "Location Required", "Please enable location services to continue.");
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          developer.log("Location permission is denied");
          Get.snackbar(
              "Location Permission Required", "Please grant location permission to continue.");
          return;
        }
      }

      if (GetPlatform.isAndroid) {
        permissionGranted = await location.hasPermission();
        if (permissionGranted == loc.PermissionStatus.deniedForever) {
          Get.snackbar(
            "Background Location Required",
            "Please enable background location permission in app settings to track attendance while the app is in the background.",
          );
          return;
        }
      }

      // Enable background mode *after* all permissions are granted
      try {
        await location.enableBackgroundMode(enable: true);
        developer.log('Background mode enabled');
      } catch (e) {
        developer.log('Error enabling background mode: $e');
      }

      // Start location tracking only if isTracking is true
      if (isTracking.value) {
        //_startLocationTracking();
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'PERMISSION_DENIED') {
        developer.log(
            "PERMISSION_DENIED caught! Background location permission denied: ${e.message}");
        Get.snackbar(
            "Background Location Denied",
            "Background location is needed to track attendance. Please grant permission in settings.");
      } else {
        developer.log(
            "An error occurred during permission check: $e");
        Get.snackbar("Error", "An error occurred while checking location permissions.");
      }
    }
  }

  // void _startLocationTracking() async {
  //   developer.log('AttendanceController: _startLocationTracking called');
  //
  //   if (isTracking.value) {
  //     if (_locationSubscription == null) {
  //       developer.log('Starting location tracking');
  //
  //       _locationSubscription = location.onLocationChanged.listen(
  //               (loc.LocationData currentLocation) async {
  //             developer.log(
  //                 'Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}');
  //             if (isTracking.value &&
  //                 currentLocation.latitude != null &&
  //                 currentLocation.longitude != null) {
  //               locations.add(LocationList(
  //                 latitude: currentLocation.latitude.toString(),
  //                 longitude: currentLocation.longitude.toString(),
  //               ));
  //
  //               try {
  //                 bool isUpdated = await attendanceService.updateLocation(
  //                   currentLocation.latitude.toString(),
  //                   currentLocation.longitude.toString(),
  //                 );
  //
  //                 if (!isUpdated) {
  //                   developer.log("Failed to update location on server");
  //                 }
  //               } catch (e) {
  //                 developer.log('Error updating location on server: $e');
  //               }
  //             } else {
  //               developer
  //                   .log('Location tracking is disabled or location data is null');
  //             }
  //           }, onError: (error) {
  //         developer.log('Error in location stream: $error');
  //       });
  //     }
  //   } else {
  //     developer
  //         .log('Location tracking is not enabled, not starting the stream.');
  //     _stopLocationTracking();
  //   }
  // }
  //
  // void _stopLocationTracking() {
  //   developer.log('AttendanceController: _stopLocationTracking called');
  //   if (_locationSubscription != null) {
  //     developer.log('Canceling location subscription');
  //     _locationSubscription!.cancel();
  //     _locationSubscription = null;
  //   } else {
  //     developer.log('No active location subscription to cancel');
  //   }
  // }

  Future<geo.Position> _determinePosition() async {
    developer.log('AttendanceController: _determinePosition called');
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await geo.Geolocator.getCurrentPosition();
  }
}

class LocationList {
  final String latitude;
  final String longitude;

  LocationList({required this.latitude, required this.longitude});
}