import 'package:dio/dio.dart';

/// Base Exception class for network and domain errors
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.statusCode]);
}

class ServerException extends AppException {
  const ServerException(super.message, [super.statusCode]);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

/// Generic wrapper class for network operations returning Success or Failure.
abstract class DataState<T> {
  final T? data;
  final AppException? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(AppException error) : super(error: error);
}

/// Utility helper to parse Dio errors into clean AppException instances
AppException handleDioError(DioException dioException) {
  switch (dioException.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkException('Network connection timeout. Please check your connection.');
    case DioExceptionType.badResponse:
      final code = dioException.response?.statusCode;
      final msg = dioException.response?.data?['status_message'] ?? 'Server error ($code)';
      return ServerException(msg.toString(), code);
    case DioExceptionType.cancel:
      return const NetworkException('Request cancelled.');
    default:
      return NetworkException(dioException.message ?? 'An unexpected error occurred.');
  }
}
