import 'dart:io';

import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../data/data_source/remote_data_source.dart';
import '../domain/entities/model_message.dart';
import '../presentation/cubit/block.dart';

class PreviewPage extends StatelessWidget {
  final String? haveUser;
  final picture;
  const PreviewPage({Key? key, required this.picture, required this.cameraPage, this.haveUser}) : super(key: key);
  final bool? cameraPage;

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Align(
          widthFactor: double.infinity,
          child: cameraPage! ? Image.file(File(picture.path), fit: BoxFit.cover, width: 250) : Image.network(picture.path),
        ),
        IconButton(
            onPressed: () async {
              if (haveUser != null) {
                ChatCubit.get(context).addMessage(Message.fromJson({
                  'sendId': Constants.idForMe,
                  'receiveId': haveUser,
                  'dateTime': DateTime.now().toString(),
                  'createdAt': DateTime.now(),
                }).toMap());
              } else {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black,
                    builder: (context) => ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: widthMedia * .05,
                                backgroundColor: Colors.black45,
                                child: ChatRemoteDatsSource.users[index].image != 'assets/img.png'
                                    ? Image.asset(
                                        'assets/person.png',
                                        width: widthMedia * .5,
                                        height: heightMedia * .5,
                                      )
                                    : Image(
                                        image: NetworkImage(
                                          Constants.modelOfLastMessage.last.text,
                                        ),
                                        width: widthMedia * .3,
                                        height: heightMedia * .3,
                                      ),
                              ),
                              title: SizedBox(
                                  width: widthMedia * .35,
                                  child: Text(
                                    ChatRemoteDatsSource.users[index].name,
                                    style: AppStyles.style16.copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              onTap: () async {
                                FirebaseStorage.instance
                                    .ref()
                                    .child('users/${Uri.file(picture.path).pathSegments.last}')
                                    .putFile(File(picture.path))
                                    .then((p0) {
                                  p0.ref.getDownloadURL().then((value) {
                                    if (value != '') {
                                      ChatCubit.get(context).addMessage(Message.fromJson({
                                        'sendId': Constants.idForMe,
                                        'receiveId': ChatRemoteDatsSource.users[index].id,
                                        "image": value,
                                        'dateTime': DateTime.now().toString(),
                                        'createdAt': DateTime.now(),
                                      }).toMap());
                                    }
                                  });
                                });
                              },
                            );
                          },
                          itemCount: ChatRemoteDatsSource.users.length,
                        ));
              }
            },
            icon: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ))),
      ],
    ));
  }
}
