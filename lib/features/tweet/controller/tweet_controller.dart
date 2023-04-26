import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/models.dart';

class TweetController extends StateNotifier<bool> {
  final Ref _ref; // to get access to the provider in this case
  TweetController({required Ref ref})
      : _ref = ref,
        super(false);

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
  }) {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!; // current user's details

    Tweet(
      text: text,
      link: link,
      hashtags: hashtags,
      imageLinks: [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '',
      reshareCount: 0,
    );
  }

  // to extract link from the given text
  String _getLinkFromText(String text) {
    String link = "";
    List<String> wordsInSentence = text.split(" ");
    for (String word in wordsInSentence) {
      // if a word starts with any of these, assume that the word is a link
      if (word.startsWith("https://") ||
          word.startsWith("http://") ||
          word.startsWith("www.")) {
        link = word;
      }
    }
    return link;
  }

  // to extract hashtags from the given text
  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(" ");
    // if a word starts with #, assume that the word is a hashtag
    for (String word in wordsInSentence) {
      if (word.startsWith("#")) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
