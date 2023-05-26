
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';

class CallContact extends StatelessWidget {
  const CallContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CallContactDetails(),

    );
  }
}

class CallContactDetails extends StatelessWidget{
  const CallContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    double heightMedia=MediaQuery.of(context).size.height;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset('assets/img_5.png',width: 500,height: 500,),
                  Padding(
                    padding:  EdgeInsets.only(top: heightMedia*.30),
                    child: Column(children: [
                      const Text('Janet Flower'),
                      SizedBox(height: heightMedia*.02,),
                      Text('calling…',style: AppStyles.style15.copyWith(color: HexColor(AppColors.lightColor)),),
                    ],)
                  ),

                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:30,bottom: 80.0),
          child: Row(
            children: [
              Expanded(child: CircleAvatar(radius:30,backgroundColor: HexColor('#2B2B2B'),child: IconButton(onPressed: (){}, icon: const   Icon(Icons.add,color: Colors.white,), ))),
              Expanded(child: CircleAvatar(radius:30,backgroundColor: HexColor('#2B2B2B'),child: IconButton(onPressed: (){}, icon: const Icon(Icons.video_call,color: Colors.white,)))),
              Expanded(child: CircleAvatar(radius:30,backgroundColor: HexColor('#FF6969'),child: IconButton(onPressed: (){}, icon: const Icon(Ionicons.call_outline,color: Colors.white,)))),
            ],
          ),
        )
      ],
    );
  }

}