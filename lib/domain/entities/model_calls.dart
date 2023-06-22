import 'package:equatable/equatable.dart';

class Calls extends Equatable {
  final String name;
  final String status;
  final String receiveId;
  final String image;
  final String dateTime;
  final DateTime createdAt;
  const Calls({
    required this.name,
    required this.status,
    required this.receiveId,
    required this.image,
    required this.dateTime,
    required this.createdAt,
  });

  factory Calls.fromJson(Map<String, dynamic> json) {
    return Calls(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      receiveId: json['receiveId'],
      image: json['image'] ?? '',
      dateTime: json['dateTime'] ?? '',
      createdAt: json['createdAt'] ?? DateTime.now(),

      // createdAt=json['createdAt'];
    );
  }

/*  Map<String, dynamic> toMap() {
    return {'name': name, 'status': status, 'receiveId': receiveId, 'image': image ?? '', 'dateTime': dateTime, 'createdAt': createdAt};
  }*/

  @override
  List<Object?> get props => [name, status, receiveId, image, dateTime, createdAt];
}
