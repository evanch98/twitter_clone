// interface for the NotificationAPI
import "package:twitter_clone/core/core.dart";

abstract class INotificationAPI {
  FutureEitherVoid createNotification();
}