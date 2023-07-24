import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/data/repository/chat_repository.dart';
import 'package:chat_first/domain/repository/chat_repository.dart';
import 'package:chat_first/domain/use_case/add_call_use_call.dart';
import 'package:chat_first/domain/use_case/create_chats.dart';
import 'package:chat_first/domain/use_case/get_chat.dart';
import 'package:chat_first/domain/use_case/get_users_use_case.dart';
import 'package:chat_first/domain/use_case/remove_message.dart';
import 'package:chat_first/src/Features/sign_in/data/data_source/add_user_remote_data_source.dart';
import 'package:chat_first/src/Features/sign_in/data/repository/add_user_data_repository.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/use_case/get_calls_use_case.dart';
import '../../../src/Features/sign_in/domain/repository/add_user_repository.dart';
import '../../../src/Features/sign_in/domain/use_case/add_user_use_case.dart';

final seGet = GetIt.instance;

class ServiceGetIt {
  void init() {
    /// Data Source
    seGet.registerLazySingleton<ChatRemoteDatsSourceRepository>(() => ChatRemoteDatsSource());
    seGet.registerLazySingleton<AddUserRemoteDatsSourceRepository>(() => AddUserRemoteDatsSource());

    /// Repository
    seGet.registerLazySingleton<ChatRepositoryDomain>(() => ChatRepository(seGet()));
    seGet.registerLazySingleton<AddUserRepositoryDomain>(() => AddUserDataRepository(seGet()));

    ///USE CASE
    seGet.registerLazySingleton<AddUsersUseCase>(() => AddUsersUseCase(seGet()));
    seGet.registerLazySingleton<GetUsersUseCase>(() => GetUsersUseCase(seGet()));
    seGet.registerLazySingleton<CreateMessagesUseCase>(() => CreateMessagesUseCase(seGet()));
    seGet.registerLazySingleton<GetChatsUseCase>(() => GetChatsUseCase(seGet()));
    seGet.registerLazySingleton<GetLastMessageUseCase>(() => GetLastMessageUseCase(seGet()));
    seGet.registerLazySingleton<GetCallsUseCase>(() => GetCallsUseCase(seGet()));
    seGet.registerLazySingleton<AddCallsUseCase>(() => AddCallsUseCase(seGet()));
    seGet.registerLazySingleton<RemoveMessageUseCase>(() => RemoveMessageUseCase(seGet()));
  }
}
