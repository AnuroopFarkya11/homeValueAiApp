import 'package:house_prediction/src/core/networking/api_endpoint.dart';
import 'package:house_prediction/src/core/networking/api_response.dart';
import 'package:house_prediction/src/core/networking/dio_client.dart';

class HomeService {
  final DioClient _dioClient = DioClient();

  Future<List<String>> getLocations() async {
    String endPoint = ApiEndpoint.locations.toString();
    ApiResponse response = await _dioClient.get(endPoint);
    if (response.isSuccess) {
      List<String> data = List<String>.from(response.data['Locations']);
      return data;
    }
    throw Exception(response.message);
  }

  void updateNgrokBase({required String code}) {
    final base = "https://$code.ngrok-free.app";
    _dioClient.updateBaseUrl(base);
  }
}
