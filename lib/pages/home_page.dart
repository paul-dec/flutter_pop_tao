// ignore_for_file: prefer_const_constructors

import 'package:bored_board/widgets/server_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;
  final DocumentSnapshot<Map<String, dynamic>> collectionUser;

  const HomePage({Key? key, required this.user, required this.collectionUser})
      : super(key: key);

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> {
  String _selected = "";

  @override
  initState() {
    super.initState();
  }

  void _update(String selected) {
    setState(() => _selected = selected);
  }

  @override
  Widget build(BuildContext context) {
    ServerList serverList =
        ServerList(collectionUser: widget.collectionUser, update: _update);
    return Scaffold(
        body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                    width: 80,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 22, 27, 29),
                        border: Border(
                            right: BorderSide(color: Colors.black, width: 1))),
                    child: Center(
                      child: serverList,
                    )),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Color.fromARGB(255, 46, 55, 71),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          print(_selected);
                        },
                        child: Text(
                          _selected,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
