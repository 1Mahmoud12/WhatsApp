import '../repository/add_user_repository.dart';

class AddUsersUseCase {
  final AddUserRepositoryDomain chatRepositoryDomain;

  AddUsersUseCase(this.chatRepositoryDomain);

  void call(Map<String, dynamic> json) async {
    chatRepositoryDomain.addUsersDomain(json);
  }
}
