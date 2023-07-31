import 'package:bloc/bloc.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/src/Features/sign_in/Pages/bloc/sign_event.dart';
import 'package:chat_first/src/Features/sign_in/Pages/bloc/sign_state.dart';

import '../../../../../domain/entities/model_user.dart';
import '../../domain/use_case/add_user_use_case.dart';

class SignCubit extends Bloc<BaseSignEvent, SignState> {
  final AddUsersUseCase addUsersUseCase;

  SignCubit(this.addUsersUseCase) : super(InitialState()) {
    on<SignEvent>((event, emit) async {
      emit(LoadingState());
      return await addUser(event.json).then((value) {
        emit(SuccessState());
      }).catchError((error) {
        printDM('Error in Sign Bloc');
        printDM(error.toString());
      });
    });
  }

  SignState get initialState => InitialState();
  Future addUser(Map<String, dynamic> json) async {
    addUsersUseCase.call(Users.fromJson(json).toMap());
  }

  //static SignCubit get(context) => BlocProvider.of(context);
}
