import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'functionality_handlers/navigation_handler.dart';

class MainNavigationBar extends BottomAppBar {
  //TODO: Make Map and My Tags proper pages
  static final List<Widget> navigation_pages = [
    Center(child: Text('', style: GoogleFonts.huninn(fontSize: 24))),
    Center(child: Text('Scan Tag', style: GoogleFonts.huninn(fontSize: 24))),
    Center(child: Text('My Tags', style: GoogleFonts.huninn(fontSize: 24))),
  ];

  MainNavigationBar(NavigationHandler navigationHandler)
    : super(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.map, size: 28),
              onPressed: () =>
                  navigationHandler.currentPage = NavigationPage.map,
              color: navigationHandler.currentPage == NavigationPage.map
                  ? Colors.teal
                  : Colors.grey,
            ),
            SizedBox(
              width: 40,
            ), //this is a space for the button in the middle of the bottom bar
            IconButton(
              icon: Icon(Icons.style, size: 28),
              onPressed: () =>
                  navigationHandler.currentPage = NavigationPage.myTags,
              color: navigationHandler.currentPage == NavigationPage.myTags
                  ? Colors.teal
                  : Colors.grey,
            ),
            //possible icons we might wanna use: collections, bookmarks, edit_square, hourglass, label, library books, loyalty, local_offer,
            // map, more_outlined, qr_code, report, sell, sensors, style
          ],
        ),
      );
}
