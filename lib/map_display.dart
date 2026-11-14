import 'package:flutter/material.dart';

import '/local_database/database.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'functionality_handlers/tile_set_handler.dart';

class MapPage extends StreamBuilder {
  MapPage(
    Stream<List<TagTableData>> stream,
    TileSetHandler tileSetHandler, {
    super.key,
  }) : super(
         stream: stream,
         builder: (context, snapshot) {
           return Center(child: KMap(context, tileSetHandler));
         },
       );
}

class KMap extends FlutterMap {
  final TileSetHandler tileSetHandler;
  KMap(BuildContext context, this.tileSetHandler, {super.key})
    : super(
        options: MapOptions(
          initialCenter: LatLng(
            // Centering the map in the center of campus
            42.290376, -85.599611
          ),
          initialZoom: 15.75,
          maxZoom: 18,
          minZoom: 15.75,
          interactionOptions: InteractionOptions(
            flags: ~InteractiveFlag.rotate,
          ),
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              LatLng(42.28121, -85.61212),
              LatLng(42.29953, -85.58770),
            ),
          ),
        ),

        children: [
          TileLayer(
            // Using the locally stored tile set
            tileProvider: tileSetHandler.tileProvider,

            // Specifying the tile bounds
            tileBounds: LatLngBounds(
              LatLng(42.28121, -85.61212),
              LatLng(42.29953, -85.58770),
            ),
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
