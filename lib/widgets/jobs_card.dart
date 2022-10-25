// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class JobsCard extends StatefulWidget {
  final String name;
  final String desc;
  final String enterprise;
  final String country;
  final String logo;

  const JobsCard(
      {Key? key,
      required this.name,
      required this.desc,
      required this.enterprise,
      required this.country,
      required this.logo})
      : super(key: key);

  @override
  State<JobsCard> createState() => _State();
}

class _State extends State<JobsCard> {
  @override
  initState() {
    super.initState();
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
          child: Row(children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.network(widget.logo),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.enterprise,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                Text(widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text(widget.desc,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text(widget.country,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.white54))
              ],
            ))
          ]),
        ));
  }
}
