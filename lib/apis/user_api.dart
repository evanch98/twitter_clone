import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as model;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

/// A provider that creates a [UserAPI] instance using a [Databases] instance and a [Realtime] instance.
///
/// This provider is used to manage the lifecycle of the [UserAPI] object and ensure that it is properly
/// disposed of when it is no longer needed. It depends on the [appwriteDatabaseProvider] and
/// [appwriteRealtimeProviderForUserProfile] providers, which provide instances of [Databases] and [Realtime],
/// respectively. These instances are used to interact with the Appwrite database and Appwrite realtime
/// services.
///
/// To use this provider, you can call the read or watch method on the [ProviderReference] and pass in
/// the [userAPIProvider] to obtain a [UserAPI] instance. The [UserAPI] object can then be used to perform
/// CRUD operations on user data in the Appwrite database and subscribe to changes in user data using
/// the Appwrite realtime service.
final userAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProviderForUserProfile);
  return UserAPI(db: db, realtime: realtime);
});

// interface for the UserAPI class
/// Abstract class defining the interface for UserAPI
abstract class IUserAPI {
  /// Saves user data to the database.
  ///
  /// Returns a [FutureEitherVoid] that resolves with no value on success,
  /// or a [Failure] object on failure.
  FutureEitherVoid saveUserData(UserModel userModel);

  /// Retrieves user data from the database.
  ///
  /// [uid] - The unique ID of the user.
  ///
  /// Returns a [Future] that resolves with a [model.Document] object on success,
  /// or throws an error if the operation fails.
  Future<model.Document> getUserData(String uid);

  /// Searches for users by name.
  ///
  /// [name] - The name of the user to search for.
  ///
  /// Returns a [Future] that resolves with a [List] of [model.Document] objects on success,
  /// or throws an error if the operation fails.
  Future<List<model.Document>> searchUserByName(String name);

  /// Updates user data in the database.
  ///
  /// Returns a [FutureEitherVoid] that resolves with no value on success,
  /// or a [Failure] object on failure.
  FutureEitherVoid updateUserData(UserModel userModel);

  /// Retrieves the latest user profile data in real time.
  ///
  /// Returns a [Stream] of [RealtimeMessage] objects.
  Stream<RealtimeMessage> getLatestUserProfileData();

  /// Follows another user.
  ///
  /// [userModel] - The [UserModel] object representing the user to follow.
  ///
  /// Returns a [FutureEitherVoid] that resolves with no value on success,
  /// or a [Failure] object on failure.
  FutureEitherVoid followUser(UserModel userModel);

  /// Adds a user to the list of users being followed.
  ///
  /// [userModel] - The [UserModel] object representing the user to add.
  ///
  /// Returns a [FutureEitherVoid] that resolves with no value on success,
  /// or a [Failure] object on failure.
  FutureEitherVoid addToFollowing(UserModel userModel);
}

/// The implementation of [IUserAPI] that interacts with the Appwrite server
class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  /// Creates a new instance of [UserAPI]
  ///
  /// [db] is the instance of the [Databases] class to interact with Appwrite databases
  /// [realtime] is the instance of the [Realtime] class to interact with Appwrite Realtime subscriptions
  UserAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  /// Saves the user data to the Appwrite server by creating a new document in the usersCollection collection of the Appwrite database.
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

  /// Retrieves the user data from the Appwrite server by fetching the document with the given [uid] from the usersCollection collection of the Appwrite database.
  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

  /// Searches for users with the given [name] in the usersCollection collection of the Appwrite database and returns a list of matching documents.
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

  /// Updates the user data on the Appwrite server by updating the document with the given [userModel.uid] in the usersCollection collection of the Appwrite database.
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

  /// Subscribes to the [Realtime] channel for changes to user profiles in the usersCollection collection of the Appwrite database and returns a [Stream] of [RealtimeMessage] objects.
  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      // databases -> collections -> documents (path to the usersCollection channel to keep track of)
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents"
    ]).stream;
  }

  /// Updates the followers list of the user with the given [userModel.uid] in the usersCollection collection of the Appwrite database.
  @override
  FutureEitherVoid followUser(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid,
          data: {
            "followers": userModel.followers,
          });
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

  /// Updates the following list of the user with the given [userModel.uid] in the usersCollection collection of the Appwrite database.
  @override
  FutureEitherVoid addToFollowing(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid,
          data: {
            "following": userModel.following,
          });
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
