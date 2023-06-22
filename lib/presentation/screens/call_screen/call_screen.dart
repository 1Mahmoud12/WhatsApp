/*
import 'package:flutter/material.dart';

import '../../../core/utils/styles.dart';
import 'items_call_widget.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ElevatedButton(onPressed:(){} ,
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
            ),
            child: const Icon(Icons.wifi_calling_3,color: Colors.blue,),)
        ],
      ),
      body: ListView.builder(itemBuilder: (context ,index)=> const ItemsCallWidget(),itemCount: 15,),

    );
  }
}
*/

import 'package:chat_first/presentation/cubit/block.dart';
import 'package:chat_first/presentation/cubit/states.dart';
import 'package:chat_first/presentation/screens/call_screen/items_call_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/general_functions.dart';

class VideoSDKQuickStart extends StatefulWidget {
  const VideoSDKQuickStart({Key? key}) : super(key: key);

  @override
  State<VideoSDKQuickStart> createState() => _VideoSDKQuickStartState();
}

class _VideoSDKQuickStartState extends State<VideoSDKQuickStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call"),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) => ConditionalBuilder(
          condition: ChatCubit.get(context).callsInformation.isNotEmpty,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: ListView.separated(
                itemBuilder: (context, index) => ItemsCallWidget(model: ChatCubit.get(context).callsInformation[index]),
                separatorBuilder: (context, index) => const Divider(color: Colors.white, height: 3),
                itemCount: ChatCubit.get(context).callsInformation.length),
          ),
          fallback: (context) => animatedText(text: 'No calls'),
        ),
      ),
    );
  }
}
