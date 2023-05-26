import 'package:chat_first/core/utils/loading_screen.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/snak_bar_me.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../../../data/data_source/remote_data_source.dart';
import '../../cubit/states.dart';
import 'widget_item_builder_home_page.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!Constants.connection) {
      Future.delayed(const Duration(milliseconds: 10),() => ScaffoldMessenger.of(context).showSnackBar(snackBarMe(color: Colors.red, text: 'no connection')),);
    }
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed:(){} ,
          style:const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
          ),
            child: Image.asset('assets/img_1.png',),)
            ,
        title:  const Text("1 new message",style: AppStyles.style16,),
        actions:  [
          ElevatedButton(onPressed:(){
            ScaffoldMessenger.of(context).showSnackBar(
                const  SnackBar(

                backgroundColor: Colors.red,
                content: Text("error")));

          } ,
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
          ),
          child: Image.asset('assets/img_2.png',),)
        ],
      ),

      body: BlocBuilder<ChatCubit,ChatState>(
        builder: (context,state) {
          return ConditionalBuilder(
          condition:ChatRemoteDatsSource.users.isNotEmpty &&ChatCubit.get(context).lastMessage.isNotEmpty,
            builder: (context)=> ListView.builder(itemBuilder: (context ,index) {
              return ItemBuilderHomePage(indexOfUsers: index);
            },itemCount: ChatRemoteDatsSource.users.length,),
          fallback: (context)=>LoadingScreen(enabled: ChatCubit.get(context).enabledMessagesScreen),
        );
        },
      ),

    );
  }


}


