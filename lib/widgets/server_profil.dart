import 'package:bored_board/firebase/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:location/location.dart';
import 'package:path/path.dart';
import '../pages/auth_page.dart';

class ServerProfil extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? collectionUser;

  const ServerProfil(
      {Key? key, required this.user, required this.collectionUser})
      : super(key: key);

  @override
  State<ServerProfil> createState() => _State();
}

class _State extends State<ServerProfil> {
  String profilePicLink = "";
  Location location = Location();
  TextEditingController pseudoController = TextEditingController();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _locationData;

  Widget loaderLocation = const Icon(
    Icons.refresh,
    color: Colors.blue,
  );

  late Widget pseudoTextField;

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    if (kIsWeb) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('images/${basename(image!.path)}');
      await reference
          .putData(
        await image.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await reference.getDownloadURL().then((value) {
          setState(() {
            profilePicLink = value;
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user?.uid)
              .update({'url': profilePicLink});
        });
      });
    } else {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${basename(image!.path)}');

      await ref.putFile(File(image.path));

      ref.getDownloadURL().then((value) async {
        setState(() {
          profilePicLink = value;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user?.uid)
            .update({'url': profilePicLink});
      });
    }
  }

  void updateLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      loaderLocation = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      );
    });

    _locationData = await location.getLocation();
    setState(() {
      _locationData;
      loaderLocation = const Icon(
        Icons.refresh,
        color: Colors.blue,
      );
    });
  }

  void updateUserData(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user?.uid)
        .update({
      'pseudo': pseudoController.text == ''
          ? widget.collectionUser!['pseudo']
          : pseudoController.text,
      'loc': _locationData == null
          ? widget.collectionUser!['loc']
          : GeoPoint(_locationData!.latitude!, _locationData!.longitude!)
    });
    scaffoldMessenger.showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text("Saved!")));
    setState(() {
      pseudoTextField = TextFormField(
        key: UniqueKey(),
        controller: pseudoController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            labelText: 'Edit pseudo',
            labelStyle: const TextStyle(color: Colors.white),
            hintText: pseudoController.text),
      );
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      profilePicLink = widget.collectionUser!['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    pseudoTextField = TextFormField(
      key: UniqueKey(),
      controller: pseudoController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: 'Edit pseudo',
          labelStyle: const TextStyle(color: Colors.white),
          hintText: pseudoController.text),
    );
    final navigator = Navigator.of(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    pickUploadProfilePic();
                  },
                  child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: profilePicLink == ""
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                profilePicLink,
                                fit: BoxFit.cover,
                              ),
                            ))),
              const SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _locationData != null
                          ? 'Latitude: ${_locationData!.latitude.toString()}, Longitude: ${_locationData!.longitude.toString()}'
                          : 'No location',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        updateLocation();
                      },
                      child: loaderLocation,
                    )
                  ]),
              const SizedBox(
                height: 10,
              ),
              SizedBox(width: 200, child: pseudoTextField),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    updateUserData(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      width: 100,
                      height: 25,
                      child: const Center(
                          child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )))),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    var res = await Auth.signOut();
                    scaffoldMessenger.showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor:
                            res == null ? Colors.green : Colors.red,
                        content: Text(res ?? "Logged out!")));
                    navigator.push(MaterialPageRoute(
                        builder: (context) => const AuthPage()));
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
                        'Sign out',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))))
            ],
          ),
        )));
  }
}
