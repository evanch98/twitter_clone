// this file is for the utility functions
import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

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

// to pick multiple images, File is from the dart:io
Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

// to pick a single image from the gallery
Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile = await picker.pickImage(source: ImageSource.gallery);
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}
