import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/utils/constants.dart';

class SignIn extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController smsController = TextEditingController();


  SignIn({super.key});

  @override
  Widget build(BuildContext context) {

    double widthMedia = MediaQuery.of(context).size.width;
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
                      onPressed: () async{
                        Constants.usersForMe = Users(
                            phone: phoneController.text,
                            );

                        if(ChatRemoteDatsSource.users.isNotEmpty){
                          for(var user in ChatRemoteDatsSource.users){
                            if(user.phone==phoneController.text){

                              Constants.idForMe=user.id;
                              SharedPreference.putDataString('id',user.id!);
                              ChatCubit.get(context).getMyData();
                              ChatCubit.get(context).getAllUsers();
                              navigatorReuse(context,const MainPage());
                            }
                          }
                        }else{ await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+2${phoneController.text}",
                          timeout:const Duration(minutes: 2),
                          verificationCompleted: (PhoneAuthCredential credential) {
                            FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                            });
                          },
                          verificationFailed: (FirebaseAuthException e) {

                          },
                          codeSent: (String verificationId, int? resendToken) async{


                            String smsCode='';
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AlertDialog(
                              title: const Text("enter verification number"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: smsController),
                                ],
                              ),
                              actions: [

                                TextButton(onPressed: (){
                                  smsCode = smsController.text;

                                  var credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                                  FirebaseAuth.instance.signInWithCredential(credential).then((value) async{
                                   Constants.tokenMessaging=await FirebaseMessaging.instance.getToken()??'';
                                    SharedPreference.putDataString('id',value.user!.uid);
                                    ChatCubit.get(context).addUser( {
                                      'id':value.user!.uid,
                                      'name':nameController.text,
                                      'phone':phoneController.text,
                                      'age':ageController.text,
                                      'tokenMessaging':Constants.tokenMessaging,
                                      'lastSeen':DateTime.now(),

                                    }
                                    );
                                    Navigator.of(context).push(createRoute(const MainPage(), -1, 1));
                                  });
                                }, child:const Text('ok'))
                              ],
                            )));
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

                            await FirebaseAuth.instance.signInWithCredential(credential);
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );}



                      },
                      style: const ButtonStyle(
                        side: MaterialStatePropertyAll(BorderSide(width: 1,color: Colors.white)),

                      ),
                      child: Text('verify',
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

  Widget textField(
      {required context,
      required String nameField,
      required TextEditingController controller}) {

    return Center(
      child:  Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Expanded(
              flex:2,
              child: Text(
                '$nameField :',
                style: AppStyles.style16,
              ),
            ),

            Expanded(
              flex: 8,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                obscureText: nameField == 'password',
                decoration: InputDecoration(
                  hintText: controller.text == ''
                      ? 'Enter $nameField'
                      : controller.text,
                  hintStyle:
                  AppStyles.style15.copyWith(color: Colors.white38),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 1)
                  ),

                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 20, color: Colors.white),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    controller.text = value;
                    SharedPreference.putDataString(nameField, value);
                  }
                  //controller.clear();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
