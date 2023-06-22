import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/general_functions.dart';
import '../../../data/data_source/remote_data_source.dart';
import '../../../domain/entities/model_user.dart';
import '../chat_screen/chat.dart';

class ItemBuilderHomePage extends StatelessWidget {
  final int indexOfUsers;
  const ItemBuilderHomePage({Key? key, required this.indexOfUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    Users model = ChatRemoteDatsSource.users[indexOfUsers];

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        // print(model.id);
        return ConditionalBuilder(
          condition: ChatRemoteDatsSource.lengthUsers - 1 == ChatRemoteDatsSource.users.length && ChatCubit.get(context).lastMessage.isNotEmpty,
          builder: (context) => ListTile(
            dense: true,
            leading: Stack(
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
                CircleAvatar(
                    radius: widthMedia * .015,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.circle,
                      color: HexColor('#0FDB66'),
                      size: 15,
                    ))
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
                      ? subStringForTime(time: ChatCubit.get(context).lastMessage[model.id]!.last.dateTime)
                      : " ",
                  style: AppStyles.style15.copyWith(color: Colors.white),
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: widthMedia * .6,
                    child: Text(
                      ChatCubit.get(context).lastMessage[model.id] != null ? ChatCubit.get(context).lastMessage[model.id]!.last.text : "say 👋",
                      style: AppStyles.style15.copyWith(color: HexColor(AppColors.lightColor)),
                      overflow: TextOverflow.ellipsis,
                    )),
                const Spacer(),
                Icon(
                  Icons.circle,
                  color: HexColor('#007EF4'),
                  size: 13,
                )
              ],
            ),
            onTap: () {
              ChatCubit.get(context).getMyData();

              Navigator.of(context).push(createRoute(
                  Chat(
                    modelUser: model,
                    countInList: indexOfUsers,
                  ),
                  -1,
                  1));
            },
          ),
          fallback: (context) => const LinearProgressIndicator(),
        );
      },
    );
  }
}
