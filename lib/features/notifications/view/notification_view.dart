import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class NotificationView extends ConsumerWidget {
  const NotificationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
    );
  }
}
