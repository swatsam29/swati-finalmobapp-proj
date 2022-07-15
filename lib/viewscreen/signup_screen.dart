import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/auth_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/user.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';

  const SignUpScreen({Key? key, this.editmode = false, this.user})
      : super(key: key);
  final bool editmode;
  final User? user;

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  late _Controller con;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _directReportController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    if (widget.editmode) {
      currentUser = _auth.currentUser!;
      geprofile();
      _emailController.text = currentUser.email!;
    }
  }

  @override
  void dispose() {
    //dispose the controllers
    super.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _usernameController.dispose();
    _departmentController.dispose();
    _directReportController.dispose();
    _roleController.dispose();
    _designationController.dispose();
  }

  void geprofile() async {
    if (widget.editmode) {
      UserProfile? userProfile =
          await FirestoreController.getUser(docId: widget.user!.uid);
      if (userProfile != null) {
        setState(() {
          _profile = userProfile;
          _phoneNumberController.text = _profile?.phone ?? "";
          _usernameController.text = _profile?.name ?? "";
          _departmentController.text = _profile?.department ?? "";
          _designationController.text = _profile?.designation ?? "";
          _roleController.text = _profile?.manager ?? "";
          _directReportController.text = _profile?.directreport ?? "";
        });
        con.valueObj();
        con.valueObj();
        con.valueObj();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editmode ? 'Update Account' : 'create New account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  widget.editmode ? 'Update Account' : 'Create a new account',
                  style: Theme.of(context).textTheme.headline5,
                ),
                widget.editmode
                    ? TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        onSaved: (value) {
                          con.saveEmail(value == null || value.isEmpty
                              ? _emailController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: con.validateEmail,
                        onSaved: con.saveEmail,
                      ),
                /////////////////
                widget.editmode
                    ? TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: (value) {
                          con.savephone(value == null || value.isEmpty
                              ? _phoneNumberController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Phone',
                        ),
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: con.savephone,
                      ),
                widget.editmode
                    ? TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: (value) {
                          con.savename(value == null || value.isEmpty
                              ? _usernameController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Name',
                        ),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: con.savename,
                      ),
                widget.editmode
                    ? TextFormField(
                        controller: _departmentController,
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: (value) {
                          con.savedepartment(value == null || value.isEmpty
                              ? _departmentController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter department',
                        ),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: con.savedepartment,
                      ),
                widget.editmode
                    ? TextFormField(
                        controller: _designationController,
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: (value) {
                          con.savedesignation(value == null || value.isEmpty
                              ? _designationController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter designation',
                        ),
                        keyboardType: TextInputType.name,
                        validator: con.validateempty,
                        onSaved: con.savedesignation,
                      ),
                widget.editmode
                    ? TextFormField(
                        controller: _roleController,
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: (value) {
                          con.savemanager(value == null || value.isEmpty
                              ? _roleController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter role',
                        ),
                        autocorrect: false,
                        validator: con.validateempty,
                        keyboardType: TextInputType.name,
                        onSaved: con.savemanager,
                      ),
                widget.editmode
                    ? TextFormField(
                        controller: _directReportController,
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        validator: con.validateempty,
                        onSaved: (value) {
                          con.savedirectreport(value == null || value.isEmpty
                              ? _directReportController.text
                              : value);
                        },
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter directreport',
                        ),
                        validator: con.validateempty,
                        onSaved: con.savedirectreport,
                      ),
                ////////////
                TextFormField(
                  decoration: InputDecoration(
                    hintText: widget.editmode
                        ? "Enter new  Password"
                        : 'Enter  Password',
                  ),
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: widget.editmode
                        ? "Confirm new Password"
                        : 'Confirm  Password',
                  ),
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.saveConfirmPassword,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () =>
                      con.signUp(context, widget.editmode, widget.user),
                  child: Text(
                    widget.editmode ? 'Update Account' : 'Sign Up',
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

  void valueObj() {
    savephone(state._profile!.phone);
    savename(state._profile!.name);
    savedepartment(state._profile!.department);
    savedesignation(state._profile!.designation);
    savemanager(state._profile!.manager);
    savedirectreport(state._profile!.directreport);
  }

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
          // user: user,
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
          confirmPassword: "$confirmpassword");

      if (!editmode) {
        showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'Account Created! Sign In and use the App!',
        );
      }
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
