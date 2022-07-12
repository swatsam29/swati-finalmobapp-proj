import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class DeletedPhotoScreen extends StatefulWidget {
  const DeletedPhotoScreen(
      {required this.user, required this.photoMemoList, Key? key})
      : super(key: key);
  static const routeName = '/DeletedPhotoScreen';

  final User user;
  final List<PhotoMemo> photoMemoList;

  @override
  State<StatefulWidget> createState() {
    return _DeletedPhotoState();
  }
}

class _DeletedPhotoState extends State<DeletedPhotoScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(onTap: () => Navigator.pop(context) , child: const Icon(Icons.arrow_back)),
          title: const Text('Deleted Photos'),
        ),
        body: con.photoMemoList.isEmpty
            ? Text(
                'No Deleted found!',
                style: Theme.of(context).textTheme.headline6,
              )
            : GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                children: List.generate(
                  con.photoMemoList.length,
                  (index) {
                    PhotoMemo p = con.photoMemoList[index];
                    return InkWell(
                      onTap: () {
                        //delete forever
                        showDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text("Delete Photo"),
                            content: const Text(
                                "This process is undone, Are you sure?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel")),
                              TextButton(
                                onPressed: () async {
                                  await FirestoreController.deletePemDoc(
                                      docId: p.docId!);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              )
                            ],
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        child: WebImage(
                          url: p.photoURL,
                          context: context,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _Controller {
  _DeletedPhotoState state;
  late List<PhotoMemo> photoMemoList;

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }
}
