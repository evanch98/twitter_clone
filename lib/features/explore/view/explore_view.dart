import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/theme/theme.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(left: 15),
          child: Row(
            children: [
              currentUser == null
                  ? const Loader()
                  : CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.profilePic),
                      radius: 18,
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Transform.scale(
                      scale: 0.5,
                      child: SizedBox(
                        width: 5,
                        height: 5,
                        child: SvgPicture.asset(
                          AssetsConstants.searchIcon,
                          colorFilter: const ColorFilter.mode(
                            Pallete.greyColor,
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                    fillColor: Pallete.searchBarColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
