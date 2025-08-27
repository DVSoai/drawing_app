import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/utils/enum/api_type.dart';
import '../../../core/utils/exception/exception_network.dart';



class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl:'',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
      followRedirects: true,
      maxRedirects: 5,
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // final token = _globalStorage.accessToken;
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }

        if (kDebugMode) {
          print('Request: ${options.method} ${options.path}');
          print('Request Headers: ${options.headers}');
          print('Request Params: ${options.queryParameters}');
          print('Request Data: ${options.data}');
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('Response Status Code: ${response.statusCode}');
          print('Response Data: ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        if (kDebugMode) {
          print("Error intercepted: ${error.response?.statusCode}");
          print("Error response: ${error.response?.data}");
        }
        return handler.next(error);
      },
    ));
  }

  Future<dynamic> request({
    required String path,
    required ApiType method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      Response response;

      switch (method) {
        case ApiType.get:
          response = await _dio.get(path,
              queryParameters: queryParameters,
              options: Options(headers: headers),
              cancelToken: cancelToken);
          break;
        case ApiType.post:
          response = await _dio.post(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(headers: headers),
              cancelToken: cancelToken);
          break;
        case ApiType.put:
          response = await _dio.put(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(headers: headers),
              cancelToken: cancelToken);
          break;
        case ApiType.delete:
          response = await _dio.delete(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(headers: headers),
              cancelToken: cancelToken);
          break;
        case ApiType.patch:
          response = await _dio.patch(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(headers: headers),
              cancelToken: cancelToken);
          break;
      }

      return response.data;
    } on DioException catch (e) {
      debugPrint("DioException in ApiClient: ${e.type}");
      debugPrint("DioException message: ${e.message}");
      debugPrint("DioException response: ${e.response}");

      if (CancelToken.isCancel(e)) {
        debugPrint('Request cancelled: ${e.message}');
        throw NetworkException(message: 'Request cancelled');
      }

      if (e.response == null) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            throw NetworkException(
              message:
              'Connection timeout. Please check your internet connection.',
              statusCode: null,
            );
          case DioExceptionType.sendTimeout:
            throw NetworkException(
              message: 'Request timeout. Please try again.',
              statusCode: null,
            );
          case DioExceptionType.receiveTimeout:
            throw NetworkException(
              message: 'Server response timeout. Please try again.',
              statusCode: null,
            );
          case DioExceptionType.connectionError:
            throw NetworkException(
              message: 'No internet connection. Please check your network.',
              statusCode: null,
            );
          case DioExceptionType.unknown:
            throw NetworkException(
              message: 'Network error. Please check your internet connection.',
              statusCode: null,
            );
          default:
            throw NetworkException(
              message: 'Network error occurred. Please try again.',
              statusCode: null,
            );
        }
      }

      rethrow;
    } catch (e) {
      debugPrint("Unexpected error in ApiClient: $e");
      throw NetworkException(message: 'An unexpected network error occurred');
    }
  }
}