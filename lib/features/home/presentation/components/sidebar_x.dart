import 'package:connect/features/home/presentation/cubits/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';

class CSidebarNavigation extends StatelessWidget {
  final SidebarXController controller;

  const CSidebarNavigation({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        hoverTextStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        hoverIconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        textStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        selectedTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        selectedItemDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        selectedIconTheme: const IconThemeData(color: Colors.white),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200, // Sidebar width for desktop/web
        margin:  EdgeInsets.all(8),
      ),
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () => context.read<CNavigationCubit>().selectPage(0),
        ),
        SidebarXItem(
          icon: Icons.person,
          label: 'Profile',
          onTap: () => context.read<CNavigationCubit>().selectPage(1),
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () => context.read<CNavigationCubit>().selectPage(2),
        ),
      ],
    );
  }
}
