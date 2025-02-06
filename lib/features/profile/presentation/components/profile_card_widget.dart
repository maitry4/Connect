import 'package:connect/features/profile/presentation/components/stats_widget.dart';
import 'package:flutter/material.dart';

class CProfileCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 400,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
                // backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              SizedBox(height: 10),
              Text('Samantha Jones', style: TextStyle(color:Theme.of(context).colorScheme.tertiary, fontSize: 28, fontWeight: FontWeight.bold)),
              Text('New York, United States', style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
              SizedBox(height: 10),
              Text('Web Producer - Web Specialist\nColumbia University - New York', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              SizedBox(height: 15),
              StatsWidget(),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Theme.of(context).canvasColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('Show Posts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}