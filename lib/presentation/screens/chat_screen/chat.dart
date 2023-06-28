import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/domain/entities/model_message.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:chat_first/presentation/screens/chat_screen/lastSeen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/constants.dart';
import 'message_widget.dart';
import 'widget_send_message.dart';

class Chat extends StatefulWidget {
  final int countInList;

  final Users modelUser;

  Chat({
    Key? key,
    required this.modelUser,
    required this.countInList,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  ScrollController scroll = ScrollController();
  bool isVisible = false;

  bool canExecute = true;
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      isVisible = visible;
      if (canExecute) {
        canExecute = !canExecute;

        if (isVisible) {
          ChatCubit.get(context).addMessage(Message.fromJson({
            'sendId': widget.modelUser.id,
            'receiveId': Constants.idForMe,
            'text': Constants.type,
            'read': false,
            'dateTime': DateTime.now().toString(),
            'createdAt': DateTime.now(),
          }).toMap());
        } else if (!isVisible) {
          ChatCubit.get(context).removeMessage(widget.modelUser.id);
        }
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            canExecute = !canExecute;
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// very important to implement in many methods
    if (ChatCubit.get(context).needScroll) {
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
              widget.modelUser.name,
              style: AppStyles.style16,
            ),
            LastSeen(
              id: widget.modelUser.id,
            )
          ],
        ),
        actions: [
          SizedBox(
              width: 50,
              child: MaterialButton(
                onPressed: () => callFunction(context, widget.modelUser),
                child: Image.asset('assets/phone.png'),
              )),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
        if (state is GetMessagesSuccessState) {
          Future.delayed(
            const Duration(milliseconds: 100),
            () => scroll.jumpTo(scroll.position.maxScrollExtent),
          );
        }
      }, builder: (context, state) {
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
                  child: ChatCubit.get(context).lastMessage[widget.modelUser.id] == null
                      ? Center(
                          child: animatedText(text: 'Say hello'),
                        )
                      : ListView(
                          controller: scroll,
                          children: ChatCubit.get(context).lastMessage[widget.modelUser.id]!.map((Message message) {
                            return MessagesWidget(message: message);
                          }).toList(),
                        ),
                ),
              ),
              SendMessage(
                receiveId: widget.modelUser.id,
                scroll: scroll,
              ),
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
