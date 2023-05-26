import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/utils/colors.dart';

class ItemsCallWidget extends StatelessWidget {
  final Contact model;

  const ItemsCallWidget({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;

    //print(model.phones);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 22),
      child: InkWell(
        onTap: () async {
          //print(model.phones[0]);
          for (int i = 0; i < ChatRemoteDatsSource.users.length; i++) {
            print(ChatRemoteDatsSource.users[i].phone);
            if (model.phones.isNotEmpty && model.phones[0] == '+') {
              print('++');
              if (model.phones[0].number ==
                  "+2${ChatRemoteDatsSource.users[i].phone}") {
                callFunction(context, ChatRemoteDatsSource.users[i]);
              }
            } else {
              print(' no ');
              if (model.phones[0].number ==
                  ChatRemoteDatsSource.users[i].phone) {
                await callFunction(context, ChatRemoteDatsSource.users[i]);
              }
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                model.photo == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      )
                    : CircleAvatar(
                        radius: 18, child: Image.memory(model.photo!)),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: SizedBox(
                        width: widthMedia * .35,
                        child: Text(
                          model.displayName,
                          style: AppStyles.style16,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: SizedBox(
                        width: widthMedia * .6,
                        child: Text(
                          model.phones.isNotEmpty
                              ? model.phones[0].number
                              : 'no number',
                          style: AppStyles.style15
                              .copyWith(color: HexColor(AppColors.lightColor)),
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: HexColor('#CCCCCC'),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
