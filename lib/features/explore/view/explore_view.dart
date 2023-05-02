import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
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
  bool isShowUsers = false;
  bool isTextFieldOnFocus = false;

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
              currentUser == null || isTextFieldOnFocus == true
                  ? const SizedBox()
                  : CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.profilePic),
                      radius: 18,
                    ),
              SizedBox(
                width: isTextFieldOnFocus ? 0 : 10,
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    setState(() {
                      isShowUsers = true;
                    });
                  },
                  onTap: () {
                    setState(() {
                      isTextFieldOnFocus = true;
                    });
                  },
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
                    hintText: 'Search Twitter',
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
              SizedBox(
                width: isTextFieldOnFocus ? 5 : 0,
              ),
              if (isTextFieldOnFocus)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isTextFieldOnFocus = false;
                    });
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 18, color: Pallete.whiteColor),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
                data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      return SearchTile(userModel: user);
                    },
                  );
                },
                error: (error, st) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}
