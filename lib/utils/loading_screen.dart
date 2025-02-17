import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CLoadingScreen extends StatelessWidget {
  final String loadingText;
  const CLoadingScreen({super.key, required this. loadingText});
  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800; // Desktop breakpoint
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: isDesktop
                ? _buildDesktopLayout(context, res)
                : _buildMobileLayout(context, res),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res) {
    return Column(
      children: [
        Image.asset("assets/images/loading.jpg", fit: BoxFit.contain, width:res.width(30)),
        Text(
          loadingText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: res.fontSize(2),
          ),
        ),
      ]
    );
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res) {
    return Column(
      children: [
        Image.asset("assets/images/loading.jpg", fit: BoxFit.contain, width:res.width(40)),
        Text(
          loadingText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: res.fontSize(3.5),
          ),
        ),
      ],
    );
  }
}
