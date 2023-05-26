import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../core/utils/styles.dart';
import 'items_call_widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMedia=MediaQuery.of(context).size.width;
    double heightMedia=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 700,
        backgroundColor: Colors.black45,
        leading: CircleAvatar(
          radius: widthMedia*.05,
          backgroundColor: Colors.black45,
          child:
          Constants.usersForMe!.image == 'assets/person.png'||Constants.usersForMe!.image == 'assets/img.png' || Constants.usersForMe!.image == null
              ? Image.asset(
            'assets/person.png',
            width: widthMedia * .05,
            height: heightMedia * .05,
          )
              : Image(
            image: NetworkImage(Constants.usersForMe!.image!,),
            width: widthMedia * .3,
            height: heightMedia * .3,
          ),

        ),
        title:  Text(
          Constants.usersForMe!.name!,
          style: AppStyles.style16,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.black45)),
            child: TextButton(
                child: Text(
                  'Edit',
                  style: AppStyles.style15.copyWith(
                      fontWeight: FontWeight.bold,
                      color: HexColor(AppColors.blueColor)),
                ),
                onPressed: () {
                  context.push('/Edit');
                }
            ),
          )
        ],
      ),
      body: ConditionalBuilder(
        condition:  ChatCubit.get(context).contacts!=null&&ChatCubit.get(context).contacts!.isNotEmpty,
        builder: (context)=> ListView.builder(
          itemBuilder: (context, index) =>
              ItemsCallWidget(model: ChatCubit.get(context).contacts![index]),
          itemCount: ChatCubit.get(context).contacts!.length,
        ),
        fallback: (context) {
          return Center(child: Text('No Contacts',style: AppStyles.style16.copyWith(color: Colors.white),));
        },
      ),
    );
  }
}
