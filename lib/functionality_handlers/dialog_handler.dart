import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nfc_scan_handler.dart';

class DialogHandler {
  bool currentlyScanning = false;
  bool currentlyDisplayed = false;

  /// Has not yet shown dialog for current tag
  bool shouldShowDialog = true;

  TagResponse? currentlyHeldTag;

  DialogHandler();

  void startTagSearching(
    BuildContext context,
    NfcInteractionHandler tagInteractionHandler,
  ) {
    currentlyScanning = true;
    tagInteractionHandler.scanning = true;

    // Provide the UI for the user to see the popup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Currently Scanning'),
          // content: const Text('Scannning...'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the popup
                tagInteractionHandler.scanning = false;
                currentlyScanning = false;
              },
            ),
          ],
        );
      },
    );
  }

  void showScannedTagDetails(
    BuildContext context,
    NfcInteractionHandler tagInteractionHandler,
  ) {
    TagResponse tagRes = currentlyHeldTag!;

    // Closing the existing popup if it exists
    if (currentlyScanning) {
      Navigator.of(context).pop();
      currentlyScanning = false;
    }

    tagInteractionHandler.scanning = false;

    // The user scanned a tag when they were suppose to
    if (tagRes.tagInfo != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Tag Details',
                style: GoogleFonts.huninn(fontSize: 24),
              ),
            ),
            content: SizedBox(
              width: 300,
              height: 500,
              child: Text(
                // TODO: Ideally, this won't just have Text for this option
                'ID: ${tagRes.tagInfo!.id}, Latitude: ${tagRes.tagInfo!.latitude}, Longitude: ${tagRes.tagInfo!.longitude}, Title: ${tagRes.tagInfo!.title}, Description: ${tagRes.tagInfo!.description}, Creation Timestamp: ${tagRes.tagInfo!.creationTimestamp}',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  shouldShowDialog = false;
                  currentlyDisplayed = false;
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
    // Handling all the other invalid popups
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Tag Details',
                style: GoogleFonts.huninn(fontSize: 24),
              ),
            ),
            content: SizedBox(
              width: 300,
              height: 500,
              child: Text('${tagRes.message}'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  shouldShowDialog = false;
                  currentlyDisplayed = false;
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
