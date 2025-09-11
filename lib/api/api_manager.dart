import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import '../constants/end_points.dart';

class ApiManager {
  late Dio _dio;
  ApiManager() {
    _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseUrl,
        )
     )
    ..interceptors.
    add(TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: true,
      printResponseData: false,
    ),));
  }

  postApi(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } catch (e) {
      print("Error in POST request: $e");
      return null;
    }
  }
  Future<Response> getApi({required String endPoint, Map<String, dynamic>? parameters}){
    return _dio.get(endPoint, queryParameters: parameters);

  }


}