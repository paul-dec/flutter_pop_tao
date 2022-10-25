// ignore_for_file: prefer_const_constructors

import 'package:bored_board/widgets/jobs_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'jobs_dialog.dart';

class ServerJobs extends StatefulWidget {
  final User? user;
  final DocumentSnapshot<Map<String, dynamic>> collectionUser;
  final String server;

  const ServerJobs(
      {Key? key,
      required this.user,
      required this.collectionUser,
      required this.server})
      : super(key: key);

  @override
  State<ServerJobs> createState() => _State();
}

class _State extends State<ServerJobs> {
  @override
  initState() {
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getJobs() async {
    DocumentSnapshot<Map<String, dynamic>> collec =
        await FirebaseFirestore.instance.collection('jobs').doc('0').get();

    return collec;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getJobs(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start');
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildList(snapshot.data!.data()!);
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => dialogBuilder(context),
        label: const Text('Create a job'),
        icon: const Icon(Icons.add_business),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> jobs) {
    List<Widget> list = [];
    jobs.forEach((key, value) {
      list.add(JobsCard(
        name: value['name'],
        desc: value['desc'],
        enterprise: value['enterprise'],
        country: value['country'],
        logo: value['logo'],
      ));
      list.add(SizedBox(
        height: 10,
      ));
    });
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: list,
        ),
      ),
    );
  }
}
