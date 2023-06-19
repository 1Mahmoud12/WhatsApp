import 'package:chat_first/core/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../network/local.dart';

class TextFieldMe extends StatelessWidget {
  final String nameField;
  final TextEditingController controller;
  const TextFieldMe(
      {Key? key, required this.nameField, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: heightMedia * .02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Text(
                '$nameField :',
                style: AppStyles.style16,
              ),
              SizedBox(
                width: widthMedia * .04,
              ),
              SizedBox(
                width: widthMedia * .6,
                child: TextFormField(
                  controller: controller,
                  obscureText: nameField == 'password',
                  decoration: InputDecoration(
                    hintText: controller.text == ''
                        ? 'Enter $nameField'
                        : controller.text,
                    hintStyle:
                        AppStyles.style15.copyWith(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 20, color: Colors.white),
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
      ],
    );
    ;
  }
}
