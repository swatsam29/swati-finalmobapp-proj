import 'package:lesson3/viewscreen/detailedview_screen.dart';

enum PhotoSource { camera, gallery }

enum DocKeyPhotoMemo {
  createBy,
  title,
  memo,
  photoFilename,
  photoURL,
  timestamp,
  imageLabels,
  sharedwith,
  favorite,
  emageLabel
}

class PhotoMemo {
  String? docId;
  late String createBy;
  late String title;
  late String memo;
  late String photoFilename;
  late String photoURL;
  DateTime? timestamp;
  late List<dynamic> imageLabels;
  late List<dynamic> sharedwith;
  late bool favorite;
  late String emageLabel;

  PhotoMemo({
    this.docId,
    this.createBy = '',
    this.title = '',
    this.memo = '',
    this.photoFilename = '',
    this.photoURL = '',
    this.timestamp,
    this.favorite = false,
    this.emageLabel = "image",
    List<dynamic>? imageLabels,
    List<dynamic>? sharedwith,
  }) {
    this.imageLabels = imageLabels == null ? [] : [...imageLabels];
    this.sharedwith = sharedwith == null ? [] : [...sharedwith];
  }

  PhotoMemo.clone(PhotoMemo p) {
    docId = p.docId;
    createBy = p.createBy;
    title = p.title;
    memo = p.memo;
    photoFilename = p.photoFilename;
    photoURL = p.photoURL;
    timestamp = p.timestamp;
    sharedwith = [...p.sharedwith];
    imageLabels = [...p.imageLabels];
    favorite = p.favorite;
    emageLabel = p.emageLabel;
  }

  //a.copyFrom(b) ==> a = b

  void copyFrom(PhotoMemo p) {
    docId = p.docId;
    createBy = p.createBy;
    title = p.title;
    memo = p.memo;
    photoFilename = p.photoFilename;
    favorite = p.favorite;
    photoURL = p.photoURL;
    timestamp = p.timestamp;
    emageLabel = p.emageLabel;
    sharedwith.clear();
    sharedwith.addAll(p.sharedwith);
    imageLabels.clear();
    imageLabels.addAll(p.imageLabels);
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPhotoMemo.title.name: title,
      DocKeyPhotoMemo.createBy.name: createBy,
      DocKeyPhotoMemo.memo.name: memo,
      DocKeyPhotoMemo.photoFilename.name: photoFilename,
      DocKeyPhotoMemo.photoURL.name: photoURL,
      DocKeyPhotoMemo.timestamp.name: timestamp,
      DocKeyPhotoMemo.imageLabels.name: imageLabels,
      DocKeyPhotoMemo.sharedwith.name: sharedwith,
      DocKeyPhotoMemo.favorite.name: favorite,
      DocKeyPhotoMemo.emageLabel.name: emageLabel
    };
  }

  static PhotoMemo? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return PhotoMemo(
      docId: docId,
      createBy: doc[DocKeyPhotoMemo.createBy.name] ??= 'N/A',
      title: doc[DocKeyPhotoMemo.title.name] ??= 'N/A',
      memo: doc[DocKeyPhotoMemo.memo.name] ??= 'N/A',
      photoFilename: doc[DocKeyPhotoMemo.photoFilename.name] ??= 'N/A',
      photoURL: doc[DocKeyPhotoMemo.photoURL.name] ??= 'N/A',
      imageLabels: doc[DocKeyPhotoMemo.imageLabels.name] ??= [],
      sharedwith: doc[DocKeyPhotoMemo.sharedwith.name] ??= [],
      favorite: doc[DocKeyPhotoMemo.favorite.name] ??= false,
      emageLabel: doc[DocKeyPhotoMemo.emageLabel.name] ??=
          EmageLabel.image.name,
      timestamp: doc[DocKeyPhotoMemo.timestamp.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyPhotoMemo.timestamp.name].millisecondsSinceEpoch,
            )
          : DateTime.now(),
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 3)
        ? 'Title too short'
        : null;
  }

  static String? validateMemo(String? value) {
    return (value == null || value.trim().length < 5) ? 'Memo too short' : null;
  }

  static String? validateSharedWith(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    List<String> emailList =
        value.trim().split(RegExp('(, |;| )+')).map((e) => e.trim()).toList();
    for (String e in emailList) {
      if (e.contains('@') && e.contains('.')) {
        continue;
      } else {
        return 'Invalid email address found: comma, semicolon, space separated list';
      }
    }
  }
}
