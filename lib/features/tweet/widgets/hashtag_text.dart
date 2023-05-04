import "package:flutter/material.dart";
import "package:twitter_clone/theme/theme.dart";

// To change the color of hashtags and links
class HashtagText extends StatelessWidget {
  final String text;

  const HashtagText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text
        .replaceAll("\n", " ")
        .replaceAll("\t", " ")
        .split(" ")
        .forEach((element) {
      if (element.startsWith("#")) {
        textSpans.add(
          TextSpan(
            text: "$element ",
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (element.startsWith("www.") ||
          element.startsWith("https://") ||
          element.startsWith("http://")) {
        textSpans.add(
          TextSpan(
            text: "$element ",
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: "$element ",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    });
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
