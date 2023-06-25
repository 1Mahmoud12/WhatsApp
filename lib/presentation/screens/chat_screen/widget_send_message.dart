import 'package:camera/camera.dart';
import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/domain/entities/model_message.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/audio/recorder.dart';
import '../../../core/camera_page.dart';
import '../../../core/text_field.dart';
import '../../../core/utils/colors.dart';

class SendMessage extends StatelessWidget {
  final String receiveId;
  final ScrollController scroll;

  const SendMessage({super.key, required this.receiveId, required this.scroll});

  static TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;

    if (ChatCubit.get(context).changeEmojiShow) {
      controller.text = TextFieldMessage.copyTextController ?? '';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: HexColor(AppColors.greyColor),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: widthMedia * 59,
                    child: TextFieldMessage(
                      receiveId: receiveId,
                      scroll: scroll,
                    ),
                  ),
                ),
                const Spacer(),
                if (controller.text == '')

                  /// camera
                  IconButton(
                      onPressed: () async {
                        await availableCameras().then(
                          (value) => Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return CameraPage(
                              cameras: value,
                              receiveId: receiveId,
                              text: controller.text,
                            );
                          })),
                        );
                      },
                      icon: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ))),
                if (controller.text == '')

                  /// audio
                  IconButton(
                      onPressed: () async {
                        //var duration = await player.setUr;
                        //navigatorReuse(context, Recorder());

                        await showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35))),
                                  insetPadding: EdgeInsets.only(top: heightMedia * .7, left: widthMedia * .3),
                                  backgroundColor: Colors.grey,
                                  children: [
                                    Recorder(receiveId: receiveId),
                                  ],
                                )).whenComplete(() {
                          if (Constants.audio != '') {
                            ChatCubit.get(context)
                                .addMessage(Message.fromJson({
                              'sendId': Constants.idForMe,
                              'receiveId': receiveId,
                              'audio': Constants.audio,
                              'dateTime': DateTime.now().toString(),
                              'createdAt': DateTime.now(),
                            }).toMap())
                                .whenComplete(() {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => scroll.jumpTo(scroll.position.maxScrollExtent),
                              );
                            });
                          }
                        });
                      },
                      icon: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.mic_rounded,
                            color: Colors.white,
                          ))),

                /// send message
                if (controller.text != ' ' || controller.text.isNotEmpty)
                  IconButton(
                      onPressed: () async {
                        ChatCubit.get(context)
                            .addMessage(Message.fromJson({
                          'sendId': Constants.idForMe,
                          'receiveId': receiveId,
                          'text': controller.text,
                          'dateTime': DateTime.now().toString(),
                          'createdAt': DateTime.now(),
                        }).toMap())
                            .whenComplete(() {
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () => scroll.jumpTo(scroll.position.maxScrollExtent),
                          );
                          ChatCubit.get(context).removeMessage(receiveId);
                        });
                        ChatCubit.get(context).changeEmojiShow = ChatCubit.get(context).changeBool(true);
                        SystemChannels.textInput.invokeMethod("TextInput.hide");
                        controller.clear();
                      },
                      icon: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ))),
              ],
            ),
          ),
          if (ChatCubit.get(context).changeEmojiShow)
            SizedBox(
              height: heightMedia * .3,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  controller.text = controller.text + emoji.emoji;
                },
                config: const Config(
                  columns: 9,
                ),
                //textEditingController: controller,
              ),
            )
        ],
      ),
    );
  }
}
