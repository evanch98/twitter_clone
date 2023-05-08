import "dart:io";

import "package:appwrite/appwrite.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/features/auth/controller/auth_controller.dart";
import "package:twitter_clone/features/notifications/controller/notification_controller.dart";
import "package:twitter_clone/models/models.dart";

//<editor-fold desc="Providers">
final tweetControllerProvider =
    StateNotifierProvider.autoDispose<TweetController, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return TweetController(
    ref: ref,
    tweetAPI: tweetAPI,
    storageAPI: storageAPI,
    notificationController: notificationController,
  );
});

final getTweetsProvider = FutureProvider.autoDispose((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

// provide the getLatestTweet from the TweetAPI
final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

// provide the replied tweets to a particular tweet
final getRepliesToTweetsProvider =
    FutureProvider.family.autoDispose((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesTweet(tweet);
});

// provide the tweet of the given id
final getTweetByIdProvider =
    FutureProvider.family.autoDispose((ref, String id) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});
//</editor-fold>

class TweetController extends StateNotifier<bool> {
  final Ref _ref; // to get access to the provider in this case
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;

  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    // to convert every item in the tweetList into a Tweet model
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  // to update the total number of like counts in both the Tweet model and the
  // server
  void likeTweet(Tweet tweet, UserModel userModel) async {
    List<String> likes = tweet.likes;

    // if the uid is in the list of likes, it means the user with that uid has
    // already liked the tweet
    if (tweet.likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      // otherwise, the user with that uid has not liked the tweet; therefore,
      // add the uid to the list of likes
      likes.add(userModel.uid);
    }

    // update the tweet likes in the Tweet model
    tweet = tweet.copyWith(likes: likes);
    // finally update the tweet likes in the server
    final res = await _tweetAPI.likeTweet(tweet);
    // in this case, there will be no message for either failure and success
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: "${userModel.name} liked your tweet!",
        postId: tweet.id,
        notificationType: NotificationType.like,
        uid: tweet.uid,
      );
    });
  }

  // to update the total number of reshare counts in both the Tweet model and
  // the server
  void reshareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      // the original tweet will increment
      reshareCount: tweet.reshareCount + 1,
    );

    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        // if the retweet action is successful, share the retweeted tweet as a
        // new tweet
        tweet = tweet.copyWith(
          // since the retweeted tweet is a new tweet, the likes, commentIds, and
          // reshareCount of the original tweet will not be carried over to the
          // new retweeted tweet
          retweetedBy: currentUser.name,
          likes: [],
          commentIds: [],
          id: ID.unique(),
          tweetedAt: DateTime.now(),
          // to make sure the retweeted tweet is a new tweet
          reshareCount: 0,
        );
        final res2 = await _tweetAPI.shareTweet(tweet);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            _notificationController.createNotification(
              text: "${currentUser.name} retweeted your tweet!",
              postId: tweet.id,
              notificationType: NotificationType.retweet,
              uid: tweet.uid,
            );
            showSnackBar(context, "Retweeted!");
          },
        );
      },
    );
  }

  // update the list of commentIds in both the Tweet model and the server
  void updateCommentIds(
    Tweet tweet,
    BuildContext context,
    UserModel userModel,
  ) async {
    List<String> commentIds = tweet.commentIds;
    commentIds.add(userModel.uid);
    tweet = tweet.copyWith(commentIds: commentIds);
    final res = await _tweetAPI.updateCommentIds(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, "Commented!"),
    );
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    // if the text is empty, the tweet function cannot proceed
    if (text.isEmpty) {
      showSnackBar(context, "Please enter text");
      return;
    }

    // if there is an image, the tweet should be image-based tweet
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      // otherwise, text-based tweet
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  // image-based tweet
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
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
      id: "",
      reshareCount: 0,
      retweetedBy: "",
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _notificationController.createNotification(
        text: "${user.name} replied to your tweet!",
        postId: r.$id,
        notificationType: NotificationType.reply,
        uid: repliedToUserId,
      );
    });
    state = false; // then the state is finished loading
  }

  // text-based tweet
  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
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
      id: "",
      reshareCount: 0,
      retweetedBy: "",
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: "${user.name} replied to your tweet!",
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false; // then the state is finished loading
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

  Future<List<Tweet>> getRepliesTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }
}
