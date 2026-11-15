import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TileSetHandler {
  String localPath = "";

  Future<void> establishLocalConnection() async {
    // Grabbing the local directory for supplementary app files
    final Directory directory = await getApplicationSupportDirectory();
    localPath = '${directory.path}/kzoo.mbtiles';

    // Grabbing the existing stored file
    final File tileSetFile = File(localPath);

    // Checking if the file already exists
    // If not, loads the file onto the phone
    final bool fileExists = await tileSetFile.exists();
    if (!fileExists) {
      await _importMBTiles(tileSetFile);
    }
  }

  Future<void> _importMBTiles(File tileSetFile) async {
    // Grabbing tilemap bundled with the app
    // Note: rootBundle works to get set cause its path was provided in pubspec.yaml assets
    final ByteData tileMap = await rootBundle.load("assets/kzoo.mbtiles");
    // (Due to stupid perms, this map can't be used by itself thus this whole loading process)

    // Writing the data from onto the users device
    // Buffer accesses the bytes stored in a ByteData object, which then turned into writeable list
    await tileSetFile.writeAsBytes(tileMap.buffer.asUint8List());
  }

}
