
import 'package:chat_first/domain/entities/model_user.dart';

import '../entities/model_message.dart';

abstract class ChatRepositoryDomain{
  void addUsersDomain(Map<String,dynamic>json);
  Future<List<Users>> getUsers();
  Future createMessage(Map<String,dynamic>json);
  Future<List<Message>> getChats(String receiveId);
  Future<Message> lastMessage(String receiveId);

}