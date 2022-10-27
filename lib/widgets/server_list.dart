// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  final Map<String, dynamic>? collectionUser;
  final ValueChanged<int> update;

  const ServerList(
      {Key? key, required this.collectionUser, required this.update})
      : super(key: key);

  @override
  State<ServerList> createState() => ServerListState();
}

class ServerListState extends State<ServerList> {
  late Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> servers;

  int _selected = 1000;

  Future<QuerySnapshot<Map<String, dynamic>>> getServers() async {
    QuerySnapshot<Map<String, dynamic>> collec =
        await FirebaseFirestore.instance.collection('servers').get();

    servers = collec.docs.asMap();

    if (_selected == 1000) {
      setState(() {
        _selected =
            int.parse(servers[widget.collectionUser!['servers'][0]]!.id);
      });
      widget.update(_selected);
    }
    return collec;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getServers(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Press button to start');
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError) {
              return Text('');
            } else {
              return _buildList(snapshot.data!);
            }
        }
      },
    );
  }

  Widget _buildList(QuerySnapshot<Map<String, dynamic>> servers) {
    return ListView(
        children: servers.docs
            .map((server) => widget.collectionUser!['servers']
                    .contains(int.parse(server.id))
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: CircleAvatar(
                        backgroundColor: _selected == int.parse(server.id)
                            ? Colors.blue
                            : Colors.transparent,
                        radius: 40.0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = int.parse(server.id);
                            });
                            widget.update(_selected);
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(server['url']!),
                            radius: 28.0,
                          ),
                        )))
                : Padding(
                    padding: EdgeInsets.zero,
                  ))
            .toList());
  }
}
