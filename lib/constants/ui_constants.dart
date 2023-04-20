import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:twitter_clone/constants/constants.dart';

class UIConstants {
  // to be able to use in the Scaffold appBar because appBar does not accept
  // stateless widget, and it only accepts AppBar type
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
      ),
    );
  }
}
