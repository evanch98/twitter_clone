import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/theme/theme.dart';

class UIConstants {
  // to be able to use in the Scaffold appBar because appBar does not accept
  // stateless widget, and it only accepts AppBar type
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        // to change the color of the vector
        colorFilter: const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
        height: 30,
      ),
      centerTitle: true,
    );
  }
}
