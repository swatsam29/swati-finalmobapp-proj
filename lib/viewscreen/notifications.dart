import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen(
      {required this.user, required this.notifications, Key? key})
      : super(key: key);
  static const routeName = '/NotificationsScreen';

  final User user;
  final List<Notifications> notifications;

  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<NotificationsScreen> {
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
          title: const Text('Notifications'),
        ),
        body: con.notificationslist.isEmpty
            ? Text(
                'No notificationslist!',
                style: Theme.of(context).textTheme.headline6,
              )
            : Column(
                children: List.generate(
                  con.notificationslist.length,
                  (index) {
                    Notifications p = con.notificationslist[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Row(
                        children: [
                          Text("@${p.email}", style: const TextStyle(color: Colors.blue),),
                          Text(" mentioned you in ${p.title}"),
                        ],
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
  _NotificationsState state;
  late List<Notifications> notificationslist;

  _Controller(this.state) {
    notificationslist = state.widget.notifications;
  }
}
