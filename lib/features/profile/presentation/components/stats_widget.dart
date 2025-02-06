import 'package:connect/features/profile/presentation/components/stat_item.dart';
import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatItem(label: 'Photos', count: '65'),
        StatItem(label: 'Followers', count: '43'),
        StatItem(label: 'Following', count: '21'),
      ],
    );
  }
}
