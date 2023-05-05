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

  void followUser({
    required UserModel userModel, // for other users
    required BuildContext context,
    required UserModel currentUser, // for the current user
  }) async {
    // this means the current user has already followed the user
    if (currentUser.following.contains(userModel.uid)) {
      // remove the current user from the user's followers
      userModel.followers.remove(currentUser.uid);
      // remove the user from the current user's following
      currentUser.following.remove(userModel.uid);
    } else { // the current user has not followed the user
      // add the current user to the user's followers
      userModel.followers.add(currentUser.uid);
      // add the user to the current user's following
      currentUser.following.add(userModel.uid);
    }

    userModel = userModel.copyWith(
      followers: userModel.followers
    );

    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final res = await _userAPI.followUser(userModel);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) => null);
    });
  }
}
