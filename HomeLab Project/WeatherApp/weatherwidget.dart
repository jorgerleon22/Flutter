import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => WeatherProvider(),
        child: const MaterialApp(
          home: Weatherapp(), // Reemplaza MyHomePage con tu widget principal
        ),
      );
}

class WeatherProvider extends ChangeNotifier {
  double _temperatureValue = 0.0; // Variable de instancia para la temperatura
  double _realfeelValue = 0.0; // Variable de instancia para la sensación térmica

  double get temperatureValue => _temperatureValue;
  double get realfeelValue => _realfeelValue;

  Future<void> fetchWeatherData() async {
    const apiKey = ''; // Reemplaza con tu API Key de AccuWeather
    const locationKey = ''; // locationkey
    const url =
        'http://dataservice.accuweather.com/currentconditions/v1/$locationKey?apikey=$apiKey&details=true';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var weatherData in data) {
          if (weatherData is Map<String, dynamic>) {
            final temperature = weatherData['Temperature']['Metric']['Value'];
            final realfeel = weatherData['RealFeelTemperature']['Metric']['Value'];
            _temperatureValue = temperature;
            _realfeelValue = realfeel;
            notifyListeners(); // Notifica a los widgets que la temperatura ha cambiado
          }
        }
      } else {
        debugPrint('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('$e');
    }
  }
}

class Weatherapp extends StatefulWidget {
  const Weatherapp({super.key});

  @override
  _WeatherappState createState() => _WeatherappState();
}

class _WeatherappState extends State<Weatherapp> {
  @override
  void initState() {
    super.initState();
    // Llama a la función fetchWeatherData cuando se inicia el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      alignment: Alignment.center, // Alinea el icono en el centro
      iconColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      shape: const CircleBorder(),
      padding: EdgeInsets.zero, // Elimina el padding interno
      minimumSize: const Size(50, 50), // Ajusta el tamaño del botón
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Temperatura exterior',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
              ),
            ),
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${weatherProvider.temperatureValue} ºC',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 100,
                    ),
                  ),
                );
              },
            ),
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                return Text(
                  '${weatherProvider.realfeelValue} ºC',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 154, 133),
                    fontSize: 25,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: style,
                onPressed: () {
                  context
                      .read<WeatherProvider>()
                      .fetchWeatherData(); // Llama a la función para actualizar el clima
                },
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
