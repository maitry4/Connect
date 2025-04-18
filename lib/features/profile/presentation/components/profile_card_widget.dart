import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/follow_button.dart';
import 'package:connect/features/profile/presentation/components/stats_widget.dart';
import 'package:connect/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CProfileCardWidget extends StatefulWidget {
  final CProfileUser user;
  String uid;
  String currentUserId;
  final VoidCallback followButtonPress;
  CProfileCardWidget({super.key, required this.user, required this.followButtonPress,String this.uid="", String this.currentUserId =""});

  @override
  State<CProfileCardWidget> createState() => _CProfileCardWidgetState();
}

class _CProfileCardWidgetState extends State<CProfileCardWidget> {
  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    return SizedBox(
      width: res.width(50),
      height: res.height(50),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: widget.user.profileImageUrl,
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
              const SizedBox(height: 10),
              Text(widget.user.name,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                  width: res.width(20),
                  child: Text(widget.user.bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14))),
              const SizedBox(height: 15),
              const StatsWidget(),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: res.width(7)),
                  
                  SizedBox(width: res.width(3)),
                  if (widget.uid == widget.currentUserId)
                  Expanded(
                    child: CActionButton(
                      icon: Icons.edit,
                      label: "Edit Profile",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CProfileEditScreen(profUser: widget.user)),
                        );
                      },
                    ),
                  ),
                  if(widget.uid != widget.currentUserId)
                  Expanded(
                    child: CFollowButton(
                      onPressed: widget.followButtonPress,
                      isFollowing: widget.user.followers.contains(widget.currentUserId),
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
