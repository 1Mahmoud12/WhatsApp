import 'package:chat_first/domain/repository/chat_repository.dart';

class AddUsersUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  AddUsersUseCase(this.chatRepositoryDomain);

  void call(Map<String, dynamic> json) async {
    chatRepositoryDomain.addUsersDomain(json);
  }
}
