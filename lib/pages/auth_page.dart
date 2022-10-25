import 'package:bored_board/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/auth.dart';

alreadyLogin(user, context) async {
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    DocumentSnapshot<Map<String, dynamic>> collec = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user?.uid)
        .get();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(
              user: user,
              collectionUser: collec,
            )));
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _State();
}

class _State extends State<AuthPage> {
  String _pwd = "";
  String _mail = "";
  String _pseudo = "";
  User? _user;
  late DocumentSnapshot<Map<String, dynamic>> _collectionUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
      alreadyLogin(_user, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(children: [
            ListView(children: [
              Card(
                color: Colors.grey.shade300,
                child: Column(children: [
                  Container(height: 10),
                  const Text("Email and password",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _pseudo = value;
                          });
                        },
                        decoration:
                            const InputDecoration(label: Text("Pseudo"))),
                  ),
                  Container(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _mail = value;
                          });
                        },
                        decoration:
                            const InputDecoration(label: Text("Email"))),
                  ),
                  Container(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _pwd = value;
                          });
                        },
                        decoration:
                            const InputDecoration(label: Text("Password"))),
                  ),
                  Container(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              var res =
                                  await Auth.mailRegister(_mail, _pwd, _pseudo);
                              scaffoldMessenger.showSnackBar(SnackBar(
                                  backgroundColor:
                                      res == null ? Colors.green : Colors.red,
                                  content: Text(res ?? "Registered!")));
                              _collectionUser = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_user?.uid)
                                  .get();
                              navigator.push(MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      user: _user,
                                      collectionUser: _collectionUser)));
                            },
                            child: const Text("Register")),
                        ElevatedButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              var res = await Auth.mailSignIn(_mail, _pwd);
                              scaffoldMessenger.showSnackBar(SnackBar(
                                  backgroundColor:
                                      res == null ? Colors.green : Colors.red,
                                  content: Text(res ?? "Logged in!")));
                              _collectionUser = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_user?.uid)
                                  .get();
                              navigator.push(MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      user: _user,
                                      collectionUser: _collectionUser)));
                            },
                            child: const Text("Login"))
                      ]),
                  Container(height: 10)
                ]),
              ),
              Container(height: 10),
              Card(
                color: Colors.grey.shade300,
                child: Column(children: [
                  Container(height: 10),
                  const Text("Log out",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(height: 10),
                  ElevatedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        var res = await Auth.signOut();
                        scaffoldMessenger.showSnackBar(SnackBar(
                            backgroundColor:
                                res == null ? Colors.green : Colors.red,
                            content: Text(res ?? "Logged out!")));
                      },
                      child: const Text("Sign out")),
                  Container(height: 10)
                ]),
              ),
              Container(height: 10),
              if (_user != null)
                Card(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("User data",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(height: 10),
                            Text("Mail: ${_user?.email}"),
                            Text("Display Name: ${_user?.displayName}"),
                            Text("User UID: ${_user?.uid}")
                          ]),
                    ))
            ]),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _user != null ? "Logged in" : "Logged out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _user != null ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ))
          ])),
    ));
  }
}
