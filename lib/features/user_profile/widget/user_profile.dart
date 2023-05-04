import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widget/follow_count.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class UserProfile extends ConsumerWidget {
  final UserModel userModel;

  const UserProfile({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: userModel.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(userModel.bannerPic),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userModel.profilePic),
                            radius: 45,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Pallete.whiteColor),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: Text(
                            // if the user is the current user, show Edit Profile
                            // otherwise, follow
                            currentUser.uid == userModel.uid
                                ? "Edit Profile"
                                : "Follow",
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          userModel.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "@${userModel.name}",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          userModel.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FollowCount(
                              count: userModel.following.length,
                              text: "Following",
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FollowCount(
                              count: userModel.followers.length,
                              text: "Followers",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        const Divider(
                          color: Pallete.whiteColor,
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ref.watch(getUserTweetsProvider(userModel.uid)).when(
                  data: (tweets) {
                    return ref.watch(getLatestTweetProvider).when(
                          data: (data) {
                            // get the latest tweet
                            final latestTweet = Tweet.fromMap(data.payload);

                            bool isTweetAlreadyPresent = false;
                            // check if the tweet is already present in the tweets
                            for (final tweetModel in tweets) {
                              if (tweetModel.id == latestTweet.id) {
                                isTweetAlreadyPresent = true;
                                break;
                              }
                            }

                            // unless the repliedTo of the tweet is equal to that
                            // of the tweet, and the tweet is not already present,
                            // don't do any tweet retrieving logic
                            if (!isTweetAlreadyPresent) {
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
          );
  }
}
