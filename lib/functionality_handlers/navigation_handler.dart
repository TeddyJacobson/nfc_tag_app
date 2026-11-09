import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../scan_button.dart';
import '../map_display.dart';
import '../local_database/database.dart';

class NavigationHandler {
  NavigationPage _currentPage = NavigationPage.map;
  late Widget pageWidget;

  final void Function(void Function()) setState;
  final ScanState scanState;
  final Stream<List<TagTableData>> persistentStorageOutput;

  NavigationHandler(this.setState, this.scanState, this.persistentStorageOutput) {
    // Initialize pageWidget and ensure proper scanState
    updatePage();
  }

  // Dart style getter and setters for private _currentPage,
  // necessary to update the widget, scanState, and set state of the main screen state
  NavigationPage get currentPage => _currentPage;
  set currentPage(NavigationPage newPage) {
    setState(() {
      _currentPage = newPage;
      updatePage();
    });
  }

  /// Update the widget and scanState based on the current page
  void updatePage() {
    pageWidget = switch (currentPage) {
      // TODO: This whole map widget (and the others) should be abstracted in another file
      NavigationPage.map => Stack(
        children: [
          Center(child: Text('Map')),
          Center(child: MapPlaceHolder(persistentStorageOutput)),
        ]
      ),
      NavigationPage.scan => Center(child: Text('Scan Tag')),
      NavigationPage.myTags => Center(child: Text('My Tags')),
    };

    if (currentPage != NavigationPage.scan) {
      scanState.showBottomButton();
    }
  }
}

enum NavigationPage {
  map,
  scan,
  myTags,
}