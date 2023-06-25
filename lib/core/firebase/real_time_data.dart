import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/domain/entities/model_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../presentation/cubit/block.dart';
import '../../presentation/screens/chat_screen/message_widget.dart';
import '../utils/general_functions.dart';

class ChatsInformation extends StatefulWidget {
  final String receiveId;
  final String sendId;
  const ChatsInformation({super.key, required this.receiveId, required this.sendId});
  static ScrollController scroll = ScrollController();

  @override
  ChatsInformationState createState() => ChatsInformationState();
}

class ChatsInformationState extends State<ChatsInformation> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ChatCubit.get(context).needScroll) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () => ChatsInformation.scroll.jumpTo(ChatsInformation.scroll.position.maxScrollExtent),
        );
        ChatCubit.get(context).needScroll = ChatCubit.get(context).changeBool(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.sendId)
        .collection(Constants.collectionChats)
        .doc(widget.receiveId)
        .collection(Constants.collectionMessages)
        .orderBy('createdAt')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text('NO Connection'))));
          return const Text('NO Connection');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return indicator();
        }
        if (snapshot.hasData) {
          Future.delayed(
            const Duration(
              milliseconds: 1000,
            ),
            () => ChatsInformation.scroll.jumpTo(ChatsInformation.scroll.position.maxScrollExtent),
          );
        }

        return ListView(
          controller: ChatsInformation.scroll,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            Message model = Message.fromJson(data);

            return MessagesWidget(message: model);
          }).toList(),
        );
      },
    );
  }
}
