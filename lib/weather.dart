import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherAPI {
  final Dio _dio = Dio();

  Future<double> getTemperatureWeather(double longitude, double latitute) async {
    try {

      var apiKey = dotenv.env['METEO_API_KEY'];
      final response = await _dio.get('https://api.openweathermap.org/data/2.5/weather?lat=$latitute&lon=$longitude&units=metric&appid=$apiKey');

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