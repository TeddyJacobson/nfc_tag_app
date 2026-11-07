import 'package:flutter/material.dart';

import '/local_database/database.dart';

/*
  TODO: Right now, everything in this file is just a placeholder to test streams

  Notice, there is a Center widget also being added in the same place as this placeholder
  Widget, but that Center widget just has empty text. See navigation_bar.dart for more
  context.
*/
class MapPlaceHolder extends StreamBuilder {
  MapPlaceHolder(Stream<List<TagTableData>> stream, {super.key})
    : super(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.connectionState != ConnectionState.none) {
            return Text('${snapshot.data}');
          }
          // Satisfying the Flutter Build conditions
          // With how lists are relayed through streams, this should never show
          return Text('Map info will go here');
        },
      );
}
