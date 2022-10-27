import 'package:bored_board/BLoC/bloc.dart';
import 'package:bored_board/pages/transition_page.dart';
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
        builder: (context) => TransitionPage(
              user: user,
              collectionUser: collec.data(),
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
        backgroundColor: const Color.fromARGB(255, 22, 27, 29),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(children: [
                ListView(children: [
                  Card(
                    color: const Color.fromARGB(255, 46, 55, 71),
                    child: Column(children: [
                      Container(height: 10),
                      const Text("Email and password",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Container(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: StreamBuilder(
                            stream: bloc.pseudo,
                            builder: (context, snapshot) {
                              return TextField(
                                  onChanged: (value) {
                                    bloc.changePseudo(value);
                                    setState(() {
                                      _pseudo = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      label: const Text(
                                        "Pseudo",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      errorText:
                                          snapshot.error.toString() == 'null'
                                              ? ''
                                              : snapshot.error.toString()));
                            },
                          )),
                      Container(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: StreamBuilder(
                            stream: bloc.email,
                            builder: (context, snapshot) {
                              return TextField(
                                  onChanged: (value) {
                                    bloc.changeEmail(value);
                                    setState(() {
                                      _mail = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      label: const Text("Email",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      errorText:
                                          snapshot.error.toString() == 'null'
                                              ? ''
                                              : snapshot.error.toString()));
                            },
                          )),
                      Container(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: StreamBuilder(
                            stream: bloc.password,
                            builder: (context, snapshot) {
                              return TextField(
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  onChanged: (value) {
                                    bloc.changePassword(value);
                                    setState(() {
                                      _pwd = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    label: const Text("Password",
                                        style: TextStyle(color: Colors.white)),
                                    errorText:
                                        snapshot.error.toString() == 'null'
                                            ? ''
                                            : snapshot.error.toString(),
                                  ));
                            },
                          )),
                      Container(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  var res = await Auth.mailRegister(
                                      _mail, _pwd, _pseudo);
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: res == null
                                          ? Colors.green
                                          : Colors.red,
                                      content: Text(res ?? "Registered!")));
                                  _collectionUser = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(_user?.uid)
                                      .get();
                                  navigator.push(MaterialPageRoute(
                                      builder: (context) => TransitionPage(
                                          user: _user,
                                          collectionUser:
                                              _collectionUser.data())));
                                },
                                child: const Text("Register")),
                            ElevatedButton(
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  var res = await Auth.mailSignIn(_mail, _pwd);
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: res == null
                                          ? Colors.green
                                          : Colors.red,
                                      content: Text(res ?? "Logged in!")));
                                  _collectionUser = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(_user?.uid)
                                      .get();
                                  navigator.push(MaterialPageRoute(
                                      builder: (context) => TransitionPage(
                                          user: _user,
                                          collectionUser:
                                              _collectionUser.data())));
                                },
                                child: const Text("Login"))
                          ]),
                      Container(height: 10)
                    ]),
                  ),
                ]),
              ])),
        ));
  }
}
