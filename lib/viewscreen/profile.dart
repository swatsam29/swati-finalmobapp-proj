import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/auth_controller.dart';
import 'package:lesson3/model/user.dart';
import 'package:lesson3/viewscreen/signup_screen.dart';
import 'package:lesson3/viewscreen/start_screen.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  final UserProfile userProfile;
  final User user;

  const ProfileScreen({required this.userProfile, Key? key, required this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile.'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
              title: Text("Display Name: ${widget.user.displayName ?? ''} ")),
          ListTile(title: Text("Email: ${widget.user.email ?? ''} ")),
          ListTile(
              title: Text("Department: ${widget.userProfile.department} ")),
          ListTile(
              title: Text("Designation: ${widget.userProfile.department} ")),
          ListTile(title: Text("Manger: ${widget.userProfile.manager} ")),
          ListTile(
              title:
                  Text("Direct Reports: ${widget.userProfile.directreport} ")),
          ListTile(title: Text("Phone: ${widget.userProfile.phone} ")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                heroTag: "sdfs",
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text(
                          "Delete your account? This process is undone, Are you sure?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                        TextButton(
                          onPressed: () async {
                            await AuthController.deleteAccount(
                                user: widget.user, context: context);
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StartScreen(),
                                ),
                                (route) => route.isFirst);
                          },
                          child: const Text("Delete"),
                        )
                      ],
                    ),
                  );
                },
                label: const Text("Delete Account"),
                backgroundColor: Colors.red,
              ),
              FloatingActionButton.extended(
                heroTag: "sdfssdgew",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(
                        user: widget.user,
                        editmode: true,
                      ),
                    ),
                  );
                },
                label: const Text("Update Account"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Controller {
  _ProfileState state;

  _Controller(this.state) {}
}
