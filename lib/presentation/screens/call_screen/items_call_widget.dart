import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/data/data_source/remote_data_source.dart';
import 'package:chat_first/domain/entities/model_user.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/general_functions.dart';
import '../../../domain/entities/model_calls.dart';

class ItemsCallWidget extends StatelessWidget {
  final Calls model;

  const ItemsCallWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Users? modelUser;

    for (int i = 0; i < ChatRemoteDatsSource.users.length; i++) {
      if (model.receiveId == ChatRemoteDatsSource.users[i].id) {
        modelUser = ChatRemoteDatsSource.users[i];
      }
      if (modelUser == null) {
        for (var element in ChatRemoteDatsSource.users) {
          if (model.sendId == element.id) modelUser = element;
        }
      }
    }
    //print(modelUser);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () => callFunction(context, modelUser!),
        child: ListTile(
          leading: model.image.length < 20
              ? Image.asset(
                  model.image,
                  width: 50,
                  height: 50,
                )
              : Image.network(model.image),
          title: Row(
            children: [
              Text(
                model.name,
                style: AppStyles.style16.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                subStringForDate(date: model.dateTime),
                style: AppStyles.style15.copyWith(color: Colors.white),
              )
            ],
          ),
          subtitle: Row(
            children: [
              Text(model.status),
              const Spacer(),
              model.status == 'called'
                  ? const Icon(
                      Icons.call_made_outlined,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.phone_callback,
                      color: Colors.red,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
