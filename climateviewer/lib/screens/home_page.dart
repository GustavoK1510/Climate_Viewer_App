import 'package:climateviewer/screens/weather_page.dart';
import 'package:climateviewer/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Search Bar Controller
  final TextEditingController _searchController = TextEditingController();

  // [SERVICE]
  // Handles API requests and location retrieval.
  final _weatherService = WeatherService(dotenv.env['OPENWEATHER_API_KEY']!);

  // [STATE]
  // Stores the current weather information
  Weather? _weather;

  // [SEARCH]
  // Creates the Weather Page using data from the search bar
  dynamic search() {
    // Returns a Snack Bar if the field is empty
    if (_searchController.text.isEmpty) {
      return SnackBar(
        content: Text("City not found or field is empty"),
        duration: Duration(seconds: 3),
      );
    }

    // Storages the city name
    String cityName = _searchController.text.trim();

    // Clears the controller
    _searchController.clear();

    // Navigates to the Weather Page
    return Navigator.push(context, MaterialPageRoute(
        builder: (context) => WeatherPage(
            cityName: cityName
        ),
      ),
    );
  }

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25),
                child: SearchBar(
                  leading: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: search,
                  ),
                  controller: _searchController,
                  hintText: "Search for a city name",
                  hintStyle: WidgetStatePropertyAll(
                    TextStyle(
                      color: Colors.grey.shade500,
                    )
                  ),
                ),
              ),
              const SizedBox(height: 120),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_weather?.cityName ?? 'loading city...'),
        
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
        
                  Text('${_weather?.temperature.round()}°C'),
        
                  Text(_weather?.mainCondition ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
