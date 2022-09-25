
import 'package:dio/dio.dart';

class DioMethods
{
 static late Dio dio;
  static init(){
   dio=Dio(
    BaseOptions(
        receiveDataWhenStatusError: true,

    ),
  );

}
  static Future<Response> postData({
   required String path,
    Map<String, dynamic>? query,
    String? token,
    required Map<String,dynamic>data
  }){

    return dio.post(
      path,
      data: data,
      queryParameters: query,
    );
  }

 static Future<Response> getData({
   required String path,
   Map<String, dynamic>? query,
   String? token,
 })async{
   return await dio.get(
     path,
     queryParameters: query,
   );
 }

 static Future<Response> putData({
   required String path,
   Map<String, dynamic>? query,
   String? token,
   required Map<String,dynamic>data
 }){

   return dio.put(
     path,
     data: data,
     queryParameters: query,
   );
 }

}