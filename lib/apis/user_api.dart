import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as model;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final userAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProviderForUserProfile);
  return UserAPI(db: db, realtime: realtime);
});

// interface for the UserAPI class
abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);

  Future<model.Document> getUserData(String uid);

  Future<List<model.Document>> searchUserByName(String name);

  FutureEitherVoid updateUserData(UserModel userModel);

  Stream<RealtimeMessage> getLatestUserProfileData();

  FutureEitherVoid followUser(UserModel userModel);

  FutureEitherVoid addToFollowing(UserModel userModel);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  UserAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
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
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        queries: [
          Query.search("name", name),
        ]);
    return document.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
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
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      // databases -> collections -> documents (path to the usersCollection channel to keep track of)
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents"
    ]).stream;
  }

  @override
  FutureEitherVoid followUser(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: {
          "followers": userModel.followers,
        }
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
