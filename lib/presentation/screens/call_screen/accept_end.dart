import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/snak_bar_me.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/general_functions.dart';
import '../../../core/utils/styles.dart';
import '../../../core/video/api.dart';
import '../../../core/video/meeting_screen.dart';
import '../../../domain/entities/model_user.dart';

class AcceptEnd extends StatelessWidget {
  final Users user;
  final bool contactRecipient;
  final String tokenMeeting;
  const AcceptEnd(
      {Key? key,
      required this.user,
      required this.contactRecipient,
      required this.tokenMeeting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightMedia = MediaQuery.of(context).size.height;
    Future.delayed(
      const Duration(seconds: 10),
      () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarMe(color: Colors.red, text: 'Call Ended'));
      },
    );
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              width: double.infinity,
              child: contactRecipient
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: heightMedia * .30),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  child: user.image == "assets/person.png"
                                      ? Image.asset("assets/person.png")
                                      : Image.network(user.image!),
                                ),
                                Text(user.name!),
                                SizedBox(
                                  height: heightMedia * .02,
                                ),
                                Text(
                                  'calling…',
                                  style: AppStyles.style15.copyWith(
                                      color: HexColor(AppColors.lightColor)),
                                ),
                              ],
                            )),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        user.image == "assets/person.png"
                            ? Image.asset("assets/person.png")
                            : Image.network(user.image!),
                        SizedBox(height: heightMedia * .05),
                        Text(user.name!),
                        SizedBox(
                          height: heightMedia * .02,
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: heightMedia * .20),
                            child: Column(
                              children: [
                                Text(
                                  "Waiting",
                                  style: AppStyles.style16.copyWith(
                                      color: HexColor(AppColors.boldColor)),
                                ),
                              ],
                            )),
                      ],
                    ),
            ),
          ),
          if (contactRecipient)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          navigatorReuse(
                              context,
                              MeetingScreen(
                                namePerson: user.name!,
                                token: tokenVideo,
                                meetingId: tokenMeeting,
                                leaveMeeting: () => Navigator.pop(context),
                              ));
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(10, 10, 10, 0))),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: HexColor('#2B2B2B'),
                            child: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ))),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(10, 10, 10, 0))),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: HexColor('#2B2B2B'),
                            child: const Icon(
                              Icons.call,
                              color: Colors.red,
                            ))),
                  ),
                ],
              ),
            ),
          if (!contactRecipient) Expanded(child: Column())
        ],
      ),
    );
  }
}
