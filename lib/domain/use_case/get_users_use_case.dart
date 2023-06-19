import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/domain/repository/chat_repository.dart';

class GetUsersUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  GetUsersUseCase(this.chatRepositoryDomain);

  Future<List<Users>> call() async {
    return await chatRepositoryDomain.getUsers();
  }
}
