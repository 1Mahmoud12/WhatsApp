import 'package:chat_first/core/network/local.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/presentation/screens/main_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

class OnBoarding1 extends StatelessWidget {
  OnBoarding1({Key? key}) : super(key: key);
  var dialogController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      primary: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/attention-please.jpg',
              ),
              const Center(
                  child: Text(
                'Do somethings before start,please',
                textAlign: TextAlign.center,
                maxLines: 2,
              )),
              heightBox(10),
              separator(widthMedia),
              heightBox(10),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: widthMedia * .05),
                      children: [
                    const TextSpan(
                      text: ' -> create account from ',
                    ),
                    TextSpan(
                        text: 'dashboard api',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: widthMedia * .05),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            //_launchUrl();
                          }),
                  ])),
              heightBox(10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'after that go to menu ',
                  maxLines: 2,
                ),
                Image.asset(
                  'assets/menus.png',
                  width: widthMedia * .09,
                  height: heightMedia * .03,
                )
              ]),
              heightBox(10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'then go to account ',
                  maxLines: 2,
                ),
                Image.asset(
                  'assets/profile.png',
                  width: widthMedia * .09,
                  height: heightMedia * .03,
                )
              ]),
              heightBox(10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'then go to my access ',
                  maxLines: 2,
                ),
                Image.asset(
                  'assets/key.png',
                  width: widthMedia * .09,
                  height: heightMedia * .03,
                )
              ]),
              heightBox(10),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'finally copy api key :',
                  maxLines: 2,
                ),
                heightBox(10),
                ElevatedButton(
                    onPressed: dialogController.text.length != 32
                        ? null
                        : () {
                            SharedPreference.putDataString(
                                'api', dialogController.text);
                            navigatorReuse(context, const MainPage());
                          },
                    child: const Text('go'))
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /* Future<void> _launchUrl() async {
    //var launchUrl = await canLaunchUrl(Constants.url);
    if(await launchUrl(Uri.parse(Constants.url),mode: LaunchMode.externalNonBrowserApplication)){
      await launchUrl(Uri.parse(Constants.url,), );
    }else {
      throw 'Could not launch ${Constants.url}';
    }
  }*/
  Widget heightBox(double heightMedia) {
    return SizedBox(
      height: heightMedia,
    );
  }
}
