import 'package:dio/dio.dart';

// ignore: non_constant_identifier_names
Dio http({
  ResponseType? responseType = ResponseType.plain,
  bool Function(int?)? validateStatus,
  String baseUrl = 'https://www.reddit.com',
}) =>
    Dio(
      BaseOptions(
        validateStatus: validateStatus,
        responseType: responseType,
        headers: {'Cache-Control': 'no-store'},
        baseUrl: baseUrl,
        queryParameters: {
          'raw_json': 1,
        },
      ),
    );
