import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CProfileEditDesktop extends StatefulWidget {
   Uint8List? webImage;
  final TextEditingController bioController;
  final VoidCallback updateProfile;
  final String profileImageUrl;
  final File? selectedImage;
  final void Function(File?, Uint8List?) setProfileImage;

  CProfileEditDesktop({
    super.key,
    required this.bioController,
    required this.updateProfile,
    required this.profileImageUrl,
    required this.selectedImage,
    required this.setProfileImage,
    required this.webImage,
  });

  @override
  State<CProfileEditDesktop> createState() => _CProfileEditDesktopState();
}

class _CProfileEditDesktopState extends State<CProfileEditDesktop> {
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
              Column(
                children: [
                  widget.selectedImage != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(widget.selectedImage!),
                    )
                  : widget.webImage != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(widget.webImage!), // For web
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.profileImageUrl,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 50,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 50,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person,
                                size: 50, color: Colors.grey),
                          ),
                        ),
                  SizedBox(height: res.height(1.5)),
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                  const Text("Pick Image"),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: res.width(20),
                  child: CBioInputField(
                    bioController: widget.bioController,
                  )),
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
