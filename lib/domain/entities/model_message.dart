
class Message{

  late String sendId;
  late String text;
  late String receiveId;
  String? image;
  String? audio;
  late String dateTime;
  DateTime createdAt=DateTime.now();

  Message(Map<String,dynamic>json){

    sendId=json['sendId'];
    text=json['text']??'';
    receiveId=json['receiveId'];
    image=json['image']??'';
    dateTime=json['dateTime'];
    audio=json['audio'];

   // createdAt=json['createdAt'];

  }


  Map<String,dynamic> toMap(){
    return {

      'sendId':sendId,
      'text':text,
      'receiveId':receiveId,
      'image':image??'',
      'audio':audio??'',
      'dateTime':dateTime,
      'createdAt':createdAt
    };

  }
}