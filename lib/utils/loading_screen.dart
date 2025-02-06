import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CLoadingScreen extends StatelessWidget {
  const CLoadingScreen({super.key});
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
          'Your Moments, Your Story—Securely Connected.',
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
          'Your Moments, Your Story—Securely Connected.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: res.fontSize(3.5),
          ),
        ),
      ],
    );
  }
}
