import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/utils/constants.dart';

class SignIn extends StatelessWidget {
  final TextEditingController smsController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  SignIn({super.key});

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
                        Constants.usersForMe = Users(
                          phone: phoneController.text,
                        );
                        FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.verifyPhoneNumber(
                          phoneNumber: "+2${phoneController.text}",
                          timeout: const Duration(minutes: 2),
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            print(phoneController.text);
                            auth
                                .signInWithCredential(credential)
                                .then((value) {});
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            }
                          },
                          codeSent:
                              (String verificationId, int? resendToken) async {
                            String smsCode = '';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              "enter verification number"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                  controller: smsController),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  smsCode = smsController.text;

                                                  var credential =
                                                      PhoneAuthProvider
                                                          .credential(
                                                              verificationId:
                                                                  verificationId,
                                                              smsCode: smsCode);
                                                  FirebaseAuth.instance
                                                      .signInWithCredential(
                                                          credential)
                                                      .then((value) async {
                                                    Constants.tokenMessaging =
                                                        await FirebaseMessaging
                                                                .instance
                                                                .getToken() ??
                                                            '';
                                                    SharedPreference
                                                        .putDataString('id',
                                                            value.user!.uid);
                                                    ChatCubit.get(context)
                                                        .addUser({
                                                      'id': value.user!.uid,
                                                      'phone':
                                                          phoneController.text,
                                                      'tokenMessaging':
                                                          Constants
                                                              .tokenMessaging,
                                                      'lastSeen':
                                                          DateTime.now(),
                                                    });
                                                    Navigator.of(context).push(
                                                        createRoute(
                                                            const MainPage(),
                                                            -1,
                                                            1));
                                                  });
                                                },
                                                child: const Text('ok'))
                                          ],
                                        )));
                            /*PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);

                            await auth.signInWithCredential(credential);*/
                            ConfirmationResult confirmationResult = await auth
                                .signInWithPhoneNumber(phoneController.text);
                            UserCredential userCredential =
                                await confirmationResult.confirm(smsCode);
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      },
                      style: const ButtonStyle(
                        side: MaterialStatePropertyAll(
                            BorderSide(width: 1, color: Colors.white)),
                      ),
                      child: Text(
                        'verify',
                        style: AppStyles.style15
                            .copyWith(color: HexColor(AppColors.lightColor)),
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
