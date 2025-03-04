import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/home/presentation/components/sidebar_x.dart';
import 'package:connect/features/home/presentation/cubits/navigation_cubit.dart';
import 'package:connect/features/home/presentation/pages/home_page.dart';
import 'package:connect/features/profile/presentation/pages/profile_page.dart';
import 'package:connect/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';

class CMainScreen extends StatefulWidget {
  const CMainScreen({super.key});

  @override
  State<CMainScreen> createState() => _CMainScreenState();
}

class _CMainScreenState extends State<CMainScreen> {
  final SidebarXController _controller = SidebarXController(selectedIndex: 0);

  @override
  Widget build(BuildContext context) {
    final user = context.read<CAuthCubit>().currentUser;
    final uid = user!.uid; 
    final List<Widget> pages = [
      const CHomePage(),
      CProfilePage(uid: uid),
      const CSettingsPage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          CSidebarNavigation(controller: _controller),
          Expanded(
            child: BlocBuilder<CNavigationCubit, int>(
              builder: (context, state) {
                return pages[state];
              },
            ),
          ),
        ],
      ),
    );
  }
}
