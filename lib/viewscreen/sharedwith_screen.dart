import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/viewscreen/addphotomemo_screen.dart';
import 'package:lesson3/viewscreen/comment_screen.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';

  final List<PhotoMemo> photoMemoList;
  final User user;

  const SharedWithScreen(
      {required this.user, required this.photoMemoList, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SharedwithState();
  }
}

class _SharedwithState extends State<SharedWithScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();
  List<dynamic> usersharedwith = <dynamic>[];
  Map<String, int> commentsLength = Map();

  dynamic _searched;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    sharedWith();
    numberOfComments();
  }

  Future<void> numberOfComments() async {
    for (var photoMemo in con.photoMemoList) {
      List<Comment> comments =
          await FirestoreController.getCommentList(photoid: photoMemo.docId!);
      setState(() {
        commentsLength[photoMemo.title] = comments.length;
      });
    }
  }

  sharedWith() {
    if (widget.photoMemoList.isNotEmpty) {
      List<String> list = <String>[];
      for (PhotoMemo element in widget.photoMemoList) {
        for (var lement in element.sharedwith) {
          list.add(lement.toString());
        }
      }
      setState(() {
        usersharedwith.addAll(list.toSet().toList());
      });
    }

    debugPrint("${usersharedwith}");
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shared with : ${con.state.widget.user.email}'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Search(empty for all)',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          autocorrect: true,
                          onSaved: con.saveSearchKey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => con.search(widget.user),
                icon: const Icon(Icons.search),
              ),
              Row(
                children: [
                  Text("$_searched"),
                  DropdownButton<dynamic>(
                    items: usersharedwith.map((value) {
                      return DropdownMenuItem<dynamic>(
                        value: "$value",
                        child: Text("$value"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      debugPrint("$val");
                      setState(() {
                        _searched = val;
                      });
                      con.filters(val, widget.user);
                    },
                  ),
                ],
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.filter_alt_rounded),
              // ),
            ],
          ),
          SingleChildScrollView(
            child: con.photoMemoList.isEmpty
                ? Text(
                    'No photomemo shared with me',
                    style: Theme.of(context).textTheme.headline6,
                  )
                : Column(
                    children: [
                      for (var photoMemo in con.photoMemoList)
                        Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: WebImage(
                                    url: photoMemo.photoURL,
                                    context: context,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                ),
                                Text(
                                  photoMemo.title,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(photoMemo.memo),
                                Text('Created By: ${photoMemo.createBy}'),
                                Text('Created at: ${photoMemo.timestamp}'),
                                Text('Shared with: ${photoMemo.sharedwith}'),
                                Constant.devMode
                                    ? Text(
                                        'Image labels: ${photoMemo.imageLabels}')
                                    : const SizedBox(
                                        height: 1.0,
                                      ),
                                FittedBox(
                                  child: Stack(
                                    alignment: const Alignment(1.4, -1.5),
                                    children: [
                                      FloatingActionButton(
                                        heroTag: "ewfesfs${photoMemo.docId}",
                                        onPressed: () {
                                          con.commentButton(
                                              context, photoMemo, widget.user);
                                        },
                                        child: const Icon(Icons.comment),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(
                                            minHeight: 32, minWidth: 32),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  color: Colors.black
                                                      .withAlpha(50))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.blue),
                                        child: Center(
                                          child: Text(
                                            "${commentsLength[photoMemo.title]}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _SharedwithState state;
  late List<PhotoMemo> photoMemoList;
  String? searchKeyString;
  List<int> selected = [];

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }

  void search(User user) async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    currentState.save();

    List<String> keys = [];
    if (searchKeyString != null) {
      var tokens = searchKeyString!.split(RegExp('(,| )+')).toList();
      for (var t in tokens) {
        if (t.trim().isNotEmpty) keys.add(t.trim().toLowerCase());
      }
    }
    debugPrint("$keys");
    startCircularProgress(state.context);

    try {
      late List<PhotoMemo> results;
      if (keys.isEmpty) {
        results = await FirestoreController.searchPhotoMemoListSharedWithMe(
            email: user.email!, searchLabel: keys);
      } else {
        results = await FirestoreController.searchImages(
          email: user.email!,
          searchLabel: keys,
        );
      }
      // ignore: use_build_context_synchronously
      stopCircularProgress(state.context);
      state.render(() {
        photoMemoList = results;
      });
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('===== failed to search : $e');
      showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'failed to search : $e');
    }
  }

  void filters(email, User user) async {
    startCircularProgress(state.context);

    try {
      late List<PhotoMemo> results;

      results = await FirestoreController.filterPhotoMemoListSharedWithMe(
        email: email.toString(),
        user: user,
      );
      // ignore: use_build_context_synchronously
      stopCircularProgress(state.context);
      state.render(
        () {
          photoMemoList = results;
        },
      );
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('===== failed to search : $e');
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'failed to search : $e',
      );
    }
  }

  void saveSearchKey(String? value) {
    searchKeyString = value;
  }

  void commentButton(
      BuildContext context, PhotoMemo photoMemo, User user) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(
          photoMemo: photoMemo,
          user: user,
        ),
      ),
    );
  }

  void onTap(int index) async {
    if (selected.isNotEmpty) {
      onLongPress(index);
      return;
    }
    await Navigator.pushNamed(state.context, CommentScreen.routeName,
        arguments: {
          ArgKey.user: state.widget.user,
          ArgKey.onePhotoMemo: photoMemoList,
        });
    state.render(() {});
  }

  void onLongPress(int index) {
    state.render(() {
      if (selected.contains(index)) {
        selected.remove(index);
      } else {
        selected.add(index);
      }
    });
  }
}
