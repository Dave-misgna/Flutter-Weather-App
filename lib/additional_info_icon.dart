import 'package:flutter/material.dart';

class AdditionalInfoIcon extends StatelessWidget {
  final IconData icons;
  final String label;
  final String value;
  const AdditionalInfoIcon({
    super.key,
    required this.icons,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icons, size: 30),
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
