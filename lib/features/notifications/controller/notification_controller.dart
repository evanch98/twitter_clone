import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final notificationControllerProvider =
    StateNotifierProvider.autoDispose<NotificationController, bool>((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return NotificationController(notificationAPI: notificationAPI);
});

final getLatestNotificationProvider = StreamProvider.autoDispose((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationsProvider =
    FutureProvider.family.autoDispose((ref, String uid) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
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
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<Notification>> getNotifications(String uid) async {
    final notifications = await _notificationAPI.getNotifications(uid);
    return notifications.map((e) => Notification.fromMap(e.data)).toList();
  }
}
