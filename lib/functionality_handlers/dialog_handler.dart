import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nfc_scan_handler.dart';

class DialogHandler {
  // Object that contains all of the states a dialog box can be in
  final DialogOps dialogOps = DialogOps();

  TagResponse? currentlyHeldTag;

  DialogHandler();

  void startTagSearching(
    BuildContext context,
    NfcInteractionHandler tagInteractionHandler,
  ) {
    dialogOps.currentlyScanning = true;
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
                dialogOps.currentlyScanning = false;
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
    if (dialogOps.currentlyScanning) {
      Navigator.of(context).pop();
      dialogOps.currentlyScanning = false;
    }

    tagInteractionHandler.scanning = false;

    // The user scanned a tag when they were suppose to
    if (tagRes.tagInfo != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _ValidTagDialog(
            dialogOps: dialogOps,
            context: context,
            tagRes: tagRes,
          );
        },
      );
    }
    // Handling all the other invalid popups
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _InvalidTagDialog(
            dialogOps: dialogOps,
            context: context,
            tagRes: tagRes,
          );
        },
      );
    }
  }
}

// A class for making an singleton object to handle dialog operations
class DialogOps {
  // Is the dialog currently looking for tags
  bool currentlyScanning = false;

  // Hasn't shown dialog for current tag
  bool shouldShowDialog = true;

  // Is currently displaying the dialog box
  bool currentlyDisplayed = false;

  DialogOps();
}

class _ValidTagDialog extends AlertDialog {
  final BuildContext context;
  final TagResponse tagRes;

  _ValidTagDialog({
    required DialogOps dialogOps,
    required this.context,
    required this.tagRes,
    super.key,
  }) : super(
         title: Center(
           child: Text('Tag Details', style: GoogleFonts.huninn(fontSize: 24)),
         ),
         content: SizedBox(
           width: 300,
           height: 500,
           child: Text(
             'ID: ${tagRes.tagInfo!.id}, Latitude: ${tagRes.tagInfo!.latitude}, Longitude: ${tagRes.tagInfo!.longitude}, Title: ${tagRes.tagInfo!.title}, Description: ${tagRes.tagInfo!.description}, Creation Timestamp: ${tagRes.tagInfo!.creationTimestamp}',
           ),
         ),
         actions: [
           TextButton(
             onPressed: () {
               dialogOps.shouldShowDialog = false;
               dialogOps.currentlyDisplayed = false;
               Navigator.of(context).pop();
             },
             child: Text('Close'),
           ),
         ],
       );
}

class _InvalidTagDialog extends AlertDialog {
  final BuildContext context;
  final TagResponse tagRes;

  _InvalidTagDialog({
    required DialogOps dialogOps,
    required this.context,
    required this.tagRes,
    super.key,
  }) : super(
         title: Center(
           child: Text('Tag Details', style: GoogleFonts.huninn(fontSize: 24)),
         ),
         content: SizedBox(
           width: 300,
           height: 500,
           child: Text('${tagRes.message}'),
         ),
         actions: [
           TextButton(
             onPressed: () {
               dialogOps.shouldShowDialog = false;
               dialogOps.currentlyDisplayed = false;
               Navigator.of(context).pop();
             },
             child: Text('Close'),
           ),
         ],
       );
}
