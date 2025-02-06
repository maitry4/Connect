import 'package:connect/features/auth/presentation/components/c_button.dart';
import 'package:connect/features/auth/presentation/components/c_text_field.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CRegisterPage extends StatefulWidget {
  final void Function()? toggle;
  const CRegisterPage({super.key, required this.toggle});

  @override
  State<CRegisterPage> createState() => _CRegisterPageState();
}

class _CRegisterPageState extends State<CRegisterPage> {
    // text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  void register() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirm = confirmController.text;

    final authCubit = context.read<CAuthCubit>();

    if(name.isNotEmpty  && email.isNotEmpty && password.isNotEmpty && confirm.isNotEmpty){

      if(password == confirm) {
        authCubit.register(name, email, password);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords Don't Match!!")));
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter All Details!!")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
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
              "assets/images/register_img.png",
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
              'Welcome To Connect',
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
                'Already a member?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              TextButton(
                onPressed: widget.toggle,
                child: Text(
                  'Log In',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: res.height(3)),
          CTextField(controller: nameController, hintTxt: "Name", ispass: false),
          SizedBox(height: res.height(2)),
          CTextField(controller: emailController, hintTxt: "Email", ispass: false),
          SizedBox(height: res.height(2)),
          CTextField(controller: passwordController, hintTxt: "Password", ispass: true),
          SizedBox(height: res.height(2)),
          CTextField(controller: confirmController, hintTxt: "Confirm Password", ispass: true),
          SizedBox(height: res.height(4)),
          CButton(text: 'Register', onPressed: register),
          SizedBox(height: res.height(2)),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Your Moments, Your Story—Securely Connected.',
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
            "assets/images/register_img.png",
            height: res.height(20),
          ),
          SizedBox(height: res.height(2)),
          Center(
            child: Text(
              'Welcome To Connect',
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
                'Already a member?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              TextButton(
                onPressed: widget.toggle,
                child: Text(
                  'Log In',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: res.height(3)),
          CTextField(controller: nameController,hintTxt: "Name", ispass: false),
          SizedBox(height: res.height(2)),
          CTextField(controller: emailController,hintTxt: "Email", ispass: false),
          SizedBox(height: res.height(2)),
          CTextField(controller: passwordController,hintTxt: "Password", ispass: true),
          SizedBox(height: res.height(2)),
          CTextField(controller: confirmController,hintTxt: "Confirm Password", ispass: true),
          SizedBox(height: res.height(4)),
          CButton(text: 'Register', onPressed: register),
          SizedBox(height: res.height(2)),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Your Moments, Your Story—Securely Connected.',
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