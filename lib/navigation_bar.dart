import 'package:flutter/material.dart';

class MainNavigationBar extends BottomAppBar {
  MainNavigationBar(int currentIndex, void Function(int index) changePage)
    : super(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.map, size: 28),
              onPressed: () => changePage(0),
              color: currentIndex == 0 ? Colors.teal : Colors.grey,
            ),
            SizedBox(
              width: 40,
            ), //this is a space for the button in the middle of the bottom bar
            IconButton(
              icon: Icon(Icons.style, size: 28),
              onPressed: () => changePage(2),
              color: currentIndex == 2 ? Colors.teal : Colors.grey,
            ),
            //possible icons we might wanna use: collections, bookmarks, edit_square, hourglass, label, library books, loyalty, local_offer,
            // map, more_outlined, qr_code, report, sell, sensors, style
          ],
        ),
      );
}
