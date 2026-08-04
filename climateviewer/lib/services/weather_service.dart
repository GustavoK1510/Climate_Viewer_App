import 'dart:convert';
import 'package:climateviewer/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// Service responsible for retrieving the user's current location
// and fetching weather data from the OpenWeatherMap API.
class WeatherService {
  // Base URL for the current weather endpoint.
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  // OpenWeatherMap API key.
  final String apiKey;

  WeatherService(this.apiKey);

  // Fetches the current weather for the given city.
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromjson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar dados de clima');
    }
  }

  // Retrieves the user's current city using the device's GPS.
  Future<String> getCurrentCity() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    // Request location permission if needed.
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get the device's current coordinates.
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // Convert the coordinates into a readable address.
    final geocoding = Geocoding();

    List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);

    String? city;

    final place = placemarks.first;

    // Prefer the city name. If unavailable, use the administrative area.
    if (place.locality != null && place.locality!.isNotEmpty) {
      city = place.locality!;
    } else if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      city = place.subAdministrativeArea!;
    }

    return city ?? "";


  }
}
