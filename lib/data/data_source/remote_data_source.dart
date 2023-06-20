import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/model_message.dart';

abstract class ChatRemoteDatsSourceRepository {
  void addUserRemoteDataSource(Map<String, dynamic> json);
  Future<List<Users>> getUserRemoteDataSource();
  Future createMessageChatsRemoteDataSource(Map<String, dynamic> json);
  Future<List<Message>> getChatsRemoteDataSource(String receiveId);
  Future<Message> lastMessageRemoteDataSource(String receiveId);
}

class ChatRemoteDatsSource extends ChatRemoteDatsSourceRepository {
  final fireStoreUsers = FirebaseFirestore.instance.collection('users');
  @override
  Future<void> addUserRemoteDataSource(Map<String, dynamic> json) async {
    if (Constants.idForMe == null) {
      await fireStoreUsers.doc(json['id']).set(json).then((value) {
        Constants.idForMe = json['id'];
        SharedPreference.putDataString('id', json['id']);
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(Constants.idForMe).update(json);
    }
  }

  static int lengthUsers = 0;
  static List<Users> users = [];
  @override
  Future<List<Users>> getUserRemoteDataSource() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) async {
      users = [];

      value.docs.forEach((element) {
        if (element.data()['id'] == Constants.idForMe) {
          Constants.usersForMe = Users.fromJson(element.data());
        } else {
          users.add(Users.fromJson(element.data()));
        }
      });
      lengthUsers = value.docs.length;
    });

    return users;
  }

  @override
  Future createMessageChatsRemoteDataSource(Map<String, dynamic> json) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(json['sendId'])
        .collection('chats')
        .doc(json['receiveId'])
        .collection('messages')
        .add(json);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(json['receiveId'])
        .collection('chats')
        .doc(json['sendId'])
        .collection('messages')
        .add(json);
    //getChatsRemoteDataSource(json['receiveId']);
  }

  @override
  Future<List<Message>> getChatsRemoteDataSource(String receiveId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.idForMe)
        .collection('chats')
        .doc(receiveId)
        .collection('messages')
        .orderBy('dataTime')
        .snapshots()
        .listen((event) {
      Constants.modelOfChats = [];
      event.docs.forEach((element) {
        Constants.modelOfChats.add(Message(element.data()));
        print(element.data());
      });
    });

    /* print(model);*/
    return await Constants.modelOfChats;
  }

  static Message? lastMessage;

  @override
  Future<Message> lastMessageRemoteDataSource(String receiveId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.idForMe)
        .collection(Constants.collectionChats)
        .doc(receiveId)
        .collection(Constants.collectionMessages)
        .orderBy('createdAt')
        .get()
        .then((value) {
      lastMessage = Message(value.docs.last.data());
    });

    return lastMessage!;
  }
}
