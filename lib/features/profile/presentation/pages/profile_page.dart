import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/profile_card_widget.dart';
import 'package:connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/features/profile/presentation/cubits/profile_state.dart';
import 'package:connect/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:connect/utils/loading_screen.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CProfilePage extends StatefulWidget {
  final String uid;
  const CProfilePage({super.key, required this.uid});

  @override
  State<CProfilePage> createState() => _CProfilePageState();
}

class _CProfilePageState extends State<CProfilePage> {
  // cubits
  late final profileCubit = context.read<CProfileCubit>();

  // onStartup
  @override
  void initState() {
    super.initState();
    // load the user profile data.
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800; // Desktop breakpoint
    return BlocBuilder<CProfileCubit, CProfileState>(
      builder: (context, state) {
      // loaded
      if (state is CProfileLoadedState) {
      // get the current user
      late CProfileUser? profileUser = state.profileUser;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: SafeArea(
              child: isDesktop
                  ? _buildDesktopLayout(context, res, profileUser)
                  : _buildMobileLayout(context, res, profileUser),
            ),
          ),
        );
      }
      // loading
      else if (state is CProfileLoadingState) {
        return const CLoadingScreen(loadingText: "Loading Your Profile...",);
      } 
      else {
        return const Center(child: Text("Profile Not Found"));
      }
    });
  }

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res, CProfileUser usr) {
    return Center(child: CProfileCardWidget(user: usr));
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res, CProfileUser usr) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: res.width(20), // Adjust size dynamically
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person),
            ),
            Positioned(
              bottom: 0,
              right: res.width(5),
              child: const CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                radius: 15,
                child: Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          usr.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(width:res.width(50),child: Text(usr.bio, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14))),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem("65", "Photos"),
            _buildStatItem("43", "Followers"),
            _buildStatItem("21", "Following"),
          ],
        ),
        SizedBox(height: res.height(2),),
        Row(
          children: [
            SizedBox(width: res.width(20),),
            Expanded(
              child: CActionButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CProfileEditScreen(profUser: usr,)),
                        );
                },
                label: "Edit Profile",
                icon:Icons.edit
              ),
            ),
            SizedBox(width: res.width(20),),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
