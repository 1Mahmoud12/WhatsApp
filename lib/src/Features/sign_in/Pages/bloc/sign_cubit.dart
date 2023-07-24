import 'package:chat_first/src/Features/sign_in/Pages/bloc/sign_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/model_user.dart';
import '../../domain/use_case/add_user_use_case.dart';

class SignCubit extends Cubit<SignState> {
  final AddUsersUseCase addUsersUseCase;

  SignCubit(this.addUsersUseCase) : super(InitialState());

  static SignCubit get(context) => BlocProvider.of(context);

  Future addUser(Map<String, dynamic> json) async {
    emit(LoadingState());
    addUsersUseCase.call(Users.fromJson(json).toMap());
    emit(SuccessState());
  }
}
