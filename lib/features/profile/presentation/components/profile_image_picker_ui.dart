import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CProfileImagePicker extends StatelessWidget {
  const CProfileImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);

    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          child: Icon(Icons.person),
        ),
        SizedBox(height: res.height(1.5)), // Responsive spacing
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.camera_alt,
            color: Theme.of(context).canvasColor,
            // size: res.width(6), // Responsive icon size
          ),
        ),
        const Text(
          "Pick Image",
          // style: TextStyle(fontSize: res.fontSize(4)), // Responsive text size
        ),
      ],
    );
  }
}
