import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/auth_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';

  const SignUpScreen({Key? key, this.editmode = false, this.user}) : super(key: key);
  final bool editmode;
  final User? user;

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.editmode ? 'Update Account':'create New account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  widget.editmode ? 'Update Account':'Create a new account',
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validateEmail,
                  onSaved: con.saveEmail,
                ),
                /////////////////
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Phone',
                  ),
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  validator: con.validateempty,
                  onSaved: con.savephone,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Name',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  validator: con.validateempty,
                  onSaved: con.savename,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter department',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  validator: con.validateempty,
                  onSaved: con.savedepartment,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter designation',
                  ),
                  keyboardType: TextInputType.name,
                  validator: con.validateempty,
                  onSaved: con.savedesignation,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter role',
                  ),
                  autocorrect: false,
                  validator: con.validateempty,
                  keyboardType: TextInputType.name,
                  onSaved: con.savemanager,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter directreport',
                  ),
                  validator: con.validateempty,
                  onSaved: con.savedirectreport,
                ),
                ////////////
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                  ),
                  autocorrect: false,
                  obscureText: true,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                  autocorrect: false,
                  obscureText: true,
                  validator: con.validatePassword,
                  onSaved: con.saveConfirmPassword,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => con.signUp(context, widget.editmode, widget.user),
                  child: Text(
                    widget.editmode ? 'Update Account':'Sign Up',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
  String? email;
  String? name;
  String? password;
  String? confirmpassword;
  String? department;
  String? designation;
  String? manager;
  String? phone;
  String? directreport;

  void signUp(BuildContext context, bool editmode, User? user) async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();
    if (password != confirmpassword) {
      showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'Passwords does not match');
      return;
    }
    try {
      await AuthController.createAccount(
        user: user,
        context: context,
        editmode: editmode,
        email: "$email",
        password: "$password",
        name: "$name",
        department: "$department",
        designation: "$designation",
        manager: "$manager",
        phone: "$phone",
        directreport: "$directreport",
      );
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'Account Created! Sign In and use the App!',
      );
    } catch (e) {
      if (Constant.devMode) print('======== Signup failed :$e');
      showSnackBar(
        context: state.context,
        message: 'Cannot create account: $e',
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || !(value.contains('@') && value.contains('.'))) {
      return 'Invalid email';
    }
  }

  String? validateempty(String? value) {
    if (value!.isEmpty) {
      return 'Value Cannot be empty';
    }
  }

  void saveEmail(String? value) {
    email = value;
  }

  void savephone(String? value) {
    phone = value;
  }

  void savedirectreport(String? value) {
    directreport = value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return ' Password is too short(min 6 chars)';
    } else {
      return null;
    }
  }

  void savePassword(String? value) {
    password = value;
  }

  void savename(String? value) {
    name = value;
  }

  void savedepartment(String? value) {
    department = value;
  }

  void savedesignation(String? value) {
    designation = value;
  }

  void savemanager(String? value) {
    manager = value;
  }

  void saveConfirmPassword(String? value) {
    confirmpassword = value;
  }
}
