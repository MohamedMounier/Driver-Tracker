import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static late SharedPreferences sharedPreferences;
static init()async
{
  sharedPreferences=await SharedPreferences.getInstance();
}
 static final  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

 static Future<bool> putData(String key,value)async{

   if(value is String) return await sharedPreferences.setString(key, value);
   if(value is bool) return await sharedPreferences.setBool(key, value);
   if(value is int) return await sharedPreferences.setInt(key, value);
   if(value==null)return false;
    print(' in putData in shared key is $key, value is$value ');
    return await  sharedPreferences.setDouble(key, value);
  }
  static dynamic getData(String key){

    print(' in getData in shared key is $key, value is ${sharedPreferences.get(key)} ');
if(sharedPreferences.get(key)!=null){
  return sharedPreferences.get(key);
}else{

}

  }

  static Future<bool> reomveData(String key){
   return  sharedPreferences.remove(key);
  }
}