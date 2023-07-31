import 'dart:convert';
import 'dart:io';

import 'package:chat_first/core/utils/general_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/model_calls.dart';
import '../../domain/entities/model_user.dart';
import '../../src/Features/call_screen/Pages/accept_end.dart';
import '../../src/Features/call_screen/Pages/call_screen.dart';
import '../../src/Features/sign_in/Pages/bloc/sign_cubit.dart';
import '../../src/Features/sign_in/Pages/bloc/sign_event.dart';
import '../utils/constants.dart';

class Messaging {
  Messaging({
    Key? key,
  });

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = const AndroidNotificationChannel('high_importance_channel', 'High Importance Notifications');

  Future<void> start(BuildContext context) async {
    await messaging.setAutoInitEnabled(true);
    await messaging.getToken().then((value) {
      if (value != null) {
        Constants.tokenMessaging = value;

        BlocProvider.of<SignCubit>(context).add(SignEvent({
          'tokenMessaging': value,
        }));
      }
    });

    messaging.onTokenRefresh.listen((event) {
      Constants.tokenMessaging = event;
      BlocProvider.of<SignCubit>(context).add(SignEvent({
        'tokenMessaging': Constants.tokenMessaging,
      }));
    });

    requestPermission();
    /*loadFCM();
    listenFCM();*/
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");

      Map<String, dynamic> user = jsonDecode(event.data['User']);

      if (event.data['click_action'] == 'calling') {
        Constants.called.add(Calls.fromJson({
          "name": user["name"],
          "receiveId": user["id"],
          "image": user["image"],
          'status': 'receive',
          "dateTime": DateTime.now().toString(),
        }));
        navigatorReuse(
            context, AcceptEnd(user: Users.fromJson(jsonDecode(event.data['User'])), contactRecipient: true, tokenMeeting: event.data['token']));
      }
    });
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> message() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
    }
    var tokenMessaging = Constants.tokenMessaging;
    print("token : $tokenMessaging");

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('openedApp message');

      print(event.data.toString());
      //showToast(text: 'on message opened app', state: ToastStates.ERROR);
    });
  }
/*  void loadFCM() async {
    if (!Platform.isWindows) {
       channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await messaging
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !Platform.isWindows) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }*/

  static Future<void> firebaseMessagingBackgroundHandler(context, RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print("click_action = ${message.data['click_action']}");
    print(message.notification!.body);
    if (message.data['click_action'] == 'calling') {
      navigatorReuse(context, const VideoSDKQuickStart());
    }
    print("Handling a background message: ${message.messageId}");
  }

  static sendMessage(
    context, {
    required Users modelUser,
    required String body,
    required String title,
    required String action,
    required String tokenMeeting,
    required String tokenUser,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAATXAdSkU:APA91bHapQvGh2vDMfPz_qEGOf2a49qU7qyIKQXvvj0wvmKkpTTi7OwcJFFU_IyAmB2ksVAmxwlAFmfD4jGU26zH-o5o8Jzv52XgWmiF63KULwmzZinwJ9ntM0AGpPsACmAM3uOqGSTC',
        },
        body: jsonEncode(
          {
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              "sound": "alarm",
            },
            'priority': 'high',
            'data': <String, dynamic>{'click_action': action, 'token': tokenMeeting, 'User': jsonEncode(modelUser.toMap()), 'status': 'done'},
            "to": tokenUser,
          },
        ),
      );

      print(jsonDecode(response.body));
    } catch (e) {
      print(e.toString());
    }
  }
}
