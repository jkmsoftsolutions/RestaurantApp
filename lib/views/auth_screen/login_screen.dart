import 'dart:async';
import 'dart:convert';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/kitchen_screen/views/auth_screen/regis_screen.dart';
import 'package:emart_seller/kitchen_screen/views/home_screen/khome.dart';
import 'package:emart_seller/responsive/responsive.dart';
import 'package:emart_seller/theme/firebase_functions.dart';
import 'package:emart_seller/theme/style.dart';
import 'package:emart_seller/views/auth_screen/regis_screen.dart';
import 'package:emart_seller/views/home_screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  bool iswait = true;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  // functions get user
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sesData = await prefs.getString('user');
    if (sesData != null) {
      var user = jsonDecode(sesData);
      if (user['id'] != null) {
        route();
      }
    } else {
      setState(() {
        iswait = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: const Color.fromARGB(255, 255, 109, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: (iswait)
                    ? progress()
                    : Container(
                        width: 500,
                        margin: EdgeInsets.all(12),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Email',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  emailController.text = value!;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: passwordController,
                                obscureText: _isObscure3,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(_isObscure3
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure3 = !_isObscure3;
                                        });
                                      }),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Password',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  RegExp regex = new RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    setState(() {
                                      visible = false;
                                    });
                                    return "Password cannot be empty";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    setState(() {
                                      visible = false;
                                    });
                                    return ("please enter valid password min. 6 character");
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  passwordController.text = value!;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              (visible)
                                  ? progress()
                                  : MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () async {
                                        setState(() {
                                          visible = true;
                                        });
                                        // signIn(emailController.text,
                                        //     passwordController.text);
                                        await signInWithEmailPassword(
                                            emailController.text,
                                            passwordController.text);
                                        setState(() {
                                          visible = false;
                                        });
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Register()));
                                  },
                                  child: Container(
                                      child: Text('Create a new account')),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              // Visibility(
                              //     maintainSize: true,
                              //     maintainAnimation: true,
                              //     maintainState: true,
                              //     visible: visible,
                              //     child: Container(
                              //         child: CircularProgressIndicator(
                              //       color: Colors.white,
                              //     ))),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void route() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    var kk = FirebaseFirestore.instance
        .collection('vendors')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('type') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Kitchen_Home(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    await Firebase.initializeApp();
    User? user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        // get user
        Map<dynamic, dynamic> where = {
          'table': "vendors",
          'id': userCredential.user?.uid
        };
        var dbData = await dbFind(where);

        if (dbData != null) {
          // set session
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', jsonEncode(dbData));
        }

        route();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        themeAlert(context, 'Wrong Email Id !!', type: 'error');
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        themeAlert(context, 'Wrong mistmatch !!', type: 'error');
      }
    }

    // return user;
  }
}
