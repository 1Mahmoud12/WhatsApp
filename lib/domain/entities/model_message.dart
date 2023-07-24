import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String sendId;
  final String text;
  final String receiveId;
  final String image;
  final String audio;
  final bool read;
  final String dateTime;
  final DateTime createdAt;

  const Message({
    required this.sendId,
    required this.text,
    required this.receiveId,
    required this.image,
    required this.audio,
    required this.read,
    required this.dateTime,
    required this.createdAt,
  });
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sendId: json['sendId'],
        text: json['text'] ?? '',
        receiveId: json['receiveId'],
        image: json['image'] ?? '',
        dateTime: json['dateTime'],
        audio: json['audio'] ?? '',
        read: json['read'] ?? true,
        createdAt: DateTime.now(),
      );
  Map<String, dynamic> toMap() {
    return {
      'sendId': sendId,
      'read': read,
      'text': text,
      'receiveId': receiveId,
      'image': image,
      'audio': audio,
      'dateTime': dateTime,
      'createdAt': createdAt
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [sendId, receiveId, text, image, audio, read, createdAt, dateTime];
}
