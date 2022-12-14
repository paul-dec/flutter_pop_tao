import 'package:bored_board/widgets/map/map_widget.dart';
import 'package:bored_board/widgets/server_jobs.dart';
import 'package:bored_board/widgets/server_profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServerBody extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? collectionUser;
  final int server;

  const ServerBody(
      {Key? key,
      required this.user,
      required this.collectionUser,
      required this.server})
      : super(key: key);

  @override
  State<ServerBody> createState() => _State();
}

class _State extends State<ServerBody> {
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.server == 1000) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text('No')),
      );
    }
    final List<Widget> widgetOptions = <Widget>[
      ServerJobs(
          user: widget.user,
          collectionUser: widget.collectionUser,
          server: widget.server),
      MapWidget(0),
      ServerProfil(user: widget.user, collectionUser: widget.collectionUser)
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: widgetOptions.elementAt(_selectedIndex),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
