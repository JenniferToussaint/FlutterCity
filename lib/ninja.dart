import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';

class NinjaAPI {
  final Dio _dio = Dio();

  Future<String> getCountryName(String cityName) async {
    try {
      final response = await _dio.get('https://api.api-ninjas.com/v1/city?name=$cityName', 
        options: Options(
          headers: {
            'X-Api-Key': dotenv.env['CITY_API_KEY'],
          },
        ));

      if (response.statusCode == 200) {
        var cityData = response.data;
        var city = cityData[0];
        return city['country'];
      } else {
        throw Exception('Failed to load city');
      }
    } catch (e) {
      throw Exception('Failed to load city: $e');
    }
  }

  Future<LatLng> getCityCoord(String cityName) async {
    try {
      final response = await _dio.get('https://api.api-ninjas.com/v1/city?name=$cityName', 
        options: Options(
          headers: {
            'X-Api-Key': dotenv.env['CITY_API_KEY'],
          },
        ));

      if (response.statusCode == 200) {

        
        var cityData = response.data;
        var city = cityData[0];
        var lat = city['latitude'];
        var long = city['longitude'];

        return  LatLng(lat, long);

      } else {
        throw Exception('Failed to load city');
      }
    } catch (e) {
      throw Exception('Failed to load city: $e');
    }
  }

}