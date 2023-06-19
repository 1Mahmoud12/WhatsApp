import 'dart:async';

import 'package:camera/camera.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/camera_page.dart';
import '../../core/firebase/messaging.dart';
import '../../core/utils/constants.dart';
import '../cubit/block.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavigationBar = [
      const BottomNavigationBarItem(label: 'call', icon: Icon(Ionicons.call_outline)),
      const BottomNavigationBarItem(label: 'camera', icon: Icon(Ionicons.camera_outline)),
      const BottomNavigationBarItem(label: 'message', icon: Icon(Ionicons.chatbox_outline)),
      const BottomNavigationBarItem(label: 'people', icon: FaIcon(FontAwesomeIcons.circleUser)),
    ];

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        /// very important to implement in many methods
        if (!ChatCubit.get(context).createTokenMessaging) {
          Messaging().start(context);

          Timer.periodic(const Duration(minutes: 1), (timer) => ChatCubit.get(context).addUser({'lastSeen': DateTime.now().toString()}));
          ChatCubit.get(context).createTokenMessaging = ChatCubit.get(context).changeBool(false);
        }
        if (Constants.newMessageOnBackground) {
          print('/*////////////////////////////////////////////');
          Messaging.firebaseMessagingBackgroundHandler(context, Constants.newMessage!);
          ChatCubit.get(context).changeBool(Constants.newMessageOnBackground);
        }
        return Scaffold(
          body: ChatCubit.get(context).screens[ChatCubit.get(context).currentState],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: ChatCubit.get(context).currentState,
            onTap: (index) async {
              /// to change bottom navigation bar
              ChatCubit.get(context).changeIndex(index);
              if (index == 2) {
                ChatCubit.get(context).getLastMessage();
                ChatCubit.get(context).changeBool(ChatCubit.get(context).enabledMessagesScreen);
                ChatCubit.get(context).getAllUsers();
              }
              if (index == 1) {
                await availableCameras().then(
                  (value) => Navigator.push(context, MaterialPageRoute(builder: (_) => CameraPage(cameras: value))),
                );
              }
            },
            items: bottomNavigationBar,
          ),
        );
      },
    );
  }
}
