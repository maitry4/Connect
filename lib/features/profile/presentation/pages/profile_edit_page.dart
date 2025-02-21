import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/features/profile/presentation/components/profile_edit_desktop.dart';
import 'package:connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/features/profile/presentation/cubits/profile_state.dart';
import 'package:connect/utils/loading_screen.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CProfileEditScreen extends StatefulWidget {
  final CProfileUser profUser;
  const CProfileEditScreen({super.key, required this.profUser});

  @override
  State<CProfileEditScreen> createState() => _CProfileEditScreenState();
}

class _CProfileEditScreenState extends State<CProfileEditScreen> {
  final bioTextController = TextEditingController();
  File? _selectedImage;
  Uint8List? _webImage; // Store web image

  // Function to update profile
  void updateProfile() {
    final profileCubit = context.read<CProfileCubit>();

    if (bioTextController.text.isNotEmpty || _selectedImage != null) {
      profileCubit.updateProfile(
        uid: widget.profUser.uid,
        newBio: bioTextController.text,
        newProfileImage: _selectedImage, // Pass image file if selected
      );
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // For web, load image as Uint8List
    );

    if (result != null) {
      if (kIsWeb) {
        _webImage = result.files.single.bytes; // Web: Use bytes
        setProfileImage(null, _webImage);
      } else {
        File newImage = File(result.files.single.path!); // Mobile: Use File
        setProfileImage(newImage, null);
      }
    }
  }

// Modify setProfileImage
  void setProfileImage(File? image, Uint8List? webImage) {
    setState(() {
      _selectedImage = image;
      _webImage = webImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CProfileCubit, CProfileState>(
      builder: (context, state) {
        // profile loading
        if (state is CProfileLoadingState) {
          return const CLoadingScreen(loadingText: "Updating Your Profile");
        } else {
          //edit form
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is CProfileLoadedState) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800; // Desktop breakpoint
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SafeArea(
          child: isDesktop
              ? _buildDesktopLayout(context, res)
              : _buildMobileLayout(context, res),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res) {
    return Center(
      child: CProfileEditDesktop(
        webImage: _webImage,
        bioController: bioTextController,
        updateProfile: updateProfile,
        profileImageUrl: widget.profUser.profileImageUrl, // Existing URL
        selectedImage: _selectedImage, // New selected image (if any)
        setProfileImage: setProfileImage, // Callback to update image
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: res.width(5),
        vertical: res.height(2),
      ),
      child: Column(
        children: [
          Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: res.fontSize(5),
            ),
          ),
          Column(
            children: [
              _selectedImage != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_selectedImage!),
                    )
                  : _webImage != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(_webImage!), // For web
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.profUser.profileImageUrl,
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
          SizedBox(height: res.height(3)),
          CBioInputField(
            bioController: bioTextController,
          ),
          SizedBox(height: res.height(3)),
          Row(
            children: [
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
            ],
          ),
        ],
      ),
    );
  }
}
