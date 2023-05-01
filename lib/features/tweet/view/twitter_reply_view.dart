import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            const SizedBox(width: 15,),
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
