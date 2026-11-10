import 'package:flutter/material.dart';

import '/local_database/database.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StreamBuilder {
  MapPage(Stream<List<TagTableData>> stream, {super.key})
    : super(
        stream: stream,
        builder: (context, snapshot) {
          return Center(child: KMap(context));
        },
      );
}

class KMap extends FlutterMap {
  KMap(BuildContext context, {super.key})
    : super(
        options: MapOptions(
          initialCenter: LatLng(
            // Centering the map in the center of campus
            42.2903937,
            -85.6014676,
          ),
          initialZoom: 10,
        ),

        children: [
          TileLayer(
            // Getter raster tiles from online
            urlTemplate:
                'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
            // Assigning an identifier to not have traffic blocked
            userAgentPackageName: 'com.kscavengerhunt.app',
          ),
          RichAttributionWidget(
            // A prebuilt attribution widget to meet TOS of provider
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      );
}
