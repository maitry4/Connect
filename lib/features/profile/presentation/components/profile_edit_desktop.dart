import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/features/profile/presentation/components/profile_image_picker_ui.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CProfileEditDesktop extends StatelessWidget {
  final TextEditingController bioController;
  final VoidCallback updateProfile;
  const CProfileEditDesktop({super.key, required this.bioController, required this.updateProfile});

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    // ignore: sized_box_for_whitespace
    return SizedBox(
      width: res.width(60),
      height: res.height(80),
      child: Card(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: res.height(5)),
              Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: res.fontSize(2),
                ),
              ),
              SizedBox(height: res.height(5)),
              const CProfileImagePicker(),
              const SizedBox(height: 10),
              SizedBox(width: res.width(20), child: CBioInputField(bioController: bioController,)),
              Row(
                children: [
                  SizedBox(width: res.width(7)),
                  Expanded(
                    child: CActionButton(
                      icon: Icons.refresh,
                      label: "Save",
                      onPressed: updateProfile,
                    ),
                  ),
                  SizedBox(width: res.width(3)),
                  Expanded(
                    child: CActionButton(
                      icon: Icons.cancel,
                      label: "Cancel",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: res.width(7)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
