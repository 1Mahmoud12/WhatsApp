import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/domain/entities/model_message.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/general_functions.dart';
import '../../../domain/entities/model_user.dart';
import '../chat_screen/chat.dart';

class ItemBuilderHomePage extends StatelessWidget {
  final int indexOfUsers;
  const ItemBuilderHomePage({Key? key, required this.indexOfUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    Users model = ChatCubit.get(context).users[indexOfUsers];

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return ChatCubit.get(context).lastMessage[model.id] != null
            ? ListTile(
                dense: true,
                leading: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: widthMedia * .05,
                          backgroundColor: Colors.black45,
                          child: model.image != 'assets/img.png'
                              ? Image.asset(
                                  'assets/person.png',
                                  width: widthMedia * .5,
                                  height: heightMedia * .5,
                                )
                              : Image(
                                  image: NetworkImage(
                                    Constants.modelOfLastMessage.last.text,
                                  ),
                                  width: widthMedia * .3,
                                  height: heightMedia * .3,
                                ),
                        ),
                        if (onlineOrNot(lastSeen: model.lastSeen))
                          CircleAvatar(
                              radius: widthMedia * .015,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.circle,
                                color: HexColor('#0FDB66'),
                                size: 15,
                              ))
                      ],
                    )
                  ],
                ),
                title: Row(
                  children: [
                    SizedBox(
                        width: widthMedia * .35,
                        child: Text(
                          model.name,
                          style: AppStyles.style16.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        )),
                    const Spacer(),
                    Text(
                      ChatCubit.get(context).lastMessage[model.id] != null
                          ? subStringForDate(date: ChatCubit.get(context).lastMessage[model.id]!.last.dateTime)
                          : " ",
                      style: AppStyles.style15.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                subtitle: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: widthMedia * .6,
                            child: Text(
                              subTitle(message: ChatCubit.get(context).lastMessage[model.id]!.last),
                              style: AppStyles.style15.copyWith(
                                  color: ChatCubit.get(context).lastMessage[model.id]!.last.read
                                      ? HexColor(AppColors.lightColor)
                                      : HexColor(AppColors.boldColor)),
                              overflow: TextOverflow.ellipsis,
                            )),
                        const Spacer(),
                        if (!ChatCubit.get(context).lastMessage[model.id]!.last.read)
                          Icon(
                            Icons.circle,
                            color: HexColor('#007EF4'),
                            size: 13,
                          )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: HexColor(AppColors.greyColor),
                    )
                  ],
                ),
                onTap: () {
                  ChatCubit.get(context).getMyData();
                  ChatRemoteDatsSource().readingMessageChatsRemoteDataSource({
                    'receiveId': ChatCubit.get(context).lastMessage[model.id]!.last.receiveId,
                    'sendId': ChatCubit.get(context).lastMessage[model.id]!.last.sendId,
                    'read': true,
                  });
                  Navigator.of(context).push(createRoute(
                      Chat(
                        modelUser: model,
                        countInList: indexOfUsers,
                      ),
                      -1,
                      1));
                },
              )
            : Container();
      },
    );
  }

  bool onlineOrNot({required String lastSeen}) {
    String today = DateTime.now().toString().substring(5, 10);

    int lastSeenMinusHour = today == lastSeen.substring(5, 10) ? DateTime.parse(lastSeen).hour - 1 : -2;
    int dateTimeMinusHour = DateTime.now().hour - 1;
    if (lastSeenMinusHour == dateTimeMinusHour) {
      return true;
    }
    return false;
  }

  String subTitle({required Message message}) {
    if (message.text.isNotEmpty) {
      return message.text;
    } else if (message.image.isNotEmpty) {
      return 'send image';
    } else if (message.audio.isNotEmpty) {
      return 'send audio';
    } else {
      return "say 👋";
    }
  }
}
