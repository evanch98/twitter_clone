import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as model;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart";

final tweetAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProviderForTweet);
  return TweetAPI(db: db, realtime: realtime);
});

// interface for the TweetAPI class
abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(Tweet tweet);

  Future<List<model.Document>> getTweets();

  Stream<RealtimeMessage> getLatestTweet();

  FutureEither<model.Document> likeTweet(Tweet tweet);

  FutureEither<model.Document> updateReshareCount(Tweet tweet);

  FutureEither<model.Document> updateCommentIds(Tweet tweet);

  Future<List<model.Document>> getRepliesTweet(Tweet tweet);

  Future<model.Document> getTweetById(String id);

  Future<List<model.Document>> getUserTweets(String uid);

  Future<List<model.Document>> getTweetsByHashtag(String hashtag);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;

  TweetAPI({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;

  @override
  FutureEither<model.Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(), // every tweet should have an unique id
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "Some unexpected error occurred",
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<model.Document>> getTweets() async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.orderDesc("tweetedAt"),
      ],
    );
    return document.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      // databases -> collections -> documents (path to the tweetsCollection channel to keep track of)
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents"
    ]).stream;
  }

  @override
  FutureEither<model.Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            "likes": tweet.likes,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "Some unexpected error occurred",
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<model.Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            "reshareCount": tweet.reshareCount,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? "Some unexpected error occurred",
        st,
      ));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<model.Document> updateCommentIds(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            "commentIds": tweet.commentIds,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? "Some unexpected error occurred",
        st,
      ));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<model.Document>> getRepliesTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        // query any tweet that the repliedTo is equal to the id of that tweet
        Query.equal("repliedTo", tweet.id),
      ],
    );
    return document.documents;
  }

  @override
  Future<model.Document> getTweetById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<model.Document>> getUserTweets(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal("uid", uid),
      ],
    );
    return document.documents;
  }

  @override
  Future<List<model.Document>> getTweetsByHashtag(String hashtag) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.search("hashtags", hashtag),
      ],
    );
    return document.documents;
  }
}
