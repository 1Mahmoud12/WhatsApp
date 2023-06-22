import 'package:equatable/equatable.dart';

import '../../core/utils/constants.dart';

class Users extends Equatable {
  final String id;
  final String tokenMessaging;
  final String name;
  final String age;
  final String image;
  final String phone;
  final String lastSeen;

  /// when i change data of user i change data for user open app only
  const Users({
    required this.id,
    required this.name,
    required this.age,
    required this.tokenMessaging,
    required this.phone,
    required this.image,
    required this.lastSeen,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json['id'] ?? Constants.idForMe,
        name: json['name'] ?? Constants.usersForMe!.name,
        age: json['age'] ?? '',
        tokenMessaging: json['tokenMessaging'] ?? Constants.tokenMessaging,
        phone: json['phone'] ?? Constants.usersForMe!.phone,
        image: json['image'] ?? "assets/person.png",
        lastSeen: json['lastSeen'] ?? '',
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'image': image,
      'phone': phone,
      'tokenMessaging': tokenMessaging,
      'lastSeen': lastSeen,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, age, phone, image, tokenMessaging, lastSeen];
}
