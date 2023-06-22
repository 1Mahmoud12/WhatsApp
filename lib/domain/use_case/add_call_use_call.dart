import '../repository/chat_repository.dart';

class AddCallsUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  AddCallsUseCase(this.chatRepositoryDomain);

  Future<void> call(Map<String, dynamic> json) async {
    await chatRepositoryDomain.addCalls(json);
  }
}
