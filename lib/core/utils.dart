// this file is for the utility functions

import 'package:flutter/material.dart';

// the show snackBar utility function
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

// extract the name from the given email
String getNameFromEmail(String email) {
  // joebloggs@email.com will return joebloggs
  return email.split("@")[0];
}
