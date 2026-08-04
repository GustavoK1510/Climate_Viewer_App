import 'dart:convert';
import 'package:climateviewer/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromjson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar dados de clima');
    }
  }

  Future<String> getCurrentCity() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    final geocoding = Geocoding();

    List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    final place = placemarks.first;

    if (place.locality != null && place.locality!.isNotEmpty) {
      city = place.locality!;
    } else if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      city = place.subAdministrativeArea!;
    }

    return city ?? "";


  }
}
