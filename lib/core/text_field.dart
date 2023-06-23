import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/presentation/screens/chat_screen/widget_send_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/entities/model_message.dart';
import '../presentation/cubit/block.dart';

class TextFieldMessage extends StatefulWidget {
  final String receiveId;
  final ScrollController scroll;

  const TextFieldMessage({
    Key? key,
    required this.receiveId,
    required this.scroll,
  }) : super(key: key);
  static String? copyTextController;

  @override
  State<TextFieldMessage> createState() => _TextFieldMessageState();
}

class _TextFieldMessageState extends State<TextFieldMessage> {
  FocusNode focus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: SendMessage.controller,
      focusNode: focus,

      /// when maxLines == null the text go to new line when fill that line
      maxLines: null,
      decoration: InputDecoration(
          hintText: SendMessage.controller.text == '' ? 'Type your message' : SendMessage.controller.text,
          hintStyle: AppStyles.style15.copyWith(color: Colors.white),
          border: InputBorder.none,
          prefixIcon: IconButton(
              onPressed: () {
                focus.unfocus();
                focus.canRequestFocus = false;
                SystemChannels.textInput.invokeMethod("TextInput.hide");
                TextFieldMessage.copyTextController = SendMessage.controller.text;
                ChatCubit.get(context).changeEmojiShow = ChatCubit.get(context).changeBool(ChatCubit.get(context).changeEmojiShow);
              },
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.white,
              ))),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: Colors.white),
      onSubmitted: (value) {
        keyboard(context);
        if (value.isNotEmpty && value != " ") {
          ChatCubit.get(context)
              .addMessage(Message.fromJson({
            'sendId': Constants.idForMe,
            'receiveId': widget.receiveId,
            'text': SendMessage.controller.text,
            'dateTime': DateTime.now().toString(),
            'createdAt': DateTime.now(),
          }).toMap())
              .whenComplete(() {
            Future.delayed(
              const Duration(milliseconds: 100),
              () => widget.scroll.jumpTo(widget.scroll.position.maxScrollExtent),
            );
          });
        }
      },
      onChanged: (value) {
        keyboard(context);
        if (value.length == 1 || value.isEmpty) {
          ChatCubit.get(context).changeBool(true);
        }
      },
    );
  }
}
