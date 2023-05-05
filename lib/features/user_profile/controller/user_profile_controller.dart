import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final userProfileControllerProvider =
    StateNotifierProvider.autoDispose<UserProfileController, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return UserProfileController(
    tweetAPI: tweetAPI,
    storageAPI: storageAPI,
    userAPI: userAPI,
  );
});

final getLatestUserProfileDataProvider = StreamProvider.autoDispose((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

final getUserTweetsProvider =
    FutureProvider.family.autoDispose((ref, String uid) {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;

  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }
}
