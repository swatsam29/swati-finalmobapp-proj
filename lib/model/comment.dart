enum DocKeyComment {
  comment,
  timestamp,
  photo_id,
  user_id,
  user_image,
  username,
}

class Comment {
  String? docId;
  late String comment;
  late String photo_id;
  late String username;
  late String user_id;
  late String user_image;
  DateTime? timestamp;

  Comment({
    this.docId,
    this.comment = '',
    this.photo_id = '',
    this.user_id = '',
    this.username = '',
    this.user_image = '',
    this.timestamp,
  });

  Comment.clone(Comment p) {
    docId = p.docId;
    comment = p.comment;
    photo_id = p.photo_id;
    user_id = p.user_id;
    user_image = p.user_image;
    username = p.username;
    timestamp = p.timestamp;
  }

  //a.copyFrom(b) ==> a = b

  void copyFrom(Comment p) {
    docId = p.docId;
    comment= p.comment;
    photo_id = p.photo_id;
    user_id = p.user_id;
    username = p.username;
    timestamp = p.timestamp;

  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyComment.photo_id.name: photo_id,
      DocKeyComment.user_id.name: user_id,
      DocKeyComment.comment.name: comment,
      DocKeyComment.username.name: username,
      DocKeyComment.user_image.name: user_image,
      DocKeyComment.timestamp.name: timestamp,
    };
  }

  static Comment? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return Comment(
      docId: docId,
      photo_id: doc[DocKeyComment.photo_id.name] ??= 'N/A',
      user_id: doc[DocKeyComment.user_id.name] ??= 'N/A',
      comment: doc[DocKeyComment.comment.name] ??= 'N/A',
      username: doc[DocKeyComment.username.name] ??= 'N/A',
      user_image: doc[DocKeyComment.user_image.name] ??= 'N/A',
      timestamp: doc[DocKeyComment.timestamp.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyComment.timestamp.name].millisecondsSinceEpoch,
            )
          : DateTime.now(),
    );
  }

  static String? validatedComment(String? value) {
    return (value == null || value.trim().length < 3)
        ? 'comment too short'
        : null;
  }
}
