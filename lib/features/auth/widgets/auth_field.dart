import "package:flutter/material.dart";
import "package:twitter_clone/theme/theme.dart";

// AuthField will only be used in authentication related text fields
class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AuthField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        // when the text field is focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 3,
          ),
        ),
        // when the text field is not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
          ),
        ),
        // padding inside the text field
        contentPadding: const EdgeInsets.all(22),
        hintText: hintText,
        // to increase the overall size of the text field
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
