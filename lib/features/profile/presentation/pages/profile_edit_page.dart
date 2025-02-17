import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/features/profile/presentation/components/profile_edit_desktop.dart';
import 'package:connect/features/profile/presentation/components/profile_image_picker_ui.dart';
import 'package:connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/features/profile/presentation/cubits/profile_state.dart';
import 'package:connect/utils/loading_screen.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CProfileEditScreen extends StatefulWidget {
  final CProfileUser profUser;
  const CProfileEditScreen({super.key, required this.profUser});

  @override
  State<CProfileEditScreen> createState() => _CProfileEditScreenState();
}

class _CProfileEditScreenState extends State<CProfileEditScreen> {
  final bioTextContoller = TextEditingController();
  // update profile method 
  void updateProfile() {
    if(bioTextContoller.text.isNotEmpty){
      // cubits
      final profileCubit = context.read<CProfileCubit>();
      profileCubit.updateProfile(uid: widget.profUser.uid, newBio:bioTextContoller.text);
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<CProfileCubit, CProfileState>(
      builder: (context, state) {
        // profile loading
        if(state is CProfileLoadingState) {
          return const CLoadingScreen(loadingText: "Updating Your Profile");
        }
        else {
          //edit form
          return buildEditPage();
        }
    }, 
    listener:  (context, state) {
      if(state is CProfileLoadedState) {
        Navigator.pop(context);
      }
    },);
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
    return Center(child: CProfileEditDesktop(bioController: bioTextContoller, updateProfile: updateProfile));
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
            const CProfileImagePicker(),
            SizedBox(height: res.height(3)), 
            CBioInputField(bioController: bioTextContoller,),
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
