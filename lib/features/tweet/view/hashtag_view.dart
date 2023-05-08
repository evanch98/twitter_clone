import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/common/common.dart";
import "package:twitter_clone/features/tweet/controller/tweet_controller.dart";
import "package:twitter_clone/features/tweet/widgets/tweet_card.dart";

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) => HashtagView(hashtag: hashtag),
      );

  final String hashtag;

  const HashtagView({
    Key? key,
    required this.hashtag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
            data: (tweets) {
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
            loading: () => const Loader(),
          ),
    );
  }
}
