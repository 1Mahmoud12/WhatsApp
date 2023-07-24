import 'dart:io';

import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/domain/use_case/add_call_use_call.dart';
import 'package:chat_first/domain/use_case/remove_message.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/model_calls.dart';
import '../../domain/entities/model_message.dart';
import '../../domain/use_case/create_chats.dart';
import '../../domain/use_case/get_calls_use_case.dart';
import '../../domain/use_case/get_chat.dart';
import '../../domain/use_case/get_users_use_case.dart';
import '../../src/Features/MainChatPage/Pages/howe_page_screen.dart';
import '../../src/Features/call_screen/Pages/call_screen.dart';
import '../../src/Features/profile_screen/Pages/profile.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetUsersUseCase getUsersUseCase;
  final CreateMessagesUseCase createMessageUseCase;
  final GetChatsUseCase getChatsUseCase;
  final GetCallsUseCase getCallsUseCase;
  final AddCallsUseCase addCallsUseCase;
  final RemoveMessageUseCase removeMessageUseCase;
  final GetLastMessageUseCase getLastMessageUseCase;
  ChatCubit(this.getUsersUseCase, this.createMessageUseCase, this.getChatsUseCase, this.getLastMessageUseCase, this.getCallsUseCase,
      this.addCallsUseCase, this.removeMessageUseCase)
      : super(InitialState());

  static ChatCubit get(context) => BlocProvider.of(context);
  int currentState = 2;

  List<Widget> screens = [
    const VideoSDKQuickStart(),
    const AllUsersScreen(),
    const AllUsersScreen(),
    Profile(firstTimeSign: false),
  ];

  void changeIndex(int index) {
    currentState = index;
    emit(BottomNavigationChangeState());
  }

  List<Contact> contacts = [];
  bool contactSuccess = false;

  Future<List<Contact>> getContact() async {
    if (await FlutterContacts.requestPermission()) {
      await FlutterContacts.getContacts(withProperties: true, withPhoto: true).then((value) {
        contacts = value;
        contactSuccess = value.isNotEmpty;
        emit(GetContactState());
      });
    }

    return contacts;
  }

  Future getImage() async {
    emit(GetImageLoadingState());
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicker = await picker.pickImage(source: ImageSource.gallery);

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imagePicker!.path).pathSegments.last}')
        .putFile(File(imagePicker.path))
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(GetImageSuccessState());

        /*addUser({
          'id': Constants.usersForMe!.id,
          'name': Constants.usersForMe!.name,
          'age': Constants.usersForMe!.age,
          'phone': Constants.usersForMe!.phone,
          'image': value,
        });*/
      });
    });

    print("image : ${Constants.usersForMe!.image}");
  }

  Future addAudio(String value) async {
    emit(AddAudioState());
    addMessage({
      'id': Constants.usersForMe!.id,
      'name': Constants.usersForMe!.name,
      'age': Constants.usersForMe!.age,
      'phone': Constants.usersForMe!.phone,
      'audio': value,
      'read': false,
    });
  }

/*  Future addUser(Map<String, dynamic> json) async {
    addUsersUseCase.call(Users.fromJson(json).toMap());
  }*/

  Future getMyData() async {
    FirebaseFirestore.instance.collection(Constants.collectionUser).doc(Constants.idForMe).get().then((value) {
      Constants.usersForMe = Users.fromJson(value.data()!);
      Constants.idForMe = value.id;
    }).catchError((error) {});
  }

  bool enabledMessagesScreen = false;
  bool changeEmojiShow = false;
  bool needScroll = false;
  bool createTokenMessaging = false;

  changeBool(bool index) {
    index = !index;
    emit(ChangeBoolState());
    return index;
  }

  List<Users> users = [];
  getAllUsers() async {
    emit(GetAllUsersLoadingState());
    await getUsersUseCase.call().then((value) {
      emit(GetAllUsersSuccessState());
      users = value;
      if (ChatRemoteDatsSource.users.isNotEmpty) {
        getLastMessage();
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUsersErrorState());
    });
  }

  Future addMessage(Map<String, dynamic> json) async {
    emit(CreateMessageLoadingState());
    createMessageUseCase.call(json).then((value) {
      emit(CreateMessageSuccessState());
      needScroll = true;
    });
  }

  /// [successMessages] =1 for loading , 2 for success , 0 for no messages and 10 for error
  int successMessages = 0;
  Map<String, List<Message>?> lastMessage = {};
  List<String> storeMessages = [];
  void getLastMessage() {
    successMessages = 1;
    emit(GetMessagesLoadingState());
    for (int i = 0; i < users.length; i++) {
      FirebaseFirestore.instance
          .collection(Constants.collectionUser)
          .doc(Constants.idForMe)
          .collection(Constants.collectionChats)
          .doc(users[i].id)
          .collection(Constants.collectionMessages)
          .orderBy('createdAt')
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          lastMessage[users[i].id] = [];
          for (var element in event.docs) {
            lastMessage[users[i].id]!.add(Message.fromJson(element.data()));
            //storeMessages.add(jsonEncode(element.data().toString()));
          }
        }
        emit(GetMessagesSuccessState());
        successMessages = lastMessage.isNotEmpty ? 2 : 0;
      });
    }

    SharedPreference.putDataStringListModel('messages', storeMessages);
    needScroll = true;
  }

  void removeMessage(String receivedId) {
    removeMessageUseCase.call(receivedId);
  }

  late List<Calls> callsInformation;
  void getCalls() {
    callsInformation = [];
    emit(GetCallsLoadingState());
    getCallsUseCase.call().then((value) {
      print(value);
      callsInformation = value;
      emit(GetCallsSuccessState());
    });
  }

  void addCalls(Map<String, dynamic> json) {
    emit(AddCallsLoadingState());
    addCallsUseCase.call(json);

    emit(AddCallsSuccessState());
  }

  int increment() {
    int index = 0;
    emit(IncrementState());
    return index++;
  }
}
