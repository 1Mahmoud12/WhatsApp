
class Calls{


  late String name;
  late String status;
  late String receiveId;
  String? image;
  late String dateTime;
  DateTime createdAt=DateTime.now();

  Calls(Map<String,dynamic>json){

    name=json['name']??'';
    status=json['status']??'';
    receiveId=json['receiveId'];
    image=json['image']??'';
    dateTime=json['dateTime'];


    // createdAt=json['createdAt'];

  }


  Map<String,dynamic> toMap(){
    return {

      'name':name,
      'status':status,
      'receiveId':receiveId,
      'image':image??'',
      'dateTime':dateTime,
      'createdAt':createdAt
    };

  }
}