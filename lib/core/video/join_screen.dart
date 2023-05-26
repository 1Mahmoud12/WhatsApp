import 'package:chat_first/core/utils/styles.dart';
import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
  final void Function() onCreateMeetingButtonPressed;
  final void Function() onJoinMeetingButtonPressed;
  final void Function(String) onMeetingIdChanged;

  const JoinScreen({
    Key? key,
    required this.onCreateMeetingButtonPressed,
    required this.onJoinMeetingButtonPressed,
    required this.onMeetingIdChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: onCreateMeetingButtonPressed,
            child: const Text("Create Meeting")),
        const SizedBox(height: 16),
        TextField(
            decoration:  InputDecoration(
              hintText: "Meeting ID",
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,width: 1)
              ),

              hintStyle: AppStyles.style16.copyWith(color: Colors.white)
            ),
            style: AppStyles.style16.copyWith(color: Colors.white),
            onChanged: onMeetingIdChanged),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onJoinMeetingButtonPressed,
          child: const Text("Join"),
        )
      ],
    );
  }
}