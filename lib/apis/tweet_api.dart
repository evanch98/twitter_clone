import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

final tweetAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return TweetAPI(db: db);
});

// interface for the TweetAPI class
abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(Tweet tweet);

  Future<List<model.Document>> getTweet();
}

class TweetAPI implements ITweetAPI {
  final Databases _db;

  TweetAPI({required Databases db}) : _db = db;

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
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<model.Document>> getTweet() async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
    );
    return document.documents;
  }
}
