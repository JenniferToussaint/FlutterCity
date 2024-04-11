// Création d'un widget Form
import 'package:flutter/material.dart';
import 'package:meteoo/ninja.dart';
import 'package:meteoo/weather.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _controller, // lien vers controller pour récupérer la valeur saisie
            decoration: const InputDecoration(
              labelText: 'Entrez votre ville',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async  {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Envoie de la requête')),
                  );
                    setState(() {
                      var ninja = NinjaAPI();
                      var weather = WeatherAPI();
                      _pays = ninja.getCountryName(_controller.text);
                      _temperatureFuture = ninja.getCityCoord(_controller.text).then((coord) => weather.getTemperatureWeather(coord[0], coord[1]));
                    });
                },
              child: const Text('Envoyer'),
            ),
          ),
          FutureBuilder<double>(
            future: _temperatureFuture,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) { // la future est en attente de réponse
                return CircularProgressIndicator(); // le logo de chargement
              } else if (snapshot.hasError) { // la future a eu une réponse, mais c'est une erreur
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.hasData) { // la future a eu une réponse correcte
                return Text('Température : ${snapshot.data}°C');
              } else {
                return SizedBox.shrink(); // Rien à afficher si _temperatureFuture est null
              }
            },
          ),
          FutureBuilder<String>(
            future: _pays,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Text('Pays : ${snapshot.data}');
              } else {
                return SizedBox.shrink(); // Rien à afficher si _pays est null
              }
            },
          ),
        ],
      ),
    );
  }
}