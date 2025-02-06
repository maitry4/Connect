// login_page.dart
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:connect/features/auth/presentation/components/c_button.dart';
import 'package:connect/features/auth/presentation/components/c_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CLoginPage extends StatefulWidget {
  final void Function()? toggle;
  const CLoginPage({super.key, required this.toggle});

  @override
  State<CLoginPage> createState() => _CLoginPageState();
}

class _CLoginPageState extends State<CLoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // login method
  void login() async {
    // get text
    final String email = emailController.text;
    final String pw = passwordController.text;

    // get the auth cubit
    final authCubit = context.read<CAuthCubit>();

    // make sure we have something in email and password
    if(email.isNotEmpty && pw.isNotEmpty) {
      try {

      await authCubit.login(email, pw);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    // else display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Both Email and Password!!")));
    }
  }

  // dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  // Build UI
  @override
  Widget build(BuildContext context) {
    final res = ResponsiveHelper(context);
    final isDesktop = res.width(100) >= 800; // Desktop breakpoint

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: isDesktop
                ? _buildDesktopLayout(context, res)
                : _buildMobileLayout(context, res),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper res) {
    return Row(
      children: [
        // Left side - Image
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.width(8),
              vertical: res.height(4),
            ),
            child: Image.asset(
              "assets/images/login_img.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Right side - Login form
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.width(10),
              vertical: res.height(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
            child: Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: res.fontSize(3),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: res.height(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not registered yet?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              TextButton(
                onPressed: widget.toggle,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: res.height(3)),
          CTextField(controller: emailController, hintTxt: "Email", ispass: false),
          SizedBox(height: res.height(2)),
          CTextField(controller: passwordController, hintTxt: "Password", ispass: true),
          SizedBox(height: res.height(4)),
          CButton(text: 'Log In', onPressed: login),
          SizedBox(height: res.height(2)),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgotten your password or login details?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: res.fontSize(1),
                ),
              ),
            ),
          ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper res) {
    return Padding(
      padding: EdgeInsets.all(res.width(6)),
      child: ListView(
        shrinkWrap: true,
        children: [
          Image.asset(
            "assets/images/login_img.png",
          ),
          SizedBox(height: res.height(2)),
          Center(
            child: Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: res.fontSize(7),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: res.height(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not registered yet?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              TextButton(
                onPressed: widget.toggle,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: res.height(3)),
          CTextField(controller: emailController,hintTxt: "Email", ispass: false),
          SizedBox(height: res.height(2)),
          CTextField(controller: passwordController,hintTxt: "Password", ispass: true),
          SizedBox(height: res.height(4)),
          CButton(text: 'Log In', onPressed: login),
          SizedBox(height: res.height(2)),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgotten your password or login details?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: res.fontSize(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
