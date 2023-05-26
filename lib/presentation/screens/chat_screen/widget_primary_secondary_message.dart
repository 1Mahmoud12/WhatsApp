import 'package:camera/camera.dart';
import 'package:chat_first/core/audio/player.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/domain/entities/model_message.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/preview_page.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/general_functions.dart';
import '../../../core/utils/styles.dart';

class MessagesWidget extends StatelessWidget {
  final Message message;

  const MessagesWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Align(
        alignment: message.sendId == Constants.idForMe
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
              color: HexColor(message.sendId == Constants.idForMe
                  ? AppColors.blueColor
                  : AppColors.greyColor),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
                bottomLeft: message.sendId == Constants.idForMe
                    ? const Radius.circular(30)
                    : const Radius.circular(0),
                bottomRight: message.sendId == Constants.idForMe
                    ? const Radius.circular(0)
                    : const Radius.circular(30),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.image != '')
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: widthMedia * .4,
                  height: heightMedia * .2,
                  decoration: BoxDecoration(
                      color: HexColor(message.sendId == Constants.idForMe
                          ? AppColors.blueColor
                          : AppColors.greyColor),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: InkWell(
                      onTap: () {
                        XFile picture = XFile(message.image!);
                        navigatorReuse(
                            context,
                            PreviewPage(
                              picture: message.image!,
                              cameraPage: false,
                            ));
                      },
                      child: Image.network(message.image!)),
                ),
              if (message.text != '')
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(message.text,
                      maxLines: 5,
                      style: AppStyles.style15
                          .copyWith(color: HexColor(AppColors.boldColor))),
                ),
              if (message.audio != null && message.audio!.length > 3)
                Player(filePath: message.audio!),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4, right: 16),
                child: Text(
                  subStringForTime(time: message.dateTime.toString()),
                  style: AppStyles.style13
                      .copyWith(color: HexColor(AppColors.lightColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

*/
