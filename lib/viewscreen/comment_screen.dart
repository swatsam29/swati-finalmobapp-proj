import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/CommentScreen';

  const CommentScreen({Key? key, required this.user, required this.photoMemo})
      : super(key: key);
  final User user;
  final PhotoMemo photoMemo;

  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<CommentScreen> {
  late _Controller con;

  List<Comment> _comment = <Comment>[];
  List<Comment> get commentList => _comment;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    getCommnets(widget.photoMemo.docId!);
  }

  void render(fn) => setState(fn);
  final TextEditingController _controller = TextEditingController();

  Future<void> getCommnets(String photoid) async {
    List<Comment> comments =
        await FirestoreController.getCommentList(photoid: photoid);

    setState(() {
      _comment = comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "ewfesfs${widget.photoMemo.docId}",
        onPressed: () {
          // con.commentButton(context, widget.photoMemo, widget.user)
          showCupertinoDialog(
            context: context,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.width,
              child: Material(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Add Comment"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controller,
                        decoration:
                            const InputDecoration(hintText: "Comment..."),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.extended(
                          onPressed: () async {
                            if (_controller.text.isNotEmpty) {
                              con.commentButton(context, widget.photoMemo,
                                  widget.user, _controller.text);

                              await getCommnets(widget.photoMemo.docId!);
                              Navigator.pop(context);
                            } else {
                              showSnackBar(
                                context: context,
                                message: "Comment can't be empty",
                              );
                              Navigator.pop(context);
                            }
                          },
                          label: const Text("Add")),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        label: Row(
          children: const [
            Text("Add Comment"),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.comment),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
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
                      url: widget.photoMemo.photoURL,
                      context: context,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  Text(
                    widget.photoMemo.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(widget.photoMemo.memo),
                  Text('Created By: ${widget.photoMemo.createBy}'),
                  Text('Created at: ${widget.photoMemo.timestamp}'),
                  Text('Shared with: ${widget.photoMemo.sharedwith}'),
                  Constant.devMode
                      ? Text('Image labels: ${widget.photoMemo.imageLabels}')
                      : const SizedBox(
                          height: 1.0,
                        ),
                ],
              ),
            ),
          ),

          //coment list
          Column(
              children: List.generate(commentList.length, (index) {
            Comment com = commentList[index];
            return SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: com.user_image != ""
                          ? Image.network(com.user_image)
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text("${com.username}\n${com.comment}"),
                    InkWell(
                      onTap: () async {
                        await FirestoreController.deletecomment(
                            context: context, docId: com.docId!);
                        getCommnets(widget.photoMemo.docId!);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);

  void commentButton(BuildContext context, PhotoMemo photoMemo, User user,
      String comment) async {
    // Add to fb controller
    FirestoreController.addComments(context, user, photoMemo, comment);
    state.getCommnets(photoMemo.docId!);
  }
}
