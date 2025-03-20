// import 'dart:math';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cotrav_driver/services/api_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FirebaseService {
//   AwesomeNotifications awesomeNotifications = AwesomeNotifications();
//   Future<void> messageHandle(
//       {required RemoteMessage message, required bool isBackground}) async {
//     try {
//       awesomeNotifications.createNotification(
//         content: NotificationContent(
//             id: Random().nextInt(100),
//             title: message.notification!.title,
//             body: message.notification!.body,
//             channelKey: 'instant_notification'),
//       );
//     } catch (e) {
//       //
//     }
//   }
//
//   Future<String> getToken() async {
//     var msg = FirebaseMessaging.instance;
//     return await msg.getToken() ?? '';
//   }
//
//   ApiService apiService = ApiService();
//   Future<void> initializeNotification() async {
//     try {
//       FirebaseMessaging _firemesaging = FirebaseMessaging.instance;
//
//       await _firemesaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//       final String token = await getToken();
//       apiService.updateFcm(fcmToken: token);
//       print("token--$token");
//       FirebaseMessaging.instance.subscribeToTopic('allUsers');
//       FirebaseMessaging.onMessage.listen((event) {
//         messageHandle(message: event, isBackground: false);
//       });
//
//       FirebaseMessaging.onMessageOpenedApp.listen((event) {});
//     } catch (e) {
//       // print(e);
//     }
//   }
// }