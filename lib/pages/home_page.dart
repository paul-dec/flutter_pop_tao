import 'package:bored_board/widgets/server_body.dart';
import 'package:bored_board/widgets/server_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? collectionUser;

  const HomePage({Key? key, required this.user, required this.collectionUser})
      : super(key: key);

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> {
  int _selected = 1000;

  @override
  initState() {
    super.initState();
  }

  void _update(int selected) {
    setState(() => _selected = selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Row(
            children: [
              Container(
                  width: 80,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 27, 29),
                      border: Border(
                          right: BorderSide(color: Colors.black, width: 1))),
                  child: Center(
                    child: ServerList(
                        collectionUser: widget.collectionUser, update: _update),
                  )),
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 46, 55, 71),
                  child: Center(
                    child: ServerBody(
                      user: widget.user,
                      collectionUser: widget.collectionUser,
                      server: _selected,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
