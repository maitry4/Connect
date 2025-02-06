import 'package:flutter/material.dart';
import 'package:connect/utils/responsive_helper.dart';

class CButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const CButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context); // Initialize responsive helper
    final isDesktop = res.width(100) >= 800;

    return SizedBox(
      width: isDesktop ? res.width(30) : res.width(100), // 100% of screen width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? res.width(1) : res.height(2)), // 2% of screen height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDesktop ? res.width(1) : res.width(3)), // 3% of screen width
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: isDesktop ? res.fontSize(1) :  res.fontSize(4.5), // 4.5% of screen width
          ),
        ),
      ),
    );
  }
}
