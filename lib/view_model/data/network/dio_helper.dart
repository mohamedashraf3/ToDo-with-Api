import 'dart:async';

import 'package:dio/dio.dart';
import 'package:note_application/view_model/data/network/end_points.dart';

class DioHelper {
  static Dio? dio;

 static Future<void> init() async {
    dio = Dio(BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        }));
  }

 static Future<Response?> post(
      { FormData? formData,
        String? token,
        required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? prams}) async {
    try{
      dio?.options.headers={
        "Authorization":"Bearer $token",
      };
      Response? response =
      await dio?.post(endpoint, data: body ?? formData, queryParameters: prams);
      return response;
    }catch(e){
      rethrow;
    }
  } static Future<Response?> delete(
      { FormData? formData,
        String? token,
        required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? prams}) async {
    try{
      dio?.options.headers={
        "Authorization":"Bearer $token",
      };
      Response? response =
      await dio?.delete(endpoint, data: body ?? formData, queryParameters: prams);
      return response;
    }catch(e){
      rethrow;
    }
  }
static Future<Response?> get(
      { FormData? formData,
        required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? prams,
      String? token
      }) async {
    try{
      dio?.options.headers={
        "Authorization":"Bearer $token",
      };
      Response? response =
      await dio?.get(endpoint, data: body??formData, queryParameters: prams);
      return response;
    }catch(e){
      rethrow;
    }
  }
}
