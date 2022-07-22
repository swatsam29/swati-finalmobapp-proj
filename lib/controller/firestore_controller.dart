import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notification.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/model/user.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';

class FirestoreController {
  static final FirebaseFirestore _fb = FirebaseFirestore.instance;
  static Future<String> addPhotoMemo({
    required PhotoMemo photoMemo,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .add(photoMemo.toFirestoreDoc());
    addPhotoMemoNotifications(photoMemo: photoMemo);
    return ref.id;
  }

  static Future<String> addPhotoMemoNotifications({
    required PhotoMemo photoMemo,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.notifications)
        .add({
      "email": photoMemo.createBy,
      "title": photoMemo.title,
      "whomentioned": photoMemo.sharedwith,
      "isRead": false,
      "timestamp": DateTime.now(),
    });
    return ref.id;
  }

  static Future<List<Notifications>> getnotificationsPhotoMemoList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.notifications)
        .where(DocKeyNotifications.whomentioned.name, arrayContains: email)
        .get();

    var result = <Notifications>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Notifications.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<String> saveDeletedPhotoMemo({
    required PhotoMemo photoMemo,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.photodeleted)
        .add(photoMemo.toFirestoreDoc());
    return ref.id;
  }

  static Future<List<PhotoMemo>> getDeletedPhotoMemoList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photodeleted)
        .where(DocKeyPhotoMemo.createBy.name, isEqualTo: email)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<PhotoMemo>> getPhotoMemoList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.createBy.name, isEqualTo: email)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<void> updatePhotoMemo({
    required String docId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(docId)
        .update(update);
  }

  static Future<List<PhotoMemo>> searchImages({
    required String email,
    required List<String> searchLabel,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.createBy.name, isEqualTo: email)
        .where(DocKeyPhotoMemo.imageLabels.name, arrayContainsAny: searchLabel)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      var p = PhotoMemo.fromFirestoreDoc(
        doc: doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
      if (p != null) result.add(p);
    }

    return result;
  }

  static Future<void> deleteDoc({
    required String docId,
    required PhotoMemo photoMemo,
  }) async {
    await saveDeletedPhotoMemo(photoMemo: photoMemo);
    await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .doc(docId)
        .delete();
  }

  static Future<void> deletePemDoc({
    required String docId,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.photodeleted)
        .doc(docId)
        .delete();
  }

  static Future<List<PhotoMemo>> getPhotoMemoListSharedWithMe({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.sharedwith.name, arrayContains: email)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<PhotoMemo>> searchPhotoMemoListSharedWithMe({
    required String email,
    required List<String> searchLabel,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.sharedwith.name, arrayContains: email)
        .where(DocKeyPhotoMemo.imageLabels.name, arrayContainsAny: searchLabel)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<PhotoMemo>> filterPhotoMemoListSharedWithMe({
    required String email,
    required User user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.photoMemoCollection)
        .where(DocKeyPhotoMemo.sharedwith.name, arrayContains: email)
        .where(DocKeyPhotoMemo.createBy.name, isEqualTo: user.email)
        .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<PhotoMemo>> favorite({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.favorite)
        .where(DocKeyPhotoMemo.createBy.name, isEqualTo: email)
        // .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
        .get();

    var result = <PhotoMemo>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<Comment>> getCommentList({
    required String photoid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.comments)
        .where(DocKeyComment.photo_id.name, isEqualTo: photoid)
        // .orderBy(DocKeyComment.timestamp.name, descending: true)
        .get();

    var result = <Comment>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Comment.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    debugPrint("$result");
    return result;
  }

  static Future<void> addComments(BuildContext context, User user,
      PhotoMemo photoMemo, String comment) async {
    await _fb.collection(Constant.comments).add({
      "comment": comment,
      "timestamp": DateTime.now(),
      "photo_id": photoMemo.docId,
      "user_id": user.uid,
      "username": user.displayName ?? user.email,
      "user_image": user.photoURL ?? ""
    });

    showSnackBar(context: context, message: 'Comment added');
  }

  static Future<void> addToFav(
      BuildContext context, PhotoMemo photoMemo) async {
    if (!(photoMemo.favorite)) {
      updatePhotoMemo(docId: photoMemo.docId!, update: {'favorite': true});
      await _fb.collection(Constant.favorite).add(photoMemo.toFirestoreDoc());
      showSnackBar(context: context, message: 'Added to Favorite');
    }
  }

  static Future<void> deleteFromFav(
      BuildContext context, PhotoMemo photoMemo) async {
    updatePhotoMemo(docId: photoMemo.docId!, update: {'favorite': false});
    await _fb.collection(Constant.favorite).doc(photoMemo.docId).delete();
    showSnackBar(context: context, message: 'Removed from Favorite');
  }

  static Future<void> deletecomment({
    required String docId,
    required BuildContext context,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.comments)
        .doc(docId)
        .delete();

    showSnackBar(context: context, message: 'Comment deleted');
  }

  static Future<UserProfile?> getUser({
    required String docId,
  }) async {
    var doc = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(docId)
        .get();
    var document = doc.data() as Map<String, dynamic>;

    return UserProfile.fromFirestoreDoc(doc: document, docId: doc.id);
  }

  static Future<void> updateProfile({
    required User user,
    required BuildContext context,
    required String name,
    required String department,
    required String designation,
    required String phone,
    required String manager,
    required String directreport,
  }) async {
    await _fb.collection(Constant.users).doc(user.uid).set({
      "name": name,
      "department": department,
      "designation": designation,
      "phone": phone,
      "manager": manager,
      "directreport": directreport,
      "timestamp": DateTime.now(),
    }, SetOptions(merge: true));

    showSnackBar(context: context, message: 'Profile Updated');
  }

  static Future<void> deleteProfile({
    required User user,
    required BuildContext context,
  }) async {
    await _fb.collection(Constant.users).doc(user.uid).delete();

    showSnackBar(context: context, message: 'Profile deleted');
  }
}
