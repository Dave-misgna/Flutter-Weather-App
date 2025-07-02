import 'package:flutter/material.dart';
import 'package:flutter_application_1/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName:".env");
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true ),
    home: WeatherPage(),
    );
  }
}
