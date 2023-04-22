import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/theme.dart';

// Login Screen
class LoginView extends ConsumerStatefulWidget {
  // to navigate to the Login Screen
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );

  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // to make sure appbar is not rebuilt when the screen is rebuilt
  final appbar = UIConstants.appBar();

  // email text editing controller
  final emailController = TextEditingController();

  // password text editing controller
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
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
                      const SizedBox(
                        height: 25,
                      ), // space between the two text fields
                      // Password TextField
                      AuthField(
                        controller: passwordController,
                        hintText: "Password",
                      ),
                      const SizedBox(
                        height: 40,
                      ), // space between the two widgets
                      Align(
                        // to align the widget to the right side of the screen
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onTap: onLogin,
                          label: "Done",
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // use RichText to be able to use TextSpan
                      RichText(
                        // use TextSpan to have text with different colors in the same
                        // line, it is more efficient to do it this way.
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: " Sign up",
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              // to be able to tap on the sign up part (to navigate to
                              // other screens
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    SignUpView.route(),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
