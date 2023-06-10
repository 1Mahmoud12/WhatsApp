import 'package:chat_first/presentation/screens/sign_in/sign_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(InitialState());

  static SignCubit get(context) => BlocProvider.of(context);
}
