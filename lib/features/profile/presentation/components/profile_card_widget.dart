import 'package:connect/features/profile/presentation/components/stats_widget.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CProfileCardWidget extends StatefulWidget {
  final String nm;
  const CProfileCardWidget({super.key, required this.nm});

  @override
  State<CProfileCardWidget> createState() => _CProfileCardWidgetState();
}

class _CProfileCardWidgetState extends State<CProfileCardWidget> {
  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    return Container(
      width: res.width(60) ,
      height: res.height(80),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
                // backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 10),
              Text(widget.nm, style: TextStyle(color:Theme.of(context).colorScheme.tertiary, fontSize: 28, fontWeight: FontWeight.bold)),
              Text('New York, United States', style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
              const SizedBox(height: 10),
              const Text('Web Producer - Web Specialist\nColumbia University - New York', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 15),
              const StatsWidget(),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Show Posts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}