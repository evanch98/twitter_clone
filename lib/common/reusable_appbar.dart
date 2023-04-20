import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';

class ReusableAppBar extends StatelessWidget {
  const ReusableAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
      ),
    );
  }
}
