import 'package:chat_first/core/utils/loading_screen.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/snak_bar_me.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../../../data/data_source/remote_data_source.dart';
import '../../cubit/states.dart';
import 'widget_item_builder_home_page.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Constants.connection) {
      Future.delayed(
        const Duration(milliseconds: 10),
        () => ScaffoldMessenger.of(context).showSnackBar(snackBarMe(color: Colors.red, text: 'no connection')),
      );
    }
    List<Contact>? model = ChatCubit.get(context).contacts;
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () {
            ChatCubit.get(context).getContact();
            showModalBottomSheet(
                context: context,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: HexColor(AppColors.lightColor)),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                backgroundColor: Colors.black,
                builder: (context) => ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: model![index].photo == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 35,
                                )
                              : CircleAvatar(radius: 18, child: Image.memory(model[index].photo!)),
                          title: Text(
                            model[index].displayName,
                            style: AppStyles.style16.copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            model[index].phones.isNotEmpty ? model[index].phones[0].number : 'no number',
                            style: AppStyles.style15.copyWith(color: HexColor(AppColors.lightColor)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                      itemCount: ChatCubit.get(context).contacts!.length,
                    ));
          },
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)),
          child: Image.asset(
            'assets/img_1.png',
          ),
        ),
        title: const Text(
          "1 new message",
          style: AppStyles.style16,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text("error")));
            },
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)),
            child: Image.asset(
              'assets/img_2.png',
            ),
          )
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return ConditionalBuilder(
            condition: ChatRemoteDatsSource.lastMessage != null,
            builder: (context) {
              print(ChatRemoteDatsSource.lastMessage);
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ItemBuilderHomePage(indexOfUsers: index);
                },
                itemCount: ChatRemoteDatsSource.users.length,
              );
            },
            fallback: (context) {
              return ConditionalBuilder(
                  condition: ChatRemoteDatsSource.lastMessage != null && state is! GetMessagesLoadingState,
                  builder: (context) => LoadingScreen(enabled: ChatCubit.get(context).enabledMessagesScreen),
                  fallback: (context) => const Center(
                        child: Text('No Chats'),
                      ));
            },
          );
        },
      ),
    );
  }
}
