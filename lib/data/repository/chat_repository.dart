import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/domain/entities/model_calls.dart';
import 'package:chat_first/domain/entities/model_user.dart';

import '../../domain/entities/model_message.dart';
import '../../domain/repository/chat_repository.dart';

class ChatRepository implements ChatRepositoryDomain {
  final ChatRemoteDatsSourceRepository chatRemoteDatsSourceRepository;

  ChatRepository(this.chatRemoteDatsSourceRepository);

  @override
  void addUsersDomain(Map<String, dynamic> json) {
    chatRemoteDatsSourceRepository.addUserRemoteDataSource(json);
  }

  @override
  Future<List<Users>> getUsers() async {
    return await chatRemoteDatsSourceRepository.getUserRemoteDataSource();
  }

  @override
  Future createMessage(Map<String, dynamic> json) async {
    chatRemoteDatsSourceRepository.createMessageChatsRemoteDataSource(json);
  }

  @override
  Future<List<Message>> getChats(String receiveId) async {
    return await chatRemoteDatsSourceRepository.getChatsRemoteDataSource(receiveId);
  }

  @override
  Future<Message> lastMessage(String receiveId) async {
    return await chatRemoteDatsSourceRepository.lastMessageRemoteDataSource(receiveId);
  }

  @override
  Future<List<Calls>> getCalls() async {
    return await chatRemoteDatsSourceRepository.getCalls();
  }

  @override
  Future<void> addCalls(Map<String, dynamic> json) async {
    return await chatRemoteDatsSourceRepository.addCalls(json);
  }
}
