import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/network/local.dart';
import '../../../../../core/utils/constants.dart';

abstract class AddUserRemoteDatsSourceRepository {
  void addUserRemoteDataSource(Map<String, dynamic> json);
}

class AddUserRemoteDatsSource extends AddUserRemoteDatsSourceRepository {
  final fireStoreUsers = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> addUserRemoteDataSource(Map<String, dynamic> json) async {
    if (Constants.idForMe == null) {
      await fireStoreUsers.doc(json['id']).set(json).then((value) {
        Constants.idForMe = json['id'];
        SharedPreference.putDataString('id', json['id']);
      });
    } else {
      await fireStoreUsers.doc(Constants.idForMe).update(json);
    }
  }
}
