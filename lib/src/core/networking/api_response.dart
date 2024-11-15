class ApiResponse<T> {
  final T? data;
  final String? message;

  ApiResponse({this.data, this.message});

  bool get isSuccess => message == null;
}
