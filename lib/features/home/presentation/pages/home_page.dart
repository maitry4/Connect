import 'package:connect/features/home/presentation/components/post_ui.dart';
import 'package:connect/features/home/presentation/components/post_ui_desktop.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/presentation/pages/create_post.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage> {
  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800;
    return  Scaffold(
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>const CCreatePostPage()),
                      );
        },
        child: Icon(Icons.add, color:Theme.of(context).colorScheme.inversePrimary),
       ),
      body:Center(
        child: SafeArea(
          child: isDesktop
              ? _buildDesktopLayout(context, res)
              : _buildMobileLayout(context, res),
        ),
      ),
    );
  }
  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res){
    return Padding(
        padding: const EdgeInsets.all(100.0),
        child: GridView.count(
           crossAxisCount: 3,
          children: [
            CPostUiDesktop(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'Emily',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y29tcHV0ZXJ8ZW58MHx8MHx8fDA%3D',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUiDesktop(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'someone',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUiDesktop(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'xyz',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNvbXB1dGVyfGVufDB8fDB8fHww',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUiDesktop(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'xyz',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNvbXB1dGVyfGVufDB8fDB8fHww',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUiDesktop(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'Emily',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y29tcHV0ZXJ8ZW58MHx8MHx8fDA%3D',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUiDesktop(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'someone',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
          ]
        ),
      );
  }
  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res){
    return Padding(
        padding: const EdgeInsets.only(top:30.0),
        child: ListView(
          children: [
            CPostUi(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'Emily',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y29tcHV0ZXJ8ZW58MHx8MHx8fDA%3D',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUi(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'someone',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
            CPostUi(
              post: CPost(
                id:'1',
                userId: '1',
                userName: 'xyz',
                text:'Beautiful Scene',
                imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNvbXB1dGVyfGVufDB8fDB8fHww',
                imageId: 'sfhld',
                timestamp: DateTime.now(),
              )
            ),
          ]
        ),
      );
  }
}
