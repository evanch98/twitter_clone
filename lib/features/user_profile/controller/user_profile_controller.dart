import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/apis.dart';
import 'package:twitter_clone/models/models.dart';

final userProfileControllerProvider = StateNotifierProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return UserProfileController(tweetAPI: tweetAPI);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;

  UserProfileController({
    required TweetAPI tweetAPI,
  })  : _tweetAPI = tweetAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
