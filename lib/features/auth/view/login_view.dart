import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/ui_constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // to make sure appbar is not rebuilt when the screen is rebuilt
  final appbar = UIConstants.appBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Column(

          ),
        ),
      ),
    );
  }
}

