import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final notificationControllerProvider =
    StateNotifierProvider.autoDispose<NotificationController, bool>((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return NotificationController(notificationAPI: notificationAPI);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;

  NotificationController({
    required NotificationAPI notificationAPI,
  })  : _notificationAPI = notificationAPI,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = Notification(
      text: text,
      postId: postId,
      id: "",
      uid: uid,
      notificationType: notificationType,
    );
    await _notificationAPI.createNotification(notification);
  }
}
