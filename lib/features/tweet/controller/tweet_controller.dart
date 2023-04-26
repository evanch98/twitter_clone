import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/core.dart';

class TweetController extends StateNotifier<bool> {
  TweetController() : super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    // if the text is empty, the tweet function cannot proceed
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    // if there is an image, the tweet should be image-based tweet
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
      );
    } else {
      // otherwise, text-based tweet
      _shareTextTweet(
        text: text,
        context: context,
      );
    }
  }

  // image-based tweet
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {}

  // text-based tweet
  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) {}
}
