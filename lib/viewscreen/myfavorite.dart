import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favoriteScreen';

  final List<PhotoMemo> photoMemoList;
  final User user;

  const FavoriteScreen(
      {required this.user, required this.photoMemoList, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavoriteState();
  }
}

class _FavoriteState extends State<FavoriteScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  int ra(int n) => Random().nextInt(n);
  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List.'),
      ),
      body: SingleChildScrollView(
        child: con.state.widget.photoMemoList.isEmpty
            ? Text(
                'No Favorite',
                style: Theme.of(context).textTheme.headline6,
              )
            : Column(
                children: [
                  for (var photoMemo in con.state.widget.photoMemoList)
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
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                ? Text('Image labels: ${photoMemo.imageLabels}')
                                : const SizedBox(
                                    height: 1.0,
                                  ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FloatingActionButton.extended(
                                    heroTag: 'dfsbsjcjscbs${ra(12313)}',
                                    onPressed: () async {
                                      await FirestoreController.deleteFromFav(
                                          context, photoMemo);
                                    },
                                    label: Row(
                                      children: const [
                                        Text("Remove from favorite"),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _Controller {
  _FavoriteState state;
  late List<PhotoMemo> photoMemoList;
  String? searchKeyString;
  List<int> selected = [];

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }
}
