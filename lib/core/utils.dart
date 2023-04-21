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
