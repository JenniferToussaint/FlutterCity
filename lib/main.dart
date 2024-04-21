import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meteoo/cityWidget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:meteoo/ninja.dart';
// import 'package:meteoo/weather.dart';

Future main() async {

 await dotenv.load(fileName: ".env");

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  runApp(const MainApp());

  // var ninja = NinjaAPI();
  // String cityName = 'Paris'; 
  // String city = await ninja.getCityName(cityName);
  // print('Resultat : $city');


  // var weather = WeatherAPI();
  // double lat = 61.89001458689152;
  // double long = 15.609894759642236;
  // String temperature = await weather.getWeather(long, lat);
  // print('Temperature : $temperature');

}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyCityForm(),
        ),
      ),
    );
  }
}
