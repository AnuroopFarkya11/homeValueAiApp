import 'package:dio/dio.dart';
import 'package:house_prediction/src/core/networking/api_response.dart';

class DioClient {
  // Private constructor
  DioClient._privateConstructor();

  // Singleton instance
  static final DioClient _instance = DioClient._privateConstructor();

  // Dio instance
  final Dio _dio = Dio();

  // Factory method to access the instance
  factory DioClient() {
    return _instance;
  }

  // Initialize Dio client with default settings
  DioClient._init() {
    _dio.options.baseUrl = "https://aa32-2405-201-3008-80-a120-88b1-9245-6ac4.ngrok-free.app";
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'multipart/form-data',
    };
  }

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  Future<ApiResponse<T>> get<T>(String endPoint,
      {Map<String, dynamic>? params}) async {
    print("Got invoked");
    final request = _dio.get<T>(
      endPoint,
      queryParameters: params,
    );
    return _sendRequest<T>(() => request);
  }

  Future<ApiResponse<T>> post<T>(String endPoint,
      {Map<String, dynamic>? params}) async {
    print("Got invoked");
    final request = _dio.post<T>(endPoint, queryParameters: params);
    return _sendRequest<T>(() => request);
  }

  Future<ApiResponse<T>> postForm<T>(String endPoint,
      {required Map<String, dynamic> data}) async {
    print("Got invoked");
    FormData formData = FormData.fromMap(data);
    final request = _dio.post<T>(endPoint, data: formData);
    return _sendRequest<T>(() => request);
  }

  Future<ApiResponse<T>> _sendRequest<T>(
      Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      print(response.data);
      return handleResponse<T>(response);
    } on DioException catch (e) {
      return ApiResponse(message: _handleError(e));
    } catch (e) {
      print("Exception while sending request : $e");
      return ApiResponse(message: e.toString());
    }
  }

  ApiResponse<T> handleResponse<T>(Response response) {
    switch (response.statusCode) {
      case 200:
        return ApiResponse<T>(data: response.data);
      case 400:
        return ApiResponse<T>(message: 'Bad request: ${response.data}');
      case 401:
        return ApiResponse<T>(message: 'Unauthorized access:');
      case 404:
        return ApiResponse<T>(message: 'Not found');
      case 500:
      default:
        return ApiResponse<T>(message: 'Server error: ${response.statusCode}');
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection Timeout Exception";

      case DioExceptionType.sendTimeout:
        print("Send Timeout Exception");
        return "Send Timeout Exception";
      case DioExceptionType.receiveTimeout:
        print("Receive Timeout Exception");
        return "Receive Timeout Exception";
      case DioExceptionType.badResponse:
        print("Received invalid status code: ${error.response?.statusCode}");
        return "Received invalid status code: ${error.response?.statusCode}";
      case DioExceptionType.cancel:
        print("Request was cancelled");
        return "Request was cancelled";

      default:
        print("Unexpected error: ${error.message}");
        return "Unexpected error: ${error.message}";
    }
  }
}
