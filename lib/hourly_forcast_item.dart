import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String hour;
  final IconData icon;
  final String temperature;
  const HourlyForecastItem({
    super.key,
    required this.hour,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: const Color.fromARGB(255, 58, 58, 58),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 100,
        child: Column(
          children: [
            Text(hour,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                ),
            const SizedBox(height: 8),
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(
              temperature,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
