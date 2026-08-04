import 'package:flutter/material.dart';
import 'screens/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //Initializes and loads the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}
