import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as model;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final notificationAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return NotificationAPI(db: db);
});

// interface for the NotificationAPI
abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);

  Future<List<model.Document>> getNotifications(String uid);
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;

  NotificationAPI({
    required Databases db,
  }) : _db = db;

  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "Some unexpected error occurred",
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }
}
