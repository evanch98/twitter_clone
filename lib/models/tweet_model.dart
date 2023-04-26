import 'package:flutter/foundation.dart';
import 'package:twitter_clone/core/core.dart';

@immutable
class Tweet {
  final String text;
  final String link;
  final List<String> hashtags;
  final List<String> imageLinks;
  final String uid;  // user id
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;  // tweet id
  final int reshareCount;

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
          reshareCount == other.reshareCount);

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
      reshareCount.hashCode;

  @override
  String toString() {
    return 'Tweet{ text: $text, link: $link, hashtags: $hashtags, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id, reshareCount: $reshareCount,}';
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'link': link,
      'hashtags': hashtags,
      'imageLinks': imageLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'reshareCount': reshareCount,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      link: map['link'] as String,
      hashtags: map['hashtags'] as List<String>,
      imageLinks: map['imageLinks'] as List<String>,
      uid: map['uid'] as String,
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt: map['tweetedAt'] as DateTime,
      likes: map['likes'] as List<String>,
      commentIds: map['commentIds'] as List<String>,
      // appwrite stores the id as $id
      id: map['\$id'] as String,
      reshareCount: map['reshareCount'] as int,
    );
  }

//</editor-fold>
}