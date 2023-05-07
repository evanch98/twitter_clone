import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";

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
}
