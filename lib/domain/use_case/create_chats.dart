import 'package:chat_first/domain/repository/chat_repository.dart';

class CreateMessagesUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  CreateMessagesUseCase(this.chatRepositoryDomain);

  Future call(Map<String, dynamic> json) async {
    chatRepositoryDomain.createMessage(json);
  }
}

class GetLastMessageUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  GetLastMessageUseCase(this.chatRepositoryDomain);

  Future call(String receiveId) async {
    chatRepositoryDomain.lastMessage(receiveId);
  }
}
