import 'package:house_prediction/src/core/networking/api_endpoint.dart';
import 'package:house_prediction/src/core/networking/api_response.dart';
import 'package:house_prediction/src/core/networking/dio_client.dart';

class PropertyFormService {
  final DioClient _dioClient = DioClient();

  Future<double> predict(
      double sqrtFeet, String location, int bhk, int bath) async {
    String endPoint = ApiEndpoint.predictPrice.toString();
    // endPoint = endPoint + "?" +"total_sqft";
    final data = {
      "total_sqft": sqrtFeet,
      "location": location,
      "bhk": bhk,
      "bath": bath
    };
    ApiResponse response = await _dioClient.postForm(endPoint,data: data);
    if (response.isSuccess) {
      return response.data['get_estimated_price'];
    }
    throw Exception(response.message);
  }
}
