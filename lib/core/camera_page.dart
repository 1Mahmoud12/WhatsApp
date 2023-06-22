import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_first/core/preview_page.dart';
import 'package:chat_first/core/utils/colors.dart';
import 'package:chat_first/core/utils/general_functions.dart';
import 'package:chat_first/core/utils/styles.dart';
import 'package:chat_first/presentation/screens/main_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/entities/model_message.dart';
import '../presentation/cubit/block.dart';
import 'utils/constants.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String? receiveId;
  final String? text;

  const CameraPage({Key? key, required this.cameras, this.receiveId, this.text}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  List<FlashMode> flash = [FlashMode.auto, FlashMode.off, FlashMode.torch];
  int flashCount = 0;
  List<String> flashString = ['auto', 'off', 'semi'];
  final ImagePicker _picker = ImagePicker();

  Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
// Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras![0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            (_cameraController.value.isInitialized)
                ? CameraPreview(_cameraController)
                : Container(color: Colors.black, child: const Center(child: CircularProgressIndicator())),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(left: 21.0),
                child: InkWell(
                  onTap: () async {
                    final XFile? imagePicker = await _picker.pickImage(source: ImageSource.gallery);
                    if (widget.receiveId != null) {
                      FirebaseStorage.instance
                          .ref()
                          .child('users/${Uri.file(imagePicker!.path).pathSegments.last}')
                          .putFile(File(imagePicker.path))
                          .then((p0) {
                        p0.ref.getDownloadURL().then((value) {
                          if (value != '') {
                            ChatCubit.get(context).addMessage(Message.fromJson({
                              'sendId': Constants.idForMe,
                              'receiveId': widget.receiveId,
                              'text': widget.text ?? '',
                              "image": value,
                              'dateTime': DateTime.now().toString(),
                              'createdAt': DateTime.now(),
                            }).toMap());
                          }
                        });
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/sanFrancesco.png',
                    width: 48,
                    height: 48,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                  child: IconButton(
                onPressed: takePicture,
                iconSize: 80,
                icon: Image.asset('assets/icons8-circle.png', width: 67),
              )),
              const Spacer(),
              Expanded(
                  child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 30,
                icon: Image.asset(
                  'assets/icons8-switch.png',
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() => _isRearCameraSelected = !_isRearCameraSelected);
                  initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                },
              )),
            ]),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 30),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ChatCubit.get(context).changeIndex(2);
                    navigatorReuse(context, const MainPage());
                    //context.push( '/chat');
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 21.0),
                  child: TextButton(
                      onPressed: () {
                        flashCount++;
                        if (flashCount > 2) flashCount = 0;
                        setState(() {
                          _cameraController.setFlashMode(flash[flashCount]);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(color: HexColor(AppColors.yellowColor), borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              flashString[flashCount == -1 ? 01 : flashCount],
                              style: AppStyles.style16.copyWith(color: Colors.white),
                            ),
                          ))),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      //await _cameraController.setFlashMode(FlashMode.off);
      XFile imagePicker = await _cameraController.takePicture();
      if (widget.receiveId != null) {
        FirebaseStorage.instance.ref().child('users/${Uri.file(imagePicker.path).pathSegments.last}').putFile(File(imagePicker.path)).then((p0) {
          p0.ref.getDownloadURL().then((value) {
            if (value != '') {
              ChatCubit.get(context).addMessage(Message.fromJson({
                'sendId': Constants.idForMe,
                'receiveId': widget.receiveId,
                'text': widget.text ?? '',
                "image": value,
                'dateTime': DateTime.now().toString(),
                'createdAt': DateTime.now(),
              }).toMap());
            }
          });
        });
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    haveUser: widget.receiveId,
                    picture: imagePicker,
                    cameraPage: true,
                  )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }
}
