import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// Interceptor to log Dio HTTP requests, responses, and errors.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '--> ${options.method.toUpperCase()} ${options.uri}',
      name: 'DioNetworkClient',
    );
    developer.log('Headers: ${options.headers}', name: 'DioNetworkClient');
    if (options.data != null) {
      developer.log('Body: ${options.data}', name: 'DioNetworkClient');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
      name: 'DioNetworkClient',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      name: 'DioNetworkClient',
      error: err.message,
    );
    super.onError(err, handler);
  }
}
