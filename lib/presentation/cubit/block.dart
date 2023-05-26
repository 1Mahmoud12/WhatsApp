import 'dart:io';

import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:chat_first/presentation/screens/call_screen/call_screen.dart';
import 'package:chat_first/presentation/screens/chat_screen/chat.dart';
import 'package:chat_first/presentation/screens/contact_screen/contact_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/snak_bar_me.dart';
import '../../domain/entities/model_message.dart';
import '../../domain/use_case/add_user_use_case.dart';
import '../../domain/use_case/create_chats.dart';
import '../../domain/use_case/get_chat.dart';
import '../../domain/use_case/get_users_use_case.dart';
import '../screens/all_users_screen/howe_page_screen.dart';


class ChatCubit extends Cubit<ChatState>{
  final AddUsersUseCase addUsersUseCase;
  final GetUsersUseCase getUsersUseCase;
  final CreateMessagesUseCase createMessageUseCase;
  final GetChatsUseCase getChatsUseCase;
  final GetLastMessageUseCase getLastMessageUseCase;
  ChatCubit(this.addUsersUseCase,this.getUsersUseCase,this.createMessageUseCase,this.getChatsUseCase,this.getLastMessageUseCase) : super(InitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  int currentState = 2;

  List<Widget> screens = [
    const VideoSDKQuickStart(),
    const MessageScreen(),
    const MessageScreen(),
    const ContactScreen(),
  ];


  void changeIndex(int index) {
    currentState = index;
    emit(BottomNavigationChangeState());
  }


  List<Contact>? contacts;
  Future<List<Contact>> getContact() async{


    if (await FlutterContacts.requestPermission()) {
    contacts = await FlutterContacts.getContacts(
    withProperties: true, withPhoto: true);
    }
    emit(GetContactState());
  return contacts??[];

  }

  Future getImage() async {
    emit(GetImageLoadingState());
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicker =
        await picker.pickImage(source: ImageSource.gallery);

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imagePicker!.path).pathSegments.last}')
        .putFile(File(imagePicker.path))
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(GetImageSuccessState());
        Constants.usersForMe!.image = value;
        addUser({
          'id': Constants.usersForMe!.id,
          'name': Constants.usersForMe!.name,
          'age': Constants.usersForMe!.age,
          'phone': Constants.usersForMe!.phone,
          'image': value,
        });
      });
    });

    print("image : ${Constants.usersForMe!.image}");
  }
  Future addAudio(String value)async{
    emit(AddAudioState());
    addMessage({
      'id': Constants.usersForMe!.id,
      'name': Constants.usersForMe!.name,
      'age': Constants.usersForMe!.age,
      'phone': Constants.usersForMe!.phone,
      'audio': value,
    });
  }

  Future addUser(Map<String,dynamic>json)async{

    addUsersUseCase.call(Users.fromJson(json).toMap());
  }
  Future getMyData()async{
    FirebaseFirestore.instance.collection(Constants.collectionUser).doc(Constants.idForMe).get()
        .then((value) {

      Constants.usersForMe=Users.fromJson(value.data()!);
      Constants.idForMe=value.id;
    })
        .catchError((error){
     //const SnackBarMe(color: Colors.red,text: 'no connection',);
    });
  }

  bool enabledMessagesScreen=false;
  bool changeEmojiShow=false;
  bool needScroll=false;
  bool createTokenMessaging=false;


  changeBool(bool index){

    index=!index;
    emit(ChangeBoolState());
    return index;

  }

  getAllUsers()async{
    emit(GetAllUsersLoadingState());
   await getUsersUseCase.call().then((value) {
     emit(GetAllUsersSuccessState());
     if(ChatRemoteDatsSource.users.isNotEmpty) {
       getLastMessage();
     }
     changeBool(enabledMessagesScreen);

   })/*.catchError((error){
     print(error.toString());
     emit(GetAllUsersErrorState());
   })*/;



    }


  Future addMessage(Map<String,dynamic>json)async{
    emit(CreateMessageLoadingState());
    createMessageUseCase.call(json).then((value) {
      emit(CreateMessageSuccessState());

    });
  }
  Map<String,List<Message>?> lastMessage={};
  void getLastMessage(){
    emit(GetMessagesLoadingState());

    for(int i=0;i<ChatRemoteDatsSource.lengthUsers-1;i++){
      FirebaseFirestore.instance
          .collection('users')
          .doc(Constants.idForMe)
          .collection(Constants.collectionChats)
          .doc(ChatRemoteDatsSource.users[i].id)
          .collection(Constants.collectionMessages)
          .orderBy('createdAt')
          .snapshots()
          .listen((event) {
        var events= event.docs;
        lastMessage[ChatRemoteDatsSource.users[i].id!]=[];
        for (var element in events) {
          lastMessage[ChatRemoteDatsSource.users[i].id!]!.add(Message(element.data()));
        }
        emit(GetMessagesSuccessState());
        needScroll=true;
      }).onError((error){
        print(error.toString());
      });
    }



    /* await getLastMessageUseCase.call(receiveId).then((value)  {


     });*/


  }


  int increment(){
    int index=0;
    emit(IncrementState());
    return index++;
  }



}