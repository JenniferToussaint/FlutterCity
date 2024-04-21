// Création d'un widget Form
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:meteoo/ninja.dart';
import 'package:meteoo/positionGeo.dart';
import 'package:meteoo/weather.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyCityForm extends StatefulWidget {
  const MyCityForm({super.key});

  @override
  MyCityFormState createState() {
    return MyCityFormState();
  }
}

// Création d'un State correspondant au widget Form
class MyCityFormState extends State<MyCityForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  Future<double>? _temperatureFuture;
  Future<String>? _pays;
  Future<LatLng>? _coord;

  // Future<Position>? _localisationUser;
  Future<String>? _city;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller:
                _controller, // lien vers controller pour récupérer la valeur saisie
            decoration: const InputDecoration(
              labelText: 'Entrez votre ville',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Envoie de la requête')),
                );
                setState(() {
                  var ninja = NinjaAPI();
                  var weather = WeatherAPI();
                  _coord = ninja.getCityCoord(_controller.text);
                  _pays = ninja.getCountryName(_controller.text);
                  _temperatureFuture = ninja
                      .getCityCoord(_controller.text)
                      .then((coord) => weather.getTemperatureWeather(coord));
                });
              },
              child: const Text('Envoyer'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Envoie de la requête')),
                );
                var geo = PositionGeolocator();
                var weather = WeatherAPI();

                Position pos = await geo.determinePosition();
                String city = await weather
                    .getCityName(LatLng(pos.latitude, pos.longitude));

                city = "Metz"; // auboué ne marche pas avec openwheathermap
                _controller.text =
                    city; // met la valeur de la variable city dans la texbox

                // reprends le même code qu'avec une saisie classique
                setState(() {
                  var ninja = NinjaAPI();
                  var weather = WeatherAPI();

                  _coord = ninja.getCityCoord(_controller.text);
                  _pays = ninja.getCountryName(_controller.text);
                  _temperatureFuture = ninja
                      .getCityCoord(_controller.text)
                      .then((coord) => weather.getTemperatureWeather(coord));
                });
              },
              child: const Text('Par localisation'),
            ),
          ),
          FutureBuilder<double>(
            future: _temperatureFuture,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // la future est en attente de réponse
                return const CircularProgressIndicator(); // le logo de chargement
              } else if (snapshot.hasError) {
                // la future a eu une réponse, mais c'est une erreur
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // la future a eu une réponse correcte
                return Text('Température : ${snapshot.data}°C');
              } else {
                return const SizedBox
                    .shrink(); // Rien à afficher si _temperatureFuture est null
              }
            },
          ),
          FutureBuilder<String>(
            future: _pays,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Text('Pays : ${snapshot.data}');
              } else {
                return const SizedBox
                    .shrink(); // Rien à afficher si _pays est null
              }
            },
          ),
          Expanded(
              child: FutureBuilder<LatLng>(
            future: _coord,
            builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                return FlutterMap(
                  options: MapOptions(
                      initialCenter: snapshot.data!, // récupère les coordonnées
                      initialZoom: 5),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                            width: 80.0,
                            height: 80.0,
                            point: snapshot.data!,
                            child: const Icon(Icons.location_on,
                                color: Color.fromARGB(255, 39, 63, 251),
                                size: 60)),
                      ],
                    ),
                  ],
                );
              } else {
                return const SizedBox
                    .shrink(); // Rien à afficher si _pays est null
              }
            },
          ))
        ],
      ),
    );
  }
}
