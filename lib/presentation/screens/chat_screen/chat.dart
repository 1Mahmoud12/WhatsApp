import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/domain/entities/model_message.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:chat_first/presentation/screens/chat_screen/lastSeen.dart';
import 'package:chat_first/presentation/screens/chat_screen/widget_primary_secondary_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'widget_send_message.dart';

class Chat extends StatelessWidget {
  final int countInList;

  final Users modelUser;

  Chat({
    Key? key,
    required this.modelUser,
    required this.countInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scroll = ScrollController();

    /// very important to implement in many methods
    if (ChatCubit.get(context).needScroll) {
      scroll = ScrollController();
      Future.delayed(
        const Duration(milliseconds: 100),
        () => scroll.jumpTo(scroll.position.maxScrollExtent),
      );
      ChatCubit.get(context).needScroll = ChatCubit.get(context).changeBool(true);
    }

    double heightMedia = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              ChatCubit.get(context).needScroll = ChatCubit.get(context).changeBool(false);
              context.push('/');
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              modelUser.name!,
              style: AppStyles.style16,
            ),
            LastSeen(
              id: modelUser.id!,
            )
          ],
        ),
        actions: [
          SizedBox(
              width: 50,
              child: MaterialButton(
                onPressed: () => callFunction(context, modelUser),
                child: Image.asset('assets/phone.png'),
              )),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
        return WillPopScope(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: heightMedia * .08),
                child: InkWell(
                  onTap: () async {
                    await SystemChannels.textInput.invokeMethod("TextInput.hide");

                    ChatCubit.get(context).changeEmojiShow = ChatCubit.get(context).changeBool(true);
                    SendMessage.controller.clear();
                  },
                  child: ListView(
                    controller: scroll,
                    children: ChatCubit.get(context).lastMessage[modelUser.id]!.map((Message message) {
                      return MessagesWidget(message: message);
                    }).toList(),
                  ),
                ),
              ),
              SendMessage(
                receiveId: modelUser.id!,
                scroll: scroll,
              )
            ],
          ),
          onWillPop: () async {
            if (ChatCubit.get(context).changeEmojiShow) {
              ChatCubit.get(context).changeEmojiShow = ChatCubit.get(context).changeBool(true);
            } else {
              await SystemChannels.textInput.invokeMethod("TextInput.hide");
            }
            return Future.value(false);
          },
        );
      }),
    );
  }
}
