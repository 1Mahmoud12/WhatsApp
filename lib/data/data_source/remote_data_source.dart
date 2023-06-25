import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/domain/entities/model_calls.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/model_message.dart';

abstract class ChatRemoteDatsSourceRepository {
  void addUserRemoteDataSource(Map<String, dynamic> json);
  Future<List<Users>> getUserRemoteDataSource();
  Future<List<Calls>> getCalls();
  Future<void> addCalls(Map<String, dynamic> json);
  Future createMessageChatsRemoteDataSource(Map<String, dynamic> json);
  Future<List<Message>> getChatsRemoteDataSource(String receiveId);
  Future<Message> lastMessageRemoteDataSource(String receiveId);
  void removeMessage(String receivedId);
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
      await fireStoreUsers.doc(Constants.idForMe).update(json);
    }
  }

  static int lengthUsers = 0;
  static List<Users> users = [];
  @override
  Future<List<Users>> getUserRemoteDataSource() async {
    await fireStoreUsers.get().then((value) async {
      users = [];

      for (var element in value.docs) {
        if (element.data()['id'] == Constants.idForMe) {
          Constants.usersForMe = Users.fromJson(element.data());
        } else {
          users.add(Users.fromJson(element.data()));
        }
      }
      lengthUsers = value.docs.length;
    });

    return users;
  }

  @override
  Future createMessageChatsRemoteDataSource(Map<String, dynamic> json) async {
    await fireStoreUsers
        .doc(json['sendId'])
        .collection(Constants.collectionChats)
        .doc(json['receiveId'])
        .collection(Constants.collectionMessages)
        .add(json);
    if (json['text'] != 'Typing0x') {
      print(json['text']);
      await fireStoreUsers
          .doc(json['receiveId'])
          .collection(Constants.collectionChats)
          .doc(json['sendId'])
          .collection(Constants.collectionMessages)
          .add(json);
      //getChatsRemoteDataSource(json['receiveId']);
    }
  }

  @override
  Future<List<Message>> getChatsRemoteDataSource(String receiveId) async {
    fireStoreUsers
        .doc(Constants.idForMe)
        .collection(Constants.collectionChats)
        .doc(receiveId)
        .collection('messages')
        .orderBy('dataTime')
        .snapshots()
        .listen((event) {
      Constants.modelOfChats = [];
      for (var element in event.docs) {
        Constants.modelOfChats.add(Message.fromJson(element.data()));
      }
    });

    return Constants.modelOfChats;
  }

  static Message? lastMessage;

  @override
  Future<Message> lastMessageRemoteDataSource(String receiveId) async {
    await fireStoreUsers
        .doc(Constants.idForMe)
        .collection(Constants.collectionChats)
        .doc(receiveId)
        .collection(Constants.collectionMessages)
        .orderBy('createdAt')
        .get()
        .then((value) {
      lastMessage = Message.fromJson(value.docs.last.data());
    });

    return lastMessage!;
  }

  @override
  Future<List<Calls>> getCalls() async {
    List<Calls> call = [];
    final response = await fireStoreUsers.doc(Constants.idForMe).collection(Constants.collectionCalls).get();
    if (await hasNetwork()) {
      for (var element in response.docs) {
        call.add(Calls.fromJson(element.data()));
      }
    }

    return call;
  }

  @override
  Future<void> addCalls(Map<String, dynamic> json) async {
    await fireStoreUsers.doc(json['sendId']).collection(Constants.collectionCalls).add(json);
    //await fireStoreUsers.doc(json["receiveId"]).collection(Constants.collectionCalls).add(json);
  }

  @override
  void removeMessage(String receivedId) {
    fireStoreUsers
        .doc(receivedId)
        .collection(Constants.collectionChats)
        .doc(Constants.idForMe)
        .collection(Constants.collectionMessages)
        .orderBy('createdAt')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.data()['text'] == 'Typing0x') element.reference.delete();
      });
    });
  }
}
