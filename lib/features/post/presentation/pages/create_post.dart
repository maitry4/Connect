import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/presentation/components/create_post_desktop.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CCreatePostPage extends StatefulWidget {
  const CCreatePostPage({super.key});

  @override
  State<CCreatePostPage> createState() => _CCreatePostPageState();
}

class _CCreatePostPageState extends State<CCreatePostPage> {
  final captionTextController = TextEditingController();
  File? _selectedImage;
  Uint8List? _webImage;
  late String ccurrentUserId;
  late String currentUserName;
  late final CPostCubit postCubit;
  @override
  void initState() {
    super.initState();
    // Get current user's ID from Firebase Auth
    
    postCubit = context.read<CPostCubit>();
    final authCubit = context.read<CAuthCubit>();
    final user = authCubit.currentUser;
    ccurrentUserId = user?.uid ?? "";
    currentUserName = user?.name ?? "Anonymous";
  }
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // For web, load image as Uint8List
    );

    if (result != null) {
      if (kIsWeb) {
        _webImage = result.files.single.bytes; // Web: Use bytes
        setPostImage(null, _webImage);
      } else {
        File newImage = File(result.files.single.path!); // Mobile: Use File
        setPostImage(newImage, null);
      }
    }
  }

// Modify setPostImage
  void setPostImage(File? image, Uint8List? webImage) {
    setState(() {
      _selectedImage = image;
      _webImage = webImage;
    });
  }

  void createPost() async {
    final postCubit = context.read<CPostCubit>();
    final user = context.read<CAuthCubit>().currentUser;

    if (captionTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Caption cannot be empty!")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Creating post...")),
    );

    try {
      final postId = FirebaseFirestore.instance.collection('posts').doc().id;

      CPost newPost = CPost(
        id: postId,
        userId: ccurrentUserId,
        userName: currentUserName,
        text: captionTextController.text.trim(),
        imageUrl: '',
        imageId: null,
        timestamp: DateTime.now(),
        likes: [],
        comments: [],
      );

      await postCubit.createPost(
        newPost,
        newPostImage: _selectedImage,
        webPostImage: _webImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post created successfully!")),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create post: $error")),
      );
    }
  }
 

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800;
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
      child: CCreatePostDesktop(
        webImage: _webImage,
        captionController: captionTextController,
        createPost: createPost,
        selectedImage: _selectedImage, // New selected image (if any)
        setPostImage: setPostImage, // Callback to update image
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
            "Create Post",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: res.fontSize(5),
            ),
          ),
          Stack(children: [
            _selectedImage != null
                ? CircleAvatar(
                    radius: 110,
                    backgroundImage: FileImage(_selectedImage!),
                  )
                : _webImage != null
                    ? CircleAvatar(
                        radius: 110,
                        backgroundImage: MemoryImage(_webImage!), // For web
                      )
                    : const CircleAvatar(
                        radius: 110,
                        child:
                            Icon(Icons.landscape, size: 50, color: Colors.grey),
                      ),
            Positioned(
              bottom: 10, // Adjust to move vertically
              right: 10, // Adjust to move horizontally
              child: Container(
                padding:
                    const EdgeInsets.all(8), // Padding for better appearance
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Background for better visibility
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
          CBioInputField(
            text: "Caption",
            bioController: captionTextController,
          ),
          SizedBox(height: res.height(3)),
          Row(
            children: [
              Expanded(
                child: CActionButton(
                  icon: Icons.refresh,
                  label: "Save",
                  onPressed: createPost,
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
