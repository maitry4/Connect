import 'package:connect/features/home/presentation/components/post_ui.dart';
import 'package:connect/features/home/presentation/components/post_ui_desktop.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect/features/post/presentation/cubits/post_states.dart';
import 'package:connect/features/post/presentation/pages/create_post.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage> {
  late final CPostCubit postCubit;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<CPostCubit>();
    postCubit.fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CCreatePostPage()),
          );
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.inversePrimary),
      ),
      body: Center(
        child: SafeArea(
          child: BlocBuilder<CPostCubit, CPostState>(
            builder: (context, state) {
              if (state is CPostsLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is CPostsLoadedState) {
                final posts = state.posts;
                return isDesktop
                    ? _buildDesktopLayout(context, res, posts)
                    : _buildMobileLayout(context, res, posts);
              } else {
                return const Center(child: Text("Failed to load posts"));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res, List<CPost> posts) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: posts.map((post) => CPostUiDesktop(post: post)).toList(),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res, List<CPost> posts) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: ListView(
        children: posts.map((post) => CPostUi(post: post)).toList(),
      ),
    );
  }
}
