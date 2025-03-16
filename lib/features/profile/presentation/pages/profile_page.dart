import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/home/presentation/components/post_ui.dart';
import 'package:connect/features/home/presentation/components/post_ui_desktop.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect/features/post/presentation/cubits/post_states.dart';
import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/follow_button.dart';
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
  bool fromHome;
  String currentUserId;
  CProfilePage(
      {super.key,
      required this.uid,
      this.fromHome = false,
      this.currentUserId = "d"});

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

  void followButtonPress() {
    final profileState = profileCubit.state;
    if (profileState is! CProfileLoadedState) {
      return; //couldn't load the profile
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(widget.currentUserId);

    // optimistically update the UI
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(widget.currentUserId);
      } else {
        profileUser.followers.add(widget.currentUserId);
      }
    });
    // perform toggle in cubit
    profileCubit
        .toggleFollow(widget.currentUserId, widget.uid)
        .catchError((error) {
      // remove update if there was an error toggling in the database
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(widget.currentUserId);
        } else {
          profileUser.followers.remove(widget.currentUserId);
        }
      });
    });
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
            leading: widget.fromHome
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      context
                          .read<CPostCubit>()
                          .fetchAllPosts(); // Refresh home on return
                    },
                  )
                : null,
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
          loadingText: "Loading The Profile...",
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
          CProfileCardWidget(
            user: usr,
            uid: widget.uid,
            currentUserId: widget.currentUserId,
            followButtonPress: followButtonPress,
          ),
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
                          .map((post) => CPostUiDesktop(
                                post: post,
                                profileImageUrl: usr.profileImageUrl,
                              ))
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

  Widget _buildMobileLayout(
      BuildContext context, ResponsiveHelper res, CProfileUser usr) {
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
                  children: state.posts
                      .map((post) => CPostUi(
                            post: post,
                            profileImageUrl: usr.profileImageUrl,
                          ))
                      .toList(),
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
            _buildStatItem(
                "65", "Photos"), // Temporary values (Replace dynamically)
            _buildStatItem(usr.followers.length.toString(), "Followers"),
            _buildStatItem(usr.following.length.toString(), "Following"),
          ],
        ),
        const SizedBox(height: 20),
        if (widget.uid == widget.currentUserId)
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
        if (widget.uid != widget.currentUserId)
          CFollowButton(
            onPressed: followButtonPress,
            isFollowing: usr.followers.contains(widget.currentUserId),
          ),
      ],
    );
  }
}
