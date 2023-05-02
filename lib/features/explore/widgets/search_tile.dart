import 'package:flutter/material.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;

  const SearchTile({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePic),
        radius: 30,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "@${userModel.name}",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
              color: Pallete.whiteColor,
            ),
          )
        ],
      ),
    );
  }
}
