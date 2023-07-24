import '../../domain/repository/add_user_repository.dart';
import '../data_source/add_user_remote_data_source.dart';

class AddUserDataRepository implements AddUserRepositoryDomain {
  final AddUserRemoteDatsSourceRepository chatRemoteDatsSourceRepository;

  AddUserDataRepository(this.chatRemoteDatsSourceRepository);

  @override
  void addUsersDomain(Map<String, dynamic> json) {
    chatRemoteDatsSourceRepository.addUserRemoteDataSource(json);
  }
}
