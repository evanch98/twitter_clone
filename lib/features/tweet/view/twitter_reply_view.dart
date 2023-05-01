import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/models.dart';

class ReplyTweetScreen extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ReplyTweetScreen(),
      );

  final Tweet tweet;

  const ReplyTweetScreen({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
    );
  }
}
