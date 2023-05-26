import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/utils/constants.dart';

class EditProfile extends StatelessWidget {
  final TextEditingController nameController=TextEditingController(text: Constants.usersForMe!.name);
  final TextEditingController ageController=TextEditingController(text: Constants.usersForMe!.age ==null? '0': Constants.usersForMe!.age.toString());
  final TextEditingController imageController=TextEditingController(text: Constants.usersForMe!.image==null?'assets/person.png': Constants.usersForMe!.image!);
  final TextEditingController phoneController=TextEditingController(text:Constants.usersForMe!.phone);

  EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;

    Constants.usersForMe!.name=nameController.text;
    Constants.usersForMe!.phone=phoneController.text;
    Constants.usersForMe!.age=ageController.text;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: widthMedia*.2,
                      backgroundColor: Colors.black45,
                      child:imageFunction(widthMedia: widthMedia,heightMedia: heightMedia),


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
            textField(context: context, nameField: 'name', controller: nameController,),
            textField(context: context, nameField: 'phone', controller: phoneController,),
            textField(context: context, nameField: 'age', controller: ageController),

            SizedBox(
              height: heightMedia * .09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextButton(onPressed: ()async=>await ChatCubit.get(context).addUser({
                'id':Constants.usersForMe!.id,
                'name':nameController.text,
                'phone':phoneController.text,
                'age':ageController.text,
              }),
                  child: Text('Update',style: AppStyles.style15.copyWith(color: HexColor(AppColors.lightColor)),))
            ],)
          ],
        ),
      ),
    );
  }

  Widget imageFunction({
    required double widthMedia,
    required double heightMedia,

}){

    return Constants.usersForMe!.image == 'assets/person.png' || Constants.usersForMe!.image == null
        ? Image.asset(
      'assets/person.png',
      width: widthMedia * .4,
      height: heightMedia * .3,
    )
        : Image(
      image: NetworkImage(Constants.usersForMe!.image!,),
      width: widthMedia * .3,
      height: heightMedia * .3,
    );
  }

/*Constants.usersForMe!.image == 'assets/person.png' || Constants.usersForMe!.image == null
                            ? Image.asset(
                                'assets/person.png',
                                width: widthMedia * .05,
                                height: heightMedia * .05,
                              )
                            : Image(
                          image: NetworkImage(Constants.usersForMe!.image!,),
                          width: widthMedia * .3,
                          height: heightMedia * .3,
                        ),*/

  Widget textField({required context, required String nameField,
    required TextEditingController controller}){
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
            children: [
              Text(
                '$nameField :',
                style: AppStyles.style16,
              ),
              SizedBox(
                width: widthMedia * .04,
              ),
              SizedBox(
                width: widthMedia*.6,
                child: TextFormField(
                  controller: controller,
                  obscureText: nameField=='password',
                  decoration: InputDecoration(
                    hintText:controller.text,
                    hintStyle: AppStyles.style15.copyWith(color: Colors.white),
                    border:  InputBorder.none,

                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20, color: Colors.white),
                  onFieldSubmitted: (value) {
                    if(value.isNotEmpty) {
                      controller.text=value;
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
