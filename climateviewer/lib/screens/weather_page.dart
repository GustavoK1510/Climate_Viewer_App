import 'package:climateviewer/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

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
  // Gets the user's current city and requests its weather data.
  Future<void> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
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
      body: Center(
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
    );
  }
}
