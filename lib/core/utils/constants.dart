import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/entities/model_calls.dart';
import '../../domain/entities/model_user.dart';
import '../../domain/entities/model_message.dart';

class Constants {
  static String? idForMe;
  static bool connection = true;
  static List<Calls> called = [];
  static RemoteMessage? newMessage;
  static bool newMessageOnBackground = false;

  /// fireBase
  static String collectionUser = 'users';
  static String collectionChats = 'chats';
  static String collectionMessages = 'messages';

  /// messaging
  static String? tokenMessaging;

  /// get chats
  // static List<Message> getChats=[];
  static String audio = '';

  static Users? usersForMe;
  static List<Message> modelOfChats = [];
  static List<Message> modelOfLastMessage = [];
}
