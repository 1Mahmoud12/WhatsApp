import 'package:chat_first/domain/repository/chat_repository.dart';

class RemoveMessageUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  RemoveMessageUseCase(this.chatRepositoryDomain);

  void call(String receivedId) {
    chatRepositoryDomain.removeMessage(receivedId);
  }
}
