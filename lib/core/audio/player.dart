import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/general_functions.dart';

class Player extends StatefulWidget {
  String filePath;

  Player({Key? key, required this.filePath}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  Duration position = Duration.zero;
  Duration fullAudio = Duration.zero;

  bool audioPlaying = false;

  Future playRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }

    assetsAudioPlayer.open(
      Audio.file(widget.filePath),
      autoStart: true,
      showNotification: true,
    );
    audioPlaying = true;
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }

    assetsAudioPlayer.open(
      Audio.file(widget.filePath),
      autoStart: false,
      showNotification: true,
    );
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
    assetsAudioPlayer.onReadyToPlay.listen((event) {
      if (event != null) {
        fullAudio = event.duration;
      }
      setState(() {});
    });

    assetsAudioPlayer.currentPosition.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightMedia = MediaQuery.of(context).size.height;
    double widthMedia = MediaQuery.of(context).size.width;

    return SizedBox(
      height: heightMedia * .05,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Text(
                formatTime(fullAudio),
                style: TextStyle(
                    fontSize: widthMedia * .04,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SliderTheme(
                data: const SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                    secondaryActiveTrackColor: Colors.black),
                child: Slider(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.white70,
                  thumbColor: Colors.blueGrey,
                  min: 0,
                  max: fullAudio.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (double value) {
                    value = position.inSeconds.toDouble();
                    setState(() {});
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16),
              child: IconButton(
                  onPressed: () async {
                    if (audioPlaying) {
                      await assetsAudioPlayer.pause();
                      audioPlaying = false;
                    } else {
                      await playRecorder();
                      audioPlaying = true;
                    }
                    setState(() {});
                  },
                  icon: audioPlaying
                      ? const FaIcon(
                          FontAwesomeIcons.stop,
                          color: Colors.white,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.circlePlay,
                          color: Colors.white,
                        )),
            )
          ],
        ),
      ),
    );
  }
}
