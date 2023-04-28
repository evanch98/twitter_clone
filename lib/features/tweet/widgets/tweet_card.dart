import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // the reason to use userDetailsProvider is to get the image of the user who
    // tweeted which may or may not be the current user
    return ref.watch(userDetailsProvider(tweet.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO: retweeted
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                              Text(
                                "@${user.name} · ${timeago.format(
                                  tweet.tweetedAt,
                                  locale: "en_short",
                                )}",
                                style: const TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          // TODO: replied to
                          HashtagText(text: tweet.text),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          error: (error, st) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
