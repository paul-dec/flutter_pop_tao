// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MobJobsCard extends StatefulWidget {
  final String role;
  final int server;
  final Map<String, dynamic> jobs;
  final String jkey;
  final ValueChanged<Map<String, dynamic>> update;

  const MobJobsCard(
      {Key? key,
      required this.role,
      required this.server,
      required this.jobs,
      required this.jkey,
      required this.update})
      : super(key: key);

  @override
  State<MobJobsCard> createState() => _State();
}

class _State extends State<MobJobsCard> {
  void deleteJob() async {
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.server.toString())
        .set(
            {widget.jkey: FieldValue.delete()},
            SetOptions(
              merge: true,
            ));

    setState(() {
      widget.jobs.removeWhere((key, value) => key == widget.jkey);
    });
    widget.update(widget.jobs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 22, 27, 29),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Container(
              color: Colors.blue,
              height: 200,
              width: 200,
              child: !widget.jobs[widget.jkey]['logo']
                      .toString()
                      .contains('https://')
                  ? const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 80,
                    )
                  : Image.network(
                      widget.jobs[widget.jkey]['logo'],
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.jobs[widget.jkey]['enterprise'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                Text(widget.jobs[widget.jkey]['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text(widget.jobs[widget.jkey]['desc'],
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text(widget.jobs[widget.jkey]['country'],
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.white54)),
                if (widget.role == 'admin')
                  const SizedBox(
                    height: 20,
                  ),
                if (widget.role == 'admin')
                  GestureDetector(
                      onTap: () {
                        deleteJob();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                          ),
                          width: 100,
                          height: 25,
                          child: const Center(
                              child: Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))))
              ],
            )
          ]),
        ));
  }
}
