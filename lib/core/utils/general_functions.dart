import 'dart:developer';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:chat_first/presentation/cubit/block.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../firebase/messaging.dart';
import '../network/local.dart';
import '../video/api.dart';
import '../video/meeting_screen.dart';
import 'constants.dart';

String subStringForDate({required String date}) {
  String today = DateTime.now().toString().substring(5, 10);
  String yasterday = DateTime.now().add(const Duration(days: -1)).toString().substring(5, 10);

  if (today == date.substring(5, 10)) {
    return subStringForTime(time: date);
  } else if (yasterday == date.substring(5, 10)) {
    return 'Yasterday';
  } else {
    return DateFormat('MMM dd').format(DateTime.parse(date.substring(0, 10)));
  }
}

/// Convert from 20:00 to 08:00 pm
String subStringForTime({required String time}) {
  int checkAmOrPm = int.parse(time.substring(11, 13));
  if (checkAmOrPm > 12) {
    return '${(checkAmOrPm - 12)}${time.substring(13, 16)} Pm';
  } else {
    return '${(checkAmOrPm)}${time.substring(13, 16)} am';
  }
}

/// TODO : just print in debugMode
void printDM(String title, {bool stop = false}) {
  if (kDebugMode) {
    stop ? null : log(title);
  }
}

String simplyFormat({required DateTime time}) {
  String year = time.year.toString();
  String month = time.month.toString().padLeft(2, '0');
  String day = time.day.toString().padLeft(2, '0');

  // return the "yyyy-MM-dd HH:mm:ss" format
  return "$year-$month-$day";
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes);
  final seconds = twoDigits(duration.inSeconds);

  return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
}

Widget separator(widthMedia) {
  return Container(
    color: Colors.grey,
    width: widthMedia,
    height: 1,
  );
}

navigatorReuse(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

Route createRoute(Widget widgetGo, double x, double y) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widgetGo,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(x, y);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget logo(widthMedia, model) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 8.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CircleAvatar(radius: 15, backgroundColor: Colors.white.withOpacity(0), child: Image(image: NetworkImage(model.logo))),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  model.name,
                  style: TextStyle(fontSize: widthMedia * .06, fontWeight: FontWeight.bold),
                )),
            Expanded(
                flex: 2,
                child: Text(
                  'substitution',
                  style: TextStyle(fontSize: widthMedia * .05, fontWeight: FontWeight.w500),
                )),
          ],
        ),
      ),
    ),
  );
}

Widget indicator() {
  return Center(
    child: LottieBuilder.asset(
      'assets/animation/Loading.json',
      fit: BoxFit.cover,
    ),
  );
}

Widget animatedText({required String text, bool secondText = true}) {
  return Center(
      child: DefaultTextStyle(
    style: const TextStyle(
      fontSize: 20.0,
    ),
    child: AnimatedTextKit(
      animatedTexts: [
        WavyAnimatedText(text),
        secondText
            ? WavyAnimatedText(
                'Sorry Bro',
              )
            : WavyAnimatedText(''),
      ],
      isRepeatingAnimation: true,
      repeatForever: true,
      onTap: () {
        //print("Tap Event");
      },
    ),
  ));
}

callFunction(context, Users model) async {
  String tokenMeeting = await createMeeting();
  Messaging.sendMessage(context,
      modelUser: Constants.usersForMe!,
      body: 'Calling...',
      title: model.name,
      action: "calling",
      tokenMeeting: tokenMeeting,
      tokenUser: model.tokenMessaging);

  ChatCubit.get(context).addCalls({
    "name": model.name,
    "receiveId": model.id,
    "sendId": Constants.idForMe,
    "image": model.image,
    'status': 'called',
    "dateTime": DateTime.now().toString(),
  });
  ChatCubit.get(context).addCalls({
    "name": model.name,
    "receiveId": Constants.idForMe,
    "sendId": model.id,
    "image": model.image,
    'status': 'called',
    "dateTime": DateTime.now().toString(),
  });
  navigatorReuse(
      context,
      MeetingScreen(
        namePerson: model.name,
        token: tokenVideo,
        meetingId: tokenMeeting,
        leaveMeeting: () => Navigator.pop(context),
      ));
}

Future<bool> hasNetwork() async {
  try {
    final result = await http.get(Uri.parse('http://www.google.com'));
    if (result.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

Widget textField({required context, required String nameField, required TextEditingController controller}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
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
                hintText: controller.text == '' ? 'Enter $nameField' : controller.text,
                hintStyle: AppStyles.style15.copyWith(color: Colors.white38),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
              ),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: Colors.white),
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
