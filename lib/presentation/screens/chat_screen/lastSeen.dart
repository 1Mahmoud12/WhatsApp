import 'package:chat_first/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/general_functions.dart';
import '../../../core/utils/styles.dart';

class LastSeen extends StatefulWidget {
  final String id;
  const LastSeen({Key? key,required this.id}) : super(key: key);

  @override
  State<LastSeen> createState() => _LastSeenState();
}

class _LastSeenState extends State<LastSeen> {
  String? lastSeen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection(Constants.collectionUser).doc(widget.id).snapshots().listen((event) {
      setState(() {
        print("update");
        lastSeen=event.data()==null?null:event.data()!['lastSeen'];
      });

    });

  }
  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(duration: const Duration(seconds: 1),
      child: lastSeen==null?Container():Text(
      subStringForTime(time:DateTime.now().toString())==subStringForTime(time: lastSeen!)?'Online':
      "last seen ${subStringForDate(date: lastSeen!)}",
      style: AppStyles.style13.copyWith(color:Colors.grey),
    ),);
  }
}
