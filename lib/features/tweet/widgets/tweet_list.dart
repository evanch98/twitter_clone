import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/common/common.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/features/tweet/controller/tweet_controller.dart";
import "package:twitter_clone/features/tweet/widgets/tweet_card.dart";
import "package:twitter_clone/models/models.dart";

class TweetList extends ConsumerWidget {
  const TweetList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      "databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create",
                    )) {
                      // to insert the new tweet at the top of the list
                      tweets.insert(0, Tweet.fromMap(data.payload));
                    } else if (data.events.contains(
                      "databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update",
                    )) {
                      // get id of the tweet
                      // to get the id of the old tweet, we need to find it in
                      // the date events[0] string
                      final startingPoint = data.events[0].lastIndexOf("documents.");
                      final endPoint = data.events[0].lastIndexOf(".update");
                      // startingPoint + 10 because we do not want to include
                      // 'documents.' and its length is 10
                      final tweetId = data.events[0].substring(startingPoint + 10, endPoint);
                      // find the index of the tweet
                      // we can use first since each tweet id is unique
                      var tweet = tweets
                          .where((element) => element.id == tweetId)
                          .first;
                      final tweetIndex = tweets.indexOf(tweet);
                      // remove the id
                      tweets.removeWhere((element) => element.id == tweetId);
                      // update the tweet
                      tweet = Tweet.fromMap(data.payload);
                      // insert the updated tweet
                      tweets.insert(tweetIndex, tweet);
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    // the reason for this is due to the way appwrite works
                    // until there is an update, it will keep loading
                    // therefore, one of the way to solve this problem is to
                    // return the same ListView.builder in the state of loading
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
          },
          error: (error, st) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
