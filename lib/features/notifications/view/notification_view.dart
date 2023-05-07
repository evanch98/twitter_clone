import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/common/common.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/features/auth/controller/auth_controller.dart";
import "package:twitter_clone/features/notifications/controller/notification_controller.dart";
import "package:twitter_clone/models/models.dart" as model;

class NotificationView extends ConsumerWidget {
  const NotificationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            "databases.*.collections.${AppwriteConstants.notificationsCollection}.documents.*.create",
                          )) {
                            // to insert the new tweet at the top of the list
                            notifications.insert(
                                0, model.Notification.fromMap(data.payload));
                          }
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return Text(notification.toString());
                            },
                          );
                        },
                        error: (error, st) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          // the reason for this is due to the way appwrite works
                          // until there is an update, it will keep loading
                          // therefore, one of the way to solve this problem is to
                          // return the same ListView.builder in the state of loading
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return Text(notification.toString());
                            },
                          );
                        },
                      );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
