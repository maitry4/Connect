import 'package:connect/features/profile/presentation/components/background_widget.dart';
import 'package:connect/features/profile/presentation/components/profile_card_widget.dart';
import 'package:flutter/material.dart';

class CProfilePage extends StatefulWidget {
  const CProfilePage({super.key});

  @override
  State<CProfilePage> createState() => _CProfilePageState();
}

class _CProfilePageState extends State<CProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(),
          Center(child: CProfileCardWidget()),
        ],
      ),
    );
  }
}