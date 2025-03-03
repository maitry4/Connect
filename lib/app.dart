
import 'package:connect/features/auth/data/firebase_auth_repo.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/auth/presentation/cubits/auth_states.dart';
import 'package:connect/features/auth/presentation/pages/auth_page.dart';
import 'package:connect/features/home/presentation/cubits/navigation_cubit.dart';
import 'package:connect/features/post/data/firebase_post_repo.dart';
import 'package:connect/features/post/data/imagekit_post_repo.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect/features/profile/data/firebase_profile_repo.dart';
import 'package:connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/themes/light_mode.dart';
import 'package:connect/utils/loading_screen.dart';
import 'package:connect/utils/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  // repos
  final authRepo = CFirebaseAuthRepo();
  final profileRepo = CFirebaseProfileRepo();
  final postRepo = CFirebasePostRepo();
  final imagekitRepo = ImageKitPostRepo();
  
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CAuthCubit(authRepo: authRepo)..checkAuth(),
        ),
        BlocProvider(
          create: (context) => CNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => CProfileCubit(profileRepo: profileRepo),
        ),
        BlocProvider(
          create: (context) => CPostCubit(postRepo: postRepo, imageKitPostRepo: imagekitRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<CAuthCubit, CAuthState>(
          builder: (context, authState) {
            if (authState is CAuthUnauthenticatedState) {
              return const CAuthPage();
            }
            if (authState is CAuthAuthenticatedState) {
              return const CMainScreen(); // Load Sidebar Navigation
            }
            return const CLoadingScreen(loadingText: "Your Moments, Your Story—Securely Connected.",);
          },
          listener: (context, state) {
            if (state is CAuthErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );

  }
}
