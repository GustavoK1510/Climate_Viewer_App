import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  final String cityName;

  const WeatherPage({
    super.key,
    required this.cityName,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // [SERVICE]
  // Handles API requests and location retrieval.
  final _weatherService = WeatherService(dotenv.env['OPENWEATHER_API_KEY']!);

  // [STATE]
  // Stores the current weather information
  Weather? _weather;

  // [FETCH]
  // Gets the weather data for the searched city.
  Future<void> _fetchWeather() async {

    try {
      final weather = await _weatherService.getWeather(widget.cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // [ANIMATION]
  // Returns the appropriate Lottie animation based on the weather condition.
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'dust':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/windy.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';

      case 'thunderstorm':
        return 'assets/storm.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    // [INITIALIZATION]
    // Loads weather data when the page is first displayed.
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                },
                  icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 130),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_weather?.cityName ?? 'loading city...'),

                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                Text('${_weather?.temperature.round()}°C'),

                Text(_weather?.mainCondition ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
