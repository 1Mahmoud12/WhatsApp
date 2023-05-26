import 'package:equatable/equatable.dart';

import '../../core/utils/constants.dart';

// ignore: must_be_immutable
class Users extends Equatable{
   String?  id;
   String?  tokenMessaging;
   String? name;
   String? age;
   String?  image;
   String? phone;
   String? lastSeen;
/// when i change data of user i change data for user open app only
  Users(
      {this.id,
       this.name,
       this.age,
        this.tokenMessaging,
      required this.phone,
       this.image,
       this.lastSeen,
      });

  Users.fromJson(Map<String, dynamic> json) {
    json['id']!=null?id = json['id']:Constants.idForMe;
    json['name']!=null?name = json['name']:Constants.usersForMe!.name;
    json['age']!=null?age = json['age']:Constants.usersForMe!.age;
    json['tokenMessaging']!=null?tokenMessaging = json['tokenMessaging']:Constants.tokenMessaging;
    json['phone']!=null?phone = json['phone']:Constants.usersForMe!.phone;
    json['image']!=null?image = json['image']:Constants.usersForMe!.image;
    json['lastSeen']!=null?lastSeen = json['lastSeen']:'';

  }

  Map<String, dynamic> toMap() {
    return {
      'id': id??Constants.idForMe,
      'name': name??Constants.usersForMe!.name,
      'age': age??Constants.usersForMe!.age,
      'image': image??Constants.usersForMe!.image,
      'phone': phone??Constants.usersForMe!.phone,
      'tokenMessaging': tokenMessaging??Constants.tokenMessaging,
      'lastSeen': lastSeen??Constants.usersForMe!.lastSeen??'',

    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,age,phone,image,tokenMessaging,lastSeen];




}
