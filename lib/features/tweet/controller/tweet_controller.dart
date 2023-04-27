import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/apis.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/models.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  return TweetController(
    ref: ref,
    tweetAPI: tweetAPI,
    storageAPI: storageAPI,
  );
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref; // to get access to the provider in this case
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;

  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
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
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);

    Tweet tweet = Tweet(
      text: text,
      link: link,
      hashtags: hashtags,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false; // then the state is finished loading
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  // text-based tweet
  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user =
        _ref.read(currentUserDetailsProvider).value!; // current user's details

    Tweet tweet = Tweet(
      text: text,
      link: link,
      hashtags: hashtags,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false; // then the state is finished loading
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
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
    // change the newline character and the tab character to the space character
    List<String> wordsInSentence =
        text.replaceAll("\n", " ").replaceAll("\t", " ").split(" ");
    // if a word starts with #, assume that the word is a hashtag
    for (String word in wordsInSentence) {
      if (word.startsWith("#")) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
