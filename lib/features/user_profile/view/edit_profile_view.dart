import "dart:js";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/common/common.dart";
import "package:twitter_clone/features/auth/controller/auth_controller.dart";
import "package:twitter_clone/theme/theme.dart";

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );

  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      body: currentUser == null
          ? const Loader()
          : Column(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: currentUser.bannerPic.isEmpty
                          ? Container(
                              color: Pallete.blueColor,
                            )
                          : Image.network(currentUser.bannerPic),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
