import 'package:appwrite/models.dart' as model;
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

// interface for the TweetAPI class
abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(Tweet tweet);
}