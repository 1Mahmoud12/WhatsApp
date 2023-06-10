import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/utils/constants.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    TextEditingController nameController =
        TextEditingController(text: Constants.usersForMe!.name.toString());
    TextEditingController ageController = TextEditingController(
        text: Constants.usersForMe!.age == null
            ? '0'
            : Constants.usersForMe!.age.toString());

    TextEditingController phoneController =
        TextEditingController(text: Constants.usersForMe!.phone);
    TextEditingController statusController = TextEditingController(text: '');

    Constants.usersForMe!.name = nameController.text;
    Constants.usersForMe!.phone = phoneController.text;
    Constants.usersForMe!.age = ageController.text;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              FirebaseAuth.instance.app.delete();
              FirebaseAuth.instance.signOut();

              await SharedPreference.putDataString('id', '');

              context.push("/Sign");
            },
            child: const Icon(Icons.exit_to_app_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: widthMedia * .2,
                      backgroundColor: Colors.black45,
                      child: imageFunction(
                          widthMedia: widthMedia, heightMedia: heightMedia),
                    ),
                    TextButton(
                        onPressed: () async {
                          await ChatCubit.get(context).getImage();
                        },
                        child: const Icon(Icons.edit)),
                  ],
                );
              },
            ),
            textField(
              context: context,
              nameField: 'name',
              controller: nameController,
            ),
            textField(
              context: context,
              nameField: 'status',
              controller: statusController,
            ),
            textField(
              context: context,
              nameField: 'phone',
              controller: phoneController,
            ),
            textField(
                context: context, nameField: 'age', controller: ageController),
            SizedBox(
              height: heightMedia * .09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async =>
                        await ChatCubit.get(context).addUser({
                          'id': Constants.usersForMe!.id,
                          'name': nameController.text,
                          'phone': phoneController.text,
                          'age': ageController.text,
                        }),
                    child: Text(
                      'Update',
                      style: AppStyles.style15
                          .copyWith(color: HexColor(AppColors.lightColor)),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageFunction({
    required double widthMedia,
    required double heightMedia,
  }) {
    return Constants.usersForMe!.image == 'assets/person.png' ||
            Constants.usersForMe!.image == null
        ? Image.asset(
            'assets/person.png',
            width: widthMedia * .4,
            height: heightMedia * .3,
          )
        : CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(
              Constants.usersForMe!.image!,
            ),
          );
  }

  Widget textField(
      {required context,
      required String nameField,
      required TextEditingController controller}) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: heightMedia * .02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$nameField :',
                style: AppStyles.style16,
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white54, width: 2)),
                width: widthMedia * .8,
                child: TextFormField(
                  maxLines: null,
                  controller: controller,
                  obscureText: nameField == 'password',
                  decoration: InputDecoration(
                    hintText: controller.text,
                    hintStyle: AppStyles.style15.copyWith(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
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
      ],
    );
  }
}
