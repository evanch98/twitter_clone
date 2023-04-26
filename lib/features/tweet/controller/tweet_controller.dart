import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TweetController extends StateNotifier<bool> {
  TweetController() : super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {}
}
