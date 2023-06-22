import 'package:chat_first/domain/repository/chat_repository.dart';

import '../entities/model_calls.dart';

class GetCallsUseCase {
  final ChatRepositoryDomain chatRepositoryDomain;

  GetCallsUseCase(this.chatRepositoryDomain);

  Future<List<Calls>> call() async {
    return await chatRepositoryDomain.getCalls();
  }
}
