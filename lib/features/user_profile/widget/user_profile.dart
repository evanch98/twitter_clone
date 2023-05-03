import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return NestedScrollView(
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
              ],
            ),
          ),
        ];
      },
      body: Container(),
    );
  }
}
