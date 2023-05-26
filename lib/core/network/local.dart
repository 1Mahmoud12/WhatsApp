import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference
{
   static Future<bool?> getDataBool(String key)async{
    var prefs = await SharedPreferences.getInstance();
    bool? repeat=  prefs.getBool(key);
    if(repeat== null){
      return repeat==false;
    }
    else{

    return repeat;
    }

  }

   static Future<List<int>> getDataString(String key)async{
     var prefs = await SharedPreferences.getInstance();
     List<int> repeat=[] ;
     if( prefs.getStringList(key)==null){}
     else{
       repeat=prefs.getStringList(key)!.map((e) => int.parse(e)).toList();

     }
     return repeat;


   }
   static Future<dynamic> getData(String key)async{
     var prefs = await SharedPreferences.getInstance();
     return prefs.get(key);


   }
   static Future<bool> putDataStringListModel(String key,List<String> repeat)async{
     var prefs = await SharedPreferences.getInstance();

     return await prefs.setStringList(key, repeat);
   }

   static Future<bool> putDataBool(String key,bool repeat)async{
    var prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, repeat);
  }
   static Future<bool> putDataString(String key,String repeat)async{
    var prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, repeat);
  }
   static Future<bool> putDataStringList(String key,List<int> repeat)async{
     var prefs = await SharedPreferences.getInstance();

     List<String> listString= repeat.map((e) => e.toString()).toList();
    print(listString);
    print(await prefs.setStringList(key, listString));
     return await prefs.setStringList(key, listString);
   }


}