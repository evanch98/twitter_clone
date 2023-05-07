import "package:twitter_clone/core/core.dart";

class Notification {
  final String text;
  final String postId;
  final String id;
  final String uid;
  final NotificationType notificationType;

//<editor-fold desc="Data Methods">
  const Notification({
    required this.text,
    required this.postId,
    required this.id,
    required this.uid,
    required this.notificationType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          postId == other.postId &&
          id == other.id &&
          uid == other.uid &&
          notificationType == other.notificationType);

  @override
  int get hashCode =>
      text.hashCode ^
      postId.hashCode ^
      id.hashCode ^
      uid.hashCode ^
      notificationType.hashCode;

  @override
  String toString() {
    return "Notification{ text: $text, postId: $postId, id: $id, uid: $uid, notificationType: $notificationType,}";
  }

  Notification copyWith({
    String? text,
    String? postId,
    String? id,
    String? uid,
    NotificationType? notificationType,
  }) {
    return Notification(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "postId": postId,
      "uid": uid,
      "notificationType": notificationType.type,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      text: map["text"] as String,
      postId: map["postId"] as String,
      id: map["\$id"] as String,
      uid: map["uid"] as String,
      notificationType:
          (map["notificationType"] as String).toNotificationTypeEnum(),
    );
  }

//</editor-fold>
}
