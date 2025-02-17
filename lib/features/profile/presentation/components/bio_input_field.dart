import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CBioInputField extends StatelessWidget {
  final TextEditingController bioController;
  const CBioInputField({super.key, required this.bioController});

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);

    return Padding(
      padding: EdgeInsets.all(res.width(2)), // Responsive padding
      child: TextField(
        controller: bioController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.edit,
            color: Colors.black54,
            // size: res.width(5), // Responsive icon size
          ),
          hintText: "Bio",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(res.width(3)), // Responsive border radius
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
