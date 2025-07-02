import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'hourly_forcast_item.dart';
import 'additional_info_icon.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<Map<String, dynamic>>? weather;
  final String?apiKey = dotenv.env["API_KEY"];

 
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Addis Ababa';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,et&APPID=$apiKey'));
          
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw data['message'];
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }


   @override
  void initState() {
    super.initState();
    dotenv.load().then((_) {
      setState(() {
        weather = getCurrentWeather();
      });
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.refresh)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // ignore: unnecessary_cast
          final data = snapshot.data as Map<String, dynamic>?;
          if (data == null) {
            return Center(child: Text('No data available'));
          }
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];
          final windSpeed = data['list'][0]['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main card
                SizedBox(
                  width: double.infinity,
                  // margin: EdgeInsets.all(10),
                  height: 200,

                  child: Card(
                    elevation: 15,
                    color: const Color.fromARGB(255, 58, 58, 58),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$currentTemp K',
                            style: TextStyle(fontSize: 40),
                          ),
                          Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 80,
                          ),
                          Text(
                            currentSky,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final currentTime =
                          data['list'][index + 1]['dt_txt'].toString();
                      final time = DateTime.parse(currentTime);

                      final currentICon =
                          data['list'][index + 1]['weather'][0]['main'];

                      final currentTemp =
                          data['list'][index + 1]['main']['temp'];

                      return HourlyForecastItem(
                        hour: DateFormat.j().format(time),
                        icon: currentICon == 'Clouds' || currentICon == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temperature: '$currentTemp K',
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                Text('Additional Information',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoIcon(
                        icons: Icons.water_drop,
                        label: 'Humidity',
                        value: '$humidity',
                      ),
                      AdditionalInfoIcon(
                        icons: Icons.air,
                        label: 'Wind speed',
                        value: '$windSpeed',
                      ),
                      AdditionalInfoIcon(
                        icons: Icons.beach_access,
                        label: 'Pressure',
                        value: '$pressure',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
