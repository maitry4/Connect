import 'package:flutter/material.dart';
class StatItem extends StatelessWidget {
  final String label;
  final String count;
   

  const StatItem({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11)),
        ]
      ),
    );
  }
}