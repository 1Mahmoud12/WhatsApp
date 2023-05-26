import 'dart:convert';
import 'package:http/http.dart' as http;

String tokenVideo = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiIxYmJkMGE0ZS04MWYyLTQwNjctOWU0Ny1lMmU5NmI5ZWFmMmYiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY4MjIzNTUzOCwiZXhwIjoxNjgyODQwMzM4fQ.c-ibf00O42gzhpa-6_Zb_6KqcZiXaR_94VQOAMGP5IM";

Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': tokenVideo,
      "Content-Type": "application/json",
    },
  );

  return json.decode(httpResponse.body)['roomId'];
}