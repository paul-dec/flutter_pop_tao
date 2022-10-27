import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_widget.dart';

MapWidget getMapWidget(int server) => MobileMap(
      server: server,
    );

class MobileMap extends StatefulWidget implements MapWidget {
  final int server;
  const MobileMap({Key? key, required this.server}) : super(key: key);

  @override
  State<MobileMap> createState() => MobileMapState();
}

class MobileMapState extends State<MobileMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const CameraPosition _kFalentexHouse =
      CameraPosition(target: LatLng(0, 0), zoom: 2);

  void getUsersLocs(int server) async {
    QuerySnapshot<Map<String, dynamic>> collec =
        await FirebaseFirestore.instance.collection('users').get();

    for (var element in collec.docs) {
      List<dynamic> userServers = element.data()['servers'];
      if (userServers.contains(server)) {
        GeoPoint tmpPoint = element.data()['loc'];
        if (tmpPoint.latitude == 0 && tmpPoint.longitude == 0) return;
        final marker = Marker(
          markerId: MarkerId(element.data()['pseudo']),
          position: LatLng(tmpPoint.latitude, tmpPoint.longitude),
          infoWindow: InfoWindow(
            title: element.data()['pseudo'],
          ),
        );

        setState(() {
          markers[MarkerId(element.data()['pseudo'])] = marker;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kFalentexHouse,
      markers: Set<Marker>.of(markers.values),
      onMapCreated: (GoogleMapController controller) {
        getUsersLocs(widget.server);
        _controller.complete(controller);
      },
    );
  }
}
