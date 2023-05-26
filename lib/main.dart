

import 'package:chat_first/core/firebase/messaging.dart';
import 'package:chat_first/core/go_router.dart';
import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/bloc_observer.dart';
import 'core/utils/constants.dart';
import 'core/utils/services/get_it.dart';
import 'core/utils/theme/dark_theme.dart';
import 'presentation/cubit/states.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  Constants.newMessage=message;
  Constants.newMessageOnBackground=true;
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(const Messaging().firebaseMessagingBackgroundHandler);

  /* Future<AppUpdateInfo> checkForUpdate(){
    return ;
  };*/


  Constants.connection = await InternetConnectionChecker().hasConnection;
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider:AndroidProvider.playIntegrity
  );

  FirebaseFirestore.instance;
  FirebaseStorage.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



   // Constants.users[0].name = await SharedPreference.getData('name') ?? 'no Name';
  if(await SharedPreference.getData('id')!=null) {
    Constants.idForMe = await SharedPreference.getData('id') ;
  }



  Bloc.observer = MyBlocObserver();

  ServiceGetIt().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ChatCubit(seGet(),seGet(),seGet(),seGet(),seGet())
        ..getAllUsers()..getLastMessage(),
      child:BlocBuilder<ChatCubit,ChatState>(
       builder:  (context,state)=> MaterialApp.router(
          theme: dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
