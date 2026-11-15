import 'dart:ui';

import 'package:flutter/material.dart';

import '/local_database/database.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';

import 'functionality_handlers/tile_set_handler.dart';

class MapPage extends StreamBuilder {
  MapPage(
    Stream<List<TagTableData>> stream,
    TileSetHandler tileSetHandler, {
    super.key,
  }) : super(
         stream: stream,
         builder: (context, AsyncSnapshot<dynamic> snapshot) {
           return Center(child: _KMap(context, snapshot.data, tileSetHandler));
         },
       );
}

class _KMap extends FlutterMap {
  final TileSetHandler tileSetHandler;
  _KMap(BuildContext context, dynamic tagList, this.tileSetHandler)
    : super(
        options: _MapOptions(),
        children: [
          TileLayer(
            // Using the locally stored tile set
            tileProvider: MbTilesTileProvider.fromPath(
              path: tileSetHandler.localPath,
            ),
            // Specifying the tile bounds
            tileBounds: LatLngBounds(
              LatLng(42.28121, -85.61212),
              LatLng(42.29953, -85.58770),
            ),
          ),
          PolygonLayer(
            polygons: [_KzooBounds()],
            invertedFill: Color.fromARGB(38, 0, 0, 0),
          ),
          _MarkerLayer(tagList),
          _AttributionLayer(),
        ],
      );
}

class _MapOptions extends MapOptions {
  _MapOptions()
    : super(
        initialCenter: LatLng(
          // Centering the map in the center of campus
          42.291000,
          -85.599611,
        ),
        initialZoom: 15.75,
        maxZoom: 18,
        minZoom: 15.75,
        interactionOptions: InteractionOptions(flags: ~InteractiveFlag.rotate),
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            LatLng(42.28121, -85.61212),
            LatLng(42.29953, -85.58770),
          ),
        ),
      );
}

class _MarkerLayer extends MarkerLayer {
  _MarkerLayer(dynamic tagList) : super(markers: dataToMarkers(tagList));

  static List<Marker> dataToMarkers(dynamic tagList) {
    if (tagList == null || tagList.isEmpty) {
      return [];
    }

    return tagList
        .map<Marker>(
          (tagDataEntry) => Marker(
            point: LatLng(tagDataEntry.latitude, tagDataEntry.longitude),
            child: GestureDetector(
              child: Icon(
                Icons.place,
                size: 30,
                color: Color.fromARGB(255, 234, 104, 32),
              ),
              onTap: () => print(
                'CALL TO THE POPUP FOR: ${tagDataEntry.title} w/ lat of ${tagDataEntry.latitude} and long of ${tagDataEntry.longitude}',
              ),
            ),
          ),
        )
        .toList();
  }
}

class _AttributionLayer extends RichAttributionWidget {
  _AttributionLayer()
    : super(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      );
}

// The precise bounds of the KZOO campus exported from the HOT map
class _KzooBounds extends Polygon {
  _KzooBounds()
    : super(
        borderColor: Color.fromARGB(255, 234, 104, 32),
        borderStrokeWidth: 2,
        pattern: StrokePattern.dotted(),
        points: [
          LatLng(42.28876, -85.6042151),
          LatLng(42.2887587, -85.6039926),
          LatLng(42.2887574, -85.6037777),
          LatLng(42.2887542, -85.6032293),
          LatLng(42.288754, -85.6030953),
          LatLng(42.2887536, -85.6027409),
          LatLng(42.2887534, -85.6026181),
          LatLng(42.2887503, -85.6022669),
          LatLng(42.2887525, -85.6013162),
          LatLng(42.2887466, -85.5994477),
          LatLng(42.2887462, -85.5993282),
          LatLng(42.2888017, -85.5991756),
          LatLng(42.2916423, -85.5948116),
          LatLng(42.2916808, -85.5951363),
          LatLng(42.2917776, -85.5959046),
          LatLng(42.2917946, -85.5960443),
          LatLng(42.2918839, -85.5967776),
          LatLng(42.2920029, -85.5977084),
          LatLng(42.2921122, -85.5986016),
          LatLng(42.2921691, -85.5990334),
          LatLng(42.2922285, -85.5995328),
          LatLng(42.2922917, -85.6000646),
          LatLng(42.292389, -85.6008202),
          LatLng(42.2924361, -85.6011521),
          LatLng(42.2919601, -85.6012214),
          LatLng(42.2919562, -85.6013426),
          LatLng(42.2918095, -85.6013834),
          LatLng(42.2918024, -85.6014894),
          LatLng(42.2914962, -85.6015319),
          LatLng(42.2915014, -85.6017842),
          LatLng(42.2910207, -85.6018711),
          LatLng(42.2910301, -85.6025132),
          LatLng(42.290494, -85.6026016),
          LatLng(42.2904427, -85.6026097),
          LatLng(42.2903682, -85.6026214),
          LatLng(42.2903578, -85.6029706),
          LatLng(42.290347, -85.6033334),
          LatLng(42.2903466, -85.6039763),
          LatLng(42.2903466, -85.6041374),
          LatLng(42.2903465, -85.6042567),
          LatLng(42.2898098, -85.6042502),
          LatLng(42.2895618, -85.6042418),
          LatLng(42.2893392, -85.6042344),
          LatLng(42.2890371, -85.6042243),
          LatLng(42.2890029, -85.6042232),
          LatLng(42.28876, -85.6042151),
        ],
      );
}
