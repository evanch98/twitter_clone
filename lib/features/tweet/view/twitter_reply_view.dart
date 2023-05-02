import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class ReplyTweetScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => ReplyTweetScreen(
          tweet: tweet,
        ),
      );

  final Tweet tweet;

  const ReplyTweetScreen({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                          )) {
                            // to insert the new tweet at the top of the list
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                          )) {
                            // get id of the tweet
                            // to get the id of the old tweet, we need to find it in
                            // the date events[0] string
                            final startingPoint =
                                data.events[0].lastIndexOf('documents.');
                            final endPoint =
                                data.events[0].lastIndexOf('.update');
                            // startingPoint + 10 because we do not want to include
                            // 'documents.' and its length is 10
                            final tweetId = data.events[0]
                                .substring(startingPoint + 10, endPoint);
                            // find the index of the tweet
                            // we can use first since each tweet id is unique
                            var tweet = tweets
                                .where((element) => element.id == tweetId)
                                .first;
                            final tweetIndex = tweets.indexOf(tweet);
                            // remove the id
                            tweets.removeWhere(
                                (element) => element.id == tweetId);
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
              ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(left: 15),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text('ProfilePic'),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  ref.read(tweetControllerProvider.notifier).shareTweet(
                    images: [],
                    text: value,
                    context: context,
                    repliedTo: tweet.id,
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Tweet your reply',
                  hintStyle: const TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  filled: true,
                  fillColor: Pallete.greyColor.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
