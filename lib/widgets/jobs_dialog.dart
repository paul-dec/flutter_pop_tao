import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context, int server,
    ValueChanged<Map<String, dynamic>> update) {
  TextEditingController enterpriseController = TextEditingController();
  TextEditingController logoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create a job'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: enterpriseController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enterprise name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: logoController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enterprise logo url'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Job name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Job description',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Job country',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Create'),
            onPressed: () {
              createNewJob(enterpriseController, logoController, nameController,
                  descController, countryController, server, update);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void createNewJob(
    TextEditingController enterpriseController,
    TextEditingController logoController,
    TextEditingController nameController,
    TextEditingController descController,
    TextEditingController countryController,
    int server,
    ValueChanged<Map<String, dynamic>> update) async {
  DocumentSnapshot<Map<String, dynamic>> jobs = await FirebaseFirestore.instance
      .collection('jobs')
      .doc(server.toString())
      .get();
  List<int> arrayOfId = [0];
  jobs.data()!.forEach((key, value) {
    arrayOfId.add(int.parse(key));
  });
  arrayOfId.sort((a, b) => a.compareTo(b));
  String lastId = (arrayOfId.last + 1).toString();
  if (jobs.data()!.isEmpty) {
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(server.toString())
        .set({
      lastId: {
        'enterprise': enterpriseController.text,
        'logo': logoController.text,
        'name': nameController.text,
        'desc': descController.text,
        'country': countryController.text
      }
    });
    update({
      lastId: {
        'enterprise': enterpriseController.text,
        'logo': logoController.text,
        'name': nameController.text,
        'desc': descController.text,
        'country': countryController.text
      }
    });
  } else {
    Map<String, dynamic> tmpData = jobs.data()!;
    tmpData.addAll({
      lastId: {
        'enterprise': enterpriseController.text,
        'logo': logoController.text,
        'name': nameController.text,
        'desc': descController.text,
        'country': countryController.text
      }
    });
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(server.toString())
        .set(tmpData);
    update(tmpData);
  }
}
