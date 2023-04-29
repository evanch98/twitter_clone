import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

final tweetAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return TweetAPI(db: db, realtime: realtime);
});

// interface for the TweetAPI class
abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(Tweet tweet);

  Future<List<model.Document>> getTweets();

  Stream<RealtimeMessage> getLatestTweet();

  FutureEither<model.Document> likeTweet(Tweet tweet);
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
          e.message ?? 'Some unexpected error occurred',
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
        Query.orderDesc('tweetedAt'),
      ],
    );
    return document.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      // databases -> collections -> documents (path to the tweetsCollection channel to keep track of)
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }
}
