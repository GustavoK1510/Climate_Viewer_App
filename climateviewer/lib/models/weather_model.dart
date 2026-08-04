// Model representing the weather data returned by the OpenWeatherMap API.
class Weather {
  // Name of the city where the weather data was collected.
  final String cityName;

  // Current temperature in degrees Celsius.
  final double temperature;

  // Main weather condition (e.g. Clear, Rain, Clouds).
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  // Creates a [Weather] instance from the JSON response provided by the API.
  factory Weather.fromjson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
    );
  }
}
