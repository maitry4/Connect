import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/presentation/components/action_button.dart';
import 'package:connect/features/profile/presentation/components/stats_widget.dart';
import 'package:connect/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CProfileCardWidget extends StatefulWidget {
  final CProfileUser user;
  const CProfileCardWidget({super.key, required this.user});

  @override
  State<CProfileCardWidget> createState() => _CProfileCardWidgetState();
}

class _CProfileCardWidgetState extends State<CProfileCardWidget> {
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
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
                // backgroundImage: AssetImage('assets/profile.jpg'),
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
                  Expanded(
                    child: CActionButton(
                      icon: Icons.camera,
                      label: "Show Posts",
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: res.width(3)),
                  Expanded(
                    child: CActionButton(
                      icon: Icons.edit,
                      label: "Edit Profile",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  CProfileEditScreen(profUser: widget.user)),
                        );
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
