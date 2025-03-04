import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/home/presentation/components/post_ui.dart';
import 'package:connect/features/home/presentation/components/post_ui_desktop.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect/features/post/presentation/cubits/post_states.dart';
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
  late final CPostCubit postCubit;

  // onStartup
  @override
  void initState() {
    super.initState();
    // load the user profile data.
    profileCubit.fetchUserProfile(widget.uid);
    postCubit = context.read<CPostCubit>();
    postCubit.fetchUserPosts(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800; // Desktop breakpoint
    return BlocBuilder<CProfileCubit, CProfileState>(builder: (context, state) {
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
        return const CLoadingScreen(
          loadingText: "Loading Your Profile...",
        );
      } else {
        return const Center(child: Text("Profile Not Found"));
      }
    });
  }

  Widget _buildDesktopLayout(
      BuildContext context, ResponsiveHelper res, CProfileUser usr) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CProfileCardWidget(user: usr),
          SizedBox(
            width: 1400,
            height: 500,
            child: BlocBuilder<CPostCubit, CPostState>(
              builder: (context, state) {
                if (state is CPostsLoadingState) {
                  return const CircularProgressIndicator();
                } else if (state is CPostsLoadedState) {
                  return Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: state.posts
                          .map((post) => CPostUiDesktop(post: post))
                          .toList(),
                    ),
                  );
                } else {
                  return const Center(child: Text("No posts found"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res, CProfileUser usr) {
  return Column(
    children: [
      _buildProfileHeader(usr, res), // Displays user profile info
      Expanded(
        child: BlocBuilder<CPostCubit, CPostState>(
          builder: (context, state) {
            if (state is CPostsLoadingState) {
              return const CircularProgressIndicator();
            } else if (state is CPostsLoadedState) {
              return ListView(
                children: state.posts.map((post) => CPostUi(post: post)).toList(),
              );
            } else {
              return const Center(child: Text("No posts found"));
            }
          },
        ),
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

  Widget _buildProfileHeader(CProfileUser usr, ResponsiveHelper res) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: usr.profileImageUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 50,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => const CircleAvatar(
              radius: 50,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Text(
        usr.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: res.width(50),
        child: Text(
          usr.bio,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("65", "Photos"), // Temporary values (Replace dynamically)
          _buildStatItem("43", "Followers"),
          _buildStatItem("21", "Following"),
        ],
      ),
      const SizedBox(height: 20),
       CActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CProfileEditScreen(profUser: usr),
              ),
            );
          },
          label: " Edit Profile   ",
          icon: Icons.edit,
        
      ),
    ],
  );
}
}
