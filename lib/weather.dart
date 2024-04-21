import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';

class WeatherAPI {
  final Dio _dio = Dio();

    Future<String> getCityName(LatLng coord) async {
    try {

      double latitude = coord.latitude;
      double longitude = coord.longitude;

      var apiKey = dotenv.env['METEO_API_KEY'];
      final response = await _dio.get('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey');

      if (response.statusCode == 200) {
        var cityData = response.data;
        return cityData['name'];
      } else {
        throw Exception('Failed to load city');
      }
    } catch (e) {
      throw Exception('Failed to load city: $e');
    }
  }

   Future<double> getTemperatureWeather(LatLng latLng) async {
    try {

      double latitude = latLng.latitude;
      double longitude = latLng.longitude;

      var apiKey = dotenv.env['METEO_API_KEY'];
      final response = await _dio.get('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey');

      if (response.statusCode == 200) {
        return  response.data['main']['temp'];
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }
}