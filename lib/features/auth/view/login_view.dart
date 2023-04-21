import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';

// Login Screen
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // to make sure appbar is not rebuilt when the screen is rebuilt
  final appbar = UIConstants.appBar();
  // email text editing controller
  final emailController = TextEditingController();
  // password text editing controller
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        // SingleChildScrollView is to make sure that when the virtual keyboard
        // pops up, it does not cause the out-of-pixels problem with the widgets.
        child: SingleChildScrollView(
          child: Padding(
            // horizontal padding
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                // Email TextField
                AuthField(
                  controller: emailController,
                  hintText: "Email",
                ),
                const SizedBox(height: 25,), // space between the two text fields
                // Password TextField
                AuthField(
                  controller: passwordController,
                  hintText: "Password",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
