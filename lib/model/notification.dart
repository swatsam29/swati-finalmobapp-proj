
enum DocKeyNotifications {
  email,
  whomentioned,
  title,
  timestamp,
  isRead
}

class Notifications {
  String? docId;
  late String email;
  late String title;
  late bool isRead;
  late List<dynamic>? whomentioned;
  DateTime? timestamp;
  Notifications({
    this.docId,
    this.email = '',
    this.title = '',
    List<dynamic>? whomentioned,
    this.isRead = false,
    this.timestamp,
  }){
    this.whomentioned = whomentioned == null ? [] : [...whomentioned];
  }

  static Notifications? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return Notifications(
      docId: docId,
      email: doc[DocKeyNotifications.email.name] ??= 'N/A',
      isRead: doc[DocKeyNotifications.isRead.name] ??= false,
      title: doc[DocKeyNotifications.title.name] ??= 'N/A',
      whomentioned: doc[DocKeyNotifications.whomentioned.name] ??= [],
      timestamp: doc[DocKeyNotifications.timestamp.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyNotifications.timestamp.name].millisecondsSinceEpoch,
            )
          : DateTime.now(),
    );
  }


}
