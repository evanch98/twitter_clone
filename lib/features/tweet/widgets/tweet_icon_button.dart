import 'package:flutter/material.dart';

class TweetIconButton extends StatelessWidget {
  final String pathName;
  final String text;
  final VoidCallback onTap;

  const TweetIconButton({
    Key? key,
    required this.pathName,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
