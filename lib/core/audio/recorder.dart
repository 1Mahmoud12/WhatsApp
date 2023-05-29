import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/constants.dart';

class Recorder extends StatefulWidget {
  final String receiveId;
  const Recorder({Key? key, required this.receiveId}) : super(key: key);

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder>
    with SingleTickerProviderStateMixin {
  var recorder = FlutterSoundRecorder();
  final audioPlayer = AssetsAudioPlayer();
  String filePath =
      '/sdcard/Download/audio${DateTime.now().microsecondsSinceEpoch}.mp4';
  bool isRecorderReady = false;

  Future stop() async {
    if (!isRecorderReady) return;
  }

  Future playRecorder() async {
    try {
      await recorder.startRecorder(toFile: filePath, codec: Codec.aacMP4);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Not supported exception')));
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
    recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    initRecorder();
  }

  @override
  Widget build(BuildContext context) {
    double heightMedia = MediaQuery.of(context).size.height;
    double widthMedia = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widthMedia * .01,
      height: heightMedia * .03,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            StreamBuilder<RecordingDisposition>(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                String twoDigits(int n) => n.toString().padLeft(2, '0');
                final twoDigitsMinutes =
                    twoDigits(duration.inMinutes.remainder(60));
                final twoDigitsSecond =
                    twoDigits(duration.inSeconds.remainder(60));
                return Text(
                  "$twoDigitsMinutes:$twoDigitsSecond",
                  style: TextStyle(
                      fontSize: widthMedia * .04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                );
              },
            ),
            const Spacer(),
            IconButton(
                padding: EdgeInsetsDirectional.only(bottom: 10),
                onPressed: () async {
                  if (recorder.isRecording) {
                    await stop();
                    controller.reverse();
                    await FirebaseStorage.instance
                        .ref()
                        .child('audio/${Uri.file(filePath).pathSegments.last}')
                        .putFile(File(filePath))
                        .then((image) {
                      image.ref.getDownloadURL().then((value) {
                        Constants.audio = value;
                      });
                    });
                  } else {
                    controller.forward();
                    await playRecorder();
                  }
                  setState(() {
                    if (recorder.isStopped) {
                      Navigator.pop(context);
                      print("Constants.audio : ${Constants.audio}");
                    }
                  });
                },
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: controller,
                ))
          ],
        ),
      ),
    );
  }

  void addAudio() async {}

  @override
  void dispose() async {
    super.dispose();

    recorder.closeRecorder();
  }
}
