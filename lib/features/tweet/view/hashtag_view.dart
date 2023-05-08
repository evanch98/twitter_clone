import "dart:js";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) => HashtagView(hashtag: hashtag),
      );

  final String hashtag;

  const HashtagView({
    Key? key,
    required this.hashtag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
    );
  }
}
