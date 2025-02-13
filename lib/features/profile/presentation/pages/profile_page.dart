import 'package:connect/features/profile/presentation/components/profile_card_widget.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/auth/domain/entities/app_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CProfilePage extends StatefulWidget {
  const CProfilePage({super.key});

  @override
  State<CProfilePage> createState() => _CProfilePageState();
}

class _CProfilePageState extends State<CProfilePage> {
  // cubits
  late final authCubit = context.read<CAuthCubit>();

  // get the current user
  late CAppUser? currentUser = authCubit.currentUser;
 
  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800; // Desktop breakpoint
    return Scaffold(
      appBar: AppBar(backgroundColor:  Theme.of(context).colorScheme.surface,),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SafeArea(
          child:  isDesktop
                ? _buildDesktopLayout(context, res)
                : _buildMobileLayout(context, res),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res) {
    return Center(child: CProfileCardWidget(nm: currentUser!.name));
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: res.width(20), // Adjust size dynamically
              backgroundColor: Colors.grey[300],
              child:const Icon(Icons.person),
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
          currentUser!.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "New York, United States",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem("65", "Photos"),
            _buildStatItem("43", "Followers"),
            _buildStatItem("21", "Following"),
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
