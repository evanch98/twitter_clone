import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/models.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.profilePic,
                      ),
                    )
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
