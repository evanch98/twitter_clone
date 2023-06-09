import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as model;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final notificationAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProviderForNotification);
  return NotificationAPI(db: db, realtime: realtime);
});

// interface for the NotificationAPI
abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);

  Future<List<model.Document>> getNotifications(String uid);

  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;

  NotificationAPI({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;

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

  @override
  Future<List<model.Document>> getNotifications(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notificationsCollection,
      queries: [
        Query.equal("uid", uid),
      ],
    );
    return document.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollection}.documents"
    ]).stream;
  }
}
