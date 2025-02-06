import 'package:connect/features/auth/presentation/pages/login_page.dart';
import 'package:connect/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class CAuthPage extends StatefulWidget {
  
  const CAuthPage({super.key});

  @override
  State<CAuthPage> createState() => _CAuthPageState();
}

class _CAuthPageState extends State<CAuthPage> {
  //initially show login page
  bool showLoginPage = true;

  // create a method to toggle between both
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return CLoginPage(toggle: togglePages,);
    }
    else {
      return CRegisterPage(toggle: togglePages,);
    }
  }
}