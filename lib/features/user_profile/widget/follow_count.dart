import "package:flutter/material.dart";
import "package:twitter_clone/theme/theme.dart";

class FollowCount extends StatelessWidget {
  final int count;
  final String text;

  const FollowCount({
    Key? key,
    required this.count,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 18.0; // font size for the two text widgets
    return Row(
      children: [
        Text(
          "$count",
          style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          text,
          style: TextStyle(
            color: Pallete.greyColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
