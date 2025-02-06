import 'package:flutter/material.dart';

class CSettingsPage extends StatefulWidget {
  const CSettingsPage({super.key});

  @override
  State<CSettingsPage> createState() => _CSettingsPageState();
}

class _CSettingsPageState extends State<CSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("settings")),
    );
  }
}