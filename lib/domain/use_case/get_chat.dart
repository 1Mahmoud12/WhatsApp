import 'package:chat_first/domain/repository/chat_repository.dart';

import '../entities/model_message.dart';

class GetChatsUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  GetChatsUseCase(this.chatRepositoryDomain);

  Future<List<Message>> call(String receiveId) async {
    return await chatRepositoryDomain.getChats(receiveId);
  }
}
