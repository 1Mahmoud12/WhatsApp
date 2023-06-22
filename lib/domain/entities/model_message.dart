class Message {
  final String sendId;
  final String text;
  final String receiveId;
  final String image;
  final String audio;
  final String dateTime;
  final DateTime createdAt;

  const Message({
    required this.sendId,
    required this.text,
    required this.receiveId,
    required this.image,
    required this.audio,
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
        createdAt: DateTime.now(),
      );
  Map<String, dynamic> toMap() {
    return {'sendId': sendId, 'text': text, 'receiveId': receiveId, 'image': image, 'audio': audio, 'dateTime': dateTime, 'createdAt': createdAt};
  }
}
