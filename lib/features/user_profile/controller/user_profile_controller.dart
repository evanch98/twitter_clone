import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";
import "package:twitter_clone/models/models.dart";

final userProfileControllerProvider = StateNotifierProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  return UserProfileController(tweetAPI: tweetAPI, storageAPI: storageAPI);
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

  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  })  : _storageAPI = storageAPI,
        _tweetAPI = tweetAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
