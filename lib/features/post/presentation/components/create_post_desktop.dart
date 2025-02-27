import 'dart:io';

import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CCreatePostDesktop extends StatefulWidget {
  Uint8List? webImage;
  final TextEditingController captionController;
  final VoidCallback updateProfile;
  final File? selectedImage;
  final void Function(File?, Uint8List?) setProfileImage;
  CCreatePostDesktop({
    super.key,
    required this.captionController,
    required this.updateProfile,
    required this.selectedImage,
    required this.setProfileImage,
    required this.webImage,
  });

  @override
  State<CCreatePostDesktop> createState() => _CCreatePostDesktopState();
}

class _CCreatePostDesktopState extends State<CCreatePostDesktop> {
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // For web, load image as Uint8List
    );

    if (result != null) {
      if (kIsWeb) {
        widget.webImage = result.files.single.bytes; // Web: Use bytes
        widget.setProfileImage(null, widget.webImage);
      } else {
        File newImage = File(result.files.single.path!); // Mobile: Use File
        widget.setProfileImage(newImage, null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
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
              Text(
                "Create Post",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: res.fontSize(2),
                ),
              ),
              Stack(children: [
                widget.selectedImage != null
                    ? CircleAvatar(
                        radius: 110,
                        backgroundImage: FileImage(widget.selectedImage!),
                      )
                    : widget.webImage != null
                        ? CircleAvatar(
                            radius: 110,
                            backgroundImage:
                                MemoryImage(widget.webImage!), // For web
                          )
                        : const CircleAvatar(
                            radius: 110,
                            child: Icon(Icons.landscape,
                                size: 50, color: Colors.grey),
                          ),
                Positioned(
                  bottom: 10, // Adjust to move vertically
                  right: 10, // Adjust to move horizontally
                  child: Container(
                    padding: const EdgeInsets.all(
                        8), // Padding for better appearance
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: res.height(3)),
              SizedBox(
                width: res.width(20),
                child: CBioInputField(
                  text: "Caption",
                  bioController: widget.captionController,
                ),
              ),
              SizedBox(height: res.height(3)),
              Row(
                children: [
                  SizedBox(width: res.width(7)),
                  Expanded(
                    child: CActionButton(
                      icon: Icons.refresh,
                      label: "Save",
                      onPressed: widget.updateProfile,
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
