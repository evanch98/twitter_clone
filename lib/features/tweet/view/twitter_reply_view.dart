import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyTweetScreen extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ReplyTweetScreen(),
      );

  const ReplyTweetScreen({
    Key? key,
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
