import 'package:another_flushbar/flushbar.dart';
import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/src/Features/sign_in/Pages/bloc/sign_cubit.dart';
import 'package:chat_first/src/Features/sign_in/Pages/bloc/sign_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../domain/entities/model_user.dart';
import '../../profile_screen/Pages/profile.dart';

class SignIn extends StatelessWidget {
  final TextEditingController smsController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightMedia = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField(
                context: context,
                nameField: 'phone',
                controller: phoneController,
              ),
              SizedBox(
                height: heightMedia * .09,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        await auth.verifyPhoneNumber(
                          phoneNumber: "+2${phoneController.text}",
                          timeout: const Duration(minutes: 2),
                          verificationFailed: (FirebaseAuthException e) {
                            print('${e.code}');
                            Flushbar(
                              message: e.code,
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ).show(context);
                          },
                          codeSent: (String verificationId, int? resendToken) async {
                            print(phoneController.text);
                            String smsCode = '';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlertDialog(
                                          title: const Text("verification number"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                  textInputAction: TextInputAction.send,
                                                  keyboardType: TextInputType.number,
                                                  controller: smsController),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  smsCode = smsController.text;

                                                  var credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                                                  auth.signInWithCredential(credential).then((value) async {
                                                    SharedPreference.putDataString('id', value.user!.uid);

                                                    /*Constants.usersForMe?.id = value.user!.uid;
                                                    Constants.usersForMe?.phone = phoneController.text;*/
                                                    Constants.usersForMe =
                                                        Users.fromJson({'id': value.user!.uid, 'phone': phoneController.text, 'name': 'new value'});

                                                    Constants.tokenMessaging = await FirebaseMessaging.instance.getToken() ?? '';
                                                    BlocProvider.of<SignCubit>(context).addUser({
                                                      'id': value.user!.uid,
                                                      'phone': phoneController.text,
                                                      'lastSeen': DateTime.now().toString(),
                                                      'name': 'new value'
                                                    });
                                                    Navigator.of(context).pushReplacement(createRoute(Profile(firstTimeSign: true), -1, 1));
                                                  });
                                                },
                                                child: const Text('ok'))
                                          ],
                                        )));
                          },
                          verificationCompleted: (PhoneAuthCredential credential) async {
                            auth.signInWithCredential(credential).then((value) async {
                              SharedPreference.putDataString('id', value.user!.uid);

                              Constants.usersForMe = Users.fromJson({'id': value.user!.uid, 'phone': phoneController.text, 'name': 'new value'});

                              Constants.tokenMessaging = await FirebaseMessaging.instance.getToken() ?? '';
                              BlocProvider.of<SignCubit>(context).add(SignEvent({
                                'id': value.user!.uid,
                                'phone': phoneController.text,
                                'lastSeen': DateTime.now().toString(),
                                'name': 'new value'
                              }));
                              Navigator.of(context).pushReplacement(createRoute(Profile(firstTimeSign: true), -1, 1));
                            });
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      },
                      style: const ButtonStyle(
                        side: MaterialStatePropertyAll(BorderSide(width: 1, color: Colors.white)),
                      ),
                      child: Text(
                        'verify',
                        style: AppStyles.style15.copyWith(color: HexColor(AppColors.lightColor)),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
