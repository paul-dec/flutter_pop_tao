import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';

import 'map_widget.dart';

MapWidget getMapWidget(int server) => WebMap(
      server: server,
    );

class WebMap extends StatefulWidget implements MapWidget {
  final int server;
  const WebMap({Key? key, required this.server}) : super(key: key);

  @override
  State<WebMap> createState() => WebMapState();
}

void getUsersLocs(int server, GMap map) async {
  QuerySnapshot<Map<String, dynamic>> collec =
      await FirebaseFirestore.instance.collection('users').get();

  for (var element in collec.docs) {
    List<dynamic> userServers = element.data()['servers'];
    if (userServers.contains(server)) {
      GeoPoint tmpPoint = element.data()['loc'];
      if (tmpPoint.latitude == 0 && tmpPoint.longitude == 0) return;
      Marker(MarkerOptions()
        ..clickable = true
        ..label = element.data()['pseudo']
        ..position = LatLng(tmpPoint.latitude, tmpPoint.longitude)
        ..map = map);
    }
  }
}

class WebMapState extends State<WebMap> {
  @override
  Widget build(BuildContext context) {
    const String htmlId = "map";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = MapOptions()
        ..zoom = 2.0
        ..center = LatLng(0, 0);

      final elem = DivElement()..id = htmlId;
      final map = GMap(elem, mapOptions);

      map.onCenterChanged.listen((event) {});
      map.onDragstart.listen((event) {});
      map.onDragend.listen((event) {});

      getUsersLocs(widget.server, map);

      return elem;
    });
    return const HtmlElementView(viewType: htmlId);
  }
}
