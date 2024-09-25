import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localapp/BlogDetail.dart';
import 'package:localapp/component/show%20coustomMesage.dart';
import 'package:localapp/constants/Config.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/main.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// this will handle notification when App is open
void onMessageHandler(RemoteMessage message) async {
  logger.w("Its Working \n Data \n ${message.data}\n");

  var data = message.data;

  Map<String, String> payload = {};
  message.data.forEach((key, value) {
    payload[key] = value.toString();
  });

  String? imageUrl = message.data['image_url'];

  String? bigPicturePath;
  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/notification_image.jpg';
      File file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      bigPicturePath = filePath;
    } catch (e) {
      logger.e('Error downloading image: $e');
    }
  }
  logger.w("big Picture ${bigPicturePath}");

  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: "basic_channel",
    payload: payload,
    title: data['title'],
    body: data['body'],
    criticalAlert: true,
    wakeUpScreen: true,
    bigPicture: bigPicturePath != null ? 'file://$bigPicturePath' : null,
    notificationLayout: bigPicturePath != null
        ? NotificationLayout.BigPicture
        : NotificationLayout.Default,
  ));
}

// This Function will handle message ricive in background
@pragma('vm:entry-point')
Future<void> onBackGroundMessage(RemoteMessage message) async {
  logger.w("from back Ground Rece ver");
  logger.i('data from message  ${message.data.length} ${message.data}');
  logger.i('data from message  ${message.data.length} ${message.data}');

  Map<String, String> payload = {};
  message.data.forEach((key, value) {
    logger.i("createing Pay lode");
    payload[key] = value.toString();
  });
  // if (message.data.isNotEmpty) {
  //   final blogId = message.data['blog_id'];
  //   if (blogId != null && blogId.isNotEmpty) {
  //     if (navigatorKey.currentContext != null) {
  //       // Navigator.push(
  //       //   navigatorKey.currentContext!,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => BlogDetailScreen(
  //       //       blogId,
  //       //       'Notification',
  //       //       '', // Pass other parameters as needed
  //       //       false,
  //       //     ),
  //       //   ),
  //       // );
  //     }
  //   }
  // }
  String? imageUrl = message.data['image_url'];

  String? bigPicturePath;
  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/notification_image.jpg';
      File file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      bigPicturePath = filePath;
    } catch (e) {
      print('Error downloading image: $e');
    }
  }



  logger.w("payLoad Is $payload");
// Handle the creation of the notification UI
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      payload: payload,
      id: 10,
      channelKey: 'basic_channel',
      title: message.data['title'],
      body: message.data['body'],
      bigPicture: bigPicturePath != null ? 'file://$bigPicturePath' : null,
      notificationLayout: bigPicturePath != null
          ? NotificationLayout.BigPicture
          : NotificationLayout.Default,
    ),
  );
}

//THis Function will Handle tap in Notification
Future<void> tapHandler(ReceivedAction receivedAction) async {
  logger.i(
      "Tap On Notification\n(${receivedAction.actionType})\n ${receivedAction.payload}");

  var data = receivedAction.payload;
  await WidgetsFlutterBinding.ensureInitialized();

  if (navigatorKey.currentContext != null && kDebugMode) {
    showMessage(navigatorKey.currentContext!,
        "Tap On Notification\n(${receivedAction.actionType})\n ${receivedAction.payload}");
  }

  if (receivedAction.actionType == ActionType.Default) {
    if (data?["blog_id"] != null && navigatorKey.currentContext != null) {
      Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (c) =>
                  BlogDetailScreen(data?["blog_id"] ?? "", "", "", false)));
    }
  }
}
