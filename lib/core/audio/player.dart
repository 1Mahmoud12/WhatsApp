import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/general_functions.dart';

class Player extends StatefulWidget {
  String filePath;

  Player({Key? key, required this.filePath}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
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
      showNotification: false,
    );
  }

  late AnimationController controllerPlayer;
  @override
  void initState() {
    super.initState();
    controllerPlayer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
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
      if (fullAudio.inSeconds == event.inSeconds) {
        controllerPlayer.reverse();
      }
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  formatTime(fullAudio),
                  style: TextStyle(
                      fontSize: widthMedia * .04,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: SliderTheme(
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
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () async {
                    if (audioPlaying) {
                      controllerPlayer.reverse();
                      audioPlaying = false;
                      await assetsAudioPlayer.pause();
                    } else {
                      audioPlaying = true;
                      controllerPlayer.forward();
                      await playRecorder();
                    }
                    setState(() {});
                  },
                  icon: AnimatedIcon(
                    color: Colors.white70,
                    icon: AnimatedIcons.play_pause,
                    progress: controllerPlayer,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
/* */
