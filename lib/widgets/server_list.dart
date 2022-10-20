// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> collectionUser;
  final ValueChanged<String> update;

  ServerList({Key? key, required this.collectionUser, required this.update})
      : super(key: key);

  @override
  State<ServerList> createState() => ServerListState();
}

class ServerListState extends State<ServerList> {
  List<Map<String, String>> servers = [
    {
      'url':
          'https://pbs.twimg.com/profile_images/1531237884770111488/gNcOONJg_400x400.jpg',
      'name': 'French Ape Yatch Club'
    },
    {
      'url':
          'https://pbs.twimg.com/profile_images/1519350417729146882/PPyU_MCm_400x400.jpg',
      'name': 'Bored Club Canada'
    },
    {
      'url':
          'https://pbs.twimg.com/profile_images/1490092475691769858/q1xwIad-_400x400.jpg',
      'name': 'UK Ape Club'
    }
  ];

  String _selected = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: servers
            .map((server) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CircleAvatar(
                    backgroundColor: _selected == server['name']
                        ? Colors.blue
                        : Colors.transparent,
                    radius: 40.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selected = server['name']!;
                        });
                        widget.update(_selected);
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(server['url']!),
                        radius: 28.0,
                      ),
                    ))))
            .toList());
  }
}
