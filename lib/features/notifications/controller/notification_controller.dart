import "package:flutter_riverpod/flutter_riverpod.dart";

final notificationControllerProvider = StateNotifierProvider.autoDispose<NotificationController, bool>((ref) {
  return NotificationController();
});

class NotificationController extends StateNotifier<bool> {
  NotificationController() : super(false);
}
