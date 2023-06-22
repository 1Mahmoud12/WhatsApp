import 'package:equatable/equatable.dart';

class Calls extends Equatable {
  final String name;
  final String status;
  final String receiveId;
  final String sendId;
  final String image;
  final String dateTime;
  final DateTime createdAt;
  const Calls({
    required this.name,
    required this.status,
    required this.receiveId,
    required this.sendId,
    required this.image,
    required this.dateTime,
    required this.createdAt,
  });

  factory Calls.fromJson(Map<String, dynamic> json) {
    return Calls(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      receiveId: json['receiveId'],
      sendId: json['sendId'],
      image: json['image'] ?? '',
      dateTime: json['dateTime'] ?? '',
      createdAt: json['createdAt'] ?? DateTime.now(),

      // createdAt=json['createdAt'];
    );
  }

  @override
  List<Object?> get props => [name, status, receiveId, image, dateTime, createdAt];
}
