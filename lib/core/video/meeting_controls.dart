import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MeetingControls extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onLeaveButtonPressed;

  const MeetingControls({
    Key? key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onLeaveButtonPressed,
            icon: const Icon(Icons.output),
            label: const Text('Leave'),
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromRGBO(119, 119, 119, 0))),
          ),
        ),
        Expanded(
          child: FilledButton.icon(
            onPressed: onToggleMicButtonPressed,
            icon: const Icon(Icons.mic),
            label: const Text('Toggle Mic'),
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromRGBO(119, 119, 119, 0))),
          ),
        ),
        Expanded(
          child: FilledButton.icon(
            onPressed: onToggleCameraButtonPressed,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Toggle Camera'),
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromRGBO(10, 10, 10, 0))),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
        )
      ],
    );
  }
}
