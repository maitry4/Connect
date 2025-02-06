import 'package:flutter/material.dart';
import 'package:connect/utils/responsive_helper.dart';

class CTextField extends StatelessWidget {
  final String hintTxt;
  final bool ispass;
  final TextEditingController controller;
  const CTextField({super.key, required this.hintTxt, required this.ispass, required this.controller});

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context); // Initialize responsive helper
    final isDesktop = res.width(100) >= 800;
    
    return TextField(
      controller: controller,
      obscureText: ispass,
      decoration: InputDecoration(
        hintText: hintTxt,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: isDesktop ? res.fontSize(1) : res.fontSize(4), // 4% of screen width
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
    );
  }
}
