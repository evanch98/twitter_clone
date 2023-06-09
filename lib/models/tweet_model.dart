import "package:flutter/foundation.dart";
import "package:twitter_clone/core/core.dart";

/// A model class that represents a tweet in the application.
///
/// The [Tweet] class is immutable and contains all the properties that define a user
/// in the application. It has properties such as text, link, hashtags, imageLinks,
/// uid, tweetType, tweetedAt, likes, commentIds, id, reshareCount, retweetedBy and
/// repliedTo.
///
/// The [Tweet] class also contains methods for comparison, copying and conversion to and from
/// a map. It overrides the == operator to compare two [Tweet] objects based on their
/// properties. It also provides a copyWith method to create a new [Tweet] object with
/// updated properties. The toMap method is used to convert a [Tweet] object to a map
/// that can be stored in a database, and the fromMap method is used to create a [Tweet]
/// object from a map retrieved from a database.
@immutable
class Tweet {
  final String text;
  final String link;
  final List<String> hashtags;
  final List<String> imageLinks;
  final String uid; // user id
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id; // tweet id
  final int reshareCount;
  final String retweetedBy;
  final String repliedTo;

//<editor-fold desc="Data Methods">
  const Tweet({
    required this.text,
    required this.link,
    required this.hashtags,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.reshareCount,
    required this.retweetedBy,
    required this.repliedTo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tweet &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          link == other.link &&
          hashtags == other.hashtags &&
          imageLinks == other.imageLinks &&
          uid == other.uid &&
          tweetType == other.tweetType &&
          tweetedAt == other.tweetedAt &&
          likes == other.likes &&
          commentIds == other.commentIds &&
          id == other.id &&
          reshareCount == other.reshareCount &&
          retweetedBy == other.retweetedBy &&
          repliedTo == other.repliedTo);

  @override
  int get hashCode =>
      text.hashCode ^
      link.hashCode ^
      hashtags.hashCode ^
      imageLinks.hashCode ^
      uid.hashCode ^
      tweetType.hashCode ^
      tweetedAt.hashCode ^
      likes.hashCode ^
      commentIds.hashCode ^
      id.hashCode ^
      reshareCount.hashCode ^
      retweetedBy.hashCode ^
      repliedTo.hashCode;

  @override
  String toString() {
    return "Tweet{ text: $text, link: $link, hashtags: $hashtags, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id, reshareCount: $reshareCount, retweetedBy: $retweetedBy, repliedTo: $repliedTo,}";
  }

  Tweet copyWith({
    String? text,
    String? link,
    List<String>? hashtags,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reshareCount,
    String? retweetedBy,
    String? repliedTo,
  }) {
    return Tweet(
      text: text ?? this.text,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "link": link,
      "hashtags": hashtags,
      "imageLinks": imageLinks,
      "uid": uid,
      "tweetType": tweetType.type,
      "tweetedAt": tweetedAt.millisecondsSinceEpoch,
      "likes": likes,
      "commentIds": commentIds,
      "reshareCount": reshareCount,
      "retweetedBy": retweetedBy,
      "repliedTo": repliedTo,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map["text"] as String,
      link: map["link"] as String,
      hashtags:
          (map["hashtags"] as List<dynamic>).map((e) => e.toString()).toList(),
      imageLinks: (map["imageLinks"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      uid: map["uid"] as String,
      tweetType: (map["tweetType"] as String).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map["tweetedAt"]),
      likes: (map["likes"] as List<dynamic>).map((e) => e.toString()).toList(),
      commentIds: (map["commentIds"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      // appwrite stores the id as $id
      id: map["\$id"] as String,
      reshareCount: map["reshareCount"] as int,
      retweetedBy: map["retweetedBy"] as String,
      repliedTo: map["repliedTo"] as String,
    );
  }

//</editor-fold>
}
