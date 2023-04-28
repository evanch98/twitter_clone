import 'package:flutter/material.dart';

class TweetIconButton extends StatelessWidget {
  final String pathName;  // path to the svg icons
  final String text;  // name of the button
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
