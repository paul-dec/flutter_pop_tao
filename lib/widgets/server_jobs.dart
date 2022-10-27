import 'package:bored_board/widgets/jobs_card/mob_jobs_card.dart';
import 'package:bored_board/widgets/jobs_card/web_jobs_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'jobs_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ServerJobs extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? collectionUser;
  final int server;

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
    DocumentSnapshot<Map<String, dynamic>> collec = await FirebaseFirestore
        .instance
        .collection('jobs')
        .doc(widget.server.toString())
        .get();

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
              return const Text('Press button to start');
            case ConnectionState.waiting:
              return const Center(
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
        onPressed: () => dialogBuilder(context, widget.server),
        label: const Text('Create a job'),
        icon: const Icon(Icons.add_business),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> jobs) {
    void update(Map<String, dynamic> selected) {
      setState(() => jobs = selected);
    }

    List<Widget> list = [];
    jobs.forEach((key, value) {
      list.add(kIsWeb
          ? WebJobsCard(
              role: widget.collectionUser!['role'],
              server: widget.server,
              jobs: jobs,
              jkey: key,
              update: update,
            )
          : MobJobsCard(
              role: widget.collectionUser!['role'],
              server: widget.server,
              jobs: jobs,
              jkey: key,
              update: update,
            ));
      list.add(const SizedBox(
        height: 10,
      ));
    });
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: list,
        ),
      ),
    );
  }
}
