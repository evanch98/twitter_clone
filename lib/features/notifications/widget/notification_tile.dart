import "package:flutter/material.dart";
import "package:twitter_clone/models/models.dart" as model;

class NotificationTile extends StatelessWidget {
  final model.Notification notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
